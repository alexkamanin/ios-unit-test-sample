#!/bin/bash

source ./BuildTools/Scripts/Base/environment.sh
source ./BuildTools/Scripts/Mockolo/mocks.sh

CONSOLE_GREEN_COLOR='\033[0;32m'
CONSOLE_RED_COLOR='\033[0;31m'
CONSOLE_NEUTRAL_COLOR='\033[0m'

updateFile() {
    local sourceDir=$1; local destinationDir=$2; local targetName=$3; local outputFileName=$4
    echo "⚙️  Updating '$destinationDir/$outputFileName'"
    ./BuildTools/Binaries/Mockolo/bin/mockolo --sourcedirs "$sourceDir" --destination "$destinationDir/$outputFileName" --testable-imports "$targetName" --logging-level $MOCKOLO_LOGGING_LEVEL --enable-args-history --mock-final --mock-all
    printf "${CONSOLE_GREEN_COLOR}Updated mocks at '$destinationDir/$outputFileName'${CONSOLE_NEUTRAL_COLOR}\n"  
}

createFile() {
    local sourceDir=$1; local destinationDir=$2; local targetName=$3; local testTargetName=$4; local outputFileName=$5
    echo "⚙️  Creating directory '$destinationDir'"
    mkdir -p "$destinationDir"
    echo "⚙️  Creating mocks '$destinationDir/$outputFileName'"
    ./BuildTools/Binaries/Mockolo/bin/mockolo --sourcedirs "$sourceDir" --destination "$destinationDir/$outputFileName" --testable-imports "$targetName" --logging-level $MOCKOLO_LOGGING_LEVEL --enable-args-history --mock-final --mock-all
    chmod a-w "$destinationDir/$outputFileName"
    echo "⚙️  Creating file reference '$destinationDir/$outputFileName'"
    ruby ./BuildTools/Scripts/XcodeProj/applySourceFileReferences.rb $PROJECT "$testTargetName" "$destinationDir" "$outputFileName"
    printf "${CONSOLE_GREEN_COLOR}Created mocks at '$destinationDir/$outputFileName'${CONSOLE_NEUTRAL_COLOR}\n"   
}

makeMock() {
    local sourceDir=$1; local destinationDir=$2; local targetName=$3; local testTargetName=$4; local outputFileName=$5
    if [ -f "$destinationDir/$outputFileName" ]; then
        updateFile $sourceDir $destinationDir $targetName $outputFileName
    else
        createFile $sourceDir $destinationDir $targetName $testTargetName $outputFileName
    fi
}

if [ ! -d $PROJECT ]; then
    printf "${CONSOLE_RED_COLOR}⛔️ Project '$PROJECT' not created${CONSOLE_NEUTRAL_COLOR}\n"
    exit
fi

for mock in "${MOCKS[@]}"; do
    set -- $mock
    sourceDir=$1; destinationDir=$2; targetName=$3; testTargetName=$4; outputFileName=$5
    makeMock $sourceDir $destinationDir $targetName $testTargetName $outputFileName
done