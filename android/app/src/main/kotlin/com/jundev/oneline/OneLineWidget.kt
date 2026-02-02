package com.jundev.oneline

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import android.app.PendingIntent
import android.content.Intent
import java.util.Locale
import kotlin.random.Random

class OneLineWidget : AppWidgetProvider() {

    companion object {
        private const val PREFS_NAME = "OneLineWidgetPrefs"

        // 한국어 멘트 - 기록 전
        private val beforeWritingKo = listOf(
            "오늘의 한 줄을 남겨보세요 ✍️",
            "오늘 하루는 어땠나요?",
            "한 줄이면 충분해요",
            "오늘을 기록해볼까요?",
            "30초면 충분해요"
        )

        private val beforeWritingStreakKo = listOf(
            "🔥 %d일째 연속 기록 중!",
            "대단해요! %d일 연속 기록 중 ✨",
            "%d일째, 오늘도 이어가세요!",
            "연속 %d일! 계속 가보자고 🔥",
            "%d일 연속 기록, 멈추지 마세요!"
        )

        // 한국어 멘트 - 기록 후
        private val afterWritingKo = listOf(
            "오늘도 수고했어요 ✨",
            "내일 또 만나요!",
            "잘했어요! 내일 봐요 👋",
            "오늘의 기록 완료!",
            "내일도 한 줄 남겨주세요 💫",
            "좋아요! 내일 또 기록해요",
            "오늘 하루도 고생했어요 🌙",
            "기록 완료! 푹 쉬세요 😴"
        )

        // 영어 멘트 - 기록 전
        private val beforeWritingEn = listOf(
            "Leave a line about today ✍️",
            "How was your day?",
            "One line is enough",
            "Ready to record today?",
            "Just 30 seconds"
        )

        private val beforeWritingStreakEn = listOf(
            "🔥 %d day streak!",
            "Amazing! %d days in a row ✨",
            "Day %d, keep it going!",
            "%d day streak! Let's go 🔥",
            "%d days straight, don't stop!"
        )

        // 영어 멘트 - 기록 후
        private val afterWritingEn = listOf(
            "Great job today ✨",
            "See you tomorrow!",
            "Well done! See you 👋",
            "Today's record complete!",
            "Leave a line tomorrow too 💫",
            "Nice! Record again tomorrow",
            "You did well today 🌙",
            "Done! Rest well 😴"
        )

        fun getRandomMessage(hasWritten: Boolean, streak: Int, isKorean: Boolean): String {
            return if (hasWritten) {
                val messages = if (isKorean) afterWritingKo else afterWritingEn
                messages.random()
            } else {
                if (streak > 1) {
                    val messages = if (isKorean) beforeWritingStreakKo else beforeWritingStreakEn
                    String.format(messages.random(), streak)
                } else {
                    val messages = if (isKorean) beforeWritingKo else beforeWritingEn
                    messages.random()
                }
            }
        }

        fun updateWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val hasWrittenToday = prefs.getBoolean("hasWrittenToday", false)
            val currentStreak = prefs.getInt("currentStreak", 0)
            val lastEntryContent = prefs.getString("lastEntryContent", null)

            val isKorean = Locale.getDefault().language == "ko"
            val message = getRandomMessage(hasWrittenToday, currentStreak, isKorean)

            val views = RemoteViews(context.packageName, R.layout.one_line_widget)

            // 배경색 설정
            if (hasWrittenToday) {
                views.setInt(R.id.widget_background, "setBackgroundResource", R.drawable.widget_background_light)
                views.setTextColor(R.id.widget_message, 0xCC000000.toInt())
                views.setTextColor(R.id.widget_streak, 0x99000000.toInt())
                views.setTextColor(R.id.widget_content, 0x80000000.toInt())
            } else {
                views.setInt(R.id.widget_background, "setBackgroundResource", R.drawable.widget_background_dark)
                views.setTextColor(R.id.widget_message, 0xFFFFFFFF.toInt())
                views.setTextColor(R.id.widget_streak, 0xCCFFFFFF.toInt())
                views.setTextColor(R.id.widget_content, 0x99FFFFFF.toInt())
            }

            // 메시지 설정
            views.setTextViewText(R.id.widget_message, message)

            // 스트릭 표시
            if (!hasWrittenToday && currentStreak > 0) {
                views.setTextViewText(R.id.widget_streak, "🔥 $currentStreak")
                views.setViewVisibility(R.id.widget_streak, android.view.View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.widget_streak, android.view.View.GONE)
            }

            // 오늘 쓴 내용 미리보기
            if (hasWrittenToday && lastEntryContent != null) {
                views.setTextViewText(R.id.widget_content, "\"$lastEntryContent\"")
                views.setViewVisibility(R.id.widget_content, android.view.View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.widget_content, android.view.View.GONE)
            }

            // 클릭 시 앱 열기
            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_background, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // 첫 위젯 추가 시
    }

    override fun onDisabled(context: Context) {
        // 마지막 위젯 제거 시
    }
}
