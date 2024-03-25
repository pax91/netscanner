#!/bin/bash

exitProgram() {
    echo ""
    printLine
    log red bold "$EX"
    printLine
    writeTiming
    writeVerbose
    writeTarget
    exit 0
}

printOptions() {
    local arr=("$@")
    local i=0
    for opt in "${arr[@]}"; do        
        echo -e "  ${BOLD_CYAN}$i)${BOLD_WHITE} $opt${RST}"  
        ((i+=1))
    done
    echo -e "  ${BOLD_CYAN}m)${BOLD_WHITE} Main Menu${RST}"  
    echo -e "  ${BOLD_CYAN}s)${BOLD_WHITE} Scan Menu${RST}"  
    echo -e "  ${BOLD_CYAN}q)${BOLD_WHITE} Exit Program${RST}"  
}

invalidOption() {
    log red bold "INVALID OPTION: $1"
    sleep 2
}

backScanMenu() {
    printLine
    log red bold "$SB"
    printLine
    read ans
    scanMenu
}

backMainMenu() {
    printLine
    log red bold "$MB"
    printLine
    read ans
    mainMenu
}

head() {
    printLine
    for l in "${TEXTS_HEADER[@]}"; do
        log white bold "$l"
    done
    printLine
}

header() {
    clear
    echo ""
    head
    echo -e "  ${BOLD_CYAN}FOLDER       : ${BOLD_WHITE}$folder${RST}"
    echo -e "  ${BOLD_CYAN}TARGET       : ${BOLD_WHITE}$target${RST}"    
    echo -e "  ${BOLD_CYAN}TIMING LEVEL : ${BOLD_WHITE}$timing${RST}"       
    echo -e "  ${BOLD_CYAN}VERBOSE LOGS : ${BOLD_WHITE}$verbose${RST}"  
    if [[ -f $ip_addresses ]]; then
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

SCANMENU=(
    "FAST Scan (-F)"
    "Custom Flags Scan"
    "TCP Connect Scan (-sT)"     
    "SYN Half-Open Scan (-sS)"
    "TCP Null Scan (-sN)"
    "TCP FIN Scan (-sF)"
    "TCP Xmas Scan (-sX)"
    "UDP Scan (-sU)" 
    "OS Detection Scan (-O)"
    "Version Detection Scan (-sV)"
    "Aggressive Scan (-A)"
    "ARP Scan (-PR)"
)
scanMenu() {
    header "$SM"
    printOptions "${SCANMENU[@]}"
    echo -ne "  ${BOLD_CYAN}Choose an option: ${RST}"
    read a
    case $a in
        0)
            execScan "$TS" fast_scan "-F"
            ;;
        1)
            customScan
            ;;
        2) 
            execScan "$TS" tcp_connect_scan "-sT"
            ;;
        3) 
            execScan "$TS" tcp_syn_scan "-sS"
            ;;
        4) 
            execScan "$TS" tcp_null_scan "-sN"
            ;;
        5) 
            execScan "$TS" tcp_fin_scan "-sF"
            ;;
        6)
            execScan "$XS" tcp_xmas_scan "-sX"
            ;;
        7)
            execScan "$US" udp_scan "-sU"
            ;;
        8)
            execScan "$TS" os_detection_scan "-O"
            ;;
        9)
            execScan "$TS" version_detection_scan "-sV"
            ;;
        10)
            execScan "$AS" aggressive_scan "-A"
            ;;
        11)
            execScan "$AS" arp_scan "-PR"
            ;;
        m|M)
            mainMenu
            ;;
        s|S)
            scanMenu
            ;;
        q|Q)
            exitProgram
            ;;
        *) 
            invalidOption $a
            scanMenu
            ;;
    esac
}

# SCAN Menu Options
MAINMENU=(
    "Set Target"
    "Set Timing Level"
    "Set Verbose Logging"
    "List Active Interfaces"
    "View Folder Files"
    "Manage IP LIST File"
)
mainMenu() {
    header "$MM"
    printOptions "${MAINMENU[@]}"
    echo -ne "  ${BOLD_CYAN}Choose an option: ${RST}"
    read a
    case $a in
        0)
            inputTarget
            ;;
        1)
            setTiming
            ;;
        2) 
            setVerbose
            ;;
        3) 
            listInterfaces
            ;;
        4) 
            showFiles 
            ;;
        5) 
            showIPList 
            ;;
        m|M)
            mainMenu
            ;;
        s|S)
            scanMenu
            ;;
        q|Q)
            exitProgram
            ;;
        *) 
            invalidOption $a
            mainMenu
            ;;
    esac
}

fileToArray() {
    local arr=()
    if [[ -f $1 ]]; then
        while IFS= read -r line; do
            arr+=("$line")
        done < "$1"
    fi
    echo "${arr[@]}"
}

deleteIPList() {
    header "$IL"
    showDescription show_iplist  
    if [[ -f $ip_addresses ]]; then
        echo -ne " ${BOLD_RED}Are you sure to delete IP LIST File (y/Y)?: ${RST}"
        read choice
        case "$choice" in
            y|Y)
                log yellow bold "-> Removing $ip_addresses ..."
                rm $ip_addresses 
                sleep 2
                showIPList
                ;;
            *)
                showIPList
                ;;
        esac
    else
        log red bold "ERROR: Missing IPLIST File"
        sleep 2
        showIPList
    fi    
}

addHost() {
    header "$IL"
    showDescription show_iplist  
    if [[ -f $ip_addresses ]]; then
        local text="$(cat $ip_addresses)"
        log white "$text"   
    else
        log red bold "ERROR: Missing IPLIST File"
    fi 
    printLine
    echo -ne " ${BOLD_CYAN}Enter new Host (void to cancel)?: ${RST}"
    read newhost
    if [ -z "$newhost" ]; then
        showIPList
    else
        log yellow bold "-> Adding $newhost ..."
        echo "$newhost" >> "$ip_addresses"
        sleep 1
        addHost
    fi   
}

SHOWIPMENU=(
    "Delete File"
    "Add Host"
    "Edit File"
)

showIPList() {
    header "$IL"
    showDescription show_iplist    
    if [ -f $ip_addresses ]; then
        local text="$(cat $ip_addresses)"
        log white "$text"   
    else
        log red bold "ERROR: Missing IPLIST File"
    fi 
    printLine
    printOptions "${SHOWIPMENU[@]}"
    echo -ne "  ${BOLD_CYAN}Choose an option: ${RST}"
    read a
    case $a in
        0)
            deleteIPList
            ;;
        1)
            addHost
            ;;
        2) 
            nano $ip_addresses
            showIPList
            ;;
        m|M)
            mainMenu
            ;;
        s|S)
            scanMenu
            ;;
        q|Q)
            exitProgram
            ;;
        *) 
            invalidOption $a
            mainMenu
            ;;
    esac
}
