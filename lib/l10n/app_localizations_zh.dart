import 'app_localizations.dart';

// ignore_for_file: type=lint

class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '一行日記';

  @override
  String get tagline => '一天結束時用一行記錄';

  @override
  String get today => '今天';

  @override
  String get write => '寫';

  @override
  String get hint => '今天過得怎麼樣？';

  @override
  String get placeholder => '用一行字記錄今天...';

  @override
  String get streak => '連續';

  @override
  String streakDays(int days) {
    return '$days天';
  }

  @override
  String get calendar => '日曆';

  @override
  String get entries => '記錄';

  @override
  String get noEntryYet => '還沒有記錄';

  @override
  String get writeFirstLine => '寫下你的第一行吧！';

  @override
  String get saved => '已儲存！';

  @override
  String get delete => '刪除';

  @override
  String get edit => '編輯';

  @override
  String get cancel => '取消';

  @override
  String get save => '儲存';
}
