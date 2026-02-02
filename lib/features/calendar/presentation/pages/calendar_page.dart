import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../bootstrap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/settings_service.dart';
import '../../../../shared/widgets/dark_mode_button.dart';
import 'entry_detail_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _currentMonth;
  late DateTime _selectedDay;
  Set<DateTime> _recordedDates = {};

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _selectedDay = DateTime.now();
    _loadRecordedDates();
  }

  void _loadRecordedDates() {
    final dates = diaryService.getRecordedDates();
    setState(() {
      _recordedDates = dates.map((d) => DateTime(d.year, d.month, d.day)).toSet();
    });
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  void _goToToday() {
    setState(() {
      _currentMonth = DateTime.now();
      _selectedDay = DateTime.now();
    });
  }

  bool _isToday(DateTime day) {
    final now = DateTime.now();
    return day.year == now.year &&
        day.month == now.month &&
        day.day == now.day;
  }

  bool _isSelected(DateTime day) {
    return day.year == _selectedDay.year &&
        day.month == _selectedDay.month &&
        day.day == _selectedDay.day;
  }

  bool _hasRecord(DateTime day) {
    return _recordedDates.contains(DateTime(day.year, day.month, day.day));
  }

  bool _isFuture(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(day.year, day.month, day.day);
    return target.isAfter(today);
  }

  void _openEntryDetail(DateTime date) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EntryDetailPage(initialDate: date),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    ).then((_) => _loadRecordedDates());
  }

  List<String> _getWeekdays(AppLocalizations l10n) {
    if (l10n.localeName == 'ko') {
      return ['일', '월', '화', '수', '목', '금', '토'];
    }
    return ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  }

  int _calculateStreak() {
    final sortedDates = _recordedDates.toList()..sort((a, b) => b.compareTo(a));
    if (sortedDates.isEmpty) return 0;

    int streak = 0;
    DateTime checkDate = DateTime.now();
    checkDate = DateTime(checkDate.year, checkDate.month, checkDate.day);

    for (final date in sortedDates) {
      if (date.year == checkDate.year &&
          date.month == checkDate.month &&
          date.day == checkDate.day) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (date.isBefore(checkDate)) {
        break;
      }
    }
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = context.watch<SettingsService>().currentThemeColors;

    return Scaffold(
      backgroundColor: isDark ? themeColors.darkBackground : themeColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(l10n, isDark, themeColors),
              const SizedBox(height: 24),
              _buildWeekdayHeader(l10n, isDark, themeColors),
              const SizedBox(height: 12),
              Expanded(child: _buildCalendarGrid(isDark, themeColors)),
              const SizedBox(height: 16),
              _buildStatsCard(l10n, isDark, themeColors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n, bool isDark, ThemeColors themeColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: _previousMonth,
              child: Icon(
                Icons.chevron_left,
                size: 24,
                color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              l10n.localeName == 'ko'
                  ? '${_currentMonth.year}년 ${_currentMonth.month}월'
                  : '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _nextMonth,
              child: Icon(
                Icons.chevron_right,
                size: 24,
                color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: _goToToday,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? themeColors.darkSurface : themeColors.lightSurface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  l10n.localeName == 'ko' ? '오늘' : 'Today',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const DarkModeButton(),
          ],
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Widget _buildWeekdayHeader(AppLocalizations l10n, bool isDark, ThemeColors themeColors) {
    final weekdays = _getWeekdays(l10n);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.asMap().entries.map((entry) {
        final index = entry.key;
        final day = entry.value;
        final isSunday = index == 0;
        final isSaturday = index == 6;

        Color textColor;
        if (isSunday) {
          textColor = AppColors.error;
        } else if (isSaturday) {
          textColor = Colors.blue;
        } else {
          textColor = isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary;
        }

        return SizedBox(
          width: 40,
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid(bool isDark, ThemeColors themeColors) {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);

    int startWeekday = firstDayOfMonth.weekday % 7;
    int daysInMonth = lastDayOfMonth.day;

    List<Widget> dayWidgets = [];

    for (int i = 0; i < startWeekday; i++) {
      dayWidgets.add(const SizedBox(width: 40, height: 48));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      dayWidgets.add(_buildDayCell(date, isDark, themeColors));
    }

    return GridView.count(
      crossAxisCount: 7,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      childAspectRatio: 0.85,
      children: dayWidgets,
    );
  }

  Widget _buildDayCell(DateTime date, bool isDark, ThemeColors themeColors) {
    final isToday = _isToday(date);
    final isSelected = _isSelected(date);
    final hasRecord = _hasRecord(date);
    final isFuture = _isFuture(date);
    final isSunday = date.weekday == 7;
    final isSaturday = date.weekday == 6;

    Color textColor;
    if (isFuture) {
      textColor = (isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary).withValues(alpha: 0.3);
    } else if (isSunday) {
      textColor = AppColors.error;
    } else if (isSaturday) {
      textColor = Colors.blue;
    } else {
      textColor = isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary;
    }

    return GestureDetector(
      onTap: () {
        setState(() => _selectedDay = date);
        _loadRecordedDates();
        if (hasRecord) {
          _openEntryDetail(date);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isToday ? const Color(0xFF2D2D2D) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                  color: isToday ? Colors.white : textColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: hasRecord
                  ? AppColors.primary
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(AppLocalizations l10n, bool isDark, ThemeColors themeColors) {
    final thisMonthRecords = _recordedDates
        .where((d) => d.year == _currentMonth.year && d.month == _currentMonth.month)
        .length;

    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final now = DateTime.now();
    final isCurrentMonth = _currentMonth.year == now.year && _currentMonth.month == now.month;
    final totalDays = isCurrentMonth ? now.day : daysInMonth;
    final percentage = totalDays > 0 ? ((thisMonthRecords / totalDays) * 100).round() : 0;

    final streak = _calculateStreak();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? themeColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.localeName == 'ko' ? '이번 달 기록' : 'This Month',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                value: '$thisMonthRecords',
                label: l10n.localeName == 'ko' ? '기록한 날' : 'Days',
                isDark: isDark,
                themeColors: themeColors,
              ),
              _buildStatItem(
                value: '$streak',
                label: l10n.localeName == 'ko' ? '연속 기록' : 'Streak',
                isDark: isDark,
                themeColors: themeColors,
              ),
              _buildStatItem(
                value: '$percentage%',
                label: l10n.localeName == 'ko' ? '달성률' : 'Rate',
                isDark: isDark,
                themeColors: themeColors,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required bool isDark,
    required ThemeColors themeColors,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}
