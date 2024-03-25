#   PAX NETWORK SCANNER SCRIPT
##  © made by PAX - Luca Passoni
### Network scanner script all based on NMAP scanning scripts
### Say thanks to NMAP developers https://nmap.org for all advanced functions

### Installation 
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
for this folder

### Requirements
The script require to be runned on Linux or MACOSX and having NMAP installed on the machine.
NMAP INSTALLERS: https://nmap.org/download.html.
The script was developed on OSX Sonoma 14.3.1 with NMAP v7.92, should run on other OS versions with no problem, not tested!

### Description
The script ask you to create a new REPORT folder in user Desktop (or your custom location to be inputed) where put a folder into it named /params containing all the txt files for the script settings.
If you input an existing folder location, the script will use founded params to use in the script.
For every scan process, a new folder will be created into the main folder, containing NMAP reports plus a CUSTOM HTML report file (see Customization section).
After inputing the Target to be scanned, the script will perform a PING SCAN (nmap -sn option) to find all Live Hosts and create a TXT files with IP ADDRESSES LIST to be used on others scanning options as INPUT.

### Customization
For every scan procss executed, the script will create a folder containing the orignal NMAP reports plusa a CUSTOM REPORT named scan_report.html created from orginal NMAP HTML scan report file and adding custom css stylesheet.
You can customize style and JS code editing the files into /parts folder.

### License
All the code is fully free and open source.
Any kind of use of the code is accepted, fell free to commit changes or improvements.
There will be bugs and maybe the script can be more faster than now, but hope that someone will find it usefull :=)


