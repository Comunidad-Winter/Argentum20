using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "Data", menuName = "ArgentumScriptable/Spell", order = 1)]
public class Spell : ScriptableObject
{
    public string _name;
    public string _magicWords;
    public string _description;
    public int _requiredMana;
    public int _requiredStamina;
    public GameObject _visualEffectPrefab;
    public List<EffectTargetType> _validTargets = new List<EffectTargetType>();
    [SerializeField]
    protected EffectsContainer _effects;
    public List<Effect> GetSpellEffects()
    {
        List<Effect> effects = new List<Effect>();
        effects.AddRange(_effects._modifyAttributes);

        return effects;
    }
}
[System.Serializable]
public class EffectsContainer
{
    public List<ModifyAttribute> _modifyAttributes;
}