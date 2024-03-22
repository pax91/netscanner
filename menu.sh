#!/bin/bash

printOptions() {
    local arr=("$@")
    local i=0
    for opt in "${arr[@]}"; do        
        echo -e "  ${BOLD_CYAN}$i)${BOLD_WHITE} $opt${RST}"  
        ((i+=1))
    done
}

invalidOption() {
    log red bold blinking "INVALID OPTION: $1"
    sleep 2
}

backScanMenu() {
    printLine
    log red bold "$SB"
    printLine
    read ans
    scanMenu
}

printLine() {
    log cyan bold "$LN"
}

header() {
    clear
    echo ""
    printLine
    log white bold "$SN"
    log white bold "$CR"
    printLine
    echo -e "  ${BOLD_CYAN}FOLDER       : ${BOLD_WHITE}$folder${RST}"
    echo -e "  ${BOLD_CYAN}TARGET       : ${BOLD_WHITE}$target${RST}"    
    echo -e "  ${BOLD_CYAN}TIMING LEVEL : ${BOLD_WHITE}$timing${RST}"    
    if [ -z "$verbose" ]; then
        echo -e "  ${BOLD_CYAN}VERBOSE LOGS : ${BOLD_WHITE}Disabled${RST}"
    else
        echo -e "  ${BOLD_CYAN}VERBOSE LOGS : ${BOLD_WHITE}Enabled${RST}"
    fi
    if [ -f $folder/$ip_addresses ]; then
        echo -e "  ${BOLD_CYAN}IP LIST      : ${BOLD_WHITE}Created${RST}"
    else
        echo -e "  ${BOLD_CYAN}IP LIST      : ${BOLD_WHITE}Missing${RST}"        
    fi
    printLine
    if [ ! -z "$1" ]; then
        log white bold "$1"
        printLine
    fi 
}

scanMenu() {
    header "$SM"
    printOptions "${SCANMENU[@]}"
    echo -ne "  ${BOLD_CYAN}Choose an option: ${RST}"
    read a
    case $a in
        1)
            pingScan
            ;;
        2) 
            tcpScan
            ;;
        3) 
            udpScan
            ;;
        4) 
            fullScan 
            ;;
        5) 
            arpScan 
            ;;
        6)
            synScan
            ;;
        7)
            nullScan
            ;;
        8)
            finScan
            ;;
        9)
            xmasScan
            ;;
        10)
            fastScan
            ;;
        11)
            activateVerbose
            ;;
        12)
            listInterfaces
            ;;
        13)
            inputTarget
            ;;
        14)
            showFiles
            ;;
        15)
            showIPList
            ;;
        16)
            setTiming
            ;;
        17)
            customScan
            ;;
        0) 
            exit 0 
            ;;
        *) 
            invalidOption $a
            scanMenu
            ;;
    esac
}
