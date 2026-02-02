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

  String _formatYearMonth(String localeName) {
    final d = _today;
    switch (localeName) {
      case 'ko':
        return '${d.year}년 ${d.month}월';
      case 'ja':
        return '${d.year}年${d.month}月';
      case 'zh':
        return '${d.year}年${d.month}月';
      case 'de':
        const months = ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni',
          'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];
        return '${months[d.month - 1]} ${d.year}';
      case 'es':
        const months = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
          'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
        return '${months[d.month - 1]} ${d.year}';
      default:
        const months = ['January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December'];
        return '${months[d.month - 1]} ${d.year}';
    }
  }

  String _getWeekday(String localeName) {
    final weekday = _today.weekday - 1;
    switch (localeName) {
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

  String _getTodayText(String localeName) {
    switch (localeName) {
      case 'ko': return '오늘';
      case 'ja': return '今日';
      case 'zh': return '今天';
      case 'es': return 'Hoy';
      case 'de': return 'Heute';
      default: return 'Today';
    }
  }

  String _getCancelText(String localeName) {
    switch (localeName) {
      case 'ko': return '취소';
      case 'ja': return 'キャンセル';
      case 'zh': return '取消';
      case 'es': return 'Cancelar';
      case 'de': return 'Abbrechen';
      default: return 'Cancel';
    }
  }

  String _getSaveText(String localeName) {
    switch (localeName) {
      case 'ko': return '저장';
      case 'ja': return '保存';
      case 'zh': return '儲存';
      case 'es': return 'Guardar';
      case 'de': return 'Speichern';
      default: return 'Save';
    }
  }

  String _getTodaysLineText(String localeName) {
    switch (localeName) {
      case 'ko': return '오늘의 한 줄';
      case 'ja': return '今日の一行';
      case 'zh': return '今天的一行';
      case 'es': return 'Línea de hoy';
      case 'de': return 'Zeile des Tages';
      default: return "Today's line";
    }
  }

  String _getTapToWriteText(String localeName) {
    switch (localeName) {
      case 'ko': return '탭하여 오늘을 기록하세요';
      case 'ja': return 'タップして今日を記録';
      case 'zh': return '點擊記錄今天';
      case 'es': return 'Toca para escribir';
      case 'de': return 'Tippen zum Schreiben';
      default: return 'Tap to write about today';
    }
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
    final lang = l10n.localeName;

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
                              _getCancelText(lang),
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
                            _getSaveText(lang),
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
                          _formatYearMonth(lang),
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
                          _getWeekday(lang),
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
                            _getTodayText(lang),
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
                            _getTodaysLineText(lang),
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
                                : _getTapToWriteText(lang),
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
