library events;

use std::contract_id::ContractId;
use std::address::Address;
use std::identity::Identity;

pub struct DepositEvent {
    address: Identity,
    poolId: u8,
    amount: u64,
}

pub struct WithdrawEvent {
    address: Identity,
    poolId: u8,
    amount: u64,
}

pub struct EmergencyWithdrawEvent {
    address: Identity,
    poolId: u8,
    amount: u64,
}

pub struct RewardHarvested {
    address: Identity,
    poolId: u8,
    amount: u64,
}

pub struct WhitelistedEvent {
    address: Identity,
    poolId: u8,
    status: bool,
}

pub struct BorrowedEvent {
    address: Identity,
    poolId: u8,
    amount: u64,
}

pub struct TransferredEvent {
    address: Identity,
    poolId: u8,
    amount: u64,
}

pub struct RepaidEvent {
    address: Identity,
    poolId: u8,
    amount: u64,
}

pub struct RecoveredEvent {
    address: ContractId,
    amount: u64,
}

pub struct RecievedEvent {
    address: Identity,
    amount: u64,
}
