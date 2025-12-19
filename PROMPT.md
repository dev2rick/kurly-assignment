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

---

### Q3. Presentation Layer ViewModel 테스트 작성 요청

**질문**: Presentation 레이어의 ViewModel 테스트 코드 작성 요청

**분석**:
- Explore 에이전트로 Presentation 레이어 구조 파악
- 1개의 ViewModel 발견: `SearchQueryListViewModel`
- ViewModel 의존성:
  - 5개 UseCase: `FetchSearchQueryUseCase`, `SaveSearchQueryUseCase`, `RemoveSearchQueryUseCase`, `RemoveAllSearchQueryUseCase`, `FetchGitHubRepoUseCase`
  - 1개 Actions: `SearchQueryListViewModelActions` (네비게이션 콜백)
- Published 상태: `query`, `githubRepos`, `searchQueries`, `errorMessage`, `isLoading`
- 입력 메서드: `onAppear()`, `onSearchQueryChange()`, `onSubmit()`, `onTapItem()`, `onTapRepo()`, `remove()`, `removeAll()`

**구현**:
1. Mock UseCase 클래스 작성 (5개):
   - `MockFetchSearchQueryUseCase`
   - `MockSaveSearchQueryUseCase`
   - `MockRemoveSearchQueryUseCase`
   - `MockRemoveAllSearchQueryUseCase`
   - `MockFetchGitHubRepoUseCase`

2. SearchQueryListViewModel 테스트 작성 (16개 테스트):
   - `onAppear` 테스트: 2개
     - 빈 쿼리로 검색 목록 조회
     - 검색 쿼리 조회 실패
   - `onSearchQueryChange` 테스트: 2개
     - 빈 문자열로 전체 목록 조회
     - 쿼리 필터링
   - `onSubmit` 테스트: 4개
     - 쿼리 저장 및 저장소 검색
     - 로딩 상태 변경
     - 저장소 검색 실패
     - 저장소 목록 누적 (페이지네이션)
   - `onTapItem` 테스트: 1개
     - 쿼리 저장 및 저장소 검색
   - `removeAll` 테스트: 2개
     - 전체 삭제 및 목록 갱신
     - 삭제 실패
   - `remove` 테스트: 2개
     - 개별 삭제 및 목록 갱신
     - 삭제 실패
   - `onTapRepo` 테스트: 2개
     - 유효한 URL로 액션 호출
     - 잘못된 URL로 액션 미호출
   - 초기 상태 테스트: 1개

**테스트 특징**:
- `@MainActor` 적용하여 ViewModel의 MainActor 격리 준수
- `async throws` 함수 테스트
- Published 프로퍼티 상태 검증
- Mock UseCase를 통한 의존성 격리
- Actions 콜백 검증
- 에러 처리 검증

**테스트 실행**:
- 플랫폼: iOS 17 (iPhone 17 Pro 시뮬레이터)
- 총 16개 테스트 모두 통과
- 실행 시간: 약 0.019초

**결과**:
- Mock UseCase 5개 작성
- ViewModel 테스트 16개 작성 및 모두 통과
- iPhone 17 Pro 시뮬레이터에서 테스트 검증 완료

---

### Q4. ViewModel 수정에 따른 테스트 케이스 업데이트

**날짜**: 2025-12-19

**질문**: ViewModel 구현을 수정했으니 테스트 케이스를 수정하고 프롬프트를 문서화 요청

**ViewModel 주요 변경사항**:
1. `searchQueries` → `cachedQueries` 프로퍼티명 변경
2. `onSearchQueryChange()` 메서드 제거, `query` Publisher 구독 방식으로 변경 (debounce 0.1초)
3. `searchState` 추가: `.idle` / `.preSearching(query:)` / `.postSearch(query:)`
4. Task 관리: `fetchCachedQueryTask`, `fetchGitHubRepoTask` → `private(set)`으로 변경
5. `onSubmit()`, `onTapItem()`: async 제거 (동기 함수로 변경, 내부에서 Task 생성)
6. `removeAll()`: `cachedQueries = []` 직접 설정

**테스트 케이스 수정 내역**:
1. 프로퍼티명 변경: `searchQueries` → `cachedQueries` (9곳)
2. query 변경 테스트 수정 (2개):
   - `await sut.onSearchQueryChange(query)` → `sut.query = query` + debounce 대기
3. removeAll 테스트: `cachedQueries.isEmpty` 직접 검증
4. 페이지네이션 테스트: `test_onLoadMore_저장소_목록_누적()` 추가
5. Task 완료 대기 방식 추가 (6개 메서드):
   ```swift
   // 이전
   await sut.onSubmit()

   // 변경 (Task 완료 대기)
   sut.onSubmit()
   _ = await sut.fetchGitHubRepoTask?.result
   ```

**결과**:
- 총 17개 테스트 케이스 (1개 추가)
- `Task.sleep()` 대신 `fetchGitHubRepoTask?.result` 사용으로 안정성 향상
- 빌드 성공 (iOS 17 시뮬레이터)

---

### Q5. AppFlowCoordinator MainActor 격리 및 코드 검토

**날짜**: 2025-12-19

**질문 1**: AppFlowCoordinator의 start 함수는 MainActor로 격리되지 않아도 괜찮은가?

**분석**:
- UIKit 작업(UIWindow, UINavigationController 설정)을 하고 있어 MainActor 격리 필요
- SceneDelegate에서 호출되므로 암묵적으로 메인 스레드에서 실행되지만 명시적 선언 필요
- Swift 6의 Strict Concurrency를 고려하면 베스트 프랙티스는 `@MainActor` 추가

**답변**:
현재는 컴파일러가 경고를 내지 않지만, 다음 이유로 명시적으로 `@MainActor`를 추가해야 함:
1. UIKit은 이미 `@MainActor`로 주석됨 (iOS 13+)
2. SceneDelegate 컨텍스트가 메인 스레드임을 컴파일러가 추론
3. 하지만 명시적 선언이 의도를 명확히 하고 미래 안전성 보장

**조치**: `AppFlowCoordinator`에 `@MainActor` 추가

---

**질문 2**: 구현에 문제가 있는지 확인 요청

**분석 수행**:
전체 코드베이스를 검토하여 잠재적 문제점 탐색
- 메모리 관리
- 스레드 안전성
- 에러 처리
- Task 관리
- 상태 관리
- 무한 스크롤
- 데이터 일관성

**발견된 치명적 버그**:
**isLoading 상태 관리 버그** (SearchQueryListViewModel.swift:130-146)

**문제점**:
```swift
private func fetchRepos(searchQuery: String) async {
    guard !Task.isCancelled else { return }
    self.isLoading = true
    do {
        let response = try await ...
        guard !Task.isCancelled else {
            return  // ⚠️ isLoading = true 상태로 종료
        }
        // ...
    } catch {
        self.errorMessage = error.localizedDescription
    }
    self.isLoading = false
}
```

**버그 시나리오**:
1. Task 취소 시: Line 137에서 return → isLoading이 true로 남음
2. 결과: 로딩 인디케이터가 계속 표시되어 UI가 정지된 것처럼 보임

**수정 방법**:
`defer` 구문을 사용하여 함수 종료 시 항상 isLoading을 false로 설정

**구현**:
```swift
private func fetchRepos(searchQuery: String) async {
    guard !Task.isCancelled else { return }
    self.isLoading = true
    defer { self.isLoading = false }  // ✅ 항상 실행

    do {
        let response = try await fetchGitHubRepoUseCase.execute(query: searchQuery, page: page)
        guard !Task.isCancelled else { return }
        self.githubRepos += response.items
        self.hasNext = response.totalCount > githubRepos.count
        self.page += 1
    } catch {
        self.errorMessage = error.localizedDescription
    }
}
```

**테스트 케이스 추가**:
1. `test_onSubmit_저장소_검색_실패()`: 에러 발생 시 isLoading 검증 추가
2. `test_onSubmit_Task_취소시_로딩_상태_복원()`: 새로 추가

**테스트 코드**:
```swift
func test_onSubmit_저장소_검색_실패() async throws {
    // Given
    sut.query = "Swift"
    let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
    mockFetchGitHubRepo.executeResult = .failure(expectedError)

    // When
    sut.onSubmit()
    _ = await sut.fetchGitHubRepoTask?.result

    // Then
    XCTAssertEqual(mockSaveSearchQuery.executeCallCount, 1)
    XCTAssertEqual(mockFetchGitHubRepo.executeCallCount, 1)
    XCTAssertNotNil(sut.errorMessage)
    XCTAssertFalse(sut.isLoading, "에러 발생 시에도 isLoading은 false여야 함")
}

func test_onSubmit_Task_취소시_로딩_상태_복원() async throws {
    // Given
    sut.query = "Swift"
    let expectedPage = GitHubRepoPage(page: 1, totalCount: 100, items: [])
    mockFetchGitHubRepo.executeResult = .success(expectedPage)

    // When
    sut.onSubmit()
    sut.fetchGitHubRepoTask?.cancel()
    _ = await sut.fetchGitHubRepoTask?.result

    // Then
    XCTAssertFalse(sut.isLoading, "Task 취소 시에도 isLoading은 false여야 함")
}
```

**잘못된 분석 수정**:
1. ~~postSearch 상태에서 재검색 불가~~ → 실제로는 onSubmit으로 처리됨 (문제 아님)
2. ~~Task cancel 후 경합 조건~~ → @MainActor로 순차 실행 보장됨 (문제 아님)
3. ✅ isLoading 관리 버그 → 실제 버그 맞음 (수정 완료)

**결과**:
- 버그 수정: `defer` 구문 추가로 isLoading 항상 복원
- 테스트 추가: 총 19개 (기존 17개 + 2개 추가)
- 빌드 성공: BUILD SUCCEEDED
- 코드 품질 향상: 엣지 케이스 처리 완료
