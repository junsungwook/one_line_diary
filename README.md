# one line

하루 끝에 한 줄만 기록하는 초간단 일기 앱

복잡한 일기는 그만. 오늘 하루를 딱 한 문장으로 정리하세요.

## 주요 기능

### 한 줄 기록
- 최대 50자로 오늘 하루를 기록
- 탭 한 번으로 간편하게 작성
- 오늘 날짜만 작성 가능 (과거는 읽기 전용)

### 캘린더
- 월간 달력으로 기록 현황 한눈에 확인
- 기록한 날짜에 주황색 점 표시
- 통계: 기록한 날, 연속 기록, 이번 달 달성률

### 알림
- 원하는 시간에 매일 알림
- 상황에 맞는 다양한 멘트

### 홈 화면 위젯
- iOS/Android 홈 화면 위젯 지원
- 기록 전/후 다른 디자인
- 탭하면 바로 앱 열기

### 개인화
- 다크/라이트 모드
- 3가지 색상 테마
- 6개 언어 지원 (한국어, English, 日本語, 繁體中文, Español, Deutsch)

## 기술 스택

| 구분 | 기술 |
|------|------|
| Framework | Flutter |
| 상태관리 | Provider |
| 로컬 DB | Hive |
| 알림 | flutter_local_notifications |
| 위젯 | WidgetKit (iOS), AppWidgetProvider (Android) |

## 시작하기

```bash
# 의존성 설치
flutter pub get

# 실행
flutter run
```

## 빌드

```bash
# Android (Play Store)
flutter build appbundle --release

# iOS (App Store)
flutter build ipa --release
```

## 프로젝트 구조

```
lib/
├── core/           # 테마, 유틸리티
├── features/       # 화면별 기능
│   ├── write/      # 기록 작성
│   ├── calendar/   # 캘린더 + 상세
│   └── settings/   # 설정
├── services/       # 비즈니스 로직
├── models/         # 데이터 모델
└── l10n/           # 다국어
```

## 개인정보처리방침

- [한국어](https://junsungwook.github.io/one_line_diary/privacy-ko.html)
- [English](https://junsungwook.github.io/one_line_diary/privacy-en.html)

## 라이선스

MIT License
