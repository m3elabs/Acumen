library interface;

use std::{contract_id::ContractId, identity::Identity};




abi AcumenCore {
// All Read Functions ------------->

#[storage(read)]
fn totalPools() -> u32
#[storage(read)]
fn getPoolInfo(poolId:u8) -> PoolInfo
#[storage(read)]
fn calculateInterest(user:Identity, poolId:u8, ) -> u64
#[storage(read)]
fn calculatePercentage(total: u64, percent: u64) -> u64
#[storage(read)]
fn getPoolUtilization(poolId: u8) -> u64
#[storage(read)]
fn getUserStakes(poolId: u8, user: Identity, ) -> UserInfo
#[storage(read)]
fn getTotalStakesOfUser(poolId: u8, user: Identity) -> u32

// All Action Functions ------------->

#[storage(read, write)]
fn recoverAllTokens(token: ContractId, amount: u64)

#[storage(read, write)]
fn setPoolPaused(poolId: u8, flag: bool)

#[storage(read, write)]
fn deposit(poolId: u8, amount: u64)

#[storage(read, write)]
fn emergencyWithdraw(poolId: u8, index: u32 , amount: u64 )

#[storage(read, write)]
fn deleteStakeIfEmpty(poolId: u8, index: u32 )

#[storage(read, write)]
fn withdraw(poolId: u8, index: u32 , amount: u64 )

#[storage(read, write)]
fn transferRewards(poolId: u8, index: u32 , duration: u64, amount: u64 )

#[storage(read, write)]
fn borrow(poolId: u8, amount: u64)

#[storage(read, write)]
fn repay(poolId: u8, index: u32, amount: u64)

#[storage(read, write)]
fn claimQuarterlyPayout(poolId: u8, index: u32)

#[storage(read, write)]
fn whitelist(poolId: u8, user: Identity, status: bool)

#[storage(read, write)]
fn createPool(_poolInfo: PoolInfo, _poolType:PoolType )

#[storage(read, write)]
fn editPool(poolId: u8, newPoolInfo: PoolInfo)


}