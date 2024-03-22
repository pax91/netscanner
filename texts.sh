#!/bin/bash
# SCAN Menu Options
SCANMENU=(
    "Exit"
    "PING Scan (-sn) and create IP LIST File" 
    "TCP Connect Scan (-sT)" 
    "UDP Scan (-sU)" 
    "FULL Scan (-A)"
    "ARP Scan (-PR)"
    "SYN Half-Open Scan (-sS)"
    "TCP Null Scan (-sN)"
    "TCP FIN Scan (-sF)"
    "TCP Xmas Scan (-sX)"
    "FAST Scan (--top-ports 20)"
    "Enable/Disable Verbose"
    "List Active Interfaces"
    "Input TARGET"
    "View Files"
    "Show/Delete IP LIST File"
    "Set Timing Level"
    "Custom SCAN Flags"
)
# Timing Setting Options
TIMINGMENU=(
    "Paranoid (-T0)"
    "Sneaky (-T1)"
    "Polite (-T2)"
    "Normal (-T3)"
    "Aggressive (-T4)"
    "Insane (-T5)" 
    "Write Timing File and go back to Scan Menu"
)
# Headers Parts
LN="##########################################################################"
SN="                         PAX NETWORK SCANNER SCRIPT                       "
CR="                              © made by PAX                               "
# Menus Headers
SM="                                 SCAN MENU                                "
# Scanning Functions Headers
TS="                        PEFORMING TCP CONNECT SCAN                        "
US="                            PEFORMING UDP SCAN                            "
AS="                            PEFORMING ARP SCAN                            "
FS="                          PEFORMING COMPLETE SCAN                         "
PS="                            PEFORMING PING SCAN                           "
XS="                         PEFORMING TCP XMAS SCAN                          "
FS="                         PEFORMING TCP FIN SCAN                           "
NS="                         PEFORMING TCP NULL SCAN                          "
SS="                         PEFORMING TCP SYN SCAN                           "
FA="                           PEFORMING FAST SCAN                            "
CS="                          PEFORMING CUSTOM SCAN                           "
# Others Functions Headers
IL="                           SHOWING IP LIST FILE                           "
IN="                         SHOWING ACTIVE INTERFACES                        "
VB="                         MANAGING VERBOSE LOGGING                         "
TG="                           MANAGING TARGET INPUT                          "
SF="                               SHOWING FILES                              "
ID="                        SCRIPT DATAS INITIALIZATION                       "
TL="                        SETTING SCRIPT TIMING LEVEL                       "
EV="                      ... VERBOSE LOGGING ENABLED ...                     "
DV="                      ... VERBOSE LOGGING DISABLED ...                    "
# Go Back Functions texts
SB="                  ... Press ENTER to go back Scan Menu ...                "

