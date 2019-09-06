package com.cingulo.device_unlock

import android.app.Activity
import android.app.Activity.RESULT_OK
import android.app.KeyguardManager
import android.content.Intent
import io.flutter.plugin.common.PluginRegistry


class DeviceUnlockManager(
    private val activity : Activity,
    private val keyguardManager: KeyguardManager,
    private val localizedReason: String,
    private val callback: DeviceUnlockCallback
) : PluginRegistry.ActivityResultListener {


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if(keyguardRequestCode == requestCode) {
            if(RESULT_OK == resultCode){
                callback.onSuccess()
            } else {
                callback.onFailure()
            }
        }
        return true
    }

    fun authenticate() {
        val intent = keyguardManager.createConfirmDeviceCredentialIntent(localizedReason, "")
        activity.startActivityForResult(intent, keyguardRequestCode)
    }

    companion object {
        private const val keyguardRequestCode = 10010
    }

}

interface DeviceUnlockCallback {
    /** Called when unlock was successful.  */
    fun onSuccess()

    /**
     * Called when unlock failed due to user. For instance, when user cancels the auth or
     * quits the app.
     */
    fun onFailure()

    /**
     * Called when unlock fails due to non-user related problems such as system errors,
     * phone not having a FP reader etc.
     *
     * @param code The error code to be returned to Flutter app.
     * @param error The description of the error.
     */
    fun onError(code: String, error: String)
}