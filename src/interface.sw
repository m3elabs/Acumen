library interface;

use std::{
    address::Address,
    auth::msg_sender,
    block::timestamp,
    call_frames::msg_asset_id,
    constants::ZERO_B256,
    context::msg_amount,
    contract_id::ContractId,
    identity::Identity,
    logging::log,
    result::Result,
    revert::require,
    storage::{
        StorageMap,
        StorageVec,
    },
    token::*,
    u128::U128
};

pub struct StakingTransaction {
    balance: u64,
    time: u64,
    user: Identity,
    entries: u64,
    poolUser: bool,
    withdrawTime: u64,
    rewardsPaid: u64,
}

pub struct BorrowingTransaction {
    balance: u64,
    time: u64,
    user: Identity,
    poolUser: bool,
}

pub struct Transaction {
    staking: StakingTransaction,
    borrowing: BorrowingTransaction,
}

pub struct DepositLimiters {
    duration: u128,
    startTime: u128, // >>Deposits<< Start Time
    endTime: u128, // >>Deposits<< End Time
    limitPerUser: u64,
    capacity: u64,
    maxUtilization: u64,
}

pub struct Funds {
    balance: u64,
    loanedBalance: u64,
}

pub struct PoolInfo {
    poolName: str[15],
    poolTypeIsStaking: bool,
    apy: u64,
    paused: bool,
    quarterlyPayout: bool,
    uniqueUsers: u64,
    tokenInfo: ContractId,
    funds: Funds,
    pool_id: u64,
    depositLimiters: DepositLimiters,
}

pub struct Whitelist {
    user: Identity,
    status: bool,
    pool_id: u64,
}

abi AcumenCore {
// All Read Functions ------------->
    #[storage(read)]
    fn get_total_pools() -> u64;
    #[storage(read)]
    fn get_pool_info_from_id(pool_id: u64) -> PoolInfo;
    #[storage(read)]
    fn get_user_stakes_info_per_pool(poolId: u64) -> Transaction;
    #[storage(read)]
    fn get_total_stakes_of_user(poolId: u64) -> u64;
    fn get_contract_id() -> ContractId;

// All Action Functions ------------->
    // #[storage(write)]
    // fn set_owner(identity: Identity);
    // #[storage(read, write)]
    // fn recover_all_tokens(token: ContractId, amount: u64);
    #[storage(read, write)]
    fn set_pool_paused(poolId: u64, flag: bool);

    #[storage(read, write)]
    fn deposit(poolId: u64, amount: u64);

    #[storage(read, write)]
    fn withdraw(poolId: u64, amount: u64);

    #[storage(read, write)]
    fn borrow(poolId: u64, amount: u64);

    #[storage(read, write)]
    fn repay(poolId: u64, amount: u64);

    #[storage(read, write)]
    fn claim_quarterly_payout(poolId: u64);

    #[storage(write)]
    fn whitelist(poolId: u64, status: bool);

    #[storage(read, write)]
    fn create_pool(pool_is_staking: bool, pool_name: str[15], apy: u64, qrt_payout: bool, duration: u128, start_time: u128, end_time: u128, max_utilization: u64, capacity: u64, limit_per_user: u64) -> u64;

    #[storage(read, write)]
    fn edit_pool(pool_id: u64, pool_name: str[15], pause: bool, apy: u32, max_utilization: u64, capacity: u64);
}
