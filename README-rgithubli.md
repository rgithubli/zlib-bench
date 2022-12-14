This is a fork of Volker's zlib benchmark repo: https://github.com/simonis/zlib-bench


He did the benchmark on Ubuntu. I'm trying to make it work on AL2.



Some notes:

```
chmod a+w /sys/devices/system/cpu/intel_pstate/no_turbo


# install cset:

cd /workplace/ruiamzn/temp/toRemove/cset/cpuset-1.6

# install dependencies
sudo yum install -y asciidoc asciidoc xmlto

# Get cset
wget https://github.com/lpechacek/cpuset/archive/refs/tags/v1.6.tar.gz
tar xzvf v1.6.tar.gz 
cd cpuset-1.6 

sudo python setup.py install

```

Output json are in tmp folder. It's decided by -o
