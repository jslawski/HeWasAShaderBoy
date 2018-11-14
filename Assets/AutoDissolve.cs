using System.Collections;
using UnityEngine;

public class AutoDissolve : MonoBehaviour {

    public MeshRenderer meshRenderer;
    public float dissolveRate = 0.01f;

	// Use this for initialization
	void Start () {
        meshRenderer.material.SetFloat("_DissolveAmount", 0.0f);
        StartCoroutine(Dissolve());
	}

    private IEnumerator Dissolve() 
    {
        yield return new WaitForSeconds(1f);

        while (meshRenderer.material.GetFloat("_DissolveAmount") < 1.0f) 
        {
            meshRenderer.material.SetFloat("_DissolveAmount", meshRenderer.material.GetFloat("_DissolveAmount") + dissolveRate);
            yield return null;
        }

        StartCoroutine(UnDissolve());
    }

    private IEnumerator UnDissolve() 
    {
        yield return new WaitForSeconds(1f);

        while (meshRenderer.material.GetFloat("_DissolveAmount") > 0.0f) {
            meshRenderer.material.SetFloat("_DissolveAmount", meshRenderer.material.GetFloat("_DissolveAmount") - dissolveRate);
            yield return null;
        }

        StartCoroutine(Dissolve());
    }
}
