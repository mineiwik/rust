# riscv32imac-unknown-linux-gnu

**Tier: 3**



## Target maintainers


## Requirements


## Building the target

The target can be built by enabling it for a `rustc` build.

```toml
[build]
target = ["riscv32imac-unknown-linux-gnu"]
```

Make sure your C compiler is included in `$PATH`, then add it to the `config.toml`:

```toml
[target.riscv32imac-unknown-linux-gnu]
cc = "riscv-none-elf-gcc"
ar = "riscv-none-elf-ar"
```

## Building Rust programs

Rust does not yet ship pre-compiled artifacts for this target. To compile for
this target, you will need to do one of the following:

* Build Rust with the target enabled (see "Building the target" above)
* Build your own copy of `core` by using `build-std` or similar

## Cross-compilation

This target can be cross-compiled from any host.

## Testing

Currently there is no support to run the rustc test suite for this target.
