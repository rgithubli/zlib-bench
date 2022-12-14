#!/usr/bin/bash
set -xe

# switch off turbo boost
# Ubuntu:
# modprobe msr
# wrmsr --all 0x1a0 0x4000850089
# RHEL

# Can't execute via script directly. Need to execute via hand. TODO: fix
chmod a+w /sys/devices/system/cpu/intel_pstate/no_turbo
echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
# switch it back: sudo sh -c "echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo"

# backup CPU frequencies
timestamp=$(date +%s)
cpu_freq_bak=backup_cpu_freq_${timestamp}
touch $cpu_freq_bak
echo "Backup original cpu frequencies to ${cpu_freq_bak}"

# todo: make it dynamic - choosing digits
echo /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq >> $cpu_freq_bak
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq >> $cpu_freq_bak
echo /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq >> $cpu_freq_bak
cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq >> $cpu_freq_bak
echo /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq >> $cpu_freq_bak
cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq >> $cpu_freq_bak
echo /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq >> $cpu_freq_bak
cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq >> $cpu_freq_bak
echo /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq >> $cpu_freq_bak
cat /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq >> $cpu_freq_bak
echo /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq >> $cpu_freq_bak
cat /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq >> $cpu_freq_bak
echo /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq >> $cpu_freq_bak
cat /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq >> $cpu_freq_bak
echo /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq >> $cpu_freq_bak
cat /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq >> $cpu_freq_bak
echo /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq >> $cpu_freq_bak
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq >> $cpu_freq_bak
echo /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq >> $cpu_freq_bak
cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq >> $cpu_freq_bak
echo /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq >> $cpu_freq_bak
cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq >> $cpu_freq_bak
echo /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq >> $cpu_freq_bak
cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq >> $cpu_freq_bak
echo /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq >> $cpu_freq_bak
cat /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq >> $cpu_freq_bak
echo /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq >> $cpu_freq_bak
cat /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq >> $cpu_freq_bak
echo /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq >> $cpu_freq_bak
cat /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq >> $cpu_freq_bak
echo /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq >> $cpu_freq_bak
cat /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq >> $cpu_freq_bak

# set fixed CPU frequency
echo "original cpu frequencies:"
echo 1900000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 1900000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
echo 1900000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
echo 1900000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
echo 1900000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
echo 1900000 > /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq
echo 1900000 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq
echo 1900000 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq
echo 1900000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo 1900000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
echo 1900000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
echo 1900000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
echo 1900000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
echo 1900000 > /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq
echo 1900000 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq
echo 1900000 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq

cpu_htt=cpu_htt_${timestamp}
touch $cpu_htt

# Downside: only works for core <= 10
for file in /sys/devices/system/cpu/cpu[0-9]/online
do
  echo $file >> $cpu_htt
  cat $file >> $cpu_htt
done

# Backup htt
# Remove this line once move the line into start.sh
# timestamp=$(date +%s)

cpu_htt=cpu_htt_${timestamp}
touch $cpu_htt

# Downside: only works for core <= 10
for file in /sys/devices/system/cpu/cpu[0-9]/online
do
  echo $file >> $cpu_htt
  cat $file >> $cpu_htt
done


# switch off hyperthreading
for file in /sys/devices/system/cpu/cpu[0-9]/online
do
  echo 0 > $file
done

# Original
# echo 0 > /sys/devices/system/cpu/cpu4/online
# echo 0 > /sys/devices/system/cpu/cpu5/online
# echo 0 > /sys/devices/system/cpu/cpu6/online
# echo 0 > /sys/devices/system/cpu/cpu7/online

# switch off DPMS
# Can comment this out - I don't have display on my cloud
# Or, use ` || true` to avoid accident exit
# xset -dpms || true

# provide some advice on how to use cset
# TODO: Ubuntu is different from RHEL. Skipped cset for now. Need to comeback.
echo "Now create a dedicated CPU set for your benchmarks:"
echo
echo "cset shield --kthread on --cpu 3"
echo "  Run: echo > /sys/fs/cgroup/cpuset/docker/cpuset.cpus"
echo "  If you get an error like 'failed to create shield, hint: do other cpusets exist?'"
echo "cset set --list"
echo "cset shield --user=ruiamzn --group=domain^users --exec bash -- -c \"./benchmarks/bash/run-java-deflate.sh -o /tmp/cloud-x86-20221213 -j /workplace/ruiamzn/OpenJDKSrc/build/OpenJDKSrc/OpenJDKSrc-1.0/AL2_x86_64/DEV.STD.PTHREAD/build/private/gradle/editable-source/jdk/bin/java -n ristretto19 ./data/silesia/*[^b] ./data/silesia/osdb\""
