#!/usr/bin/env bash

if [ -z $RUST_TOOLCHAIN ]
then
    RUST_TOOLCHAIN=""
fi

set -e
set -u
set -o pipefail

rust_sysroot=$(rustc $RUST_TOOLCHAIN --print sysroot)

export RUST_COMPILER_RT_ROOT="$(pwd)/src/llvm-project/compiler-rt"
export CARGO_PROFILE_RELEASE_DEBUG=0
export CARGO_PROFILE_RELEASE_OPT_LEVEL="3"
export CARGO_PROFILE_RELEASE_DEBUG_ASSERTIONS="true"
export RUSTC_BOOTSTRAP=1
export RUSTFLAGS="-Cforce-unwind-tables=yes -Cembed-bitcode=yes"
export __CARGO_DEFAULT_LIB_METADATA="stablestd"

command_exists() {
    which $1 &> /dev/null && $1 --version 2>&1 > /dev/null
}

if [ ! -z $CC ]
then
    echo "Using compiler $CC"
elif command_exists riscv32-unknown-elf-gcc
then
    export CC="riscv32-unknown-elf-gcc"
    export AR="riscv32-unknown-elf-ar"
elif command_exists riscv-none-embed-gcc
then
    export CC ="riscv-none-embed-gcc"
    export AR ="riscv-none-embed-ar"
elif command_exists riscv64-unknown-elf-gcc
then
    export CC="riscv64-unknown-elf-gcc"
    export AR="riscv64-unknown-elf-ar"
else
    echo "No C compiler found for riscv" 1>&2
    exit 1
fi

src_path="./library/target/riscv32imac-unknown-linux-gnu/release/deps"
dest_path="$rust_sysroot/lib/rustlib/riscv32imac-unknown-linux-gnu"
dest_lib_path="$dest_path/lib"

mkdir -p $dest_lib_path

rustc $RUST_TOOLCHAIN --version | awk '{print $2}' > "$dest_path/RUST_VERSION"

rm -f $dest_lib_path/*.rlib

cargo $RUST_TOOLCHAIN build \
    --target riscv32imac-unknown-linux-gnu \
    -Zbinary-dep-depinfo \
    --release \
    --features "panic-unwind compiler-builtins-c compiler-builtins-mem" \
    --manifest-path "library/sysroot/Cargo.toml" || exit 1

for new_item in $(ls -1 $src_path/*.rlib)
do
    file=$(basename $new_item)
    base_string=$(echo $file | rev | cut -d- -f2- | rev)
done

cp $src_path/*.rlib "$dest_lib_path"