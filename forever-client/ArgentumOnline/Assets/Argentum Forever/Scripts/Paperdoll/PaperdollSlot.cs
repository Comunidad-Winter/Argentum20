using Mirror;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PaperdollSlot : MonoBehaviour
{
    #region components cache
    private Animator mAnimator;
    private SpriteRenderer mSpriteRenderer;
    private Animator mRootAnimator;
    private EquipmentManager mEquipmentManager;
    #endregion

    // Associated slot type
    [SerializeField] public EquipmentSlotType mType;

    // Animator overrider
    private AnimatorOverrideController mAnimatorOverride;

    // Paperdoll rendering order for every direction
    /// <summary>
    //      0 CardinalDirection.NORTH
    //      1 CardinalDirection.NORTHEAST
    //      2 CardinalDirection.EAST
    //      3 CardinalDirection.SOUTHEAST
    //      4 CardinalDirection.SOUTH
    //      5 CardinalDirection.SOUTHWEST
    //      6 CardinalDirection.WEST
    //      7 CardinalDirection.NORTHWEST
    /// </summary>
    [Tooltip("0 CardinalDirection.NORTH \n 1 CardinalDirection.NORTHEAST \n 2 CardinalDirection.EAST \n 3 CardinalDirection.SOUTHEAST \n 4 CardinalDirection.SOUTH \n 5 CardinalDirection.SOUTHWEST \n 6 CardinalDirection.WEST \n 7 CardinalDirection.NORTHWEST")]
    [SerializeField] public int[] mRenderingOrderByDirection = new int[8];

    #region unity loop
    // Start is called before the first frame update
    void Awake()
    {
        // Setup the component cache
        SetupComponentCache();

        // Instantiate the animator override controller
        mAnimatorOverride = new AnimatorOverrideController(mAnimator.runtimeAnimatorController);

        // Actually override the animator controller
        mAnimator.runtimeAnimatorController = mAnimatorOverride;
    }
    #endregion

    private void SetupComponentCache()
    {
        // Set up all the cached components
        mAnimator = GetComponent<Animator>();
        mSpriteRenderer = GetComponent<SpriteRenderer>();
        mRootAnimator = GetComponentInParent<Animator>();
        mEquipmentManager = GetComponentInParent<EquipmentManager>();
    }

    public void LoadAnimationSet(StringAnimationClipDictionary animations)
    {
        // Reset the alpha channel of this slot
        Color newColor = mSpriteRenderer.color;
        newColor.a = 1;
        mSpriteRenderer.color = newColor;

        // Override the animation set
        foreach (string animationSlot in animations.Keys)
        {
            mAnimatorOverride[animationSlot] = animations[animationSlot];
        }
    }

    public void ResetAnimationSet()
    {
        // Set all the animations for this slot to null (no override)
        //TODO generalizar
        mAnimatorOverride["attack_east"] = null;
        mAnimatorOverride["attack_north"] = null;
        mAnimatorOverride["attack_northeast"] = null;
        mAnimatorOverride["attack_northwest"] = null;
        mAnimatorOverride["attack_south"] = null;
        mAnimatorOverride["attack_southeast"] = null;
        mAnimatorOverride["attack_southwest"] = null;
        mAnimatorOverride["attack_west"] = null;
        mAnimatorOverride["run_east"] = null;
        mAnimatorOverride["run_north"] = null;
        mAnimatorOverride["run_northeast"] = null;
        mAnimatorOverride["run_northwest"] = null;
        mAnimatorOverride["run_south"] = null;
        mAnimatorOverride["run_southeast"] = null;
        mAnimatorOverride["run_southwest"] = null;
        mAnimatorOverride["run_west"] = null;
        mAnimatorOverride["stand_east"] = null;
        mAnimatorOverride["stand_north"] = null;
        mAnimatorOverride["stand_northeast"] = null;
        mAnimatorOverride["stand_northwest"] = null;
        mAnimatorOverride["stand_south"] = null;
        mAnimatorOverride["stand_southeast"] = null;
        mAnimatorOverride["stand_southwest"] = null;
        mAnimatorOverride["stand_west"] = null;
        mAnimatorOverride["walk_east"] = null;
        mAnimatorOverride["walk_north"] = null;
        mAnimatorOverride["walk_northeast"] = null;
        mAnimatorOverride["walk_northwest"] = null;
        mAnimatorOverride["walk_south"] = null;
        mAnimatorOverride["walk_southeast"] = null;
        mAnimatorOverride["walk_southwest"] = null;
        mAnimatorOverride["walk_west"] = null;

        // Reset the alpha channel
        Color newColor = mSpriteRenderer.color;
        newColor.a = 0;
        mSpriteRenderer.color = newColor;
    }

    public void UpdateAnimatorFlags(bool directionChanged, float horizontalSpeed, float verticalSpeed, float finalSpeed)
    {
        // If the direction of the player is different...
        if (directionChanged)
        {
            // Update animator flags
            mAnimator.SetFloat("Horizontal", horizontalSpeed);
            mAnimator.SetFloat("Vertical", verticalSpeed);

            // Update the orden in layer
            //FIXME chequer este redondeo porque si cae en 0.5 alterna entre 0 y 1
            UpdateOrderInLayer(Mathf.RoundToInt(horizontalSpeed), Mathf.RoundToInt(verticalSpeed));
        }
        mAnimator.SetFloat("Speed", finalSpeed);
    }

    private void UpdateOrderInLayer(int horizontalSpeed, int verticalSpeed)
    {
        // Get the "friendly" representation of the direction
        CardinalDirection cardinalDirection = GetCardinalDirection(horizontalSpeed, verticalSpeed);

        // Update the order in layer
        Item item = mEquipmentManager.GetItemInSlot(mType);
        if (item != null)
        {
            mSpriteRenderer.sortingOrder = mRenderingOrderByDirection[GetCardinalDirectionAsInt(cardinalDirection)];
        }
    }

    public void UpdateMeleeAttackStatus(bool started)
    {
        // Attack started?
        if (started)
        {
            mAnimator.SetTrigger("DoMeleeAttack");
        }

        // Attack finished
        else
        {
            ///TODO es necesario hacer algo aca?
        }
    }

    public CardinalDirection GetCardinalDirection(int x, int y)
    {
        CardinalDirection result = CardinalDirection.SOUTH;

        // SOUTH
        if (x == 0 && y == -1)
        {
            result = CardinalDirection.SOUTH;
        }

        // SOUTH EAST
        else if (x == 1 && y == -1)
        {
            result = CardinalDirection.SOUTHEAST;
        }

        // EAST
        else if (x == 1 && y == 0)
        {
            result = CardinalDirection.EAST;
        }

        // NORTH EAST
        else if (x == 1 && y == 1)
        {
            result = CardinalDirection.NORTHEAST;
        }

        // NORTH
        else if (x == 0 && y == 1)
        {
            result = CardinalDirection.NORTH;
        }

        // NORTH WEST
        else if (x == -1 && y == 1)
        {
            result = CardinalDirection.NORTHWEST;
        }

        // WEST
        else if (x == -1 && y == 0)
        {
            result = CardinalDirection.WEST;
        }

        // SOUTH WEST
        else if (x == -1 && y == -1)
        {
            result = CardinalDirection.SOUTHWEST;
        }

        // Return the direction
        return result;
    }

    public int GetCardinalDirectionAsInt(CardinalDirection direction)
    {
        //      0 CardinalDirection.NORTH
        //      1 CardinalDirection.NORTHEAST
        //      2 CardinalDirection.EAST
        //      3 CardinalDirection.SOUTHEAST
        //      4 CardinalDirection.SOUTH
        //      5 CardinalDirection.SOUTHWEST
        //      6 CardinalDirection.WEST
        //      7 CardinalDirection.NORTHWEST
        int result = 0;
        switch (direction)
        {
            case CardinalDirection.NORTH: result = 0; break;
            case CardinalDirection.NORTHEAST: result = 1; break;
            case CardinalDirection.EAST: result = 2; break;
            case CardinalDirection.SOUTHEAST: result = 3; break;
            case CardinalDirection.SOUTH: result = 4; break;
            case CardinalDirection.SOUTHWEST: result = 5; break;
            case CardinalDirection.WEST: result = 6; break;
            case CardinalDirection.NORTHWEST: result = 7; break;
        }
        return result;
    }
}
