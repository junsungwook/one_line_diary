import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../bootstrap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/settings_service.dart';
import '../../../../shared/widgets/dark_mode_button.dart';

class CalendarPage extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const CalendarPage({super.key, required this.onDateSelected});

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

  String _getMonthName(int month, AppLocalizations l10n) {
    if (l10n.localeName == 'ko') {
      return '$month월';
    }
    const months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  List<String> _getWeekdays(AppLocalizations l10n) {
    if (l10n.localeName == 'ko') {
      return ['월', '화', '수', '목', '금', '토', '일'];
    }
    return ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
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
              const SizedBox(height: 28),
              _buildMonthSelector(l10n, isDark, themeColors),
              const SizedBox(height: 20),
              _buildWeekdayHeader(l10n, isDark, themeColors),
              const SizedBox(height: 12),
              Expanded(child: _buildCalendarGrid(isDark, themeColors)),
              const SizedBox(height: 16),
              _buildRecordCount(l10n, isDark, themeColors),
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
        Text(
          l10n.appTitle,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const DarkModeButton(),
      ],
    );
  }

  Widget _buildMonthSelector(AppLocalizations l10n, bool isDark, ThemeColors themeColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              _getMonthName(_currentMonth.month, l10n),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${_currentMonth.year}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildNavButton(Icons.chevron_left_rounded, _previousMonth, isDark, themeColors),
            const SizedBox(width: 8),
            _buildNavButton(Icons.chevron_right_rounded, _nextMonth, isDark, themeColors),
          ],
        ),
      ],
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onTap, bool isDark, ThemeColors themeColors) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDark ? themeColors.darkSurface : themeColors.lightSurface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 22,
          color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
        ),
      ),
    );
  }

  Widget _buildWeekdayHeader(AppLocalizations l10n, bool isDark, ThemeColors themeColors) {
    final weekdays = _getWeekdays(l10n);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays
          .map((day) => SizedBox(
                width: 40,
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid(bool isDark, ThemeColors themeColors) {
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);

    int startWeekday = firstDayOfMonth.weekday;
    int daysInMonth = lastDayOfMonth.day;

    List<Widget> dayWidgets = [];

    for (int i = 1; i < startWeekday; i++) {
      dayWidgets.add(const SizedBox(width: 40, height: 40));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      dayWidgets.add(_buildDayCell(date, isDark, themeColors));
    }

    return GridView.count(
      crossAxisCount: 7,
      mainAxisSpacing: 8,
      crossAxisSpacing: 6,
      children: dayWidgets,
    );
  }

  Widget _buildDayCell(DateTime date, bool isDark, ThemeColors themeColors) {
    final isToday = _isToday(date);
    final isSelected = _isSelected(date);
    final hasRecord = _hasRecord(date);
    final isFuture = _isFuture(date);

    Color bgColor;
    Color textColor;
    FontWeight fontWeight = FontWeight.w500;

    if (isToday) {
      bgColor = AppColors.dotToday;
      textColor = Colors.white;
      fontWeight = FontWeight.w600;
    } else if (hasRecord) {
      bgColor = AppColors.dotRecorded;
      textColor = Colors.white;
    } else if (isFuture) {
      bgColor = isDark ? themeColors.darkSurface : AppColors.dotFuture;
      textColor = isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary;
    } else {
      bgColor = isDark ? themeColors.darkSurface.withValues(alpha: 0.5) : AppColors.dotEmpty;
      textColor = isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = date;
        });
        _loadRecordedDates();
        widget.onDateSelected(date);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                  width: 2.5,
                )
              : null,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: fontWeight,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecordCount(AppLocalizations l10n, bool isDark, ThemeColors themeColors) {
    final thisMonthRecords = _recordedDates
        .where((d) =>
            d.year == _currentMonth.year && d.month == _currentMonth.month)
        .length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? themeColors.darkSurface : themeColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.dotRecorded,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            l10n.localeName == 'ko'
                ? '이번 달 $thisMonthRecords개 기록'
                : '$thisMonthRecords entries this month',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
