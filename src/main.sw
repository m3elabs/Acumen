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
        contract_id,
    },
    contract_id::ContractId,
    identity::Identity,
    logging::log,
    result::Result,
    revert::require,
    storage::{StorageMap, StorageVec},
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

  pub enum StakingTransaction {
        balance: u64,
        time: u64,
        user: Identity,
        entries: u64,
        poolUser: bool,
        withdrawTime: u64
    }

      pub enum BorrowingTransaction {
        balance: u64,
        time: u64,
        paidOut: u64,
        user: Identity,
    }

     pub enum Transaction {
        staking: StakingTransaction,
        borrowing: BorrowingTransaction
    }

    pub struct TokenInfo {
        collateralToken: BASE_TOKEN,
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
        pool_id: u8,
        depositLimiters: DepositLimiters
    }

    pub enum Whitelist {
      user : Identity,
      status: bool,
      pool_id: u8
    }

  

storage {
  allPools: StorageVec<PoolInfo> = StorageVec {},
  owner: Identity = Identity::Address(Address { value: owner }),
  isWhiteListed: StorageVec<Whitelist> = StorageVec {},
  allUserTransactions: StorageVec<Transaction> = StorageVec {},
  userInfoPerPool: StorageMap<(Identity, u8), Transaction> = StorageMap {},
}


impl AcumenCore for Contract {
   // @dev All Read Functions ------------->
#[storage(read)]
fn getTotalPools() -> u32 {
  // @dev Returning the length of allPools storage vector that contains all the pools. This acts similar to an array 
   storage.allPools.len();
}

#[storage(read)]
fn getPoolInfoFrom(pool_id:u8) -> PoolInfo {
  // @dev Looping through the length of allPools and checking to see if any match the pool_id passed in the param
 let mut i = 0;
        while i < storage.allPools.len() {
          let x = storage.allPools.get(i).unwrap().pool_id;
            if (x == pool_id ) {
              storage.allPools.get(i).unwrap()
            }
            else {
              i += 1;
            }
        }
}

#[storage(read)]
fn getPoolInfoFrom(poolName:str[15]) -> PoolInfo {
  // @dev Looping through the length of allPools and checking to see if any match the poolName passed as the param
 let mut i = 0;
        while i < storage.allPools.len() {
          let x = storage.allPools.get(i).unwrap().poolName;
            if (x == poolName ) {
              storage.allPools.get(i).unwrap()
            }
            else {
              i += 1;
            }
        }
}

#[storage(read)]
fn calculateInterest(user:Identity, pool_id:u8, amount: u64 ) -> u64 {
  let ts = timestamp();
  let mut i = 0;
        while i < storage.allPools.len() {
          let x = storage.allPools.get(i).unwrap().pool_id;
            if (x == pool_id ) {
              let pool_info = storage.allPools.get(i).unwrap();
              let user_info = storage.userInfoPerPool.get(user, pool_id).unwrap();
              require(user_info.staking.balance <= amount, InteractionErrors::MoreThanUserDeposited); //Throw error
              if (pool_info.poolType.staking == true) {
                if (ts < pool_info.depositLimiters.endTime) {
                 return 0
                }
              }
            let utilization: u64 = 0;
              if (!pool_info.poolType.staking) {
                 return utilization = getPoolUtilization(pool_id);
                } else {
                 return utilization = 100;
                }

              let reward_calculation_start_time: u64 = (pool_info.poolType == pool_info.poolType.staking
              ?  pool_info.depositLimiters.endTime
              : user_info.borrowing.time) ;

             return (amount * pool_info.APY * utilization * (ts - reward_calculation_start_time)) / (100 * 100 * 365 days)


              } 
              
            } else {
              i += 1;
            }
        }
 


#[storage(read)]
fn calculatePercentage(whole: u64, percent: u64) -> u64 {

  if (percent == 0) return 0;
 let percentage: u64 = (whole * 100) / percent;
 return percentage;


}
#[storage(read)]
fn getPoolUtilization(pool_id: u8) -> u64 {
  let pool = storage.poolInfo.get(pool_id).unwrap();

  if (pool.funds.balance == 0) {
    0
  }

  let utilization: u64 = calculatePercentage(pool.funds.balance, pool.funds.loanedBalance);

  if (utilization > 100) {
    utilization = 100;
  }

  return utilization;

}
#[storage(read)]
fn getUserStakesInfoPerPool(pool_id: u8, user: Identity) -> UserInfo {

let user_stakes = storage.userInfoPerPool.get(pool_id, user).unwrap();

return user_stakes.staking;

}


#[storage(read)]
fn getTotalStakesOfUser(pool_id: u8, user: Identity) -> u32 {
   let total_stakes = storage.userInfoPerPool.get(pool_id, user).unwrap();
   return total_stakes.staking.entries;

}




// All Action Functions ------------->

#[storage(read, write)]
fn recoverAllTokens(token: ContractId, amount: u64) {

}

#[storage(read, write)]
fn setPoolPaused(pool_id: u8, flag: bool) {
let pool = storage.allPools.get(pool_id).unwrap();
pool.paused.push(flag);

}

#[storage(read, write)]
fn deposit(pool_id: u8, amount: u64, user:Identity) {
  let pool = storage.allPools.get(pool_id).unwrap();

  if (!storage.userInfoPerPool.get(user, pool_id)) {
storage.userInfoPerPool.insert(user, pool_id);
  }
let user_info = storage.userInfoPerPool.get(user, pool_id).unwrap();

require(!pool.paused, InteractionErrors::PoolisPaused);
if (pool.poolType.staking == true) {
  require(timestamp >= pool.depositLimiters.startTime && timestamp >= pool.depositLimiters.endTime, InteractionErrors::DepositsNotAllowedRightNow)
}
require(amount <=  pool.depositLimiters.limitPerUser,InteractionErrors::AmountExceedsAllowedDeposit)
require(pool.funds.balance + amount <=  pool.depositLimiters.capacity, InteractionErrors::PoolisAtCapacity)

require(msg_asset_id() == BASE_TOKEN,  InteractionErrors::NotTheCorrectCollateral)

transfer(amount, pool.tokenInfo.collateralToken, contract_id());

user_info.staking.push(StakingTransaction::amountIn( user_info.staking.amountIn += amount));
user_info.staking.push(StakingTransaction::time( timestamp));
user_info.staking.push(StakingTransaction::user( user));
user_info.staking.push(StakingTransaction::entries( user_info.staking.entries + 1));

if (!user_info.staking.poolUser) {
pool.uniqueUsers = pool.uniqueUsers + 1;
}

user_info.staking.push(StakingTransaction::poolUser(true));

pool.funds.balance.push(pool.funds.balance + amount);

log(DepositEvent {
address: user,
poolId: pool_id,
amount: amount
}

)

}

#[storage(read, write)]
fn emergencyWithdraw(pool_id: u8 , amount: u64, user: Identity ) {
let pool = storage.allPools.get(pool_id).unwrap();
let user_info = storage.userInfoPerPool.get(user, pool_id).unwrap();

pool.funds.balance.push(pool.funds.balance - amount)

user_info.staking.push(StakingTransaction::withdrawTime( timestamp));
user_info.staking.push(StakingTransaction::user( user));
user_info.staking.push(StakingTransaction::balance( user_info.staking.balance + amount));

require(amount <= user_info.staking.balance, InteractionErrors::MoreThanUserDeposited )

transfer(amount, pool.tokenInfo.collateralToken, user);

if (user_info.staking.balance == 0) {
  user_info.staking.push(StakingTransaction::poolUser(false);
}

log(EmergencyWithdrawEvent {
address: user ,
poolId: pool_id ,
amount: amount
})

}



#[storage(read, write)]
fn withdraw(pool_id: u8, amount: u64 ) {
let pool = storage.allPools.get(pool_id).unwrap();
let user_info = storage.userInfoPerPool.get(user, pool_id).unwrap();

  if (timestamp < pool.depositLimiters.endTime) {
    emergencyWithdraw(pool_id, amount);
    return
  }

  require(amount <= user_info.staking.balance, InteractionErrors::MoreThanUserDeposited );
  require(timestamp >= pool.depositLimiters.endTime + pool.depositLimiters.duration, InteractionErrors::WithdrawingBeforeExpiration );
  require(pool.funds.balance >= pool.funds.loanedBalance + amount, InteractionErrors::FundUtilizationTooHigh);

let projected_utilization: u64 = calaculatePercentage(pool.funds.loanedBalance, (pool.funds.balance - amount) );
require( projected_utilization < pool.depositLimiters.maxUtilization, InteractionErrors::PastRecommendedUtilization);



user_info.staking.push(StakingTransaction::balance(user_info.staking.balance - amount))

transfer(amount, pool.tokenInfo.collateralToken, user);
transferRewards(pool_id, timestamp - pool.depositLimiters.endTime, amount);

if (user_info.staking.balance == 0) {
  user_info.staking.push(StakingTransaction::poolUser(false);
}

pool.funds.balance.push(pool.funds.balance - amount);


log(WithdrawEvent {
address: user,
poolId: pool_id,
amount: amount
})


}

#[storage(read, write)]
fn transferRewards(pool_id: u8, duration: u64, amount: u64 ) {

}

#[storage(read, write)]
fn borrow(pool_id: u8, amount: u64) {

}

#[storage(read, write)]
fn repay(pool_id: u8, index: u32, amount: u64) {

}

#[storage(read, write)]
fn claimQuarterlyPayout(pool_id: u8, index: u32) {

}

#[storage(read, write)]
fn whitelist(pool_id: u8, user: Identity, status: bool) {

}

#[storage(read, write)]
fn createPool(pool_info: PoolInfo, pool_type:PoolType ) {

}

#[storage(read, write)]
fn editPool(pool_id: u8, new_pool_info: PoolInfo) {

}

}
