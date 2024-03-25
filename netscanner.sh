#!/bin/bash
source bin/texts.sh
source bin/log.sh
source bin/scanner.sh
source bin/menu.sh
# Directories Paths
parentDir="$HOME/Desktop"
scriptDir="$PWD"
descriptionsFolder="$PWD/descriptions"
partsFolder="$PWD/parts"
# TXT Files names
paramsFolder="params"
ip_addresses=ip_addresses.txt
live_hosts=live_hosts.txt
target_file=target.txt
timing_file=timing.txt
verbose_file=verbose.txt
# Running Variables
folder=""
target=""
verbose="-v"
timing="-T3"

main() {
    clear
    echo ""
    head
    if [[ "$OSTYPE" == "linux"* || "$OSTYPE" == "darwin"* ]]; then
        log green bold "-> Detected compatible OS $OSTYPE"
        if ! nmap -V >/dev/null 2>&1; then
            log red bold "ERROR: The script require NMAP to be installed !!!"
            printLine
            log white bold "Please install NMAP on your machine"
            log white bold "https://nmap.org/download.html"
            printLine
            exit 1
        else
            log green bold "-> Detected NMAP Installed"
            inputDatas
        fi
    else
        log red bold "ERROR: Incompatible Operating System Detected $OSTYPE"
        printLine
        log white bold "The script is compatible only with OSX and LINUX"
        printLine
        exit 1
    fi
}

while getopts "f:" arg; do
    case $arg in
        f) 
            folder="$OPTARG"
            ;;
    esac
done

main