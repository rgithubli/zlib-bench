# Use instance listed here: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/processor_state_control.html
# I used m4.10xlarge. Otherwise turbo can't be configured.
# graviton 
# Checks:
cat /sys/devices/system/cpu/intel_pstate/no_turbo 
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq

# If it's only 0, don't use the host - it only provides a single CPU for isolation. we need > 1
cat /sys/fs/cgroup/cpuset/cpuset.cpus 
for file in /sys/devices/system/cpu/cpu[0-9]*/online
do
  echo $file
  cat $file
done

echo "Done with check"

sudo yum -y install git

mkdir -p ~/zlib
pushd ~/zlib


# Install pyenv. Probably it's not required. Ended up not using it 
sudo yum -y update
sudo yum -y install git tmux
sudo yum -y install @development zlib-devel bzip2 bzip2-devel readline-devel sqlite \
sqlite-devel openssl-devel xz xz-devel libffi-devel findutils

rm -rf /home/ruiamzn/.pyenv
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

# add below to ./zsh

cat <<'EOF' >> ~/.zshrc
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
EOF

source ~/.zshrc

pyenv -h

# Know what sys.path is: /usr/lib/python2.7/site-packages/cpuset/main.py. Add import sys; print(sys.path)
pyenv install 3.8

pyenv global 3.8

sudo yum -y install python-pip 

sudo pip install --target=/usr/lib64/python2.7/site-packages future

# install cset:
cdwp

wget https://github.com/lpechacek/cpuset/archive/refs/tags/v1.6.tar.gz
tar xzvf v1.6.tar.gz

# install dependencies
sudo yum install -y asciidoc asciidoc xmlto
sudo pip install --target=/usr/lib64/python2.7/site-packages configparser
sudo pip install --target=/usr/lib/python2.7/site-packages configparser
sudo pip install --target=/usr/lib/python3.8/site-packages future

# install
cd cpuset-1.6

sudo python setup.py install

# Should print out help menu
cset -h

# If still see complaints like 
# Traceback (most recent call last):
#   File "/bin/cset", line 44, in <module>
#     from cpuset.main import main
#   File "/usr/lib/python3.8/site-packages/cpuset/main.py", line 7, in <module>
#     from future import standard_library
# ModuleNotFoundError: No module named 'future'

# Install future with target:
# sudo pip install --target=/usr/lib/python3.8/site-packages future
