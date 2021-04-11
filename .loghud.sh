#!/bin/bash

# Current user
user=$(whoami)

# System hostname
hostname=$(hostname)

# Distro name
distro=$(lsb_release -i | awk '{print $3}')
distroVer=$(lsb_release -r | awk '{print $2}')

# Architecture
arch=$(arch)
archBits=$(getconf LONG_BIT)bit

# Kernel
kernel=$(uname)
kernelRelease=$(uname -r)

# Loggin session
session=$(echo $DESKTOP_SESSION)

# Shell
#shell=$(echo eval "$0 --version" | awk '{print $1, $2}')
shell=$(ps | awk 'NR==2 {print $4}')
shellVer=$($shell --version | awk 'NR==1 {print $1, $2}')

# Processor
cpuModel=$(grep -m 1 "model name" /proc/cpuinfo | cut -d: -f2 | awk '{print $1, $2, $3, $4}')
cpuFrecuency=$(grep -m 1 "model name" /proc/cpuinfo | cut -dU -f2 | awk '{print $1, $2, $3, $4}')
cpuCores=$(grep -c "processor" /proc/cpuinfo)

# Memory
memory=$(cat /proc/meminfo | head -1 | awk '{print $2}')

# Disk space
diskUsed=$(df . | grep 'sda' | awk '{print int($3/1024/1024+0.5)}')
diskTotal=$(df . | grep 'sda' | awk '{print int($2/1024/1024+0.5)}')
diskPerc=$(df . | grep 'sda' | awk '{print int($5)}')

# Memory space
mem=$(free -m | grep -i "mem")
memUsed=$(echo $mem | awk '{print $3}')
memTotal=$(echo $mem | awk '{print $2}')
memFree=$(echo $mem | awk '{print $7}')

# Terminal
terminal=$(x-terminal-emulator --version | awk 'NR==1')

# Colors
stE="\u001b["
endE="\u001b[0m"
block="█"
white="${stE}37m${block}${endE}${stE}97m${block}${endE}"
cyan="${stE}36m${block}${endE}${stE}96m${block}${endE}"
magenta="${stE}35m${block}${endE}${stE}95m${block}${endE}"
blue="${stE}34m${block}${endE}${stE}94m${block}${endE}"
yellow="${stE}33m${block}${endE}${stE}93m${block}${endE}"
green="${stE}32m${block}${endE}${stE}92m${block}${endE}"
red="${stE}31m${block}${endE}${stE}91m${block}${endE}"

colors="${white} ${cyan} ${magenta} ${blue} ${yellow} ${green} ${red}"


# Packages
packages=$(dpkg -l | wc -l)

# Processes
process=$(ps -aux | wc -l)

stB="${stE}34;1m"
stF="${stE}92m"
stD="${stE}0m"
if [ $diskPerc -ge 75 ]; then
  stD="${stE}93m"
elif [$diskPerc -ge 90]; then
  std="${stE}91m"
fi
stL="${stE}1;95m"
endB="${stE}1;97m"

info="\n\n ${stB}$user@$hostname${endE}\n\n
${stB}Distribución:${endE} $distro $distroVer $arch $archBits\n
${stB}Kernel:${endE} $kernel $kernelRelease\n
${stB}Sesión:${endE} $session\n
${stB}Shell:${endE} $shellVer\n
${stB}Terminal:${endE} $terminal $colors\n
${stB}Procesos:${endE} $process\n
${stB}Paquetes instalados:${endE} $packages\n
${stB}CPU:${endE} $cpuCores x $cpuModel $cpuFrecuency\n
${stB}RAM:${endE} ${memUsed} MB / ${memTotal} MB\t${stF}${memFree} MB libres${endE}\n
${stB}Almacenamiento:${endE} ${stD}$diskUsed GB${endE} / $diskTotal GB  ${stD}${diskPerc}% usado${endE}\n
"

logo="${stL}            .-/+oossssoo+/-.\t\t\t
${stL}        \`:+ssssssssssssssssss+:\`\t\t
${stL}     -+ssssssssssssssssssyyssss+-\t\t
${stL}   .ossssssssssssssssss${endB}dMMMNy${stL}sssso.\t\t
${stL}  /sssssssssss${endB}hdmmNNmmyNMMMMh${stL}ssssss/\t\t
${stL}  +sssssssss${endB}hm${stL}yd${endB}MMMMMMMNddddy${stL}ssssssss+\t\t
${stL} /ssssssss${endB}hNMMM${stL}yh${endB}hyyyyhmNMMMNh${stL}ssssssss/\t\t
${stL}.ssssssss${endB}dMMMNh${stL}ssssssssss${endB}hNMMMd${stL}ssssssss.\t
${stL}+ssss${endB}hhhyNMMNy${stL}ssssssssssss${endB}yNMMMy${stL}sssssss+\t
${stL}oss${endB}yNMMMNyMMh${stL}ssssssssssssss${endB}hmmmh${stL}ssssssso\t
${stL}oss${endB}yNMMMNyMMh${stL}ssssssssssssss${endB}hmmmh${stL}ssssssso\t
${stL}+ssss${endB}hhhyNMMNy${stL}ssssssssssss${endB}yNMMMy${stL}sssssss+\t
${stL}.ssssssss${endB}dMMMNh${stL}ssssssssss${endB}hNMMMd${stL}ssssssss.\t
${stL} /ssssssss${endB}hNMMM${stL}yh${endB}hyyyyhdNMMMNh${stL}ssssssss/\t\t
${stL}  +sssssssss${endB}dm${stL}yd${endB}MMMMMMMMddddy${stL}ssssssss+\t\t
${stL}   /sssssssssss${endB}hdmNNNNmyNMMMMh${stL}ssssss/\t\t
${stL}    .ossssssssssssssssss${endB}dMMMNy${stL}sssso.\t\t
${stL}      -+sssssssssssssssss${endB}yyy${stL}ssss+-\t\t
${stL}        \`:+ssssssssssssssssss+:\`\t\t
${stL}            .-/+oossssoo+/-.\t\t\t
"
count=0

IFS="
"
for line in $logo; do
  count=$((count+1))
  inf=$(echo -e $info | awk "NR==${count}")
  echo -e $line $inf
done
