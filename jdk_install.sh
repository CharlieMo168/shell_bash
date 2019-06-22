#!/bin/bash

function ECHO
{
    echo -e "\033[1;32m$* \033[0m"
}




echo "# set java environment to /etc/profile" >> /etc/profile
echo "JAVA_HOME=/usr/java/jdk-11" >> /etc/profile
echo "JRE_HOME=\$JAVA_HOME/jre" >> /etc/profile
echo "CLASSPATH=.:\${JAVA_HOME}/jre/lib/rt.jar:\${JAVA_HOME}/lib/dt.jar:\${JAVA_HOME}/lib/tools.jar" >> /etc/profile
echo "PATH=\$PATH:\${JAVA_HOME}/bin" >> /etc/profile
echo "export JAVA_HOME JRE_HOME PATH CLASSPATH" >> /etc/profile


