package com.cingulo.device_unlock

import android.app.Activity
import androidx.fragment.app.FragmentActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.concurrent.atomic.AtomicBoolean
import android.content.Context.KEYGUARD_SERVICE
import android.app.KeyguardManager

class DeviceUnlockPlugin(private val registrar: Registrar): MethodCallHandler {

  private val authInProgress = AtomicBoolean(false)


  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "request") {
      request(call, result)


    } else {
      result.notImplemented()
    }
  }

  private fun request(call: MethodCall, result: Result) {

    if (!authInProgress.compareAndSet(false, true)) {
      result.error("RequestInProgress", "unlock in progress", null)
      return
    }

    val activity : Activity = registrar.activity()

    if(activity.isFinishing) {
      result.error("NoActivity", "unlock_device plugin requires a foreground activity", null)
      return
    }

    val keyguardManager = activity.getSystemService(KEYGUARD_SERVICE) as KeyguardManager?

    if(keyguardManager == null) {
      result.error(
          "NoKeyguardManager",
          "unlock_devices plugin could not retrieve the KeyguardManager.",
          null)
      return
    }

    if(!keyguardManager.isKeyguardSecure) {
      result.error(
          "DeviceUnlockUnavailable",
          "The Device does not have patter, face, touch or pin security available.",
          null)
      return
    }

    val localizedReason = call.arguments as String
    val deviceUnlockManager = DeviceUnlockManager(activity, keyguardManager, localizedReason, object : DeviceUnlockCallback{
      override fun onSuccess() {
        if (authInProgress.compareAndSet(true, false)) {
          result.success(true);
        }
      }

      override fun onFailure() {
        if (authInProgress.compareAndSet(true, false)) {
          result.success(false);
        }
      }

      override fun onError(code: String, error: String) {
        if (authInProgress.compareAndSet(true, false)) {
          result.error(code, error, null);
        }
      }
    })
    registrar.addActivityResultListener(deviceUnlockManager)
    deviceUnlockManager.authenticate()
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "device_unlock")
      channel.setMethodCallHandler(DeviceUnlockPlugin(registrar))
    }
  }
}
