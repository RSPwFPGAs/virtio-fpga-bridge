rm -rf qemu-2.10.0-rc3


tar -xJf qemu-2.10.0-rc3.tar.xz


patch -s -p0 < qemu-cosim.patch
patch -s -p0 < qemu-memfd.patch
patch -s -p0 < qemu-iotrace.patch


cd qemu-2.10.0-rc3
mkdir build
cd build
../configure --target-list=x86_64-softmmu --disable-vnc --enable-sdl --enable-curses

sed -i 's/LIBS+=/LIBS+=-lzmq -lczmq /g' config-host.mak

make -j32


cp ../../../scripts/launch_fpga.sh .
cd ../../

