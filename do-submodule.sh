#!/bin/sh
THIS_DIR="$(dirname "$(readlink -f "${0}")")"
if [ -d "${THIS_DIR}/${1}" ]; then
    cd "${THIS_DIR}/${1}"
    case "${1}" in
    beast | json)
        if ! [ -f CMakeLists.txt ]; then
            git submodule init
            git submodule update
        fi
        ;;
    xdotool)
        if ! [ -f Makefile ]; then
            git submodule init
            git submodule update
        fi
        CC=${THIS_DIR}/buildroot/output/host/usr/bin/arm-buildroot-linux-musleabi-gcc
        CXX=${THIS_DIR}/buildroot/output/host/usr/bin/arm-buildroot-linux-musleabi-g++
        AR=${THIS_DIR}/buildroot/output/host/usr/bin/arm-buildroot-linux-musleabi-ar
        export CC CXX AR
        make libxdo.a
        ;;
    buildroot)
        if ! [ -f Makefile ]; then
            git submodule init
            git submodule update
        fi
        cp -f ../buildroot-nx500.config .config
        make oldconfig
        make
        ;;
    libraw)
        if ! [ -f configure.ac ]; then
            git submodule init
            git submodule update
        fi
        BINPATH=${THIS_DIR}/buildroot/output/host/usr/bin/
        if ! [ -f configure ]; then
            autoreconf --install
            autoconf
        fi
        ./configure --disable-openmp --disable-jpeg --disable-jasper --disable-lcms --disable-examples --enable-static --disable-shared --host=arm-buildroot-linux-musleabi CC=${BINPATH}arm-buildroot-linux-musleabi-gcc CXX=${BINPATH}arm-buildroot-linux-musleabi-g++ AR=${BINPATH}arm-buildroot-linux-musleabi-ar
        make
        ;;
    *)
        echo "Unknown submodule"
        ;;
    esac
fi
