#!/bin/bash

set -e

configure_args=(
    --prefix="${PREFIX}"
    --disable-static
    --disable-dependency-tracking
    --disable-selective-werror
    --disable-silent-rules
)

autoreconf_args=(
    --force
    --verbose
    --install
    -I "${PREFIX}/share/aclocal"
    -I "${BUILD_PREFIX}/share/aclocal"
)
autoreconf "${autoreconf_args[@]}"

configure_args+=("--build=${BUILD}")

export PKG_CONFIG_LIBDIR="${PREFIX}/lib/pkgconfig:${PREFIX}/share/pkgconfig"

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" ]] ; then
    configure_args+=(
        --enable-malloc0returnsnull
    )
fi

./configure "${configure_args[@]}"
make -j$CPU_COUNT
make install

rm -rf ${PREFIX}/share/man ${PREFIX}/share/doc/${PKG_NAME}
