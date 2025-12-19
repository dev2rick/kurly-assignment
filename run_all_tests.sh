#!/bin/bash

set -e

# xcode app 을 사용하도록 유도
xcodebuild_path=$(xcode-select -p)
if [[ "$xcodebuild_path" == *"CommandLineTools"* ]]; then
  echo "⚠️  Xcode가 아닌 CommandLineTools가 선택되어 있습니다. Xcode를 선택합니다..."
  sudo xcode-select -s /Applications/Xcode.app
fi

# 시뮬레이터 목록에서 선택하도록 유도
echo "📱 사용 가능한 iOS 시뮬레이터 목록:"
SIMULATOR_ARRAY=()
while IFS= read -r line; do
  SIMULATOR_ARRAY+=("$line")
done < <(xcrun simctl list devices available | grep -E "iPhone" | awk -F '[()]' '{print $1}' | sed 's/^[[:space:]]*//')

select SIMULATOR_NAME in "${SIMULATOR_ARRAY[@]}"; do
  if [[ -n "$SIMULATOR_NAME" ]]; then
    SIMULATOR_NAME=$(echo "$SIMULATOR_NAME" | xargs)
    echo "✅ 선택된 시뮬레이터: $SIMULATOR_NAME"
    break
  else
    echo "❌ 유효하지 않은 선택입니다. 다시 선택해주세요."
  fi
done

PROJECT_PATH="KurlyAssignment.xcodeproj"
SCHEME_NAME="KurlyAssignment"
DESTINATION="platform=iOS Simulator,name=$SIMULATOR_NAME"
SPM_ROOT="./Packages"
USE_WORKSPACE=false

echo "🔍 1. Xcode 프로젝트 테스트 시작..."

if command -v xcpretty &> /dev/null; then
  xcodebuild test -project "$PROJECT_PATH" -scheme "$SCHEME_NAME" -destination "$DESTINATION" | xcpretty -s
else
  xcodebuild test -project "$PROJECT_PATH" -scheme "$SCHEME_NAME" -destination "$DESTINATION" -quiet
fi


echo "✅ Xcode 프로젝트 테스트 완료"

echo "🔍 2. 로컬 SPM 테스트 시작..."

cd "$SPM_ROOT"
./local_spm_tests.sh "$DESTINATION"

echo "✅ 모든 테스트 완료"
