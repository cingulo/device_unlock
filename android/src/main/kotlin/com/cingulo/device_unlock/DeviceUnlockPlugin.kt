package com.cingulo.device_unlock

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class DeviceUnlockPlugin(registrar: Registrar): MethodCallHandler {

  private val deviceUnlockManager = DeviceUnlockManager(registrar.activity())

  init {
      registrar.addActivityResultListener(deviceUnlockManager)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "request") {
      request(call, result)
    } else {
      result.notImplemented()
    }
  }

  private fun request(call: MethodCall, result: Result) {
    deviceUnlockManager.authenticate(call, result)
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "device_unlock")
      channel.setMethodCallHandler(DeviceUnlockPlugin(registrar))
    }
  }
}
