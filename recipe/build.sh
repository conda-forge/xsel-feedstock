#!/bin/bash
set -e -x

autoreconf_args=(
    --force
    --verbose
    --install
    -I "${PREFIX}/share/aclocal"
    -I "${BUILD_PREFIX}/share/aclocal"
)
autoreconf "${autoreconf_args[@]}"

export PKG_CONFIG_LIBDIR="${PREFIX}/lib/pkgconfig:${PREFIX}/share/pkgconfig"
configure_args=(
    --prefix="${PREFIX}"
    --disable-static
    --disable-debug
    --disable-dependency-tracking
    --disable-selective-werror
    --disable-silent-rules
)

./configure "${configure_args[@]}"
make -j$CPU_COUNT
make install
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
make check
fi
rm -rf ${PREFIX}/share/man ${PREFIX}/share/doc/${PKG_NAME}

# Remove any new Libtool files we may have installed. It is intended that
# conda-build will eventually do this automatically.
find ${PREFIX}/. -name '*.la' -delete
