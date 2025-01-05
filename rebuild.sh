#!/usr/bin/env bash

if [ -z $RUST_TOOLCHAIN ]
then
    RUST_TOOLCHAIN=""
fi

set -e
set -u
set -o pipefail

export CC_riscv32imac_unknown_linux_gnu=riscv32-unknown-linux-gnu-gcc
export AR_riscv32imac_unknown_linux_gnu=riscv32-unknown-linux-gnu-ar
export CFLAGS_riscv32imac_unknown_linux_gnu="-mabi=ilp32 -fPIC"
export CC=riscv32-unknown-linux-gnu-gcc
export AR=riscv32-unknown-linux-gnu-ar
export LINKER=riscv32-unknown-linux-gnu-gcc

DESTDIR=./dist ./x install -i --stage 1 --target riscv32imac-unknown-linux-gnu compiler/rustc library/std
