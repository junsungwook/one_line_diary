# 한 줄 기록 (One Line Diary)

하루 끝에 한 줄만 기록하는 초간단 일기 앱

## Screenshots

<!-- 스크린샷 추가 예정 -->

## Features

- **한 줄 기록**: 매일 간단하게 한 줄로 하루를 기록
- **달력 뷰**: 기록한 날짜를 한눈에 확인
- **다크/라이트 모드**: 눈이 편한 테마 선택
- **3가지 색상 테마**: Milk & Gray Blue, Plum & Milk, Cloud & Smog
- **다국어 지원**: 한국어, English
- **로컬 저장**: 서버 없이 기기에 안전하게 저장

## Tech Stack

- **Framework**: Flutter
- **State Management**: Provider
- **Local Database**: Hive
- **Localization**: Flutter intl (ARB)

## Project Structure

```
lib/
├── main.dart
├── app.dart
├── bootstrap.dart
├── core/
│   ├── router/          # 라우팅 설정
│   └── theme/           # 테마, 색상 정의
├── features/
│   ├── calendar/        # 달력 화면
│   ├── home/            # 홈 화면
│   ├── settings/        # 설정 화면
│   └── write/           # 일기 입력 화면
├── l10n/                # 다국어 리소스
├── models/              # 데이터 모델
├── services/            # 비즈니스 로직
└── shared/              # 공유 위젯
```

## Getting Started

### Prerequisites

- Flutter SDK 3.0+
- Dart 3.0+

### Installation

```bash
# 의존성 설치
flutter pub get

# 앱 실행
flutter run

# 웹에서 실행
flutter run -d chrome
```

### Build

```bash
# Android APK
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```

## License

MIT License
