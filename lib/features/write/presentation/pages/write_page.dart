import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../bootstrap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/settings_service.dart';
import '../../../../shared/widgets/dark_mode_button.dart';

class WritePage extends StatefulWidget {
  final DateTime selectedDate;

  const WritePage({super.key, required this.selectedDate});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _loadEntry();
  }

  @override
  void didUpdateWidget(WritePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _loadEntry();
    }
  }

  void _loadEntry() {
    final entry = diaryService.getEntry(widget.selectedDate);
    _controller.text = entry?.content ?? '';
    _hasUnsavedChanges = false;
    setState(() {});
  }

  Future<void> _saveEntry() async {
    if (_controller.text.trim().isEmpty) return;

    await diaryService.saveEntry(
      _controller.text.trim(),
      date: widget.selectedDate,
    );

    if (mounted) {
      setState(() {
        _hasUnsavedChanges = false;
      });
      _focusNode.unfocus();
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.saved),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 1),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  bool _isToday() {
    final now = DateTime.now();
    return widget.selectedDate.year == now.year &&
        widget.selectedDate.month == now.month &&
        widget.selectedDate.day == now.day;
  }

  String _formatFullDate(AppLocalizations l10n) {
    final d = widget.selectedDate;
    if (l10n.localeName == 'ko') {
      return '${d.year}년 ${d.month}월 ${d.day}일';
    }
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  String _getShortWeekday(AppLocalizations l10n) {
    if (l10n.localeName == 'ko') {
      const days = ['월', '화', '수', '목', '금', '토', '일'];
      return days[widget.selectedDate.weekday - 1];
    }
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[widget.selectedDate.weekday - 1];
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = context.watch<SettingsService>().currentThemeColors;

    return Scaffold(
      backgroundColor: isDark ? themeColors.darkBackground : themeColors.lightBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => _focusNode.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Day number
                    Text(
                      '${widget.selectedDate.day}',
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.w800,
                        color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                        height: 1.0,
                      ),
                    ),
                    const Spacer(),
                    // Unsaved indicator & dark mode
                    Column(
                      children: [
                        if (_hasUnsavedChanges)
                          Text(
                            '*',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                            ),
                          ),
                        const SizedBox(height: 8),
                        const DarkModeButton(),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Date and weekday
                Text(
                  _formatFullDate(l10n),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                  ),
                ),
                Text(
                  _getShortWeekday(l10n),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                  ),
                ),
                if (_isToday())
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      l10n.today,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                      ),
                    ),
                  ),

                const SizedBox(height: 36),

                // Section title
                Text(
                  l10n.localeName == 'ko' ? '오늘의 기록' : "Today's thoughts",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                  ),
                ),

                const SizedBox(height: 20),

                // Input field
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                      height: 1.8,
                    ),
                    decoration: InputDecoration(
                      hintText: l10n.hint,
                      hintStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? themeColors.darkTextSecondary.withValues(alpha: 0.5)
                            : themeColors.lightTextSecondary.withValues(alpha: 0.5),
                      ),
                      border: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _hasUnsavedChanges = true;
                      });
                    },
                  ),
                ),

                // Save button
                if (_controller.text.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Center(
                      child: GestureDetector(
                        onTap: _saveEntry,
                        child: Text(
                          l10n.save,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
