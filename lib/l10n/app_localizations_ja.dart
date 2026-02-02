import 'app_localizations.dart';

// ignore_for_file: type=lint

class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '一行日記';

  @override
  String get tagline => '一日の終わりに一行で記録';

  @override
  String get today => '今日';

  @override
  String get write => '書く';

  @override
  String get hint => '今日はどんな一日でしたか？';

  @override
  String get placeholder => '今日を一行で...';

  @override
  String get streak => '連続';

  @override
  String streakDays(int days) {
    return '$days日目';
  }

  @override
  String get calendar => 'カレンダー';

  @override
  String get entries => '記録';

  @override
  String get noEntryYet => 'まだ記録がありません';

  @override
  String get writeFirstLine => '最初の一行を書いてみましょう！';

  @override
  String get saved => '保存しました！';

  @override
  String get delete => '削除';

  @override
  String get edit => '編集';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';
}
