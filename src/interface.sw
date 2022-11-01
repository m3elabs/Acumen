library interface;

use std::{contract_id::ContractId, identity::Identity,
 context::call_frames::{
        contract_id,
        msg_asset_id,
    },
    context::msg_amount,
    token::*
    };

const day: u64 = 86400;
const month: u64 = 2629743;



abi AcumenCore {
// All Read Functions ------------->

#[storage(read)]
fn totalPools() -> u32;
#[storage(read)]
fn getPoolInfo(poolId:u8) -> PoolInfo;
#[storage(read)]
fn calculateInterest(user:Identity, poolId:u8, amount: u64 ) -> u64;
#[storage(read)]
fn calculatePercentage(whole: u64, percent: u64) -> u64;
#[storage(read)]
fn getPoolUtilization(poolId: u8) -> u64;
#[storage(read)]
fn getUserStakes(poolId: u8) -> UserInfo;
#[storage(read)]
fn getTotalStakesOfUser(poolId: u8) -> u32;

// All Action Functions ------------->

#[storage(read, write)]
fn recoverAllTokens(token: ContractId, amount: u64);

#[storage(read, write)]
fn setPoolPaused(poolId: u8, flag: bool);

#[storage(read, write)]
fn deposit(poolId: u8, amount: u64);

#[storage(read, write)]
fn emergencyWithdraw(poolId: u8, amount: u64);


#[storage(read, write)]
fn withdraw(poolId: u8, amount: u64 );

#[storage(read, write)]
fn transferRewards(poolId: u8, duration: u64, amount: u64) -> u64;

#[storage(read, write)]
fn borrow(poolId: u8, amount: u64);

#[storage(read, write)]
fn repay(poolId: u8, amount: u64);

#[storage(read, write)]
fn claimQuarterlyPayout(poolId: u8);

#[storage(read, write)]
fn whitelist(poolId: u8, status: bool);

#[storage(read, write)]
fn createPool(pool_is_staking: bool, pool_name: str[15], apy: u64, qrt_payout: bool, duration: u64, start_time:u64, end_time:u64, max_utilization: u64, capacity: u64, limit_per_user: u64) -> u8;

#[storage(read, write)]
fn editPool(pool_id: u8, pool_name: str[15], pause: bool, apy: u32, max_utilization: u64, capacity: u64);

}