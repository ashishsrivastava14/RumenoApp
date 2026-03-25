package com.rumeno.rumeno_app

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService

class RumenoAlertService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return RumenoAlertFactory(applicationContext)
    }
}

class RumenoAlertFactory(private val context: Context) : RemoteViewsService.RemoteViewsFactory {

    private val alerts = mutableListOf<String>()

    override fun onCreate() {}

    override fun onDataSetChanged() {
        alerts.clear()
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val count = (prefs.getString("alert_count", "0") ?: "0").toIntOrNull() ?: 0
        for (i in 0 until minOf(count, 10)) {
            val text = prefs.getString("alert_$i", "") ?: ""
            if (text.isNotEmpty()) {
                alerts.add(text)
            }
        }
    }

    override fun onDestroy() {
        alerts.clear()
    }

    override fun getCount(): Int = alerts.size

    override fun getViewAt(position: Int): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.alert_item)
        if (position in alerts.indices) {
            views.setTextViewText(R.id.tv_alert_text, alerts[position])
        }
        return views
    }

    override fun getLoadingView(): RemoteViews? = null
    override fun getViewTypeCount(): Int = 1
    override fun getItemId(position: Int): Long = position.toLong()
    override fun hasStableIds(): Boolean = true
}
