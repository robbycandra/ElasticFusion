#!/bin/bash

mkdir deps &> /dev/null
cd deps

#Add necessary extra repos
version=$(lsb_release -a 2>&1)
if [[ $version == *"14.04"* ]] ; then
    wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_7.5-18_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu1404_7.5-18_amd64.deb
    rm cuda-repo-ubuntu1404_7.5-18_amd64.deb
    sudo apt-get update
elif [[ $version == *"15.04"* ]] ; then
    wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1504/x86_64/cuda-repo-ubuntu1504_7.5-18_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu1504_7.5-18_amd64.deb
    rm cuda-repo-ubuntu1504_7.5-18_amd64.deb
    sudo apt-get update
elif [[ $version == *"16.04"* ]] ; then
    wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
    rm cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
    sudo apt-get update
else
    echo "Don't use this on anything except 14.04 or 15.04 or 16.04"
    exit
fi

sudo apt-get install -y g++ python doxygen graphviz 

sudo apt-get install -y cmake-qt-gui git build-essential libusb-1.0-0-dev libudev-dev default-jdk freeglut3-dev libglew-dev cuda libsuitesparse-dev libeigen3-dev zlib1g-dev libjpeg-dev

#Installing Pangolin
git clone https://github.com/stevenlovegrove/Pangolin.git
cd Pangolin
mkdir build
cd build
cmake ../ -DAVFORMAT_INCLUDE_DIR="" -DCPP11_NO_BOOST=ON
make -j8
cd ../..

#Up to date OpenNI2
git clone https://github.com/occipital/OpenNI2.git
cd OpenNI2
make -j8
cd ..

## move to /opt/openni2 then

#sudo ./install.sh
#cd Packaging
#./ReleaseVersion.py x64
#cd ../..
#echo "source /opt/openni2/OpenNIDevEnvironment" >> ~/.bashrc
#sudo ln -s /lib/x86_64-linux-gnu/libudev.so.1.6.4 /lib/x86_64-linux-gnu/libudev.so.0
#sudo usermod -a -G video $USER

#Actually build ElasticFusion
cd ../Core
mkdir build
cd build
cmake ../src
#cmake -G "Eclipse CDT4 - Unix Makefiles" ../src
make -j8

cd ../../GPUTest
mkdir build
cd build
cmake ../src
#cmake -G "Eclipse CDT4 - Unix Makefiles" ../src
make -j8

cd ../../GUI
mkdir build
cd build
cmake ../src
#cmake -G "Eclipse CDT4 - Unix Makefiles" ../src
make -j8
