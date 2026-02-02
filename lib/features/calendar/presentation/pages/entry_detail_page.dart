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

  String _formatYear(String lang) {
    switch (lang) {
      case 'ko':
        return '${_currentDate.year}년';
      case 'ja':
        return '${_currentDate.year}年';
      case 'zh':
        return '${_currentDate.year}年';
      default:
        return '${_currentDate.year}';
    }
  }

  String _formatMonthDay(String lang) {
    final m = _currentDate.month;
    final d = _currentDate.day;
    switch (lang) {
      case 'ko':
        return '${m}월 ${d}일';
      case 'ja':
        return '${m}月${d}日';
      case 'zh':
        return '${m}月${d}日';
      case 'de':
        const months = ['Jan.', 'Feb.', 'März', 'Apr.', 'Mai', 'Juni',
          'Juli', 'Aug.', 'Sept.', 'Okt.', 'Nov.', 'Dez.'];
        return '$d. ${months[m - 1]}';
      case 'es':
        const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
          'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
        return '$d de ${months[m - 1]}';
      default:
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        return '${months[m - 1]} $d';
    }
  }

  String _formatWeekday(String lang) {
    final weekday = _currentDate.weekday - 1;
    switch (lang) {
      case 'ko':
        const days = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
        return days[weekday];
      case 'ja':
        const days = ['月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日', '日曜日'];
        return days[weekday];
      case 'zh':
        const days = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
        return days[weekday];
      case 'es':
        const days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
        return days[weekday];
      case 'de':
        const days = ['Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag'];
        return days[weekday];
      default:
        const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
        return days[weekday];
    }
  }

  String _formatNavDate(DateTime date, String lang) {
    final m = date.month;
    final d = date.day;
    switch (lang) {
      case 'ko':
        return '${m}월 ${d}일';
      case 'ja':
        return '${m}月${d}日';
      case 'zh':
        return '${m}月${d}日';
      case 'de':
        const months = ['Jan.', 'Feb.', 'März', 'Apr.', 'Mai', 'Juni',
          'Juli', 'Aug.', 'Sept.', 'Okt.', 'Nov.', 'Dez.'];
        return '$d. ${months[m - 1]}';
      case 'es':
        const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
          'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
        return '$d de ${months[m - 1]}';
      default:
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        return '${months[m - 1]} $d';
    }
  }

  String _formatTime(DateTime time, String lang) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');

    switch (lang) {
      case 'ko':
        if (hour < 12) {
          return '오전 ${hour == 0 ? 12 : hour}:$minute에 기록됨';
        } else {
          return '오후 ${hour == 12 ? 12 : hour - 12}:$minute에 기록됨';
        }
      case 'ja':
        if (hour < 12) {
          return '午前${hour == 0 ? 12 : hour}:${minute}に記録';
        } else {
          return '午後${hour == 12 ? 12 : hour - 12}:${minute}に記録';
        }
      case 'zh':
        if (hour < 12) {
          return '上午${hour == 0 ? 12 : hour}:$minute記錄';
        } else {
          return '下午${hour == 12 ? 12 : hour - 12}:$minute記錄';
        }
      case 'de':
        return 'Aufgezeichnet um $hour:$minute Uhr';
      case 'es':
        return 'Registrado a las $hour:$minute';
      default:
        final amPm = hour < 12 ? 'AM' : 'PM';
        final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
        return 'Recorded at $displayHour:$minute $amPm';
    }
  }

  String _getCalendarText(String lang) {
    switch (lang) {
      case 'ko': return '캘린더';
      case 'ja': return 'カレンダー';
      case 'zh': return '日曆';
      case 'es': return 'Calendario';
      case 'de': return 'Kalender';
      default: return 'Calendar';
    }
  }

  String _getEditText(String lang) {
    switch (lang) {
      case 'ko': return '수정';
      case 'ja': return '編集';
      case 'zh': return '編輯';
      case 'es': return 'Editar';
      case 'de': return 'Bearbeiten';
      default: return 'Edit';
    }
  }

  String _getNoEntryText(String lang) {
    switch (lang) {
      case 'ko': return '기록이 없습니다';
      case 'ja': return '記録がありません';
      case 'zh': return '沒有記錄';
      case 'es': return 'Sin entrada';
      case 'de': return 'Kein Eintrag';
      default: return 'No entry';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = context.watch<SettingsService>().currentThemeColors;
    final lang = l10n.localeName;

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
                          _getCalendarText(lang),
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
                      _getEditText(lang),
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
                    _formatYear(lang),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatMonthDay(lang),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatWeekday(lang),
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
                            _formatTime(entry.createdAt, lang),
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
                        _getNoEntryText(lang),
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
                          prevDate != null ? _formatNavDate(prevDate, lang) : '',
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
                          nextDate != null ? _formatNavDate(nextDate, lang) : '',
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
