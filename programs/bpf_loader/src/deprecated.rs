solomka_sdk::declare_builtin!(
    solomka_sdk::bpf_loader_deprecated::ID,
    solana_bpf_loader_deprecated_program,
    solana_bpf_loader_program::process_instruction,
    deprecated::id
);
