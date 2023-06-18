#!/bin/bash

# boost
expect <(cat << EOF
spawn yum install boost-devel
expect {
        "Is this ok [y/d/N]:*"  { send "y\r" }
}
interact
EOF
)
# libnanomsg
tar -zxvf nanomsg-1.1.5.tar.gz
cd nanomsg-1.1.5
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local
cmake --build .
ctest .
cmake --build . --target install


# gcc
cd ~
tar -zxvf gcc-9.5.0.tar.gz
cd gcc-9.5.0
expect <(cat << EOF
spawn yum install  gmp  gmp-devel  mpfr  mpfr-devel  libmpc  libmpc-devel
expect {
        "Is this ok*"  { send "y\r" }
}
interact
EOF
)
mkdir build
cd build
../configure --enable-languages=c,c++ -disable-multilib &&\
make -j96 &&\
make -j install &&\
yum -y remove gcc g++ &&\
ln -s /usr/local/bin/gcc /usr/bin/gcc &&\
rm -f /usr/lib64/libstdc++.so.6 &&\
ln -s /usr/local/lib64/libstdc++.so.6.0.28 /usr/lib64/libstdc++.so.6 &&\

# bash_profile
cd ~
echo LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64 >> .bash_profile
echo export LD_LIBRARY_PATH >> .bash_profile
ldconfig