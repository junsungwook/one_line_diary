// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '한 줄 기록';

  @override
  String get tagline => '하루 끝, 한 줄로 기록해요';

  @override
  String get today => '오늘';

  @override
  String get write => '기록하기';

  @override
  String get hint => '오늘 하루는 어땠나요?';

  @override
  String get placeholder => '오늘 하루를 한 줄로...';

  @override
  String get streak => '연속';

  @override
  String streakDays(int days) {
    return '$days일째';
  }

  @override
  String get calendar => '달력';

  @override
  String get entries => '기록';

  @override
  String get noEntryYet => '아직 기록이 없어요';

  @override
  String get writeFirstLine => '오늘의 한 줄을 남겨보세요!';

  @override
  String get saved => '저장됨!';

  @override
  String get delete => '삭제';

  @override
  String get edit => '수정';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';
}
