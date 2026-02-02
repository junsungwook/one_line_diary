//
//  OneLineWidget.swift
//  OneLineWidget
//
//  Created by 전성욱 on 2/2/26.
//

import WidgetKit
import SwiftUI

// MARK: - Data Models
struct DiaryWidgetData {
    let hasWrittenToday: Bool
    let currentStreak: Int
    let lastEntryContent: String?
}

// MARK: - Messages
struct WidgetMessages {
    // 아직 안 쓴 경우 (스트릭 중심)
    static let beforeWritingKo: [String] = [
        "오늘의 한 줄을 남겨보세요 ✍️",
        "오늘 하루는 어땠나요?",
        "한 줄이면 충분해요",
        "오늘을 기록해볼까요?",
        "30초면 충분해요",
    ]

    static let beforeWritingStreakKo: [String] = [
        "🔥 %d일째 연속 기록 중!",
        "대단해요! %d일 연속 기록 중 ✨",
        "%d일째, 오늘도 이어가세요!",
        "연속 %d일! 계속 가보자고 🔥",
        "%d일 연속 기록, 멈추지 마세요!",
    ]

    static let beforeWritingEn: [String] = [
        "Leave a line about today ✍️",
        "How was your day?",
        "One line is enough",
        "Ready to record today?",
        "Just 30 seconds",
    ]

    static let beforeWritingStreakEn: [String] = [
        "🔥 %d day streak!",
        "Amazing! %d days in a row ✨",
        "Day %d, keep it going!",
        "%d day streak! Let's go 🔥",
        "%d days straight, don't stop!",
    ]

    // 쓴 경우 (완료 느낌)
    static let afterWritingKo: [String] = [
        "오늘도 수고했어요 ✨",
        "내일 또 만나요!",
        "잘했어요! 내일 봐요 👋",
        "오늘의 기록 완료!",
        "내일도 한 줄 남겨주세요 💫",
        "좋아요! 내일 또 기록해요",
        "오늘 하루도 고생했어요 🌙",
        "기록 완료! 푹 쉬세요 😴",
    ]

    static let afterWritingEn: [String] = [
        "Great job today ✨",
        "See you tomorrow!",
        "Well done! See you 👋",
        "Today's record complete!",
        "Leave a line tomorrow too 💫",
        "Nice! Record again tomorrow",
        "You did well today 🌙",
        "Done! Rest well 😴",
    ]

    static func getRandomMessage(hasWritten: Bool, streak: Int, isKorean: Bool) -> String {
        if hasWritten {
            let messages = isKorean ? afterWritingKo : afterWritingEn
            return messages.randomElement() ?? messages[0]
        } else {
            if streak > 1 {
                let messages = isKorean ? beforeWritingStreakKo : beforeWritingStreakEn
                let template = messages.randomElement() ?? messages[0]
                return String(format: template, streak)
            } else {
                let messages = isKorean ? beforeWritingKo : beforeWritingEn
                return messages.randomElement() ?? messages[0]
            }
        }
    }
}

// MARK: - Timeline Provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), data: DiaryWidgetData(hasWrittenToday: false, currentStreak: 0, lastEntryContent: nil))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let data = loadWidgetData()
        let entry = SimpleEntry(date: Date(), data: data)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let data = loadWidgetData()
        let entry = SimpleEntry(date: Date(), data: data)

        // 다음 자정에 새로고침
        let calendar = Calendar.current
        let tomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)

        let timeline = Timeline(entries: [entry], policy: .after(tomorrow))
        completion(timeline)
    }

    private func loadWidgetData() -> DiaryWidgetData {
        let defaults = UserDefaults(suiteName: "group.com.jundev.oneline")

        let hasWrittenToday = defaults?.bool(forKey: "hasWrittenToday") ?? false
        let currentStreak = defaults?.integer(forKey: "currentStreak") ?? 0
        let lastEntryContent = defaults?.string(forKey: "lastEntryContent")

        return DiaryWidgetData(
            hasWrittenToday: hasWrittenToday,
            currentStreak: currentStreak,
            lastEntryContent: lastEntryContent
        )
    }
}

// MARK: - Timeline Entry
struct SimpleEntry: TimelineEntry {
    let date: Date
    let data: DiaryWidgetData
}

// MARK: - Widget Views
struct OneLineWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var isKorean: Bool {
        let preferredLanguage = Locale.preferredLanguages.first ?? ""
        return preferredLanguage.hasPrefix("ko")
    }

    var body: some View {
        ZStack {
            // 배경색
            ContainerRelativeShape()
                .fill(entry.data.hasWrittenToday ?
                      Color(red: 0.98, green: 0.96, blue: 0.93) : // 크림색
                      Color(red: 0.15, green: 0.15, blue: 0.15))  // 다크

            VStack(alignment: .leading, spacing: 8) {
                // 상단 아이콘/상태
                HStack {
                    if entry.data.hasWrittenToday {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.orange)
                            .font(.system(size: 16))
                    } else {
                        Image(systemName: "pencil.circle.fill")
                            .foregroundColor(Color.orange)
                            .font(.system(size: 16))
                    }

                    Spacer()

                    if !entry.data.hasWrittenToday && entry.data.currentStreak > 0 {
                        Text("🔥 \(entry.data.currentStreak)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(entry.data.hasWrittenToday ? .black.opacity(0.6) : .white.opacity(0.8))
                    }
                }

                Spacer()

                // 메인 메시지
                Text(WidgetMessages.getRandomMessage(
                    hasWritten: entry.data.hasWrittenToday,
                    streak: entry.data.currentStreak,
                    isKorean: isKorean
                ))
                .font(.system(size: family == .systemSmall ? 14 : 16, weight: .medium))
                .foregroundColor(entry.data.hasWrittenToday ? .black.opacity(0.8) : .white)
                .lineLimit(2)

                // 오늘 쓴 내용 미리보기 (medium 이상)
                if family != .systemSmall && entry.data.hasWrittenToday,
                   let content = entry.data.lastEntryContent {
                    Text("\"\(content)\"")
                        .font(.system(size: 12))
                        .foregroundColor(entry.data.hasWrittenToday ? .black.opacity(0.5) : .white.opacity(0.6))
                        .lineLimit(1)
                }
            }
            .padding(16)
        }
    }
}

// MARK: - Widget Configuration
struct OneLineWidget: Widget {
    let kind: String = "OneLineWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                OneLineWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                OneLineWidgetEntryView(entry: entry)
            }
        }
        .configurationDisplayName("one line")
        .description("오늘의 한 줄 기록 상태를 확인하세요")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Preview
#Preview(as: .systemSmall) {
    OneLineWidget()
} timeline: {
    SimpleEntry(date: .now, data: DiaryWidgetData(hasWrittenToday: false, currentStreak: 5, lastEntryContent: nil))
    SimpleEntry(date: .now, data: DiaryWidgetData(hasWrittenToday: true, currentStreak: 6, lastEntryContent: "오늘은 좋은 하루였다"))
}
