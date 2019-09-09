package com.cingulo.device_unlock

import android.app.Activity
import android.app.Activity.RESULT_OK
import android.app.KeyguardManager
import android.content.Context
import android.content.Intent
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.util.concurrent.atomic.AtomicBoolean

class DeviceUnlockManager(
    private val activity: Activity
) : PluginRegistry.ActivityResultListener {

    private val authInProgress = AtomicBoolean(false)
    private var keyguardManager: KeyguardManager? = null
    private var deviceUnlockCallback: DeviceUnlockCallback? = null

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (keyguardRequestCode == requestCode) {
            if (RESULT_OK == resultCode) {
                deviceUnlockCallback?.onSuccess()
            } else {
                deviceUnlockCallback?.onFailure()
            }
            deviceUnlockCallback = null
        }
        return true
    }

    private fun validate(): Pair<String, String>? {
        if (!authInProgress.compareAndSet(false, true)) {
            return Pair("RequestInProgress", "unlock in progress")
        }

        if (activity.isFinishing) {
            return Pair("NoForegroundActivity", "unlock_device plugin requires a foreground activity")
        }

        keyguardManager = activity.getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager?
            ?: return Pair(
                "DeviceUnlockUnavailable",
                "unlock_devices plugin could not retrieve the KeyguardManager.")

        if (keyguardManager?.isKeyguardSecure != false) {
            Pair(
                "DeviceUnlockUnavailable",
                "The Device does not have patter, face, touch or pin security available.")
        }
        return null
    }

    fun authenticate(call: MethodCall, result: MethodChannel.Result) {
        val error = validate()
        if (error != null) {
            result.error(error.first, error.second, null)
            return
        }
        deviceUnlockCallback = object : DeviceUnlockCallback {
            override fun onSuccess() {
                if (authInProgress.compareAndSet(true, false)) {
                    result.success(true)
                }
            }

            override fun onFailure() {
                if (authInProgress.compareAndSet(true, false)) {
                    result.success(false)
                }
            }

            override fun onError(code: String, error: String) {
                if (authInProgress.compareAndSet(true, false)) {
                    result.error(code, error, null)
                }
            }
        }

        val localizedReason = call.arguments as String
        val intent = keyguardManager?.createConfirmDeviceCredentialIntent(localizedReason, "")
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
