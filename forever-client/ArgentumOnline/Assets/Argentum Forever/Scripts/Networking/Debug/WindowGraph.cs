using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class WindowGraph : MonoBehaviour
{
    [SerializeField] private Sprite mSprite;
    private RectTransform mGraphContainer;
    private Texture2D mTexture;
    private List<GameObject> mBars;
    private List<int> mValues;
    private System.Diagnostics.Stopwatch mInputStopwatch;

    private void Awake(){
        mTexture = new Texture2D(1,1);
        mTexture.SetPixel(1,1,new Color(0,1,1,0.3f));
        mTexture.Apply();
        mSprite = Sprite.Create(mTexture, new Rect(0, 0, 1, 1), new Vector2(0, 0));
        mGraphContainer = transform.Find("GraphContainer").GetComponent<RectTransform>();
        mBars = new List<GameObject>();
        mValues = new List<int>() { 5,78,56,45,30,22,17,15,13,17,5,78,56,45,30,22,17,15,13,17,25,37,40,36,33, 5,78,56,45,30,22,17,15,13,17,25,37,40,36,33};
        ShowGraph(mValues);
        mInputStopwatch = new System.Diagnostics.Stopwatch();
        mInputStopwatch.Start();
    }

    private GameObject CreateBar(Vector2 Pos, float barWidth, float barHeight){
        Debug.Assert(mGraphContainer!=null);
        float graphHeight = mGraphContainer.sizeDelta.y;
        GameObject gameObject = new GameObject("bar",typeof(Image));
        gameObject.transform.SetParent(mGraphContainer,false);
        gameObject.GetComponent<Image>().sprite = mSprite;
        RectTransform rectTransform = gameObject.GetComponent<RectTransform>();
        rectTransform.pivot = Vector2.zero;
        rectTransform.anchoredPosition = new Vector2(Pos.x, -Pos.y);
        rectTransform.sizeDelta = new Vector2(barWidth, barHeight);
        rectTransform.anchorMin = Vector2.zero;
        rectTransform.anchorMax = Vector2.zero;
        return gameObject;
    }
    private void ShowGraph(List<int> valueList){
        float barWidth = 10f;
        float xSep = 5f;
        float xSize =20f;
        float yMaximum =200f;
        float graphHeight = mGraphContainer.sizeDelta.y;
        GameObject lastCircle = null;
        for(int i=0; i< valueList.Count;++i){
            float xPosition = xSize + i * xSize ;
            float yPosition = 0; //(valueList[i]/yMaximum)*graphHeight;
            float barHeight = (valueList[i]/yMaximum)*graphHeight;
            mBars.Add(CreateBar(new Vector2(xPosition,yPosition),barWidth,barHeight));
        }
    }
    void FixedUpdate()
    {

        if ( transform.localScale.x != 0f){
            // We limit the number of movement the player can do aiming to make PCs speed framerate independet
            mInputStopwatch.Stop();
            if(mInputStopwatch.ElapsedMilliseconds >= 1000){
                mInputStopwatch = System.Diagnostics.Stopwatch.StartNew();
                var first = mBars[0];
                mBars.RemoveAt(0);
                Destroy(first);
                mValues.RemoveAt(0);
                for (var i = 0; i < mBars.Count; i++) {
                        Destroy(mBars[i]);
                }
                mValues.Add(Random.Range(5, 100));
                if(mValues.Count > 0)
                    ShowGraph(mValues);

            }
            else {
                mInputStopwatch.Start();
            }

        }


    }

    private void CreateDotConnection(Vector2 dotPositionA,Vector2 dotPositionB){
        GameObject gameObject = new GameObject("dotConnection", typeof(Image));
        gameObject.transform.SetParent(mGraphContainer,false);
        gameObject.GetComponent<Image>().color = new Color(1,1,1,0.5f);
        RectTransform rectTransform = gameObject.GetComponent<RectTransform>();
        rectTransform.sizeDelta = new Vector2(100,3f);
        rectTransform.anchorMin = Vector2.zero;
        rectTransform.anchorMax = Vector2.zero;
        rectTransform.anchoredPosition = dotPositionA;
    }
}
