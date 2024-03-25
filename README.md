#   PAX NMAP NETWORK SCANNER SCRIPT
##  © made by PAX - Luca Passoni
### Network scanner script all based on NMAP scanning scripts
### Say thanks to NMAP developers https://nmap.org for all advanced functions

### Requirements
The script require to be runned on Linux or MACOSX and having NMAP installed on the machine.
At script starting, thi script will check for OSTYPE and NMAP to be installed before proceed.
NMAP INSTALLERS: https://nmap.org/download.html.
The script was developed on OSX Sonoma 14.3.1 with NMAP v7.92, should run on other OS versions with no problem, not tested yet!

### Installation Instruction
Download and extract all files, an make sure to let all .sh file to be executable.
Run the below command to download the script, make all file executable and run it.
```
wget -O netscanner.zip https://github.com/pax91/netscanner/archive/refs/heads/main.zip && unzip netscanner.zip && cd netscanner-main && chmod +x *.sh && chmod +x bin/*.sh && ./netscanner.sh
```

### Run Script
To run script just run ./netscanner.sh and follow onscreen instuctions.
It's possible to add -f flag to set Running Directory
Ex: ./netscanner.sh -f "/Users/username/Desktop/myscanfolder"
After the Script create the Reports Folder, a run.sh script will be created into it to allow you start Netscanner Script
for this folder.
```
##########################################################################
                         PAX NETWORK SCANNER SCRIPT                       
                     https://github.com/pax91/netscanner                  
                        © made by PAX - Luca Passoni                      
##########################################################################
  FOLDER       : /Users/pax/Desktop/pax
  TARGET       : 192.168.2.0/24
  TIMING LEVEL : -T3
  VERBOSE LOGS : -v
  IP LIST      : Created
##########################################################################
                        PEFORMING TCP CONNECT SCAN                        
##########################################################################
Specifies that you wish to scan fewer ports than the default. 
Normally Nmap scans the most common 1,000 ports for each scanned 
protocol. With -F, this is reduced to 100.

Nmap needs an nmap-services file with frequency information in 
order to know which ports are the most common. 
If port frequency information isn´t available, perhaps because 
of the use of a custom nmap-services file, -F means to scan only 
ports that are named in the services file (normally Nmap scans 
all named ports plus ports 1–1024).
##########################################################################
-> Using IP LIST File for Scan ...
-> The below command will be executed
sudo nmap -iL /Users/pax/Desktop/pax/params/ip_addresses.txt -v -T3 -F
##########################################################################
-> Press (t/T) to force start Scan Using TARGET
-> Press (y/Y) to start Scan
-> Press any other key to Cancel Scan
 Please enter choiche: 
```

### Description
The script ask you to create a new REPORT folder in user Desktop (or your custom location to be inputed) where put a folder into it named /params containing all the txt files for the script settings.
Into this folder will be also created a run.sh script to let you start the scrit directly from this folder.
If you input an existing folder location, the script will use founded params to use in the script.
```
##########################################################################
                         PAX NETWORK SCANNER SCRIPT                       
                     https://github.com/pax91/netscanner                  
                        © made by PAX - Luca Passoni                      
##########################################################################
  FOLDER       : 
  TARGET       : 
  TIMING LEVEL : -T3
  VERBOSE LOGS : -v
  IP LIST      : Missing
##########################################################################
                        SCRIPT DATAS INITIALIZATION                       
##########################################################################
The script will create a new Folder with the scan results.
 By default Desktop will be used as Parent Directory.
 You can change the default folder name or use an existing folder name.
##########################################################################
 Enter Parent Path (void to use /Users/pax/Desktop): 
-> Default /Users/pax/Desktop Parent Path will be used ...
##########################################################################
$RECYCLE.BIN
GOOGLE DRIVE
NODEJS CODES
SOFTWARE VARI
netscanner-main
pax
##########################################################################
 Enter new Folder Name (Void for default): 
```
For every scan process, a new folder will be created into the main folder, containing NMAP reports plus a CUSTOM HTML report file (see Customization section).
After inputing the Target to be scanned, the script will perform a PING SCAN (nmap -sn option) to find all Live Hosts and create a TXT files with IP ADDRESSES LIST to be used on others scanning options as INPUT.

### Customization
For every scan procss executed, the script will create a folder containing the orignal NMAP reports (nmap_report.txt, nmap_report.xml and nmap_report.html) plus a CUSTOM REPORT named scan_report.html created from orginal NMAP HTML scan report file and adding custom css stylesheet and custom JS code.
You can customize style and JS code editing the files into /parts folder.
You can edit ROOT CSS Variables to change colors and other
```
:root {
    --fontFamily: Verdana;
    --fontSize: 15px;  
    --bgColor: rgb(255, 255, 255);
    --textColor: rgb(0, 0, 0);
    --bgHead: rgb(100, 220, 100);
    --bgMain: rgb(204, 255, 204);
    --bgSecondary: rgb(239, 255, 247);
    --linkColor: rgb(0, 100, 0);
}
```

### License
All the code is fully free and open source of course.
Any kind of use of the code is accepted, fell free to commit changes or improvements.
There will be bugs and maybe the script can be more faster than now, but hope that someone will find it usefull :=)

### Operating Menus Preview
The MAIN MENU
```
##########################################################################
                         PAX NETWORK SCANNER SCRIPT                       
                     https://github.com/pax91/netscanner                  
                        © made by PAX - Luca Passoni                      
##########################################################################
  FOLDER       : /Users/pax/Desktop/pax
  TARGET       : 192.168.2.0/24
  TIMING LEVEL : -T3
  VERBOSE LOGS : -v
  IP LIST      : Created
##########################################################################
                                 MAIN MENU                                
##########################################################################
  0) Set Target
  1) Set Timing Level
  2) Set Verbose Logging
  3) List Active Interfaces
  4) View Folder Files
  5) Manage IP LIST File
  m) Main Menu
  s) Scan Menu
  q) Exit Program
  Choose an option:  
```
The SCAN MENU
```
##########################################################################
                         PAX NETWORK SCANNER SCRIPT                       
                     https://github.com/pax91/netscanner                  
                        © made by PAX - Luca Passoni                      
##########################################################################
  FOLDER       : /Users/pax/Desktop/pax
  TARGET       : 192.168.2.0/24
  TIMING LEVEL : -T3
  VERBOSE LOGS : -v
  IP LIST      : Created
##########################################################################
                                 SCAN MENU                                
##########################################################################
  0) FAST Scan (-F)
  1) Custom Flags Scan
  2) TCP Connect Scan (-sT)
  3) SYN Half-Open Scan (-sS)
  4) TCP Null Scan (-sN)
  5) TCP FIN Scan (-sF)
  6) TCP Xmas Scan (-sX)
  7) UDP Scan (-sU)
  8) OS Detection Scan (-O)
  9) Version Detection Scan (-sV)
  10) Aggressive Scan (-A)
  11) ARP Scan (-PR)
  m) Main Menu
  s) Scan Menu
  q) Exit Program
  Choose an option: 
```
The IP LIST FILE MANAGER MENU
```
##########################################################################
                         PAX NETWORK SCANNER SCRIPT                       
                     https://github.com/pax91/netscanner                  
                        © made by PAX - Luca Passoni                      
##########################################################################
  FOLDER       : /Users/pax/Desktop/pax
  TARGET       : 192.168.2.0/24
  TIMING LEVEL : -T3
  VERBOSE LOGS : -v
  IP LIST      : Created
##########################################################################
                         MANAGING IP LIST FILE                           
##########################################################################
In this section you can manage the IP LIST file used
into the Scan Options. If this file is missing, the
TARGET wll be used
##########################################################################
192.168.2.1
192.168.2.9
192.168.2.11
192.168.2.12
192.168.2.15
192.168.2.50
192.168.2.70
192.168.2.100
192.168.2.101
192.168.2.102
##########################################################################
  0) Delete File
  1) Add Host
  2) Edit File
  m) Main Menu
  s) Scan Menu
  q) Exit Program
  Choose an option: 
```
The SCRIPT VERBOSE LEVEL MENU
```
##########################################################################
                         PAX NETWORK SCANNER SCRIPT                       
                     https://github.com/pax91/netscanner                  
                        © made by PAX - Luca Passoni                      
##########################################################################
  FOLDER       : /Users/pax/Desktop/pax
  TARGET       : 192.168.2.0/24
  TIMING LEVEL : -T3
  VERBOSE LOGS : -v
  IP LIST      : Created
##########################################################################
                        SETTING SCRIPT VERBOSE LEVEL                      
##########################################################################
  0) Disabled
  1) Level 1 (-v)
  2) Level 2 (-vv)
  3) Level 3 (-v3)
  m) Main Menu
  s) Scan Menu
  q) Exit Program
  Choose an option: 
```
The TIMING TEMPLATES MENU
```
##########################################################################
                         PAX NETWORK SCANNER SCRIPT                       
                     https://github.com/pax91/netscanner                  
                        © made by PAX - Luca Passoni                      
##########################################################################
  FOLDER       : /Users/pax/Desktop/pax
  TARGET       : 192.168.2.0/24
  TIMING LEVEL : -T3
  VERBOSE LOGS : -v
  IP LIST      : Created
##########################################################################
                        SETTING SCRIPT TIMING LEVEL                       
##########################################################################
These templates allow the user to specify how aggressive they wish to be, 
while leaving Nmap to pick the exact timing values. 
The templates also make some minor speed adjustments for which fine-grained 
control options do not currently exist. For example, -T4 prohibits the 
dynamic scan delay from exceeding 10 ms for TCP ports and -T5 caps that 
value at 5 ms. Templates can be used in combination with fine-grained 
controls, and the granular options will override the general timing templates 
for those specific values. I recommend using -T4 when scanning reasonably 
modern and reliable networks. Keep that option 
(at the beginning of the command line) even when you add fine-grained 
controls so that you benefit from those extra minor
optimizations that it enables.
##########################################################################
  0) Paranoid (-T0)
  1) Sneaky (-T1)
  2) Polite (-T2)
  3) Normal (-T3)
  4) Aggressive (-T4)
  5) Insane (-T5)
  m) Main Menu
  s) Scan Menu
  q) Exit Program
  Choose an option: 
```
