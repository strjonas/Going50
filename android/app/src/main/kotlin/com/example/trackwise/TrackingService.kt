package com.example.going50

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Binder
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import android.util.Log
import androidx.core.app.NotificationCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.FlutterCallbackInformation
import java.util.concurrent.atomic.AtomicBoolean

/**
 * Android foreground service for collecting driving data in the background.
 *
 * This service maintains a persistent notification and keeps the data collection
 * running even when the app is not in the foreground. It communicates with the
 * Flutter side through method channels.
 */
class TrackingService : Service() {
    companion object {
        private const val TAG = "TrackingService"
        private const val NOTIFICATION_ID = 1337
        private const val CHANNEL_ID = "going50_channel"
        private const val CHANNEL_NAME = "going50 Tracking"
        private const val WAKELOCK_TAG = "going50:BackgroundService"
        private const val METHOD_CHANNEL_NAME = "com.example.going50/tracking_service"

        // Service state
        private val serviceStarted = AtomicBoolean(false)
        
        // Callback handles for Flutter
        private var backgroundCallbackHandle: Long = 0
    }

    // Binder for local service interaction
    private val binder = LocalBinder()
    private var flutterEngine: FlutterEngine? = null
    private var methodChannel: MethodChannel? = null
    private var wakeLock: PowerManager.WakeLock? = null

    /**
     * Binder class for local service binding
     */
    inner class LocalBinder : Binder() {
        fun getService(): TrackingService = this@TrackingService
    }

    override fun onCreate() {
        super.onCreate()
        Log.i(TAG, "Creating tracking service")
        
        // Create notification channel for Android Oreo and above
        createNotificationChannel()
        
        // Set up wake lock to keep CPU running
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            WAKELOCK_TAG
        ).apply {
            setReferenceCounted(false)
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.i(TAG, "Service start command received")
        
        // Initialize if not already started
        if (serviceStarted.compareAndSet(false, true)) {
            // Start as a foreground service with a notification
            startForeground(NOTIFICATION_ID, createNotification())
            
            // Acquire wake lock to prevent CPU from sleeping
            wakeLock?.acquire(10*60*1000L /*10 minutes*/)
            
            // Initialize Flutter engine and method channel
            initializeMethodChannel()
            
            // Let the Dart side know we've started
            methodChannel?.invokeMethod("onServiceStarted", null)
        } else {
            // Check if callback handle was sent
            intent?.getLongExtra("backgroundCallbackHandle", 0L)?.let { callbackHandle ->
                if (callbackHandle != 0L) {
                    backgroundCallbackHandle = callbackHandle
                    Log.i(TAG, "Received Flutter callback handle: $backgroundCallbackHandle")
                }
            }
        }
        
        // If service is killed, restart it
        return START_STICKY
    }

    override fun onBind(intent: Intent): IBinder {
        return binder
    }

    override fun onDestroy() {
        Log.i(TAG, "Service is being destroyed")
        serviceStarted.set(false)
        
        // Release wake lock if held
        if (wakeLock?.isHeld == true) {
            wakeLock?.release()
        }
        
        // Clean up Flutter engine
        flutterEngine?.destroy()
        flutterEngine = null
        methodChannel = null
        
        super.onDestroy()
    }

    /**
     * Initialize the Flutter method channel for communication with dart code
     */
    private fun initializeMethodChannel() {
        if (flutterEngine != null) return
        
        // Initialize Flutter
        val flutterLoader = FlutterLoader()
        flutterLoader.startInitialization(this)
        flutterLoader.ensureInitializationComplete(this, null)
        
        // Create a new background Flutter engine
        flutterEngine = FlutterEngine(this)
        
        // Set up method channel for communication
        methodChannel = MethodChannel(
            flutterEngine!!.dartExecutor.binaryMessenger,
            METHOD_CHANNEL_NAME
        )
        
        // Set method call handler
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "stopService" -> {
                    Log.i(TAG, "Received stop service request from Flutter")
                    stopSelf()
                    result.success(null)
                }
                "isServiceRunning" -> {
                    result.success(serviceStarted.get())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
        
        // Start executing Dart in the background if we have a callback handle
        if (backgroundCallbackHandle != 0L) {
            val callbackInfo = 
                FlutterCallbackInformation.lookupCallbackInformation(backgroundCallbackHandle)
            if (callbackInfo != null) {
                flutterEngine!!.dartExecutor.executeDartCallback(
                    DartExecutor.DartCallback(
                        assets,
                        flutterLoader.findAppBundlePath(),
                        callbackInfo
                    )
                )
            }
        }
    }

    /**
     * Create notification channel for Android Oreo and above
     */
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Used for eco-driving data collection"
                setShowBadge(false)
            }
            
            val notificationManager = 
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    /**
     * Create the persistent notification for the foreground service
     */
    private fun createNotification() = NotificationCompat.Builder(this, CHANNEL_ID)
        .setContentTitle("going50 Active")
        .setContentText("Collecting driving data")
        .setSmallIcon(R.mipmap.ic_launcher)
        .setPriority(NotificationCompat.PRIORITY_LOW)
        .setOngoing(true)
        .setCategory(NotificationCompat.CATEGORY_SERVICE)
        .setShowWhen(false)
        .apply {
            // Add open app action
            val pendingIntent = PendingIntent.getActivity(
                this@TrackingService,
                0,
                packageManager.getLaunchIntentForPackage(packageName),
                PendingIntent.FLAG_IMMUTABLE
            )
            setContentIntent(pendingIntent)
        }
        .build()
} 