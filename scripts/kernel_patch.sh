#!/bin/sh

sudo yum -y update
sudo yum -y install rpm-build redhat-rpm-config asciidoc bison hmaccalc patchutils perl-ExtUtils-Embed xmlto audit-libs-devel binutils-devel elfutils-devel elfutils-libelf-devel newt-devel python-devel zlib-devel ncurses-devel gcc hmaccalc zlib-devel binutils-devel elfutils-libelf-devel
sudo yum -y groupinstall "Development Tools"

wget http://ftp.redhat.com/pub/redhat/linux/enterprise/6Workstation/en/os/SRPMS/kernel-2.6.32-573.18.1.el6.src.rpm
mkdir -p ~/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros
rpm -i ./kernel-2.6.32-573.18.1.el6.src.rpm 2>&1 | grep -v exist
sudo rngd -r /dev/urandom
cd ~/rpmbuild/BUILD/kernel*/linux*/
cat ~/multi_stream/kernl_patch/0001-multi-stream-support-for-SAS-and-NVMe.patch | patch -p1
make -j32
sudo make modules_install install

sleep 2
echo "install the packages for infiniband"
yum -y groupinstall "Infiniband Support"
yum -y install infiniband-diags perftest qperf opensm
chkconfig rdma on
chkconfig opensm on

echo "need to reboot for adjusting update"
