import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../bootstrap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/settings_service.dart';
import '../../../../shared/widgets/dark_mode_button.dart';

class WritePage extends StatefulWidget {
  const WritePage({super.key});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isEditing = false;
  static const int _maxLength = 50;

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();
    _loadEntry();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isEditing = _focusNode.hasFocus;
    });
  }

  void _loadEntry() {
    final entry = diaryService.getEntry(_today);
    _controller.text = entry?.content ?? '';
    setState(() {});
  }

  Future<void> _saveEntry() async {
    if (_controller.text.trim().isEmpty) return;

    await diaryService.saveEntry(
      _controller.text.trim(),
      date: _today,
    );

    if (mounted) {
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

  void _cancelEditing() {
    _loadEntry();
    _focusNode.unfocus();
  }

  String _formatYearMonth(AppLocalizations l10n) {
    final d = _today;
    if (l10n.localeName == 'ko') {
      return '${d.year}년 ${d.month}월';
    }
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[d.month - 1]} ${d.year}';
  }

  String _getWeekday(AppLocalizations l10n) {
    if (l10n.localeName == 'ko') {
      const days = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
      return days[_today.weekday - 1];
    }
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[_today.weekday - 1];
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
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
          child: Column(
            children: [
              // 상단 바
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_isEditing)
                      GestureDetector(
                        onTap: _cancelEditing,
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              size: 16,
                              color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                            ),
                            Text(
                              l10n.localeName == 'ko' ? '취소' : 'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      const SizedBox(width: 60),
                    if (_isEditing)
                      GestureDetector(
                        onTap: _controller.text.trim().isNotEmpty ? _saveEntry : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _controller.text.trim().isNotEmpty
                                ? (isDark ? Colors.white : const Color(0xFF2D2D2D))
                                : (isDark ? Colors.grey[800] : Colors.grey[300]),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            l10n.localeName == 'ko' ? '저장' : 'Save',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _controller.text.trim().isNotEmpty
                                  ? (isDark ? Colors.black : Colors.white)
                                  : (isDark ? Colors.grey[600] : Colors.grey[500]),
                            ),
                          ),
                        ),
                      )
                    else
                      const DarkModeButton(),
                  ],
                ),
              ),

              // 날짜 영역
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // 년/월
                        Text(
                          _formatYearMonth(l10n),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // 날짜 (큰 숫자)
                        Text(
                          '${_today.day}',
                          style: TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.w700,
                            color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                            height: 1.1,
                          ),
                        ),
                        // 요일
                        Text(
                          _getWeekday(l10n),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                          ),
                        ),
                        // 오늘 표시
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            l10n.localeName == 'ko' ? '오늘' : 'Today',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 구분선
              Divider(
                height: 1,
                color: isDark ? themeColors.darkTextSecondary.withValues(alpha: 0.2) : Colors.grey[200],
              ),

              // 오늘의 한 줄 영역
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () => _focusNode.requestFocus(),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!_isEditing) ...[
                          Text(
                            l10n.localeName == 'ko' ? '오늘의 한 줄' : "Today's line",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (_isEditing) ...[
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              maxLength: _maxLength,
                              maxLines: null,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                                height: 1.6,
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
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                filled: true,
                                fillColor: Colors.transparent,
                                counterText: '',
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${_controller.text.length} / $_maxLength',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                              ),
                            ),
                          ),
                        ] else ...[
                          Text(
                            _controller.text.isNotEmpty
                                ? _controller.text
                                : (l10n.localeName == 'ko' ? '탭하여 오늘을 기록하세요' : 'Tap to write about today'),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: _controller.text.isNotEmpty
                                  ? (isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary)
                                  : (isDark ? themeColors.darkTextSecondary.withValues(alpha: 0.5) : themeColors.lightTextSecondary.withValues(alpha: 0.5)),
                              height: 1.6,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // 숨겨진 TextField (포커스용)
              if (!_isEditing)
                Offstage(
                  offstage: true,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
