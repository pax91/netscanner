#!/bin/bash
source texts.sh
source colors.sh
source menu.sh
# Directories Paths
parentDir=$HOME/Desktop
scriptDir=$PWD
descriptionsFolder="$PWD/descriptions"
# Scanning Filenames
ping_scan=ping_scan
udp_scan=udp_scan
full_scan=full_scan
arp_scan=arp_scan
fast_scan=fast_scan
custom_scan=custom_scan
# TCP Scanning Filenames
tcp_scan=tcp_connect_scan
syn_scan=tcp_syn_scan
null_scan=tcp_null_scan
fin_scan=tcp_fin_scan
xmas_scan=tcp_xmas_scan
# TXT Files names
ip_addresses=ip_addresses.txt
live_hosts=live_hosts.txt
target_file=target.txt
timing_file=timing.txt
verbose_file=verbose.txt
# Running Variables
folder=$(date +'%Y-%m-%d_%H-%M-%S')
target=""
verbose=""
timing="-T3"

missingTarget() {
    log red bold "ERROR: missing TARGET input"
    log red bold "Redirecting to TARGET INPUT ..."
    sleep 2
    inputTarget
}

showIPList() {
    header "$IL"
    if [ -f $folder/$ip_addresses ]; then
        local text="$(cat $folder/$ip_addresses)"
        log white "$text"
        printLine
        echo -ne "  ${BOLD_RED}Do you want to Delete File (y/Y)? ${RST}"
        read choice
        case "$choice" in 
            y|Y) 
                log yellow bold "-> Removing IPLIST File $folder/$ip_addresses ..."
                rm $folder/$ip_addresses
                log yellow bold "-> Redirecting to SCAN menu ..."
                sleep 3
                scanMenu 
                ;;
            *) 
                scanMenu
                ;;
        esac    
    else
        log red bold "ERROR: Missing IPLIST File"
        printLine
        backScanMenu
    fi
}

listInterfaces() {
    header "$IN"
    nmap --iflist | grep "ethernet    up"
    backScanMenu
}

showDescription() {
    if [ -z "$1" ]; then
        log red bold "ERROR: missing argument description file name"
    else
        local par="$1"
        local fname="${par}_description.txt"
        if [[ -f $descriptionsFolder/$fname ]]; then
            local text="$(cat $descriptionsFolder/$fname)"
            log white "$text"
            printLine
        else
            log red bold "ERROR: Missing $fname File"
            printLine    
        fi
    fi
}

activateVerbose() {
    header "$VB"
    if [ -z "$verbose" ]; then
        local v="-v"
        verbose=$v      
        printLine
        log yellow bold "$EV"
        printLine
    else
        local n=""
        verbose=$n
        printLine
        log yellow bold "$DV"
        printLine
    fi
    log yellow bold "-> Writing new Verbose File ..."
    echo "$verbose" > $folder/$verbose_file
    sleep 2
    scanMenu
}

inputDatas() {
    header "$ID"
    showDescription input_datas
    echo -ne " ${BOLD_CYAN}Enter Parent Path (void to use $parentDir): ${RST}"
    read newparent
    if [ -z "$newparent" ]; then
        log yellow bold "-> Default $parentDir Parent Path will be used ..."        
    else
        if [ -d "$newparent" ]; then
            log yellow bold "-> Setting $newparent as Parent Path ..." 
            parentDir=$newparent
        else
            log red bold "ERROR: Path $newparent Not Found !" 
            sleep 2
            inputDatas
        fi
    fi
    echo -ne " ${BOLD_CYAN}Enter new Folder Name (void to use default $folder): ${RST}"
    read newfolder
    if [ -z "$newfolder" ]; then
        log yellow bold "-> Default $folder folder name will be used ..." 
        folder=$parentDir/$folder       
    else
        folder=$parentDir/$newfolder
    fi
    if [ ! -d "$folder" ]; then
        log yellow bold "-> Creating $folder ..."
        mkdir $folder
    else
        log yellow bold "-> Folder $folder Already Exists ..."    
    fi
    if [ -f $folder/$verbose_file ]; then
        log yellow bold "-> Finded Existing VERBOSE FILE ..."
        local vb="$(cat $folder/$verbose_file)"
        verbose=$vb        
    fi
    if [ -f $folder/$timing_file ]; then
        log yellow bold "-> Finded Existing TIMING FILE ..."
        local tm="$(cat $folder/$timing_file)"
        timing=$tm        
    fi
    if [ -f $folder/$target_file ]; then
        log yellow bold "-> Finded Existing TARGET FILE ..."
        local tg="$(cat $folder/$target_file)"
        target=$tg
        log yellow bold "-> Redirecting to SCAN MENU ..."
        sleep 3
        scanMenu
    else       
        log yellow bold "-> Redirecting to TARGET INPUT ..."
        sleep 3
        inputTarget           
    fi
}

inputTarget() {
    header "$TG"
    showDescription input_target
    echo -ne " ${BOLD_CYAN}Pease Enter Target (void to cancel): ${RST}"
    read t  
    if [ -z "$t" ]; then        
        if [ -z "$target" ]; then
            log red bold "  ERROR: Script require a Target"
            sleep 2
            inputTarget
        else
            log yellow bold "-> Target Unchanged"
            sleep 2
            scanMenu
        fi
    else
        target=$t
        log yellow bold "-> Writing new Target File ..."
        echo "$target" > $folder/$target_file
        if [ -f $folder/$ip_addresses ]; then
            log yellow bold "-> Removing IP LIST File ..."
            rm $folder/$ip_addresses
        fi
        log yellow bold "-> Redirecting to PING SCAN ..."
        sleep 3
        pingScan
    fi    
}

pingScan() {
    header "$PS"
    showDescription ping_scan
    if [ -z "$target" ]; then
        missingTarget
    else
        echo -ne " ${BOLD_YELLOW}Do you want to start scan (y/Y)? ${RST}"
        read choice
        case "$choice" in 
            y|Y) 
                nmap -sn $target -oX $folder/$ping_scan.xml -oN $folder/$live_hosts
                log yellow bold "-> Creating IPLIST File $folder/$ip_addresses ..."
                grep "Nmap scan report for" $folder/$live_hosts | awk '{print $5}' > $folder/$ip_addresses
                xmlTOhtml $ping_scan.xml $ping_scan.html
                backScanMenu 
                ;;
            *) 
                scanMenu
                ;;
        esac      
    fi   
}

xmlTOhtml() {
    if [ -z "$1" ]; then
        log red bold "ERROR: missing argument source file"
        exit 0
    fi
    if [ -z "$2" ]; then
        log red bold "ERROR: missing argument destination file"
        exit 0
    fi
    if [ -f $folder/$1 ]; then
        log yellow bold "-> Converting $1 to $2 ..."
        xsltproc $folder/$1 -o $folder/$2
        log yellow bold "-> Created HTML Report $2"
    else       
        log red bold "ERROR: Missing source file $1"        
    fi   
}

performScan() {
    if [ -z "$1" ]; then
        printRed "ERROR: missing argument NAMP params"
        exit 0
    fi
    if [ -z "$2" ]; then
        printRed "ERROR: missing argument Destination File"
        exit 0
    fi
    if [ -z "$target" ]; then
        missingTarget
    else
        echo -ne " ${BOLD_YELLOW}Do you want to start scan (y/Y)? ${RST}"
        read choice
        case "$choice" in 
            y|Y) 
                if [ -f $folder/$ip_addresses ]; then
                    log yellow bold "-> Using IP LIST File for Scan ..."
                    sudo nmap -iL $folder/$ip_addresses $verbose $1 $timing -oX $folder/$2.xml
                else
                    log yellow bold "-> Using TARGET $target for Scan ..."
                    sudo nmap $verbose $1 $timing $target -oX $folder/$2.xml            
                fi
                xmlTOhtml $2.xml $2.html
                backScanMenu 
                ;;
            *) 
                scanMenu
                ;;
        esac           
    fi      
}

tcpScan() {
    header "$TS"
    showDescription tcp_connect
    performScan "-sT" $tcp_scan  
}

udpScan() {
    header "$US"
    showDescription udp_scan
    performScan "-sU" $udp_scan
}

fullScan() {
    header "$FS"
    showDescription full_scan
    performScan "-A" $full_scan
}

arpScan() {
    header "$AS"
    showDescription arp_scan
    performScan "-PR" $arp_scan
}

synScan() {
    header "$SS"
    showDescription tcp_syn
    performScan "-sS" $syn_scan
}

nullScan() {
    header "$NS"
    showDescription other_tcp_scan
    performScan "-sN" $null_scan
}

finScan() {
    header "$FS"
    showDescription other_tcp_scan
    performScan "-sF" $fin_scan
}

xmasScan() {
    header "$XS"
    showDescription other_tcp_scan
    performScan "-sX" $xmas_scan
}

fastScan() {
    header "$FA"
    showDescription fast_scan
    performScan "--top-ports 20" $fast_scan
}

customScan() {
    header "$CS"
    echo -ne " ${BOLD_YELLOW}Enter Custom Flags: ${RST}"
    read flags
    performScan "$flags" $custom_scan
}

showFiles() {
    header "$SF"
    if [ -d "$folder" ]; then
        cd $folder
        ls -l
        cd $scriptDir
        backScanMenu
    else
        log red bold "ERROR: Missing Folder $folder"
        backScanMenu
    fi
}

writeTiming() {
    log yellow bold "-> Writing new Timing File ..."
    echo "$timing" > $folder/$timing_file
    sleep 2
    scanMenu
}

setTiming() {
    header "$TL"
    showDescription timing
    printOptions "${TIMINGMENU[@]}"
    echo -ne "  ${BOLD_CYAN}Choose an option: ${RST}"
    read a
    case $a in
        0)
            timing="-T0"
            writeTiming
            ;;
        1)
            timing="-T1"
            writeTiming
            ;;
        2) 
            timing="-T2"
            writeTiming
            ;;
        3) 
            timing="-T3"
            writeTiming
            ;;
        4) 
            timing="-T4"
            writeTiming
            ;;
        5) 
            timing="-T5"
            writeTiming
            ;;
        6)
            writeTiming
            scanMenu
            ;;
        *) 
            invalidOption $a
            setTiming
            ;;
    esac
}

inputDatas