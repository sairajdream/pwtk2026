#!/bin/bash

#---------------------------------------------------------------------------------------------
# script written by Sai Raj Ali
#---------------------------------------------------------------------------------------------
# Step-0:  Manual Work
#---------------------------------------------------------------------------------------------
# To make this script useful for future updates I am going to create two variables 
# In the 1st variable "QElink" I will paste the download link of latest QE.
# In the 2nd variable "VER" will enter the version name.  
# There is one more varible for the installation path "IDIR" you can choose your installation directory as per your choice
#---------------------------------------------------------------------------------------------


QElink="https://www.quantum-espresso.org/rdm-download/488/v7-5/bd889894027de8275c5115a1f904b164/qe-7.5-ReleasePack.tar.gz"
VER="qe7.5"      
IDIR="$HOME/espresso"      # Path of the installation directory


# Note: If you are planning to run above steps manually one by one then dont forget to add export in above variables for example

# export QElink="https://www.quantum-espresso.org/rdm-download/488/v7-5/bd889894027de8275c5115a1f904b164/qe-7.5-ReleasePack.tar.gz"
# export VER="qe7.5"      
# export IDIR="$HOME/espresso"      # Path of the installation directory


#---------------------------------------------------------------------------------------------
# Step-1: Installation of QE Pre-requisite
#---------------------------------------------------------------------------------------------
#1: Prerequsite for Quantum Espresso
sudo apt-get update
sudo apt-get install -y gcc gfortran
sudo apt-get install -y build-essential 
sudo apt-get install -y libfftw3-dev
sudo apt-get install -y libblas3 
sudo apt-get install -y libblas-dev
sudo apt-get install -y liblapack-dev
sudo apt-get install -y libopenmpi-dev

#2 Installation of stable openmpi from apt package
sudo apt-get install -y openmpi-bin


#3 Installation of Latest-ver
mkdir $IDIR
wget -O $IDIR/QE.tar.gz $QElink
tar -xvzf $IDIR/QE.tar.gz -C $IDIR/ 
mv $IDIR/qe* $IDIR/$VER
cd $IDIR/$VER
./configure --enable-parallel=yes 
make -j 4 all      # I have only 4 cores. you can change accordingly

# in case of intel compiler
# source /opt/intel/inteloneapi/setvars.sh
# source ./compilervars.sh intel64
#./configure --enable-openmp --enable-parallel --with-scalapack=intelmpi
#make -j 24 all


# Insert QE path to .bashrc file
echo "export PATH=\$PATH:$IDIR/$VER/bin" >> ~/.bashrc

exec $BASH
