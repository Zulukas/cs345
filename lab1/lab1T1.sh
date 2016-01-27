#!/bin/bash
###############################################################################
# Lab LinuxInfo
# Brother Jones, CS 345, Operating Systems
# Kevin Andres
# 
###############################################################################

###############################################################################
# Part #1
#
# Dump /proc/cpuinfo for parsing.  Search for 'model name', sort out the unique
# duplicates.  Clean up the input with the final awk statement.
###############################################################################
echo "What is the CPU type and model?"
echo "    `cat /proc/cpuinfo | grep 'model name' | uniq | 
           awk '{print substr($0, index($0, $4))}'`"
echo "" #newline

echo "How many processors on this system?"



###############################################################################
# Part #2
#
# Figure out how many physical CPUs, then the total number of cores.  Divide
# num of total cores by num of physical cpus.  build a message based on that
# info.
###############################################################################

NumPhysicalCPUs=`cat /proc/cpuinfo | grep "physical id" | uniq | wc -l`
TotalNumCores=`cat /proc/cpuinfo | grep 'cpu cores' | sort | uniq | cut -c13-`

#Assume that each processor shares the same amount of cores
NumCores=$((TotalNumCores / NumPhysicalCPUs))

#The system is hyper thread if "ht" is found within the flags
MSG="$NumPhysicalCPUs"

if [ $NumCores -eq 1 ]; then
	NumCoreMsg="1 core"
else
	NumCoreMsg="$NumCores cores"
fi

MSG="$MSG processor with $NumCoreMsg each"

#Search for the 'ht' flag, send text to /dev/null
#cat /proc/cpuinfo | grep 'flags' | uniq | grep 'ht' > /dev/null
NumSiblings=`cat /proc/cpuinfo | grep 'siblings' | awk '{print $3}'` | uniq

if [ "$NumSiblings" > "$NumCores" ]; 
then
	MSG="$MSG (hyperthreaded)"
else
	MSG="$MSG (not hyperthreaded)"
fi

echo "    $MSG"
echo "" #newline

###############################################################################
# Part #3
#
# Determine which version of the Linux kernel is being used
###############################################################################

echo "What version of the Linux kernel is being used?"
echo "    `uname -s` version `uname -rv | sed 's/.\{5\}$//'`"
echo "" #newline

###############################################################################
# Part #4
#
# Determine how long the system has been up.
# Note: with the awk, there was an oddball space in the sample provided for
# comparison.  Hence the two spaces between $3 and $4
###############################################################################
echo "How long has it been since the system was last booted?"
UPTIME=`uptime | cut -c11-26 | awk '{print $1 " " $2 " " $3 "  " $4}'`
echo "    $UPTIME"
echo ""

###############################################################################
# Part #5
#
# Determine CPU execution time for user, system and idle.
# All the important stuff on this one comes from the line containing 'cpu  '
# Tearing the information from it and multiplying it by 0.01 gives the needed
# information.
#
# Prints the statistics out with sprintf in order to get a nice output that is
# not in scientific notation.
###############################################################################
echo "How much CPU execution time has been spent in user, system, and idle modes?"
# CPUTIMEINFO=`cat /proc/stat | grep 'cpu  '`
USER=`cat /proc/stat | grep 'cpu  ' | awk '{print sprintf("%.2f", (($2 + $3) * 0.01))}'`
SYSTEM=`cat /proc/stat | grep 'cpu  ' | awk '{print sprintf("%.2f", ($4 * 0.01))}'`
IDLE=`cat /proc/stat | grep 'cpu  ' | awk '{print sprintf("%.2f", ($5 * 0.01))}'`

echo "    USER: $USER seconds"
echo "    SYSTEM: $SYSTEM seconds"
echo "    IDLE: $IDLE seconds"
echo ""

###############################################################################
# Part #6
#
# Determine how much memory is on the machine
#
# This one was tricky because I didn't realize that we were just dumping the
# output
###############################################################################
echo "How much memory is on the machine?"
echo "    `cat /proc/meminfo | grep 'MemTotal:'`"
echo ""

###############################################################################
# Part #7
#
# Determine how much memory is currently available on the machine
#
# Like Part #6, I didn't realize we were just dumping the output from grep.
###############################################################################
echo "How much memory is currently on available?"
echo "    `cat /proc/meminfo | grep 'MemFree:'`"
echo ""

###############################################################################
# Part #8
#
# Determine how much data has been written and read.
#
# I had a weird issue where the data retrieved from iostat was being read
# differently than the sample output.  Giving it a -k flag fixed it *shrug*
###############################################################################
echo "How many kBytes have been read and written to the disk since the last reboot?"
echo "    Read: `iostat -k | grep 'sda' | awk '{print $5}'` kB"
echo "    Written: `iostat -k | grep 'sda' | awk '{print $6}'` kB"
echo ""

###############################################################################
# Part #9
#
# Determine how many processes have been spawned since boot.
###############################################################################
echo "How many processes have been created since the last reboot?"
echo "    Processes created: `cat /proc/stat | grep 'processes ' | awk '{print $2}'`"
echo ""

###############################################################################
# Part #10
#
# Determine how many context switches have been made since boot.
###############################################################################
echo "How many context switches have been performed since the last reboot?"
echo "    Context switches: `cat /proc/stat | grep 'ctxt ' | awk '{print $2}'`"
echo ""

###############################################################################
# Part #11
#
# Determine the average load for the time intervals given.
###############################################################################
echo "What is the current load average for the last 1, 5 and 15 minutes?"
echo "    Load average:`uptime | cut -d: -f5`"
