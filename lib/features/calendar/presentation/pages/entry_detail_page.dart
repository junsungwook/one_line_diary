import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../bootstrap.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/settings_service.dart';

class EntryDetailPage extends StatefulWidget {
  final DateTime initialDate;

  const EntryDetailPage({super.key, required this.initialDate});

  @override
  State<EntryDetailPage> createState() => _EntryDetailPageState();
}

class _EntryDetailPageState extends State<EntryDetailPage> {
  late DateTime _currentDate;
  Set<DateTime> _recordedDates = {};

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate;
    _loadRecordedDates();
  }

  void _loadRecordedDates() {
    final dates = diaryService.getRecordedDates();
    _recordedDates = dates.map((d) => DateTime(d.year, d.month, d.day)).toSet();
  }

  bool _hasRecord(DateTime day) {
    return _recordedDates.contains(DateTime(day.year, day.month, day.day));
  }

  DateTime? _findPreviousRecordedDate() {
    DateTime checkDate = _currentDate.subtract(const Duration(days: 1));
    for (int i = 0; i < 365; i++) {
      if (_hasRecord(checkDate)) {
        return checkDate;
      }
      checkDate = checkDate.subtract(const Duration(days: 1));
    }
    return null;
  }

  DateTime? _findNextRecordedDate() {
    DateTime checkDate = _currentDate.add(const Duration(days: 1));
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (int i = 0; i < 365; i++) {
      if (checkDate.isAfter(today)) return null;
      if (_hasRecord(checkDate)) {
        return checkDate;
      }
      checkDate = checkDate.add(const Duration(days: 1));
    }
    return null;
  }

  void _goToPreviousDate() {
    final prevDate = _findPreviousRecordedDate();
    if (prevDate != null) {
      setState(() => _currentDate = prevDate);
    }
  }

  void _goToNextDate() {
    final nextDate = _findNextRecordedDate();
    if (nextDate != null) {
      setState(() => _currentDate = nextDate);
    }
  }

  String _formatYear(AppLocalizations l10n) {
    if (l10n.localeName == 'ko') {
      return '${_currentDate.year}년';
    }
    return '${_currentDate.year}';
  }

  String _formatMonthDay(AppLocalizations l10n) {
    if (l10n.localeName == 'ko') {
      return '${_currentDate.month}월 ${_currentDate.day}일';
    }
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[_currentDate.month - 1]} ${_currentDate.day}';
  }

  String _formatWeekday(AppLocalizations l10n) {
    if (l10n.localeName == 'ko') {
      const days = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
      return days[_currentDate.weekday - 1];
    }
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[_currentDate.weekday - 1];
  }

  String _formatNavDate(DateTime date, AppLocalizations l10n) {
    if (l10n.localeName == 'ko') {
      return '${date.month}월 ${date.day}일';
    }
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatTime(DateTime time, AppLocalizations l10n) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');

    if (l10n.localeName == 'ko') {
      if (hour < 12) {
        return '오전 ${hour == 0 ? 12 : hour}:$minute에 기록됨';
      } else {
        return '오후 ${hour == 12 ? 12 : hour - 12}:$minute에 기록됨';
      }
    }

    final amPm = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return 'Recorded at $displayHour:$minute $amPm';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = context.watch<SettingsService>().currentThemeColors;

    final entry = diaryService.getEntry(_currentDate);
    final prevDate = _findPreviousRecordedDate();
    final nextDate = _findNextRecordedDate();

    return Scaffold(
      backgroundColor: isDark ? themeColors.darkBackground : themeColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 바
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 16,
                          color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                        ),
                        Text(
                          l10n.localeName == 'ko' ? '캘린더' : 'Calendar',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: 수정 기능
                    },
                    child: Text(
                      l10n.localeName == 'ko' ? '수정' : 'Edit',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 날짜 헤더
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatYear(l10n),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatMonthDay(l10n),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatWeekday(l10n),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // 구분선
            Divider(
              height: 1,
              color: isDark ? themeColors.darkTextSecondary.withValues(alpha: 0.2) : Colors.grey[200],
            ),

            // 내용
            Expanded(
              child: entry != null
                  ? Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                          entry.content,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                            height: 1.6,
                          ),
                        ),
                          const SizedBox(height: 16),
                          Text(
                            _formatTime(entry.createdAt, l10n),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        l10n.localeName == 'ko' ? '기록이 없습니다' : 'No entry',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                        ),
                      ),
                    ),
            ),

            // 하단 네비게이션
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: prevDate != null ? _goToPreviousDate : null,
                    child: Row(
                      children: [
                        Icon(
                          Icons.chevron_left,
                          size: 20,
                          color: prevDate != null
                              ? (isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary)
                              : Colors.transparent,
                        ),
                        Text(
                          prevDate != null ? _formatNavDate(prevDate, l10n) : '',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: nextDate != null ? _goToNextDate : null,
                    child: Row(
                      children: [
                        Text(
                          nextDate != null ? _formatNavDate(nextDate, l10n) : '',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: nextDate != null
                              ? (isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary)
                              : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
