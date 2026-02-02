package com.jundev.oneline

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.jundev.oneline/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "updateWidgetData" -> {
                    val hasWrittenToday = call.argument<Boolean>("hasWrittenToday") ?: false
                    val currentStreak = call.argument<Int>("currentStreak") ?: 0
                    val lastEntryContent = call.argument<String>("lastEntryContent")

                    updateWidgetData(hasWrittenToday, currentStreak, lastEntryContent)
                    result.success(null)
                }
                "reloadWidget" -> {
                    reloadWidget()
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun updateWidgetData(hasWrittenToday: Boolean, currentStreak: Int, lastEntryContent: String?) {
        val prefs = getSharedPreferences("OneLineWidgetPrefs", Context.MODE_PRIVATE)
        prefs.edit().apply {
            putBoolean("hasWrittenToday", hasWrittenToday)
            putInt("currentStreak", currentStreak)
            if (lastEntryContent != null) {
                putString("lastEntryContent", lastEntryContent)
            } else {
                remove("lastEntryContent")
            }
            apply()
        }

        reloadWidget()
    }

    private fun reloadWidget() {
        val appWidgetManager = AppWidgetManager.getInstance(this)
        val widgetComponent = ComponentName(this, OneLineWidget::class.java)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(widgetComponent)

        for (appWidgetId in appWidgetIds) {
            OneLineWidget.updateWidget(this, appWidgetManager, appWidgetId)
        }
    }
}
