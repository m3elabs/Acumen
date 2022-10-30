contract;

dep interface;
dep errors;
dep events;

use events::*;
use errors::InteractionErrors;
use interface::AcumenCore;
use std::{
    address::Address,
    block::timestamp,
    chain::auth::msg_sender,
    constants::ZERO_B256,
    context::{
        call_frames::msg_asset_id,
        msg_amount,
        this_balance,
    },
    contract_id::ContractId,
    identity::Identity,
    logging::log,
    result::Result,
    revert::require,
    storage::StorageMap,
    token::transfer,
};

pub enum PoolType {
  Staking: bool,
  Loan: bool
}

pub struct ReceiptToken {
    token: ContractId,
}

pub struct CollateralToken {
    token: ContractId,
}

  pub enum TransactionType {
        Staking: bool,
        Borrow: bool
    }

     pub struct UserInfo {
        transactionType: TransactionType,
        amount: u64,
        time: u32,
        paidOut: u64,
        user: Identity
    }

    pub struct TokenInfo {
        collateralToken: ContractId,
        receiptToken: ContractId,
        decimals: u8,
        name: str[4],
        symbol: str[4]
    }

    pub struct DepositLimiters {
        duration: u32,
        startTime: u32, // >>Deposits<< Start Time
        endTime: u32, // >>Deposits<< End Time
        limitPerUser:u64,
        capacity: u64,
        maxUtilisation: u64
    }

    pub struct Funds {
        balance: u64,
       loanedBalance: u64
    }

    pub struct PoolInfo {
        poolName:str[15],
        poolType:PoolType,
        APY: u32,
        paused: bool,
        quarterlyPayout:bool, 
        uniqueUsers: u64,
        tokenInfo: TokenInfo ,
        funds: Funds,
        depositLimiters: DepositLimiters
    }

storage {
  poolBalance: StorageMap<u8, u64> = StorageMap {},
  loanedBalance: StorageMap<u8, u64> = StorageMap {},
  owner: Identity = Identity::Address(Address { value: owner }),
  isInPool: StorageMap<(u8, Identity), bool> = StorageMap {},
  isWhiteListed: StorageMap<(u8, Identity), bool> = StorageMap {},
  userDetails: StorageMap<(u8, Identity), UserInfo > = StorageMap {},
  totalUserAmountStaked: StorageMap<(u8, Identity), u64 > = StorageMap {},
  totalUserAmountBorrowed: StorageMap<(u8, Identity), u64 > = StorageMap {},
}


impl AcumenCore for Contract {
   // All Read Functions ------------->
#[storage(read)]
fn totalPools() -> u32 {

}
#[storage(read)]
fn getPoolInfo(poolId:u8) -> PoolInfo {

}
#[storage(read)]
fn calculateInterest(user:Identity, poolId:u8, ) -> u64 {

}
#[storage(read)]
fn calculatePercentage(total: u64, percent: u64) -> u64 {

}
#[storage(read)]
fn getPoolUtilization(poolId: u8) -> u64 {

}
#[storage(read)]
fn getUserStakes(poolId: u8, user: Identity, ) -> UserInfo {

}
#[storage(read)]
fn getTotalStakesOfUser(poolId: u8, user: Identity) -> u32 {

}


// All Action Functions ------------->

#[storage(read, write)]
fn recoverAllTokens(token: ContractId, amount: u64) {

}

#[storage(read, write)]
fn setPoolPaused(poolId: u8, flag: bool) {

}

#[storage(read, write)]
fn deposit(poolId: u8, amount: u64) {

}

#[storage(read, write)]
fn emergencyWithdraw(poolId: u8, index: u32 , amount: u64 ) {

}

#[storage(read, write)]
fn deleteStakeIfEmpty(poolId: u8, index: u32 ) {

}

#[storage(read, write)]
fn withdraw(poolId: u8, index: u32 , amount: u64 ) {

}

#[storage(read, write)]
fn transferRewards(poolId: u8, index: u32 , duration: u64, amount: u64 ) {

}

#[storage(read, write)]
fn borrow(poolId: u8, amount: u64) {

}

#[storage(read, write)]
fn repay(poolId: u8, index: u32, amount: u64) {

}

#[storage(read, write)]
fn claimQuarterlyPayout(poolId: u8, index: u32) {

}

#[storage(read, write)]
fn whitelist(poolId: u8, user: Identity, status: bool) {

}

#[storage(read, write)]
fn createPool(_poolInfo: PoolInfo, _poolType:PoolType ) {

}

#[storage(read, write)]
fn editPool(poolId: u8, newPoolInfo: PoolInfo) {

}

}
