package com.rumeno.rumeno_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class RumenoWidgetProvider : HomeWidgetProvider() {

    // Demo fallback alerts shown when no data has been pushed from Flutter yet
    private val demoAlerts = listOf(
        "\uD83D\uDC89 FMD Vaccination Due \u2013 C-001",
        "\uD83D\uDC89 PPR Vaccination Overdue \u2013 G-002",
        "\uD83D\uDC89 Brucellosis Due \u2013 B-001",
        "\uD83D\uDC89 Deworming Due \u2013 C-003",
        "\uD83E\uDE7A Mastitis Treatment \u2013 C-002",
        "\uD83E\uDE7A Foot Rot Treatment \u2013 G-004",
        "\uD83D\uDC89 HS Vaccination Due \u2013 B-002",
        "\uD83E\uDE7A Bloat Follow-up \u2013 C-005"
    )

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            try {
                val views = RemoteViews(context.packageName, R.layout.rumeno_widget)

                // Read data; use demo fallbacks if nothing saved yet
                val hasData = widgetData.getString("last_updated", "")?.isNotEmpty() == true

                val treatments = if (hasData) widgetData.getString("active_treatments", "5") ?: "5" else "5"
                val milkToday = if (hasData) widgetData.getString("milk_today", "230") ?: "230" else "230"
                val kidsCount = if (hasData) widgetData.getString("kids_count", "3") ?: "3" else "3"
                val pregnant = if (hasData) widgetData.getString("pregnant", "4") ?: "4" else "4"
                val nextEvent = if (hasData) widgetData.getString("next_event", "PPR Vaccination \u2013 G-001") ?: "PPR Vaccination \u2013 G-001" else "PPR Vaccination \u2013 G-001"
                val lastUpdated = if (hasData) widgetData.getString("last_updated", "") ?: "" else "Demo"

                // Populate stats
                views.setTextViewText(R.id.tv_treatments, treatments)
                views.setTextViewText(R.id.tv_milk_today, milkToday)
                views.setTextViewText(R.id.tv_kids_count, kidsCount)
                views.setTextViewText(R.id.tv_pregnant, pregnant)
                views.setTextViewText(R.id.tv_next_event, nextEvent)
                views.setTextViewText(R.id.tv_last_updated, lastUpdated)

                // Set emoji text
                views.setTextViewText(R.id.tv_emoji_treat, "\uD83E\uDE7A")
                views.setTextViewText(R.id.tv_emoji_milk, "\uD83E\uDD5B")
                views.setTextViewText(R.id.tv_emoji_kids, "\uD83D\uDC10")
                views.setTextViewText(R.id.tv_emoji_pregnant, "\uD83E\uDD30")
                views.setTextViewText(R.id.tv_emoji_event, "\uD83D\uDCC5")
                views.setTextViewText(R.id.tv_notification, "\uD83D\uDD14")

                // Populate alert TextViews
                val alertIds = intArrayOf(
                    R.id.tv_alert_0, R.id.tv_alert_1, R.id.tv_alert_2,
                    R.id.tv_alert_3, R.id.tv_alert_4, R.id.tv_alert_5,
                    R.id.tv_alert_6, R.id.tv_alert_7, R.id.tv_alert_8,
                    R.id.tv_alert_9
                )

                if (hasData) {
                    val alertCount = (widgetData.getString("alert_count", "0") ?: "0").toIntOrNull() ?: 0
                    for (i in alertIds.indices) {
                        if (i < alertCount) {
                            val text = widgetData.getString("alert_$i", "") ?: ""
                            if (text.isNotEmpty()) {
                                views.setTextViewText(alertIds[i], text)
                                views.setViewVisibility(alertIds[i], View.VISIBLE)
                            } else {
                                views.setViewVisibility(alertIds[i], View.GONE)
                            }
                        } else {
                            views.setViewVisibility(alertIds[i], View.GONE)
                        }
                    }
                } else {
                    // Show demo alerts
                    for (i in alertIds.indices) {
                        if (i < demoAlerts.size) {
                            views.setTextViewText(alertIds[i], demoAlerts[i])
                            views.setViewVisibility(alertIds[i], View.VISIBLE)
                        } else {
                            views.setViewVisibility(alertIds[i], View.GONE)
                        }
                    }
                }

                // Load the Rumeno logo
                try {
                    val logoStream = context.assets.open("flutter_assets/assets/images/Rumeno_logo-rb.png")
                    val logoBitmap = BitmapFactory.decodeStream(logoStream)
                    logoStream.close()
                    if (logoBitmap != null) {
                        views.setImageViewBitmap(R.id.iv_logo, logoBitmap)
                    }
                } catch (_: Exception) {}

                appWidgetManager.updateAppWidget(widgetId, views)
            } catch (_: Exception) {
                // Fallback: prevent crash from blanking widget
            }
        }
    }
}
