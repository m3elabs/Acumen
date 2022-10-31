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
    token::*
};

const BASE_TOKEN = ~ContractId::from(0x9ae5b658754e096e4d681c548daf46354495a437cc61492599e33fc64dcdc30c);


pub struct PoolType {
  staking: bool,
}

pub struct ReceiptToken {
    token: ContractId,
}

pub struct CollateralToken {
    token: ContractId,
}


     pub enum Transaction {
        staking: bool,
        amountIn: u64,
        time: u32,
        paidOut: u64,
        user: Identity,
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

    pub enum PoolInfo {
        poolName:str[15],
        poolType:PoolType,
        APY: u32,
        paused: bool,
        quarterlyPayout:bool, 
        uniqueUsers: u64,
        tokenInfo: TokenInfo ,
        funds: Funds,
        poolId: u8,
        depositLimiters: DepositLimiters
    }

    pub enum Whitelist {
      user : Identity,
      status: bool,
      poolId: u8
    }

  

storage {
  allPools: StorageVec<PoolInfo> = StorageVec {},
  owner: Identity = Identity::Address(Address { value: owner }),
  isWhiteListed: StorageVec<Whitelist> = StorageVec {},
  allUserTransactions: StorageVec<Transaction> = StorageMap {},
}


impl AcumenCore for Contract {
   // @dev All Read Functions ------------->
#[storage(read)]
fn getTotalPools() -> u32 {
  // @dev Returning the length of allPools storage vector that contains all the pools. This acts similar to an array 
   storage.allPools.len();
}

#[storage(read)]
fn getPoolInfo(poolId:u8) -> PoolInfo {
 let mut i = 0;
        while i < storage.allPools.len() {
          let x = storage.allPools.get(i).poolId.unwrap();
            if (x == poolId ) {
              x
            }
            i += 1;
        }
}

#[storage(read)]
fn calculateInterest(user:Identity, poolId:u8, index:u16, amount: u64 ) -> u64 {
  let pool = storage.poolInfo.get(poolId);
  let userInf = storage.userDetails.get(poolId, user);

  require( amount <=

  )

}
#[storage(read)]
fn calculatePercentage(total: u64, percent: u64) -> u64 {


}
#[storage(read)]
fn getPoolUtilization(poolId: u8) -> u64 {
  let pool = storage.poolInfo.get(poolId);

  if (pool.funds.balance == 0) {
    0
  }

  let utilization: u64 = calculatePercentage(pool.funds.balance, pool.funds.loanedBalance)

  if (utilization > 100) {
    utilization = 100;
  }

  utilization;

}
#[storage(read)]
fn getUserStakes(poolId: u8, user: Identity) -> UserInfo {

  let TotalStakes = storage.userDetails.get(poolId, user)



}
#[storage(read)]
fn getTotalStakesOfUser(poolId: u8, user: Identity) -> u32 {
   let TotalStakes = storage.userDetails.get(poolId, user);
   TotalStakes.numberOfTransactions

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
