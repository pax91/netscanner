#!/bin/bash

exitProgram() {
    writeTiming
    writeVerbose
    writeTarget
    exit 0 
}

customScan() {
    header "$CS"
    showDescription custom_scan
    echo -ne " ${BOLD_CYAN}Enter Custom Flags (void to exit): ${RST}"
    read flags
    if [ -z "$flags" ]; then
        scanMenu
    else
        execScan "$CS" custom_scan "$flags"
    fi
}

execScan() {
    header "$1"
    showDescription "$2"
    performScan $2 "$3"  
}

missingTarget() {
    log red bold "-> ERROR: missing TARGET input"
    log red bold "-> Redirecting to TARGET INPUT ..."
    sleep 2
    inputTarget
}

listInterfaces() {
    header "$IN"
    showDescription list_interfaces
    local list="$(nmap --iflist)"
    nmap --iflist | grep "ethernet    up"
    backMainMenu
}

showDescription() {
    if [ ! -z "$1" ]; then
        local path="$descriptionsFolder/$1.txt"
        if [[ -f $path ]]; then
            local text="$(cat $path)"
            log white "$text"
            printLine
        else
            log red bold "ERROR: Missing $1 Description File"
            printLine    
        fi
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
        writeTarget
        if [[ -f $path ]]; then
            local text="$(cat $path)"
            log white "$text"
            printLine
        fi
        log yellow bold "-> Redirecting to PING SCAN ..."
        sleep 3
        pingScanHosts
    fi    
}

pingScanHosts() {
    header "$PS"
    showDescription ping_scan
    if [ -z "$target" ]; then
        missingTarget
    else
        log yellow bold "-> If you skip this scan, the inputed TARGET will be used for scans"
        log yellow bold "-> Otherwhise a new IP LIST file will be created"
        echo -ne " ${BOLD_YELLOW}Do you want to start scan (y/Y)? ${RST}"
        read choice
        case "$choice" in 
            y|Y) 
                nmap -sn $target -oN "$live_hosts"
                log yellow bold "-> Creating IPLIST File $ip_addresses ..."
                grep "Nmap scan report for" "$live_hosts" | awk '{print $5}' > "$ip_addresses"                
                backScanMenu 
                ;;
            *) 
                scanMenu
                ;;
        esac      
    fi   
}

createCustomReport() {
    if [ -z "$1" ]; then
        log red bold "ERROR: Missing argument Scan Folder"        
    else
        if [ ! -d "$1" ]; then
            log red bold "ERROR: Folder $1 doesn't exists"        
        else
            local xmlFile="$1/nmap_report.xml"
            local htmlFile="$1/nmap_report.html"
            local customFile="$1/scan_report.html"
            if [[ -f $xmlFile ]]; then
                log yellow bold "-> Converting $xmlFile to $htmlFile ..."
                xsltproc $xmlFile -o $htmlFile       
            else
                log red bold "-> ERROR: Missing XML File $xmlFile"
            fi
            if [[ -f $htmlFile ]]; then
                log yellow bold "-> Creating Custom Report ..."
                if [[ -f $customFile ]]; then
                    log yellow bold "-> Removing Existing $customFile ..."
                    rm $customFile
                fi
                log yellow bold "-> Copying base.html to $customFile ..."
                cp $partsFolder/base.html $customFile
                log yellow bold "-> Adding Custom CSS ..."
                local css="$(cat $partsFolder/style.css)"
                echo "<style type='text/css'>$css</style>" >> $customFile
                log yellow bold "-> Adding Custom JS ..."
                local js="$(cat $partsFolder/functions.js)"
                echo "<script type='text/javascript'>$js</script>" >> $customFile
                echo "</head>" >> $customFile
                log yellow bold "-> Adding Extracted BODY ..."
                local body="$(sed -n "/<body>/,/<\/body>/p" $htmlFile)"
                echo "$body" >> $customFile
                echo "</html>" >> $customFile
                log yellow bold "-> Created Custom REPORT $customFile"      
            fi 
        fi
    fi
}

runScan() {
    if [ -d "$1" ]; then
        log yellow bold "-> Removing Existing $1 ..."
        sudo rm -r $1
    fi
    log yellow bold "-> Creating $1 ..."
    mkdir "$1"                
    sudo nmap $2 -oN $1/nmap_report.txt -oX $1/nmap_report.xml
    createCustomReport "$1" 
}

performScan() {
    if [ -z "$1" ]; then
        log red bold "ERROR: missing argument Scan Name"
        exit 0
    fi
    if [ -z "$2" ]; then
        log red bold "ERROR: missing argument Scan Params"
        exit 0
    fi
    if [ -z "$target" ]; then
        missingTarget
    else
        local scanFolder="$folder/$1"  
        local args="$verbose $timing $2"
        if [ -d "$scanFolder" ]; then
            log red bold "-> WARNING: Existing $scanFolder will be overwritten"
        fi
        if [[ -f $ip_addresses ]]; then
            log yellow bold "-> Using IP LIST File for Scan ..."
            args="-iL $ip_addresses $args"
        else
            log yellow bold "-> Using TARGET $target for Scan ..."
            args="$args $target"         
        fi
        log yellow bold "-> The below command will be executed"
        log purple bold "sudo nmap $args"
        printLine
        log yellow bold "-> Press (t/T) to force start Scan Using TARGET"
        log yellow bold "-> Press (y/Y) to start Scan"
        log yellow bold "-> Press any other key to Cancel Scan"
        echo -ne "${BOLD_CYAN} Please enter choiche: ${RST}"
        read choice
        case "$choice" in 
            t|T)
                log red bold "-> Forcing Using TARGET $target for Scan ..."
                args="$verbose $timing $2 $target" 
                runScan "$scanFolder" "$args"
                backScanMenu 
                ;;
            y|Y) 
                runScan "$scanFolder" "$args"
                backScanMenu 
                ;;
            *) 
                scanMenu
                ;;
        esac           
    fi      
}

showFiles() {
    header "$SF"
    if [ -d "$folder" ]; then
        cd $folder
        ls -l
        cd $scriptDir
        backMainMenu
    else
        log red bold "ERROR: Missing Folder $folder"
        backMainMenu
    fi
}

writeTiming() {
    log yellow bold "-> Writing Timing File ..."
    echo "$timing" > $timing_file 
}

writeVerbose() {
    log yellow bold "-> Writing Verbose File ..."
    echo "$verbose" > $verbose_file 
}

writeTarget() {
    log yellow bold "-> Writing Target File ..."
    echo "$target" > $target_file
}

# Timing Setting Options
TIMINGMENU=(
    "Paranoid (-T0)"
    "Sneaky (-T1)"
    "Polite (-T2)"
    "Normal (-T3)"
    "Aggressive (-T4)"
    "Insane (-T5)" 
)
setTiming() {
    header "$TL"
    showDescription set_timing
    printOptions "${TIMINGMENU[@]}"
    echo -ne "  ${BOLD_CYAN}Choose an option: ${RST}"
    read a
    case $a in
        [0-5])
            timing="-T$a"
            writeTiming
            sleep 2
            setTiming
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
            setTiming
            ;;
    esac
}
# Verbose Setting Options
VERBOSEMENU=(
    "Disabled"
    "Level 1 (-v)"
    "Level 2 (-vv)"
    "Level 3 (-v3)"
)
setVerbose() {
    header "$VL"
    printOptions "${VERBOSEMENU[@]}"
    echo -ne "  ${BOLD_CYAN}Choose an option: ${RST}"
    read a
    case $a in
        0)
            verbose=""
            writeVerbose
            sleep 2
            setVerbose
            ;;
        1)
            verbose="-v"
            writeVerbose
            sleep 2
            setVerbose
            ;;
        2)
            verbose="-vv"
            writeVerbose
            sleep 2
            setVerbose
            ;;
        3)
            verbose="-v3"
            writeVerbose
            sleep 2
            setVerbose
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
            setVerbose
            ;;
    esac
}

listDirs() {
    printLine
    cd "$1"
    ls -d */ | cut -f1 -d'/' 
    cd $scriptDir
    printLine
}

inputDatas() {
    header "$ID"
    showDescription input_datas
    if [ -z "$folder" ]; then
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
        listDirs "$parentDir"
        echo -ne " ${BOLD_CYAN}Enter new Folder Name (Void for default): ${RST}"
        read newfolder
        if [ -z "$newfolder" ]; then
            log yellow bold "-> Default folder name will be used ..." 
            local dt=$(date +'%Y-%m-%d_%H-%M-%S')
            folder="$parentDir/$dt"      
        else
            folder="$parentDir/$newfolder"
        fi
    else 
        log cyan bold "-> Using Folder $folder ..."
    fi
    if [ ! -d "$folder" ]; then
        log yellow bold "-> Creating $folder ..."
        mkdir $folder        
    else
        log yellow bold "-> Folder $folder Already Exists ..."    
    fi
    paramsFolder="$folder/$paramsFolder" 
    if [ ! -d "$paramsFolder" ]; then
        log yellow bold "-> Creating $paramsFolder ..."
        mkdir $paramsFolder
    else
        log yellow bold "-> Folder $paramsFolder Already Exists ..."    
    fi
    verbose_file="$paramsFolder/$verbose_file"
    timing_file="$paramsFolder/$timing_file"
    target_file="$paramsFolder/$target_file"
    ip_addresses="$paramsFolder/$ip_addresses"
    live_hosts="$paramsFolder/$live_hosts"
    if [[ -f $verbose_file ]]; then
        log yellow bold "-> Finded Existing VERBOSE FILE ..."
        local vb="$(cat $verbose_file)"
        verbose=$vb        
    fi
    if [[ -f $timing_file ]]; then
        log yellow bold "-> Finded Existing TIMING FILE ..."
        local tm="$(cat $timing_file)"
        timing=$tm        
    fi
    if [[ -f $target_file ]]; then
        log yellow bold "-> Finded Existing TARGET FILE ..."
        local tg="$(cat $target_file)"
        target=$tg      
    fi
    createRunner
    if [ -z "$target" ]; then
        log yellow bold "-> Redirecting to TARGET INPUT ..."
        sleep 2
        inputTarget 
    else
        log yellow bold "-> Redirecting to SCAN MENU ..."
        sleep 2
        scanMenu
    fi
}

createRunner() {
    log yellow bold "-> Creating Running Script ..."
    local runnerPath="$folder/run.sh"
    if [[ -f $runnerPath ]]; then
        log yellow bold "-> Removing $runnerPath ..."
        rm $runnerPath
    fi
    log yellow bold "-> Copying Running Script ..."
    cp $partsFolder/run.sh "$runnerPath"
    log yellow bold "-> Adding Settings ..."
    echo "script_dir='$scriptDir'" >> "$runnerPath"
    echo "current_dir='$folder'" >> "$runnerPath"
    echo "start" >> "$runnerPath"
    log yellow bold "-> Making Script Executable ..."
    chmod +x $runnerPath
}