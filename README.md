##   PAX NETWORK SCANNER SCRIPT
##  © made by PAX - Luca Passoni
# Network scanner script all based on NMAP scanning functions, say thanks to NMAP developers https://nmap.org

Download all files and add to all the .sh files +x mode, using chmod +x *.sh.
To run script just run ./scanner.sh and follow onscreen instuctions.

The script will create a new REPORT folder in user Desktop where put txt files containing settings and HTML reports of scans.
All the functions are based on NMAP scripts, this script just want to be an automation of the NMAP scanning scripts.
For all Scanning operation an XML report will be created and then will be converted into an HTML file using xsltproc command.

The script require to be runned on Linux or MACOSX and having NMAP installed on the machine.
The script was developed on OSX Sonoma 14.3.1 with NMAP v7.92

All the code is fully free and open source, all improvements and any use for any is full free.
Any kind of use of the code is accepted, fell free to commit changes or improvements.
