# PROMPT.md

Kurly 채용과제 진행 중 AI(Claude Code)와의 대화 기록

---

## 세션 1: 프로젝트 분석 및 문서화

**날짜**: 2025-12-15

### Q1. 코드베이스 분석 및 CLAUDE.md 생성 요청

**질문**: `/init` 명령으로 코드베이스 분석 후 CLAUDE.md 생성
- 빌드/테스트 커맨드 정리
- 아키텍처 및 구조 설명

**답변**:
- Explore 에이전트로 프로젝트 전체 분석
- iOS 15.0+, Swift 5.0, UIKit 기반 스켈레톤 프로젝트 확인
- Clean Architecture + MVVM 계획되었으나 미구현
- 외부 의존성 없음
- CLAUDE.md 생성: 빌드/테스트 커맨드, 아키텍처, 계획된 기능 문서화

**결과**: `CLAUDE.md` 파일 생성

---

### Q2. AI Prompt 기록 문서화

**질문**: PROMPT.md 파일 생성하여 질의응답 요약 및 시간 기록

**답변**: 본 문서 생성

**결과**: `PROMPT.md` 파일 생성

---

## 세션 2: Domain Layer UseCase 테스트 코드 작성

**날짜**: 2025-12-17

### Q1. XCTest로 Domain Layer UseCase 테스트 작성 요청

**질문**: 프로젝트의 테스트 코드를 작성할 예정이며, XCTest로 도메인 레이어의 UseCase부터 작성 요청

**분석**:
- Explore 에이전트로 도메인 레이어 구조 파악
- 5개의 UseCase 발견:
  - `FetchGitHubRepoUseCase`: GitHub 저장소 검색
  - `FetchSearchQueryUseCase`: 검색 히스토리 조회
  - `SaveSearchQueryUseCase`: 검색 쿼리 저장
  - `RemoveSearchQueryUseCase`: 검색 쿼리 삭제
  - `RemoveAllSearchQueryUseCase`: 전체 검색 쿼리 삭제
- 2개의 Repository 인터페이스: `GitHubRepository`, `SearchQueryRepository`
- 3개의 엔티티: `GitHubRepo`, `GitHubRepoPage`, `SearchQuery`

**구현**:
1. Mock Repository 클래스 작성:
   - `MockGitHubRepository`: GitHubRepository 테스트 더블
   - `MockSearchQueryRepository`: SearchQueryRepository 테스트 더블
   - `@unchecked Sendable` 적용하여 Swift Concurrency 요구사항 충족

2. UseCase별 테스트 작성 (총 27개 테스트):
   - `FetchGitHubRepoUseCaseTests`: 4개 테스트
   - `FetchSearchQueryUseCaseTests`: 6개 테스트
   - `SaveSearchQueryUseCaseTests`: 5개 테스트
   - `RemoveSearchQueryUseCaseTests`: 6개 테스트
   - `RemoveAllSearchQueryUseCaseTests`: 6개 테스트

3. 엔티티 테스트 작성 (총 6개 테스트):
   - `SearchQueryTests`: 초기화, 날짜 표시, Hashable (3개)
   - `GitHubRepoTests`: 초기화, Hashable (2개)
   - `GitHubRepoPageTests`: 초기화 (1개)

**테스트 패턴**:
- Given-When-Then 패턴 사용
- 성공 케이스와 실패 케이스 분리
- Mock 객체를 통한 의존성 격리
- 호출 횟수, 파라미터 검증

**결과**:
- 총 33개 테스트 작성 및 모두 통과
- Mock 클래스 2개 작성
- 실행 시간: 약 0.006초

---

### Q2. 테스트 함수명을 한글로 변경 요청

**질문**: 테스트 함수명을 전부 한글로 다시 작성하고, AI 프롬프트를 정리 요청

**구현**:
- 모든 테스트 함수명을 한글로 변경:
  - `test_execute_success` → `test_깃허브_저장소_조회_성공`
  - `test_execute_withEmptyResults` → `test_깃허브_저장소_조회_빈_결과`
  - `test_searchQuery_initialization` → `test_검색_쿼리_초기화`
  - 등 33개 테스트 함수명 모두 한글화

**변경 내역**:
- FetchGitHubRepoUseCaseTests: 4개 함수명 변경
- FetchSearchQueryUseCaseTests: 6개 함수명 변경
- SaveSearchQueryUseCaseTests: 5개 함수명 변경
- RemoveSearchQueryUseCaseTests: 6개 함수명 변경
- RemoveAllSearchQueryUseCaseTests: 6개 함수명 변경
- EntityTests: 6개 함수명 변경

**결과**:
- 모든 테스트 함수명이 한글로 변경되었으며, 33개 테스트 모두 정상 통과
- PROMPT.md 파일 업데이트 (본 내용 추가)
