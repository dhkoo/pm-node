#/bin/sh

#yum -y install gcc gcc-gfortran gcc-c++ automake
#wget http://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz
#tar xzf mpich-3.1.4.tar.gz
#mkdir -p benchmark/{mpich3,ior}
#cd mpich-3.1.4
#./configure --prefix=/home/kau/dhkoo/benchmark/mpich3
#make -j16
#sudo make install

#cd ~/dhkoo
#git clone https://github.com/chaos/ior.git
#mv ior ior_src
cd ior_src/
./bootstrap
./configure --prefix=/home/kau/dhkoo/benchmark/ior
make -j16
sudo make install

echo "Done mpi&ior installation"
echo "set PATH and LIBRARY at bash_profile"
