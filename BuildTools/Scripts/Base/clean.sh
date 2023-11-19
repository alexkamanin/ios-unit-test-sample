#!/bin/bash

source ./BuildTools/Scripts/Base/environment.sh

CONSOLE_GREEN_COLOR='\033[0;32m'
CONSOLE_NEUTRAL_COLOR='\033[0m'

localClean() {
    rm -rf $PROJECT
    rm -rf `find . -type d -name $GENERATED_SOURCE_DIR_NAME`
}

globalClean() {
    rm -rf ~/Library/Developer/Xcode/DerivedData/$PROJECT_NAME-*
}

option=$1

case $option in 
    "global") 
        echo "⚙️  Cleaning project at '$PROJECT'"
        localClean
        echo "⚙️  Cleaning derived data at '$PROJECT'"
        globalClean
        printf "${CONSOLE_GREEN_COLOR}Cleaned project at '$PROJECT'${CONSOLE_NEUTRAL_COLOR}\n" 
    ;;
    *) 
        echo "⚙️  Cleaning project at '$PROJECT'"
        localClean
        printf "${CONSOLE_GREEN_COLOR}Cleaned project at '$PROJECT'${CONSOLE_NEUTRAL_COLOR}\n" 
    ;;
esac