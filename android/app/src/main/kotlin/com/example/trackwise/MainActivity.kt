package com.example.going50

import android.content.Context
import android.content.Intent
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.going50/tracking_service"
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    val callbackHandle = call.argument<Long>("backgroundCallbackHandle")
                    if (callbackHandle == null) {
                        result.error("ERROR", "Missing callback handle", null)
                        return@setMethodCallHandler
                    }
                    
                    startTrackingService(callbackHandle)
                    result.success(true)
                }
                "stopService" -> {
                    stopTrackingService()
                    result.success(true)
                }
                "isServiceRunning" -> {
                    result.success(isServiceRunning())
                }
                else -> result.notImplemented()
            }
        }
    }
    
    private fun startTrackingService(callbackHandle: Long) {
        val intent = Intent(context, TrackingService::class.java).apply {
            putExtra("backgroundCallbackHandle", callbackHandle)
        }
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(intent)
        } else {
            context.startService(intent)
        }
    }
    
    private fun stopTrackingService() {
        val intent = Intent(context, TrackingService::class.java)
        context.stopService(intent)
    }
    
    private fun isServiceRunning(): Boolean {
        // This is a simple check using shared preferences
        // In a production app, you might want to use a more reliable method
        val prefs = context.getSharedPreferences("going50_prefs", Context.MODE_PRIVATE)
        return prefs.getBoolean("is_service_running", false)
    }
}
