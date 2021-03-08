#!/bin/bash
clear
echo "$USER"@"$(hostname | cut -f 1 -d .)"' ~ % hedgefetch'
echo '		###  ###'
echo '	       ## ## #'
echo '##### ###   ## #   # ##'
echo '# # #  ##  #   #   #  ##'
echo '# # # # #  #   ## ##   #'
echo '# # # ## #  ##  ###  ###'
echo ""
date=$(date +%a\ %d\ %b\ %Y)
echo "Current Date:" $date
time=$(date +%I:%M:%S\ %p\ %Z)
timezone=$(date +%Z)
ampm=$(echo "$time" | grep -qi 'PM' && echo PM || echo AM)
if  [[ $ampm == PM ]]; then
    time=$(date +%I:%M | sed "s/$/ PM ${timezone}/")
else
    time=$(date +%I:%M:%S | sed "s/$/ AM ${timezone}/")
fi
Metal=$(system_profiler SPDisplaysDataType 2> /dev/null | grep Metal)

if [[ $Metal =~ "Metal" ]];then
	Metal=$(echo '(Metal)')
else
	Metal=$(echo '(OpenGL)')
fi
echo "Current Time: $time"
uptime=$(uptime | sed -E 's/^[^,]*up *//; s/mins/minutes/; s/hrs?/hours/; s/([[:digit:]]+):0?([[:digit:]]+)/\1 hours, \2 minutes/; s/^1 hours/1 hour/; s/ 1 hours/ 1 hour/; s/min,/minutes,/; s/ 0 minutes,/ less than a minute,/; s/ 1 minutes/ 1 minute/; s/  / /; s/, *[[:digit:]]* users?.*//')
echo "Uptime: $uptime"
if [ -f ~/Library/Preferences/com.apple.SystemProfiler.plist ];then
HMac=$(defaults read ~/Library/Preferences/com.apple.SystemProfiler.plist "CPU Names" | cut -f 2 -d = | sed 's/..$//' | tail -n 2 | head -n 1 | sed 's/$//' | cut -c 3-)
else
	if ping -t 1 apple.com >> /dev/null ; then
	HMac=$( curl -s 'https://support-sp.apple.com/sp/product?cc='$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}' | cut -c 9-)  | sed 's|.*<configCode>\(.*\)</configCode>.*|\1|' )
	else
		HMac=$(system_profiler SPHardwareDataType | awk '/Model Name/' | cut -f 2 -d ':' | cut -c 2-)
	fi
fi
echo Mac: "$HMac"
sysctl hw.model | cut -c 11\-  | sed 's/^/Model: /g'
system_profiler SPSoftwareDataType | grep 'System Version' | cut -c 23- | sed 's/^/OS: /g'
sysctl -n machdep.cpu.brand_string  | sed 's/^/CPU: /g'
system_profiler SPDisplaysDataType 2> /dev/null  | grep "Chipset Model" | cut -f 2 -d ':' | sed 's/^/GPU: /g' | sed "s/$/ ${Metal}/"
system_profiler SPDisplaysDataType 2> /dev/null | grep Resolution | cut -c 23- | cut -f 1 -d "(" | cut -f 1 -d "R" | sed -E 's/[ ]+//g' | sed 's/^/Resolution: /g'
kb=$(sysctl hw.memsize | cut -c 13- )
MB=$(( $kb / 1024/1024 ))
GB=$(( $kb / 1024/1024/1024 ))
MB=$( echo $MB | sed 's/$/MB/')
activeram=$(($(vm_stat | grep "Pages active:" | sed 's/[^0-9]*//g')*4096/1024/1024))
wiredram=$(($(vm_stat | grep "wired down:" | cut -f 2 -d ':' | sed 's/[^0-9]*//' | cut -f 1 -d '.')*4096/1024/1024))
compressedram=$(($(vm_stat | grep "Pages occupied by compressor:" | cut -f 2 -d ':' | sed 's/[^0-9]*//' | cut -f 1 -d '.')*4096/1024/1024))
#UsedMem=$(top -l 1 | grep PhysMem | cut -c 10-  | cut -d ' ' -f -1 | sed 's/.$//')
UsedMem=$(( $activeram + $wiredram + $compressedram))
UsedGB=$(( $UsedMem / 1024 ))
#UsedMem=$( top -l 1 | grep PhysMem | cut -c 10-  | cut -d ' ' -f -1)
echo "$UsedMem" | sed "s/$/MB ("$UsedGB"GB) of $MB ("$GB"GB) Used/"




