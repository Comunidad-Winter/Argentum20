using UnityEngine;

public class Attribute
{
    DefaultAttributeType mType;
    public string mName;
    public int mMaxValue;
    public int mCurrentValue;
    public Attribute(){}
    public Attribute(DefaultAttributeType type, string name, int maxValue)
    {
        mType = type;
        mName = name;
        mMaxValue = maxValue;
        mCurrentValue = mMaxValue;
    }
}
