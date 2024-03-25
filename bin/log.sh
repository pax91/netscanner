#!/bin/bash

INI="\033"
RST="$INI[0m"

regular="0"
bold="1"
lowintensity="2"
underline="4"
blinking="5"
reverse="7"
invisible="8"

black="30m"
red="31m"
green="32m"
yellow="33m"
blue="34m"
purple="35m"
cyan="36m"
white="37m"

REGULAR_BLACK="$INI[$black"
REGULAR_RED="$INI[$red"
REGULAR_GREEN="$INI[$green"
REGULAR_YELLOW="$INI[$yellow"
REGULAR_BLUE="$INI[$blue"
REGULAR_PURPLE="$INI[$purple"
REGULAR_CYAN="$INI[$cyan"
REGULAR_WHITE="$INI[$white"

BOLD_BLACK="$INI[$bold;$black"
BOLD_RED="$INI[$bold;$red"
BOLD_GREEN="$INI[$bold;$green"
BOLD_YELLOW="$INI[$bold;$yellow"
BOLD_BLUE="$INI[$bold;$blue"
BOLD_PURPLE="$INI[$bold;$purple"
BOLD_CYAN="$INI[$bold;$cyan"
BOLD_WHITE="$INI[$bold;$white"

BLINK_BLACK="$INI[$blinking;$black"
BLINK_RED="$INI[$blinking;$red"
BLINK_GREEN="$INI[$blinking;$green"
BLINK_YELLOW="$INI[$blinking;$yellow"
BLINK_BLUE="$INI[$blinking;$blue"
BLINK_PURPLE="$INI[$blinking;$purple"
BLINK_CYAN="$INI[$blinking;$cyan"
BLINK_WHITE="$INI[$blinking;$white"

log() {
    local arr=("$@")
    local lines=()
    local color="0m"
    local mode=$regular
    for opt in "${arr[@]}"; do
        case $opt in
            "BLACK" | "black") 
                color=$black
                ;;
            "RED" | "red") 
                color=$red
                ;;
            "GREEN" | "green") 
                color=$green 
                ;;
            "YELLOW" | "yellow") 
                color=$yellow  
                ;;
            "BLUE" | "blue") 
                color=$blue
                ;;
            "PURPLE" | "purple")
                color=$purple
                ;;
            "CYAN" | "cyan")
                color=$cyan
                ;;
            "WHITE" | "white") 
                color=$white 
                ;;
            "REGULAR" | "regular") 
                mode=$regular 
                ;;
            "BOLD" | "bold") 
                mode=$bold 
                ;;
            "LOWINTENSITY" | "lowintensity") 
                mode=$lowintensity 
                ;;
            "UNDERLINE" | "underline") 
                mode=$underline 
                ;;
            "BLINKING" | "blinking") 
                mode=$blinking 
                ;;
            "REVERSE" | "reverse") 
                mode=$reverse 
                ;;
            "INVISIBLE" | "invisible") 
                mode=$invisible 
                ;;
            *) 
                lines+=("$opt")
                ;;
        esac
    done
    local CLR="$INI[$mode;$color"
    if [ "${lines[@]}" ]; then 
        for line in "${lines[@]}"; do
            echo -e "${CLR}$line${RST}"
        done
    else
        echo -e "${CLR} ${RST}"
    fi
}

printLine() {
    log cyan bold "$LN"
}
