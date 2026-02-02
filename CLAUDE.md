# CLAUDE.md

# one line (한 줄 기록)

## 앱 소개
하루 끝에 한 줄만 기록하는 초간단 일기 앱. 복잡한 일기 대신 오늘 하루를 한 문장으로 정리한다.

## 앱 정보
- **앱 이름**: one line
- **패키지명**: com.jundev.oneline (iOS/Android 동일)
- **버전**: 1.0.0
- **최소 지원**: iOS 13.0 / Android (minSdk Flutter 기본값)

## 기술 스택
- **Framework**: Flutter 3.10+
- **언어**: Dart
- **DB**: Hive (로컬 저장, 서버 없음)
- **상태관리**: Provider
- **달력**: table_calendar
- **라우팅**: go_router
- **국제화**: flutter_localizations (한국어/영어)

## 구현된 기능

### 1. 스플래시 화면
- 앱 시작 시 로고와 함께 페이드 전환
- 1초 대기 후 메인 화면으로 이동

### 2. 쓰기 화면 (WritePage)
- 오늘 날짜 표시 (년/월, 큰 날짜 숫자, 요일, "오늘")
- 하단에 "오늘의 한 줄" 입력 영역
- 탭하면 편집 모드 전환
- 최대 50자 제한
- 저장 시 스낵바 알림
- **오늘 날짜만 작성 가능** (과거 날짜는 읽기 전용)

### 3. 캘린더 화면 (CalendarPage)
- table_calendar 기반 월간 달력
- 기록된 날짜에 주황색 점 표시
- 일요일 빨간색, 토요일 파란색
- **통계 카드**: 기록한 날, 연속 기록, 이번 달 달성률
- 날짜 클릭 시 상세 페이지로 이동

### 4. 상세 페이지 (EntryDetailPage)
- 전체화면으로 기록 확인
- 상단: "← 캘린더" 뒤로가기, "수정" 버튼
- 날짜 헤더 (년도, 월/일, 요일)
- 기록 내용 및 기록 시간 표시
- 하단: 이전/다음 기록된 날짜로 이동 네비게이션

### 5. 설정 화면 (SettingsPage)
- 다크모드 토글
- 테마 색상 선택 (5가지)
- 언어 설정 (한국어/영어)

### 6. 공통 기능
- 스와이프로 페이지 전환 (PageView)
- 다크모드 지원
- 다국어 지원 (한국어/영어)
- 테마 색상 커스터마이징

## 화면 구성
```
[스플래시] → [홈]
                ├── 쓰기 (WritePage) ←→ 스와이프 ←→ 캘린더 (CalendarPage) ←→ 설정 (SettingsPage)
                                                        │
                                                        └── 상세 (EntryDetailPage)
```

## 프로젝트 구조
```
lib/
├── main.dart                 # 앱 진입점
├── app.dart                  # MaterialApp 설정, 스플래시 래퍼
├── bootstrap.dart            # Hive 초기화, 서비스 인스턴스
├── core/
│   ├── theme/
│   │   ├── app_theme.dart    # 라이트/다크 테마 정의
│   │   ├── app_colors.dart   # 테마별 색상 정의
│   │   └── app_text_styles.dart
│   ├── router/
│   │   ├── app_router.dart   # go_router 설정
│   │   └── route_names.dart
│   └── utils/
│       └── logger.dart
├── features/
│   ├── splash/
│   │   └── presentation/pages/splash_page.dart
│   ├── home/
│   │   └── presentation/pages/home_page.dart    # PageView 컨테이너
│   ├── write/
│   │   └── presentation/pages/write_page.dart   # 오늘 기록 작성
│   ├── calendar/
│   │   └── presentation/pages/
│   │       ├── calendar_page.dart      # 달력 + 통계
│   │       └── entry_detail_page.dart  # 기록 상세 보기
│   └── settings/
│       └── presentation/pages/settings_page.dart
├── models/
│   └── diary_entry.dart      # DiaryEntry 모델 (Hive 어댑터)
├── services/
│   ├── diary_service.dart    # 일기 CRUD (Hive)
│   └── settings_service.dart # 설정 관리 (다크모드, 테마, 언어)
├── shared/
│   └── widgets/
│       └── dark_mode_button.dart
└── l10n/
    ├── app_localizations.dart
    ├── app_localizations_ko.dart
    └── app_localizations_en.dart
```

## 데이터 모델
```dart
@HiveType(typeId: 0)
class DiaryEntry extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String content;  // 최대 50자

  @HiveField(3)
  DateTime createdAt;
}
```

## 빌드 명령어
```bash
# 개발
flutter pub get              # 의존성 설치
flutter run                  # 디버그 실행
flutter run -d "iPhone 16e"  # iOS 시뮬레이터 지정 실행

# 릴리즈 빌드
flutter build appbundle --release  # Android (Play Store용 .aab)
flutter build ipa --release        # iOS (App Store용)

# 기타
flutter analyze              # 코드 분석
flutter test                 # 테스트 실행
dart run flutter_launcher_icons  # 앱 아이콘 생성
```

## 출시 준비 상태
- ✅ Android: 패키지명, 서명키, ProGuard 설정 완료
- ✅ iOS: Bundle ID 설정 완료
- ⬜ Apple Developer 계정 등록 필요
- ⬜ App Store Connect 앱 생성 필요

## 디자인
- 미니멀하고 모던한 UI
- 다크/라이트 모드 지원
- 5가지 테마 색상 (크림, 라벤더, 민트, 피치, 스카이)
- 앱 아이콘: 검정 배경에 흰색 연필 + 주황색 점

## Claude Code 협업 지침
- 단순함 최우선: 한 줄 기록의 본질에 집중
- 로컬 우선 (서버 연동 X)
- MVP 기능에 집중, 불필요한 기능 추가 자제
- 커밋 메시지는 한글로 작성
