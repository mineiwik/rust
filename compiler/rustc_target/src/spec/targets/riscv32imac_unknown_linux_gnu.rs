use std::borrow::Cow;

use crate::spec::{CodeModel, SplitDebuginfo, Target, TargetOptions, base};

pub(crate) fn target() -> Target {
    Target {
        data_layout: "e-m:e-p:32:32-i64:64-n32-S128".into(),
        llvm_target: "riscv32-unknown-linux-gnu".into(),
        metadata: crate::spec::TargetMetadata {
            description: Some("RISC-V Linux GNU (RV32IMAC ISA)".into()),
            tier: Some(3),
            host_tools: Some(false),
            std: Some(false),
        },
        pointer_width: 32,
        arch: "riscv32".into(),

        options: TargetOptions {
            code_model: Some(CodeModel::Medium),
            cpu: "generic-rv32".into(),
            max_atomic_width: Some(32),
            features: "+m,+a,+c".into(),
            llvm_abiname: "ilp32".into(),
            supported_split_debuginfo: Cow::Borrowed(&[SplitDebuginfo::Off]),
            ..base::linux_gnu::opts()
        },
    }
}
