# GitHub Repository Search

GitHub 저장소를 검색하고 탐색할 수 있는 iOS 애플리케이션입니다.

## 📱 스크린샷

|             검색 화면             |            최근 검색어            |             검색 결과             |             상세 화면             |
| :-------------------------------: | :-------------------------------: | :-------------------------------: | :-------------------------------: |
| ![search](screenshots/search.png) | ![recent](screenshots/recent.png) | ![result](screenshots/result.png) | ![detail](screenshots/detail.png) |

## 🏗 앱실행

xcodeproj 실행 후 `CMD + R`

### 요구사항

- iOS 17.0+ 시뮬레이터 또는 디바이스

## 🧪 테스트

### 테스트 구조

- **Domain Layer Tests**: UseCase 및 Entity 테스트 (33개)
- **Presentation Layer Tests**: ViewModel 테스트 (17개)
- Mock 객체를 활용한 의존성 격리

### 테스트 실행

### 테스트 실행방법 1

SPM(Swift Package Manager) 를 실행후 `CMD + U` 를 사용하여 실행

### 테스트 실행방법 2

(Optional) [xcpretty](https://github.com/xcpretty/xcpretty) 설치

```bash
$ sudo gem install xcpretty
```

Terminal에서 아래의 명령어를 실행

```bash
$ ./run_all_tests.sh
# 1. xcodeproj 테스트 실행
# 2. local spm 테스트 실행
```

## ✨ 주요 기능

### 검색 화면

- 검색어 입력을 통한 GitHub 저장소 검색
- 최근 검색어 최대 10개 목록 표시 (최신순 정렬)
- 최근 검색어 탭하여 재검색
- 최근 검색어 개별삭제 / 전체삭제
- 최근 검색어 자동완성 기능
- 검색 날짜 표시

### 검색 결과 화면

- 검색 결과 리스트 표시
- 총 검색 건수 표시
- 저장소 정보 표시
  - Thumbnail: 소유자 아바타 이미지
  - Title: 저장소 이름
  - Description: 소유자 로그인명
- 셀 선택 시 SFSafariViewController 저장소 상세 페이지 이동
- 무한 스크롤 페이지네이션
- 페이지 로딩 인디케이터

## 🛠 기술 스택

| 구분          | 사용 기술                             |
| :------------ | :------------------------------------ |
| UI Framework  | SwiftUI & UIKit (Hybrid)              |
| Architecture  | Clean Architecture + MVVM             |
| Concurrency   | Swift Concurrency (async/await, Task) |
| Reactive      | Combine Framework                     |
| Persistence   | SwiftData                             |
| Network       | URLSession                            |
| Testing       | XCTest                                |
| Swift Version | 6.2                                   |
| iOS Version   | 17.0+                                 |

### 주요 특징

- **Swift 6.2** 및 **Strict Concurrency** (complete) 적용
- **Clean Architecture** 기반 모듈화 (Domain, Data, Presentation)
- **Combine**을 활용한 반응형 프로그래밍
- **SwiftData**를 활용한 로컬 데이터 영속화

## 📁 프로젝트 구조

```
KurlyAssignment/
├── KurlyAssignment/                      # Main App Target
│   ├── Application/                      # App Lifecycle & DI
│   │   ├── AppDelegate.swift
│   │   ├── SceneDelegate.swift
│   │   ├── AppFlowCoordinator.swift
│   │   └── DIContainer/
│   │       ├── AppDIContainer.swift
│   │       └── MainSceneDIContainer.swift
│   └── Resource/                         # Assets
│       └── Assets.xcassets
│
├── Packages/                             # Swift Packages (Modular Architecture)
│   ├── Domain/                           # Business Logic Layer
│   │   ├── Package.swift                 # iOS 15.0+
│   │   ├── Sources/Domain/
│   │   │   ├── Entities/
│   │   │   │   ├── GitHubRepo.swift
│   │   │   │   └── SearchQuery.swift
│   │   │   ├── UseCases/
│   │   │   │   ├── FetchGitHubRepoUseCase.swift
│   │   │   │   ├── FetchSearchQueryUseCase.swift
│   │   │   │   ├── SaveSearchQueryUseCase.swift
│   │   │   │   ├── RemoveSearchQueryUseCase.swift
│   │   │   │   └── RemoveAllSearchQueryUseCase.swift
│   │   │   └── Repositories/
│   │   │       ├── GitHubRepository.swift
│   │   │       └── SearchQueryRepository.swift
│   │   └── Tests/DomainTests/
│   │       ├── Entities/
│   │       ├── UseCases/
│   │       └── Mocks/
│   │
│   ├── Data/                             # Data Access Layer
│   │   ├── Package.swift                 # iOS 17.0+
│   │   ├── Sources/
│   │   │   ├── Networks/
│   │   │   │   ├── GitHubAPIService.swift
│   │   │   │   ├── GitHubAPIEndpoint.swift
│   │   │   │   ├── DefaultNetworkLogger.swift
│   │   │   │   └── DataMapping/
│   │   │   │       └── GitHubRepositoryDTO.swift
│   │   │   ├── SwiftDataStorage/
│   │   │   │   ├── SearchQueryStorage.swift
│   │   │   │   └── Schema/
│   │   │   │       └── SearchQueryEntity.swift
│   │   │   └── Repositories/
│   │   │       ├── DefaultGitHubRepository.swift
│   │   │       └── SwiftDataSearchQueryRepository.swift
│   │   └── Tests/DataTests/
│   │
│   └── Presentation/                     # Presentation Layer
│       ├── Package.swift                 # iOS 17.0+
│       ├── Sources/Presentation/
│       │   ├── MainScene/
│       │   │   ├── Flows/
│       │   │   │   └── MainFlowCoordinator.swift
│       │   │   └── SearchQueryList/
│       │   │       ├── ViewModel/
│       │   │       │   └── SearchQueryListViewModel.swift
│       │   │       └── View/
│       │   │           └── SearchQueryListView.swift
│       │   └── Stubs/                    # Preview용 Stub
│       │       ├── StubSearchQueryUseCase.swift
│       │       └── StubFetchGitHubUseCase.swift
│       └── Tests/PresentationTests/
│           ├── SearchQueryListViewModelTests.swift
│           └── Mocks/
│
├── KurlyAssignmentTests/                 # App Target Tests
├── CLAUDE.md                             # AI 개발 가이드
├── PROMPT.md                             # AI 대화 기록
└── README.md
```

### 아키텍처 설명

#### Clean Architecture 레이어

- **Domain Layer**: 비즈니스 로직의 핵심, 외부 의존성 없음 (iOS 15.0+ 지원)
- **Data Layer**: 데이터 소스 구현 (Network, SwiftData)
- **Presentation Layer**: UI 및 ViewModel (SwiftUI + Combine)
- **Application Layer**: 앱 진입점 및 DI Container

#### 의존성 방향

```
Application → Presentation → Domain ← Data
```

#### 주요 패턴

- **MVVM**: ViewModel을 통한 View와 비즈니스 로직 분리
- **Repository Pattern**: 데이터 소스 추상화
- **Use Case Pattern**: 비즈니스 로직 캡슐화
- **Coordinator Pattern**: 화면 전환 관리
- **Dependency Injection**: DIContainer를 통한 의존성 주입

## 🔗 API

GitHub REST API를 사용합니다.

**Endpoint**

```
GET https://api.github.com/search/repositories
```

**Parameters**
| Parameter | Type | Description |
|:---|:---|:---|
| q | String | 검색 키워드 |
| page | Int | 페이지 번호 (기본값: 1) |

**Response**

```json
{
  "total_count": 372678,
  "incomplete_results": false,
  "items": [
    {
      "id": 44838949,
      "name": "swift",
      "full_name": "swiftlang/swift",
      "owner": {
        "login": "swiftlang",
        "avatar_url": "https://avatars.githubusercontent.com/u/42816656?v=4"
      },
      "html_url": "https://github.com/swiftlang/swift"
    }
  ]
}
```

## 📝 개발 문서

- **CLAUDE.md**: Claude Code AI를 위한 프로젝트 가이드
- **PROMPT.md**: AI와의 대화 기록 및 기술 의사결정 문서

## 🔑 주요 기술 결정

### Swift Concurrency (Swift 6)

- **Strict Concurrency** 완전 적용
- `@MainActor` 격리로 UI 스레드 안전성 보장
- `async/await` 기반 비동기 처리
- `Task` 관리를 통한 작업 취소 및 생명주기 관리

### Combine Framework

- ViewModel의 상태 관리 (`@Published`)
- `debounce`를 활용한 검색어 입력 최적화
- 반응형 데이터 바인딩

### SwiftData

- 최근 검색어 영속화
- 타입 안전한 데이터 스키마
- iOS 17+ 최신 기술 활용

### Hybrid UI

- **SwiftUI**: 주요 화면 구현 (선언적 UI)
- **UIKit**: 네비게이션 및 Coordinator (Programmatic)
- 두 프레임워크의 장점을 결합
