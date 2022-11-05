library interface;

use std::{
    call_frames::{
        contract_id,
        msg_asset_id,
    },
    context::msg_amount,
    contract_id::ContractId,
    identity::Identity,
    token::*,
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
    duration: u64,
    startTime: u64, // >>Deposits<< Start Time
    endTime: u64, // >>Deposits<< End Time
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
    pool_id: u8,
    depositLimiters: DepositLimiters,
}

pub struct Whitelist {
    user: Identity,
    status: bool,
    pool_id: u8,
}

abi AcumenCore {
// All Read Functions ------------->
    #[storage(read)]
    fn get_total_pools() -> u64;
    #[storage(read)]
    fn get_pool_info_from_id(pool_id: u8) -> PoolInfo;
    #[storage(read)]
    fn get_user_stakes_info_per_pool(poolId: u8) -> Transaction;
    #[storage(read)]
    fn get_total_stakes_of_user(poolId: u8) -> u64;



// All Action Functions ------------->
    // #[storage(write)]
    // fn set_owner(identity: Identity);
    // #[storage(read, write)]
    // fn recover_all_tokens(token: ContractId, amount: u64);
    #[storage(read, write)]
    fn set_pool_paused(poolId: u8, flag: bool);

    #[storage(read, write)]
    fn deposit(poolId: u8, amount: u64);

    #[storage(read, write)]
    fn withdraw(poolId: u8, amount: u64);

    #[storage(read, write)]
    fn borrow(poolId: u8, amount: u64);

    #[storage(read, write)]
    fn repay(poolId: u8, amount: u64);

    #[storage(read, write)]
    fn claim_quarterly_payout(poolId: u8);

    #[storage(write)]
    fn whitelist(poolId: u8, status: bool);

    #[storage(read, write)]
    fn create_pool(pool_is_staking: bool, pool_name: str[15], apy: u64, qrt_payout: bool, duration: u64, start_time: u64, end_time: u64, max_utilization: u64, capacity: u64, limit_per_user: u64) -> u8;

    #[storage(read, write)]
    fn edit_pool(pool_id: u8, pool_name: str[15], pause: bool, apy: u32, max_utilization: u64, capacity: u64);
}
