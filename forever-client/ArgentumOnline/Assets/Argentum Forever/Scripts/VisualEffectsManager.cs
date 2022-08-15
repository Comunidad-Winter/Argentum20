using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VisualEffectsManager : MonoBehaviour
{
    [SerializeField]
    private List<Spell> _spells;

    private static VisualEffectsManager _instance;
    public static VisualEffectsManager Instance { get { return _instance; } }

    private void Awake()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(this.gameObject);
        }
        else
        {
            _instance = this;
        }
    }

    public void PlaySpellFX(GameObject visualEffectPrefab, Vector2 position, Transform attachedTo)
    {
        if (attachedTo != null)
        {
            Instantiate(visualEffectPrefab, attachedTo);
        }
        else
        {
            Instantiate(visualEffectPrefab, position, Quaternion.identity);
        }
    }

    public int GetIndexFromSpell(Spell spell)
    {
        return _spells.IndexOf(spell);
    }

    public Spell GetSpellFromIndex(int index)
    {
        return _spells[index];
    }
}
