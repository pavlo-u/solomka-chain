//! Example Rust-based BPF program that panics

#[cfg(all(feature = "custom-panic", target_os = "solana"))]
#[no_mangle]
fn custom_panic(info: &core::panic::PanicInfo<'_>) {
    // Note: Full panic reporting is included here for testing purposes
    solomka_program::msg!("program custom panic enabled");
    solomka_program::msg!(&format!("{}", info));
}

extern crate solomka_program;
use solomka_program::{account_info::AccountInfo, entrypoint::ProgramResult, pubkey::Pubkey};

solomka_program::entrypoint!(process_instruction);
#[allow(clippy::unnecessary_wraps)]
fn process_instruction(
    _program_id: &Pubkey,
    _accounts: &[AccountInfo],
    _instruction_data: &[u8],
) -> ProgramResult {
    assert_eq!(1, 2);
    Ok(())
}
