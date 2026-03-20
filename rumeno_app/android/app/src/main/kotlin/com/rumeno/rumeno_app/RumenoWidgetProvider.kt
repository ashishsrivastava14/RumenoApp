package com.rumeno.rumeno_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class RumenoWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.rumeno_widget)

            // Read ALL data as String (home_widget stores everything as String)
            val total = widgetData.getString("total_animals", "0") ?: "0"
            val pregnant = widgetData.getString("pregnant", "0") ?: "0"
            val treatments = widgetData.getString("active_treatments", "0") ?: "0"
            val vaxDue = widgetData.getString("overdue_vax", "0") ?: "0"
            val nextEvent = widgetData.getString("next_event", "No upcoming events") ?: "No upcoming events"
            val lastUpdated = widgetData.getString("last_updated", "") ?: ""

            // Populate stats
            views.setTextViewText(R.id.tv_total, total)
            views.setTextViewText(R.id.tv_pregnant, pregnant)
            views.setTextViewText(R.id.tv_treatments, treatments)
            views.setTextViewText(R.id.tv_vax_due, vaxDue)
            views.setTextViewText(R.id.tv_next_event, nextEvent)
            views.setTextViewText(R.id.tv_last_updated, lastUpdated)

            // Set emoji text from code (avoids UTF-8 encoding issues in XML)
            views.setTextViewText(R.id.tv_emoji_total, "\uD83D\uDC04")   // cow
            views.setTextViewText(R.id.tv_emoji_pregnant, "\uD83E\uDD30") // pregnant
            views.setTextViewText(R.id.tv_emoji_treat, "\uD83E\uDE7A")   // stethoscope
            views.setTextViewText(R.id.tv_emoji_vax, "\uD83D\uDC89")     // syringe
            views.setTextViewText(R.id.tv_emoji_event, "\uD83D\uDCC5")   // calendar

            // Load the Rumeno logo from Flutter assets
            try {
                val assetManager = context.assets
                val logoStream = assetManager.open("flutter_assets/assets/images/Rumeno_logo-rb.png")
                val logoBitmap = BitmapFactory.decodeStream(logoStream)
                logoStream.close()
                if (logoBitmap != null) {
                    views.setImageViewBitmap(R.id.iv_logo, logoBitmap)
                }
            } catch (_: Exception) {
                // Logo not found — leave default
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
