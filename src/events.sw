library events;

use std::contract_id::ContractId;
use std::address::Address;
use std::identity::Identity;

pub struct DepositEvent {
address: Address,
poolId: u8,
amount: u64
}

pub struct WithdrawEvent {
address: Address,
poolId: u8,
amount: u64
}

pub struct EmergencyWithdrawEvent {
address: Address,
poolId: u8,
amount: u64
}

pub struct RewardHarvested {
address: Address,
poolId: u8,
amount: u64
}

pub struct WhitelistedEvent {
address: Address,
poolId: u8,
status: bool,
}

pub struct BorrowedEvent {
address: Address,
poolId: u8,
amount: u64
}

pub struct RepaidEvent {
address: Address,
poolId: u8,
amount: u64
}


pub struct RecoveredEvent {
address: ContractId,
amount: u64
}

pub struct RecievedEvent {
address: Address,
amount: u64
}