using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomLighting : MonoBehaviour {

    public float timeBetweenChecks = 0.5f;
    public float frequency = 0.3f;
    public float minLightAmount = 0.0f;
    public float maxLightAmount = 0.1f;
    public float minDuration = 0.3f;
    public float maxDuration = 2.0f;
    private bool lightChanged = false;
    //FFF4D6
    //0E448E
    public Light thisLight;

    // Use this for initialization
    void Start () {
        StartCoroutine(RandomLightChangeGenerator());
	}

    private IEnumerator RandomLightChangeGenerator() {
        while (true) {
            yield return new WaitForSeconds(this.timeBetweenChecks);

            float randomNumber = Random.Range(0.0f, 1.0f);

            if (this.lightChanged == false && randomNumber <= this.frequency) {
                StartCoroutine(this.ChangeLight(Random.Range(this.minLightAmount, this.maxLightAmount), Random.Range(this.minDuration, this.maxDuration)));
            }
        }
    }

    private IEnumerator ChangeLight(float amount, float duration) {
        this.lightChanged = true;

        this.thisLight.intensity = 0.0f;

        yield return new WaitForSeconds(duration);

        this.thisLight.intensity = 0.1f;

        this.lightChanged = false;
    }
}
