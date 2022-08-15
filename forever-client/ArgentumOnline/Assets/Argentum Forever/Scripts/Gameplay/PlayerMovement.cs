using Mirror;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : NetworkBehaviour
{
    // Input movement speeds (calculated with the user input)
    private float mInputMovementSpeed;
    private float mFinalMovementSpeed;

    // Movement direction
    private Vector2 mMovementDirection;
    private Vector2 mLastMovementDirection;

    // Base movement speed
    [SerializeField] private float mBaseMovementSpeed = 1.0f;
    [SerializeField] private LayerMask mPlayerLayerMask;

    // Flag that indicates if the character is in the middle of an animation attack
    private bool mIsAttacking = false;

    #region components cache
    private Rigidbody2D mRigidBody;
    private Animator mAnimator;
    private Collider2D mOwnCollider;
    private Collider2D mBlockerCollider;
    private PlayableCharacter mPlayableCharacter;
    private PlayerMeleeAttack mPlayerMeleeAttack;
    #endregion

    #region unity loop
    private void Awake()
    {
        // Setup the component cache
        SetupComponentCache();

        // Ignore collisions between the two character colliders
        Physics2D.IgnoreCollision(mOwnCollider, mBlockerCollider, true);
    }

    private void Update()
    {
        // Prevent non-local manipulation
        if (!isLocalPlayer) { return; }

        // Update blocking animations
        UpdateBlockingAnimations();

        // Process the user input
        ProcessInputs();     

        // Do the animation
        Animate();
    }

    private void FixedUpdate()
    {
        // Prevent non-local manipulation
        if (!isLocalPlayer) { return; }

        // Move the character acording to the user input
        Move();
    }
    #endregion

    private void UpdateBlockingAnimations()
    {
        // If the player is currently attacking...
        if (mIsAttacking)
        {
            // If the animation already finished...
            if (!this.mAnimator.GetCurrentAnimatorStateInfo(0).IsName("Combat"))
            {
                // Reset the flag
                mIsAttacking = false;

                // Notify the paperdoll
                mPlayableCharacter.NotifyMeleeAttackToPaperdoll(false);
            }
        }
    }

    private void SetupComponentCache()
    {
        // Set up all the cached components
        mRigidBody = GetComponent<Rigidbody2D>();
        mAnimator = transform.Find("Sprites/Base").GetComponent<Animator>();
        mOwnCollider = GetComponent<Collider2D>();
        mBlockerCollider = transform.Find("Blocker").GetComponent<Collider2D>();
        mPlayableCharacter = GetComponent<PlayableCharacter>();
        mPlayerMeleeAttack = GetComponent<PlayerMeleeAttack>();
    }

    private void ProcessInputs()
    {

        // Check if the user wants to launch a melee attack
        //FIXME usar ejes virtuales, no teclas concretas
        bool meleeInputPressed = Input.GetKeyDown(KeyCode.LeftControl) || Input.GetKeyDown(KeyCode.RightControl);
        if (meleeInputPressed && !mIsAttacking)
        {
            // Set the flag
            mIsAttacking = true;

            // Stop character from moving
            mFinalMovementSpeed = 0;

            // Send the trigger to the animator
            mAnimator.SetTrigger("DoMeleeAttack");

            // Notify the paperdoll
            mPlayableCharacter.NotifyMeleeAttackToPaperdoll(true);

            // Process the actual attack
            ProcessMeleeAttack();
        }

        // Read the user input on vertical axes (horizontal/vertical)
        mMovementDirection = new Vector2(Input.GetAxisRaw("Horizontal"), Input.GetAxisRaw("Vertical"));

        // Clamp and normalize the input speed
        mInputMovementSpeed = Mathf.Clamp(mMovementDirection.magnitude, 0.0f, 1.0f);
        mMovementDirection.Normalize();

        // Check if the player is trying to run
        //FIXME cambiar la tecla directa por un eje virtual
        if (Input.GetKeyDown(KeyCode.R))
        {
            // Limit the base movement speed
            if (mBaseMovementSpeed < 2.0f)
            {
                mBaseMovementSpeed = 2.0f;
            } else
            {
                mBaseMovementSpeed = 1.0f;
            }
        }

        // Calculate the final movement speed
        mFinalMovementSpeed = mInputMovementSpeed * mBaseMovementSpeed * 2.0f;
    }

    private void ProcessMeleeAttack()
    {
        mPlayerMeleeAttack.DoAttack();
    }

    private void Move()
    {
        // Move the character with the rb, using the calculated speeds (Update hook)
        mRigidBody.MovePosition(mRigidBody.position + mMovementDirection * mFinalMovementSpeed * Time.fixedDeltaTime);
    }

    private void Animate()
    {
        // Direction changed?
        bool directionChanged = false;

        // If the player is moving (has speed)
        if (mMovementDirection != Vector2.zero)
        {
            directionChanged = true;
            mAnimator.SetFloat("Horizontal", mMovementDirection.x);
            mAnimator.SetFloat("Vertical", mMovementDirection.y);
            mLastMovementDirection = mMovementDirection;
        }

        // Set the "speed" animator parameter
        mAnimator.SetFloat("Speed", mFinalMovementSpeed);

        // Update the paperdoll
        mPlayableCharacter.UpdatePaperdoll(directionChanged, mMovementDirection.x, mMovementDirection.y, mFinalMovementSpeed);
    }

    public CardinalDirection GetCardinalDirection(float x, float y)
    {
        CardinalDirection direction = CardinalDirection.SOUTHWEST;

        // SOUTH
        if (x == 0 && y == -1)
        {
            direction = CardinalDirection.SOUTH;
        }

        // SOUTH EAST
        else if (x == 1 && y == -1)
        {
            direction = CardinalDirection.SOUTHEAST;
        }

        // EAST
        else if (x == 1 && y == 0)
        {
            direction = CardinalDirection.EAST;
        }

        // NORTH EAST
        else if (x == 1 && y == 1)
        {
            direction = CardinalDirection.NORTHEAST;
        }

        // NORTH
        else if (x == 0 && y == 1)
        {
            direction = CardinalDirection.NORTH;
        }

        // NORTH WEST
        else if (x == -1 && y == 1)
        {
            direction = CardinalDirection.NORTHWEST;
        }

        // WEST
        else if (x == -1 && y == 0)
        {
            direction = CardinalDirection.WEST;
        }

        // SOUTH WEST (default value, nothing to do)
        // -------------------

        return direction;
    }

    public Vector2 GetLastMovementDirection() { return mLastMovementDirection; }
}
