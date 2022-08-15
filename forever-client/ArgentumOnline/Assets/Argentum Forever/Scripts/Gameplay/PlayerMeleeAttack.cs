using Mirror;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class PlayerMeleeAttack : NetworkBehaviour
{
    [SerializeField]
    private float attackRadius;

    [SerializeField]
    private float maxHitAngle = 30f;

    [SerializeField]
    private int hitDamage = 30;

    [Command]
    public void DoAttack()
    {
        RaycastHit2D[] hits = Physics2D.CircleCastAll(transform.position, attackRadius, Vector2.zero);
        for (int i = 0; i < hits.Length; i++)
        {
            if (transform == hits[i].transform) continue;
            PlayableCharacter victimCharacter = hits[i].transform.GetComponent<PlayableCharacter>();
            if (!victimCharacter) continue;
            Vector2 characterForward = GetComponent<PlayerMovement>().GetLastMovementDirection().normalized;
            float hitAngle = Vector2.Angle(((Vector2)transform.position - hits[i].point).normalized, -characterForward);
            if (hitAngle > maxHitAngle) continue;

            Debug.Log("PlayerHitted!, Angle: " + hitAngle + " With: " + hits[i].transform.name);
            Debug.DrawLine(transform.position, hits[i].point, Color.red, 2f);

            victimCharacter.DealDamage(hitDamage);
        }
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, attackRadius);

        //Vector2 characterForward = GetComponent<PlayerMovement>().GetLastMovementDirection().normalized;
        //float angle = Vector2.Angle(((Vector2)transform.position - hits[i].point).normalized, -characterForward);
    }
}
