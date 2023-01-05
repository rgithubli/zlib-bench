cdwp
cd zlib
git clone https://github.com/rgithubli/zlib-bench.git
cd zlib-bench

# switch off turbo boost
# Ubuntu:
# modprobe msr
# wrmsr --all 0x1a0 0x4000850089
# RHEL

# Can't execute via script directly. Need to execute via hand. TODO: fix
sudo chmod a+w /sys/devices/system/cpu/intel_pstate/no_turbo
sudo echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
cat /sys/devices/system/cpu/intel_pstate/no_turbo
# switch it back: sudo sh -c "echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo"

# backup CPU frequencies
timestamp=$(date +%s)
cpu_freq_bak=backup_cpu_freq_${timestamp}
touch $cpu_freq_bak
echo "Backup original cpu frequencies to ${cpu_freq_bak}"


##############################################
# set fixed CPU min frequency
##############################################
echo "original cpu frequencies:"
for file in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_min_freq
do
  echo $file >> $cpu_freq_bak
  cat $file >> $cpu_freq_bak
done

cat $cpu_freq_bak

echo "Set cpu frequencies..."
for file in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_min_freq
do
  sudo chmod a+w $file
done

for file in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_min_freq
do
  sudo echo 1900000 > $file
done

# check:
grep . /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_min_freq

##############################################
# set fixed CPU max frequency
##############################################
for file in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_max_freq
do
  echo $file >> $cpu_freq_bak
  cat $file >> $cpu_freq_bak
done

for file in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_max_freq
do
  sudo chmod a+w $file
done

for file in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_max_freq
do
  sudo echo 1900000 > $file
done

# check

grep . /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_max_freq


##############################################
# disable cpu hyperthread
##############################################
cpu_htt=backup_cpu_htt_${timestamp}
touch $cpu_htt

for file in /sys/devices/system/cpu/cpu[0-9]*/online
do
  echo $file >> $cpu_htt
  cat $file >> $cpu_htt
done

# switch off hyperthreading
for file in /sys/devices/system/cpu/cpu[0-9]*/online
do
  sudo chmod a+w $file
  sudo echo 0 > $file
done

for file in /sys/devices/system/cpu/cpu[0-9]*/online
do
  cat $file
done


# Leave 3 htt
# Left 1,2,9 for my arm as cpu9 for some reason saying "device busy" when echoing 0 into the file
for file in /sys/devices/system/cpu/cpu[0-3]/online
do
  sudo chmod a+w $file
  sudo echo 1 > $file
done

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
echo "cset shield --user=simonisv --group=domain^users --exec bash -- -c \"./benchmarks/bash/run-java-deflate.sh -o /tmp/i7-8650U-1900MHz-deflate-my-corretto11-2020-07-06 -j corretto-11-opt/images/jdk/bin/java -n corretto11 ./data/silesia/*[^b] ./data/silesia/osdb\""

sudo cset shield --kthread on --cpu 3

sudo cset set -s user -c 0-3
sudo cset shield --sysset=root --userset=user -k on -c 2-3

cset set --list


######### 

# define below:
export DATE="2023-01-03"
export ID="01"

export WK_DIR=/workplace/ruiamzn/zlib/zlib-bench
export CPU="Xeon E5-2686 v4 / 1900MHz"
export DIR_PREFIX="Xeon-E52686-v4-1900MHz-silesia-${DATE}-${ID}"
export JAVA_BIN_PATH=/workplace/ruiamzn/OpenJDKSrc/build/OpenJDKSrc/OpenJDKSrc-1.0/AL2_x86_64/DEV.STD.PTHREAD/build/private/gradle/editable-source/images/jdk/bin/java
# original java: /workplace/ruiamzn/origin-ristretto-tip/src/OpenJDKSrc/build/jdk-19/bin
# with latest code: /workplace/ruiamzn/OpenJDKSrc/build/OpenJDKSrc/OpenJDKSrc-1.0/AL2_x86_64/DEV.STD.PTHREAD/build/private/gradle/editable-source/images/jdk/bin/java

export DEFLATE_DIR=Xeon-E52686-v4-1900MHz-silesia-${DATE}-${ID}-new-code-deflate

# Update
# ristretto19-2022-12-14-01: original
# ristretto19-2022-12-14-02: have latest code
# ristretto19-2022-12-14-01-deflate
# export ORIGINAL_OUTPUT_DIR=ristretto19-2022-12-14-latest-code-02
export ORIGINAL_OUTPUT_DIR=ristretto19-${DATE}-${ID}-deflate
export DEFLATE_DIR=${DIR_PREFIX}-deflate
export RESULT_TMP_DIR=/tmp/$ORIGINAL_OUTPUT_DIR

# deflate
cd $WK_DIR

nohup sudo cset shield --user=ruiamzn --group=amazon --exec bash -- -c "./benchmarks/bash/run-java-deflate.sh -o /tmp/$ORIGINAL_OUTPUT_DIR-deflate -j ${JAVA_BIN_PATH} -n ristretto19 ./data/silesia/*[^b] ./data/silesia/osdb" &

# Check. Expect user has >0 tasks. 
cset set --list 

# install npm, then install vega
# https://stackoverflow.com/a/44509677/7061266 to install.
# https://stackoverflow.com/questions/34718528/nvm-is-not-compatible-with-the-npm-config-prefix-option to unset prefix


# verify:
vl2vg --version
# If not installed:
# npm i vega-cli

# For getting results:
# results are in :

# zlib-bench setup:
 
pushd ${WK_DIR}/results
mkdir -p $DEFLATE_DIR
popd

pushd ${WK_DIR}/graphs
mkdir -p $DEFLATE_DIR
popd

# after finishing the run
cp -r ${RESULT_TMP_DIR}/* ${WK_DIR}/results/${DEFLATE_DIR}

# cp -r ${RESULT_TMP_DIR}-deflate/* ${WK_DIR}/results/${DEFLATE_DIR}

# check if new result folder is created
ll ${WK_DIR}/results/${DEFLATE_DIR}

# generate graphs for deflate
cd ${WK_DIR}
# verify current status. commit before changing
gits

bash benchmarks/bash/graph-silesia-openjdk-deflate-horizontal-all.sh
# check
echo ${WK_DIR}/graphs/${DEFLATE_DIR}
ll ${WK_DIR}/graphs/${DEFLATE_DIR}

cd ${WK_DIR}/graphs
python2 -m SimpleHTTPServer 9000


################# Clean up
pushd ${WK_DIR}/results
rm -rf $DEFLATE_DIR
popd


################# Inflate

# define below
export DATE="2023-01-05"
export ID="01"
export NEW_OR_OLD="new-code"
export X64_CPU="Xeon-E52686-v4-1900MHz"
export ARM_CPU="Neoverse-N1"
export X64_JAVA_PATH="/workplace/ruiamzn/OpenJDKSrc/src/OpenJDKSrc/build/private/gradle/editable-source/jdk/bin/java"
export ARM_JAVA_PATH="/workplace/ruiamzn/OpenJDKSrc/build/OpenJDKSrc/OpenJDKSrc-1.0/AL2_aarch64/DEV.STD.PTHREAD/build/private/gradle/editable-source/jdk/bin/java"

export CPU=${X64_CPU}
export JAVA_BIN_PATH=${X64_JAVA_PATH}

# no change needed for below
export WK_DIR=/workplace/ruiamzn/zlib/zlib-bench
export DIR_PREFIX="${CPU}-silesia-${DATE}-${ID}-${NEW_OR_OLD}"

export ORIGINAL_OUTPUT_DIR=ristretto19-${DATE}-${ID}-${NEW_OR_OLD}-inflate
export RESULT_TMP_DIR=/tmp/$ORIGINAL_OUTPUT_DIR

export INFLATE_ORIGINAL_OUTPUT_DIR=${ORIGINAL_OUTPUT_DIR}
export INFLATE_DIR=${DIR_PREFIX}-inflate
export RESULT_TMP_DIR=/tmp/$ORIGINAL_OUTPUT_DIR
export INFLATE_RESULT_TMP_DIR=/tmp/${ORIGINAL_OUTPUT_DIR}

# echo to verify
echo ${DATE}
echo ${ID}
echo ${NEW_OR_OLD}
echo ${CPU}
echo ${JAVA_BIN_PATH}
echo ${WK_DIR}
echo ${DIR_PREFIX}
echo ${ORIGINAL_OUTPUT_DIR}
echo ${RESULT_TMP_DIR}
echo ${INFLATE_ORIGINAL_OUTPUT_DIR}
echo ${INFLATE_DIR}
echo ${RESULT_TMP_DIR}
echo ${INFLATE_RESULT_TMP_DIR}

# inflate
cd ${WK_DIR}
nohup sudo cset shield --user=ruiamzn --group=amazon --exec bash -- -c "./benchmarks/bash/run-java-inflate.sh -o /tmp/$ORIGINAL_OUTPUT_DIR -j ${JAVA_BIN_PATH} -n ristretto19 ./data/silesia/*[^b] ./data/silesia/osdb" &

# x-ray only:
sudo cset shield --user=ruiamzn --group=amazon --exec bash -- -c "./benchmarks/bash/run-java-inflate-single-impl.sh -o /tmp/$ORIGINAL_OUTPUT_DIR -j ${JAVA_BIN_PATH} -n ristretto19 ./data/silesia/x-ray"

# get jps id
jps 

# pass jsp id
./profiler.sh -d 30 -f /tmp/x64-2.html jps_id

# for arm:
nohup bash ./benchmarks/bash/run-java-inflate.sh -o /tmp/$ORIGINAL_OUTPUT_DIR -j ${JAVA_BIN_PATH} -n ristretto19 ./data/silesia/*[^b] ./data/silesia/osdb &



# Check. Expect user has >0 tasks. 
cset set --list 

# wait until having the results. Can check nohup.out. Inflate usually takes 30 min
pushd ${WK_DIR}/results
mkdir -p ${INFLATE_DIR}
popd

pushd ${WK_DIR}/graphs
mkdir -p ${INFLATE_DIR}
popd

# after finishing the run
cp -r ${RESULT_TMP_DIR}/* ${WK_DIR}/results/${INFLATE_DIR}

# check
ll ${WK_DIR}/results/${INFLATE_DIR}

# generate graphs for inflate
cd ${WK_DIR}
bash benchmarks/bash/graph-silesia-openjdk-inflate-horizontal-all.sh
ll ${WK_DIR}/graphs/${INFLATE_DIR}
cd ${WK_DIR}/graphs/
python2 -m SimpleHTTPServer 9000

# clean up if needed
pushd ${WK_DIR}/results
rm -rf $INFLATE_DIR
popd

pushd ${WK_DIR}/graphs
rm -rf $INFLATE_DIR
popd

pushd ${INFLATE_RESULT_TMP_DIR}
rm -f ./*


