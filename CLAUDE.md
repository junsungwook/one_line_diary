# CLAUDE.md

# 한 줄 기록 (One Line Diary)

## 앱 소개
하루 끝에 한 줄만 기록하는 초간단 일기 앱

## 핵심 컨셉
- 한 줄만 쓴다 (길게 X)
- 달력에 기록이 쌓인다
- 심플하고 모던한 감성
- 

## 기술 스택
- Framework: Flutter
- DB: Hive (로컬 저장)
- 상태관리: Provider
- 달력: table_calendar

## 코어 기능 (MVP)
1. 오늘 한 줄 입력
2. 달력에서 기록된 날 표시
3. 날짜 누르면 기록 확인
4. 로컬 저장 (서버 없음)

## 화면 구성
1. 홈 화면: 달력 + 오늘 입력창
2. 상세 화면: 선택한 날짜 기록 보기

## 데이터 모델
```dart
DiaryEntry {
  String id
  DateTime date
  String content  // 한 줄 텍스트
  DateTime createdAt
}
```

## 디자인 방향
- 픽셀/도트 스타일
- 귀여운 분위기
- 미니멀한 UI
- 컬러: 파스텔 톤

## MVP 우선순위
1. ✅ 기록 입력/저장
2. ✅ 달력 뷰
3. ✅ 기록 조회
4. ⬜ 스트릭 표시 (나중에)
5. ⬜ 테마 설정 (나중에)

## 출시 타겟
- iOS + Android 동시
- 앱 이름: 한 줄 기록
- 패키지: com.yourname.onelinediary

## 빌드 및 실행 명령어

```bash
flutter pub get              # 의존성 설치
flutter run                  # 앱 실행 (디버그)
flutter test                 # 테스트 실행
flutter analyze              # 코드 분석 (린팅)
```

## 아키텍처

```
lib/
├── main.dart
├── app.dart
├── core/           # 공통 유틸, 테마, 상수
├── features/
│   ├── diary/      # 일기 입력/조회 (핵심)
│   └── calendar/   # 달력 뷰
├── models/         # 데이터 모델 (DiaryEntry)
├── services/       # Hive 로컬 DB 서비스
└── shared/         # 공유 위젯
```

## Claude Code 협업 지침

- 단순함 최우선: 한 줄 기록의 본질에 집중
- 로컬 우선 (서버 연동 X)
- MVP 기능에 집중, 불필요한 기능 추가 자제
