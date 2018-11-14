using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AreaDissolveController : MonoBehaviour {

    public float radius = 0.5f;
    public float softness = 0.5f;
    public float moveSpeed = 5f;

    void Update() {
        //Because these are global values, you don't need to specify a shader.
        //It just looks for the global value name in our code, and sets it.
        //That's why this script, attached to our sphere, is able to modify values in shaders on completely different objects (like the floor)
        Shader.SetGlobalVector("_GLOBALMaskPosition", this.transform.position);
        Shader.SetGlobalFloat("_GLOBALMaskRadius", this.radius);
        Shader.SetGlobalFloat("_GLOBALMaskSoftness", softness);

        if (Input.GetKey(KeyCode.W)) {
            this.transform.Translate(Vector3.forward * this.moveSpeed * Time.deltaTime);
        }
        if (Input.GetKey(KeyCode.S)) {
            this.transform.Translate(Vector3.back * this.moveSpeed * Time.deltaTime);
        }
        if (Input.GetKey(KeyCode.A)) {
            this.transform.Translate(Vector3.left * this.moveSpeed * Time.deltaTime);
        }
        if (Input.GetKey(KeyCode.D)) {
            this.transform.Translate(Vector3.right * this.moveSpeed * Time.deltaTime);

        }

    }
}
