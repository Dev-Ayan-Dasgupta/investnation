package com.example.investigation_hij

import com.clevertap.android.sdk.ActivityLifecycleCallback
import io.flutter.app.FlutterApplication
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.GeneratedPluginRegistrant

class Application : FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        ActivityLifecycleCallback.register(this)
        super.onCreate()
    }

    override fun registerWith(registry: PluginRegistry) {
        GeneratedPluginRegistrant.registerWith((registry as FlutterEngine))
    }
}