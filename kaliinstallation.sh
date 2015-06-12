#!/bin/bash
#Coloring
#red = 'tput setaf 1'
#green = 'tput setaf 2'
#nc = 'tput sgr0'
red='\033[0;31m'
cyan='\033[0;36m'
blue='\033[0;34m'
lgreen='\033[1;32m'
orange='\033[0;33m'
nc='\033[0m'
printf "${blue}Kali ${cyan}Linux ${nc} Initialiasation Script\n"

printf "Checking ${red}Bleeding Edge ${nc} repository...\n"

if grep -q "deb http://repo.kali.org/kali kali-bleeding-edge main" "/etc/apt/sources.list"; then
  printf "${lgreen}OK  ✔${nc}\n"
else
  printf "Adding ${red}Bleeding Edge ${nc} repository...\n"
  printf "\n## Bleeding Edge Repository\n" >> /etc/apt/sources.list
  printf "deb http://repo.kali.org/kali kali-bleeding-edge main\n" >> /etc/apt/sources.list
  printf "${lgreen}OK  ✔${nc}\n"
fi

printf "Updating and Upgrading ${blue}Kali ${cyan}Linux ${nc}\n"
#apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade
printf "${lgreen}OK  ✔${nc}\n"

printf "Starting ${cyan}Postgresql${nc} and ${red}Metasploit${nc} at boot\n"
update-rc.d postgresql enable
update-rc.d metasploit enable
printf "${lgreen}OK  ✔${nc}\n"


printf "Checking ${orange}Java ${nc}version\n"

tmp=`java -version 2>&1`
#printf "$tmp\n"

if grep -q OpenJDK<<<$tmp ; then
  echo "found OpenJDK"
  read -r -p "Do you want to install Sun Java 7u79 (working with older Burp Suite)? [y/N] " response
  response=${response,,}
  if [[ $response =~ ^(yes|y)$ ]];then
    printf "Downloading ${red}Oracle ${orange}Java ${nc} JDK\n"
    #random folder
    rm -rf temp_installation
    mkdir temp_installation && cd temp_installation
    if grep -q x86_64<<<`uname -m`;then 
      wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz
      jversion="jdk-7u79-linux-x64.tar.gz"
    else
      wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-i586.tar.gz
      jversion="jdk-7u79-linux-i586.tar.gz"
    fi
    tar xzvf ${jversion}
    mv jdk1.7.0_79 /opt

    #UPDATE ALTERNATIVES

    update-alternatives --install /usr/bin/java java /opt/jdk1.7.0_79/bin/java 1
    update-alternatives --install /usr/bin/javac javac /opt/jdk1.7.0_79/bin/javac 1
    update-alternatives --install /usr/lib/mozilla/plugins/libjavaplugin.so mozilla-javaplugin.so /opt/jdk1.7.0_79/jre/lib/amd64/libnpjp2.so 1
    update-alternatives --set java /opt/jdk1.7.0_79/bin/java
    update-alternatives --set javac /opt/jdk1.7.0_79/bin/javac
    update-alternatives --set mozilla-javaplugin.so /opt/jdk1.7.0_79/jre/lib/amd64/libnpjp2.so
    cd .. && rm -rf temp_installation
  fi
else
  printf "Oracle Java found\n"
  printf "${lgreen}OK  ✔${nc}\n"
fi

read -r -p "Do you want to install Veil Evasion? [y/N] " response
response=${response,,}
if [[ $response =~ ^(yes|y)$ ]];then
  apt-get -y install veil-evasion
  printf "You must run veil-evasion to complete installation.\n"
fi

# then echo "\[\e[32m\] ✔ "; else echo "\[\e[31m\] ✘ "; fi`\[\e[00;37m\]\u'
