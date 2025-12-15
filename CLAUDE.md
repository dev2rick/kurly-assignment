# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

KurlyAssignment is an iOS application for searching GitHub repositories. The project uses Clean Architecture + MVVM pattern with a hybrid SwiftUI/UIKit approach.

**Current Status**: Minimal skeleton setup - core features not yet implemented.

## Build and Test Commands

### Building
```bash
# Build for Debug
xcodebuild -project KurlyAssignment.xcodeproj -scheme KurlyAssignment -configuration Debug build

# Build for Release
xcodebuild -project KurlyAssignment.xcodeproj -scheme KurlyAssignment -configuration Release build

# Clean build folder
xcodebuild -project KurlyAssignment.xcodeproj -scheme KurlyAssignment clean
```

### Running Tests
```bash
# Run all tests
xcodebuild test -project KurlyAssignment.xcodeproj -scheme KurlyAssignment -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test class
xcodebuild test -project KurlyAssignment.xcodeproj -scheme KurlyAssignment -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:KurlyAssignmentTests/KurlyAssignmentTests

# Run specific test method
xcodebuild test -project KurlyAssignment.xcodeproj -scheme KurlyAssignment -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:KurlyAssignmentTests/KurlyAssignmentTests/testExample
```

## Architecture

### Planned Architecture: Clean Architecture + MVVM
The project is designed to follow Clean Architecture principles with MVVM for the presentation layer. Implementation is pending.

### Current Implementation
- **UIKit-based lifecycle**: AppDelegate + SceneDelegate pattern with scene-based multi-window support
- **Programmatic UI**: No Storyboards, UI created in code (SceneDelegate:21 sets up root view controller)
- **File System Synchronization**: Uses Xcode 15.2+ auto-synchronized root groups - files are automatically discovered from disk

### Key Technical Details
- **Minimum Deployment**: iOS 15.0
- **Swift Version**: 5.0
- **Swift Concurrency**: Enabled with `async`/`await` support and MainActor isolation
- **String Localization**: Uses Swift Strings Catalog (type-safe, iOS 16+ feature)
- **Asset Management**: Auto-generated Swift symbols for Assets.xcassets

### Directory Organization
```
KurlyAssignment/
├── Application/        # App lifecycle (AppDelegate, SceneDelegate)
└── Resource/          # Assets and resources
```

### Planned Features (Not Yet Implemented)

**GitHub API Integration**
- Endpoint: `GET https://api.github.com/search/repositories`
- Parameters: `q` (keyword), `page` (pagination)
- No networking layer currently exists

**Search Screen**
- Keyword search input
- Recent search history (max 10, newest first)
- History deletion (individual/bulk)

**Results Screen**
- Repository list with thumbnail, name, owner
- Total count display
- WebView detail on cell selection
- Optional: Infinite scroll pagination

**Data Persistence**
- Recent searches storage (planned, not implemented)
- No current persistence layer (CoreData, UserDefaults, etc.)

## Dependencies

**No external dependencies** - Project uses only Apple frameworks. No CocoaPods, Swift Package Manager, or Carthage dependencies.

## Development Notes

- Project uses modern Xcode 15.2 features including auto-generated Info.plist
- Scene manifest auto-generation enabled (`UIApplicationSceneManifest_Generation = YES`)
- Indirect input events supported (external keyboards/trackpads)
- All orientations supported (portrait/landscape)
- Bundle ID: `com.dev2rick.KurlyAssignment`

## AI Prompt Documentation

**Important**: This is a Kurly recruitment assignment project. All AI interactions must be documented in `PROMPT.md`.

When using Claude Code or other AI assistants:
- Record all questions and answers in `PROMPT.md`
- Include date and session information
- Summarize key decisions and solutions provided by AI
- Keep the documentation concise and structured
