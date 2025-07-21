#!/bin/bash -x
basedir="$HOME/libapps/ssh_client"
out="$basedir/output"
sysroot="$out/wasi-sdk/share/wasi-sysroot"
libdir="$sysroot/lib"
exec \
./configure \
	--disable-server \
	--host=wasm32-wasi \
	--disable-hardening \
	--prefix=/ \
	PKG_CONFIG_SYSROOT_DIR="$sysroot" \
	PKG_CONFIG_LIBDIR="$libdir/pkgconfig" \
	PROTOC="$out/bin/protoc" \
	CC="ccache $out/wasi-sdk/bin/clang --sysroot=$sysroot -target wasm32-wasip1-threads" \
	CXX="ccache $out/wasi-sdk/bin/clang++ --sysroot=$sysroot -target wasm32-wasip1-threads" \
	CXXFLAGS="-O2 -g -pipe -flto" \
	CPPFLAGS="-isystem $basedir/wassh-libc-sup/include -D_WASI_EMULATED_GETPID -D_WASI_EMULATED_PROCESS_CLOCKS -D_WASI_EMULATED_SIGNAL" \
	LDFLAGS="-L$libdir -lwassh-libc-sup -lwasi-emulated-getpid -lwasi-emulated-process-clocks -lwasi-emulated-signal -Wl,--export=__wassh_signal_deliver"
