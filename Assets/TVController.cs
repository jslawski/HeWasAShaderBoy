using System.Collections;
using UnityEngine;

public class TVController : MonoBehaviour {

    public MeshRenderer meshRenderer;
    
    public float timeBetweenShiftChecks = 0.5f;
    public float shiftFrequency = 0.3f;
    public float minShiftAmount = 0.0f;
    public float maxShiftAmount = 0.7f;
    public float minShiftDuration = 0.3f;
    public float maxShiftDuration = 1.0f;
    private bool isShifted = false;

    public float timeBetweenDistortionChecks = 0.5f;
    public float distortionFrequency = 0.3f;
    public float minDistortionHeight = 0.0f;
    public float maxDistortionHeight = 0.7f;
    public float minDistortionDuration = 0.3f;
    public float maxDistortionDuration = 1.0f;
    private bool isDistorted = false;

    public float timeBetweenFlickerChecks = 0.5f;
    public float flickerFrequency = 0.3f;
    public float minFlickerDuration = 0.1f;
    public float maxFlickerDuration = 0.5f;
    private bool isFlickering = false;

    public float timeBetweenHiddenTextureChecks = 0.5f;
    public float hiddenTextureFrequency = 0.3f;
    public float minHiddenTextureDuration = 0.1f;
    public float maxHiddenTextureDuration = 0.5f;
    private bool showingHiddenTexture = false;

    private void Start() {
        StartCoroutine(this.RandomShiftGenerator());
        StartCoroutine(this.RandomDistortionGenerator());
        StartCoroutine(this.RandomFlickerGenerator());
        StartCoroutine(this.RandomHiddenTextureGenerator());
        StartCoroutine(this.RandomScreenBrightnessGenerator());
    }

    private IEnumerator RandomShiftGenerator() {
        while (true) {
            yield return new WaitForSeconds(this.timeBetweenShiftChecks);

            float randomNumber = Random.Range(0.0f, 1.0f);

            if (this.isShifted == false && randomNumber <= this.shiftFrequency) {
                StartCoroutine(this.ShiftImage(Random.Range(this.minShiftAmount, this.maxShiftAmount), Random.Range(this.minShiftDuration, this.maxShiftDuration)));
            }
        }
	}

    private IEnumerator RandomDistortionGenerator() {
        while (true) {
            yield return new WaitForSeconds(this.timeBetweenDistortionChecks);

            float randomNumber = Random.Range(0.0f, 1.0f);

            if (this.isDistorted == false && randomNumber <= this.distortionFrequency) {
                StartCoroutine(this.DistortImage(Random.Range(this.minDistortionHeight, this.maxDistortionHeight), Random.Range(this.minDistortionDuration, this.maxDistortionDuration)));
            }
        }
    }

    private IEnumerator RandomFlickerGenerator() {
        while (true) {
            yield return new WaitForSeconds(this.timeBetweenFlickerChecks);

            float randomNumber = Random.Range(0.0f, 1.0f);

            if (this.isFlickering == false && randomNumber <= this.flickerFrequency) {
                StartCoroutine(this.FlickerScreen(Random.Range(this.minFlickerDuration, this.maxFlickerDuration)));
            }
        }
    }

    private IEnumerator RandomHiddenTextureGenerator() {
        while (true) {
            yield return new WaitForSeconds(this.timeBetweenHiddenTextureChecks);

            float randomNumber = Random.Range(0.0f, 1.0f);

            if (this.showingHiddenTexture == false && this.isDistorted == false && randomNumber <= this.hiddenTextureFrequency) {
                StartCoroutine(this.ShowHiddenTexture(Random.Range(this.minHiddenTextureDuration, this.maxHiddenTextureDuration)));
            }
        }
    }

    private IEnumerator RandomScreenBrightnessGenerator() {
        while (true) {
            yield return new WaitForSeconds(Random.Range(0.1f, 1.0f));

            float targetBrightness = Random.Range(0.5f, 0.7f);
            float currentBrightness = this.meshRenderer.material.GetFloat("_ScreenLuminance");

            while (Mathf.Abs(currentBrightness - targetBrightness) > 0.01f) {
                currentBrightness = Mathf.Lerp(currentBrightness, targetBrightness, 0.05f);
                this.meshRenderer.material.SetFloat("_ScreenLuminance", currentBrightness);
                yield return null;
            }
        }
    }

    private IEnumerator ShiftImage(float shiftAmount, float shiftDuration) {
        this.isShifted = true;
        this.meshRenderer.material.SetFloat("_ShiftAmount", shiftAmount);

        yield return new WaitForSeconds(shiftDuration);

        this.meshRenderer.material.SetFloat("_ShiftAmount", 0.0f);
        this.isShifted = false;
    }

    private IEnumerator DistortImage(float distortionHeight, float distortionDuration) {
        this.isDistorted = true;
        this.meshRenderer.material.SetFloat("_DistortionHeight", distortionHeight);

        yield return new WaitForSeconds(distortionDuration);

        this.meshRenderer.material.SetFloat("_DistortionHeight", 0.0f);
        this.isDistorted = false;
    }

    private IEnumerator FlickerScreen(float flickerDuration) {
        this.isFlickering = true;
        this.meshRenderer.material.SetFloat("_FlickerScreen", 1.0f);

        yield return new WaitForSeconds(flickerDuration);

        this.meshRenderer.material.SetFloat("_FlickerScreen", 0.0f);
        this.isFlickering = false;
    }

    private IEnumerator ShowHiddenTexture(float hiddenTextureDuration) {
        this.showingHiddenTexture = true;
        this.meshRenderer.material.SetFloat("_RevealHiddenTex", 1.0f);

        yield return new WaitForSeconds(hiddenTextureDuration);

        this.meshRenderer.material.SetFloat("_RevealHiddenTex", 0.0f);
        this.showingHiddenTexture = false;
    }
}
