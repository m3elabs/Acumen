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

  pub struct StakingTransaction {
        balance: u64,
        time: u64,
        user: Identity,
        entries: u64,
        poolUser: bool,
        withdrawTime: u64,
        rewardsPaid: u64
    }

      pub struct BorrowingTransaction {
        balance: u64,
        time: u64,
        user: Identity,
        poolUser: bool,
    }

     pub struct Transaction {
        staking: StakingTransaction,
        borrowing: BorrowingTransaction
    }

    pub struct DepositLimiters {
        duration: u64,
        startTime: u64, // >>Deposits<< Start Time
        endTime: u64, // >>Deposits<< End Time
        limitPerUser:u64,
        capacity: u64,
        maxUtilization: u64
    }

    pub struct Funds {
        balance: u64,
       loanedBalance: u64
    }

    pub struct PoolInfo {
        poolName:str[15],
        poolTypeIsStaking: bool,
        apy: u32,
        paused: bool,
        quarterlyPayout:bool, 
        uniqueUsers: u64,
        tokenInfo: BASE_TOKEN,
        funds: Funds,
        pool_id: u8,
        depositLimiters: DepositLimiters
    }

    pub struct Whitelist {
      user : Identity,
      status: bool,
      pool_id: u8
    }

  

storage {
  allPools: StorageVec<PoolInfo> = StorageVec {},
  owner: Identity = Identity::Address(Address { value: owner }),
  isWhiteListed: StorageMap<(Identity,u8), bool> = StorageMap {},
  allUserTransactions: StorageVec<Transaction> = StorageVec {},
  userInfoPerPool: StorageMap<(Identity, u8), Transaction> = StorageMap {},
  totalDeposits: StorageMap<Identity, u32 > = StorageMap {},
  totalLoans: StorageMap<Identity, u32> = StorageMap {},
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
fn calculateInterest(pool_id:u8, amount: u64 ) -> u64 {
  let ts = timestamp();
              let pool_info = storage.allPools.get(pool_id).unwrap();
              let user_info = storage.userInfoPerPool.get(msg_sender(), pool_id).unwrap();
              require(user_info.staking.balance <= amount, InteractionErrors::MoreThanUserDeposited); //Throw error
              if (pool_info.poolTypeIsStaking == true) {
                if (ts < pool_info.depositLimiters.endTime) {
                 return 0;
                }
              };

            let utilization: u64 = 0;
              if (!pool_info.poolTypeIsStaking) {
                 return utilization = getPoolUtilization(pool_id);
                } else {
                 return utilization = 100;
                };

              let reward_calculation_start_time: u64 = if (pool_info.poolTypeIsStaking == true) {
               return pool_info.depositLimiters.endTime;
              } else {
               return user_info.borrowing.time;
              };

             return (amount * pool_info.apy * utilization * (ts - reward_calculation_start_time)) / (100 * 100 * 365 * day);

              } 
           
 


#[storage(read)]
fn calculatePercentage(whole: u64, percent: u64) -> u64 {

  if (percent == 0) {return 0};
 let percentage: u64 = (whole * 100) / percent;
 return percentage;
}

#[storage(read)]
fn getPoolUtilization(pool_id: u8) -> u64 {
  let pool = storage.allPools.get(pool_id).unwrap();

  if (pool.funds.balance == 0) {
    0;
  }

  let utilization: u64 = calculatePercentage(pool.funds.balance, pool.funds.loanedBalance);

  if (utilization > 100) {
    utilization = 100;
  }

  return utilization;

}
#[storage(read)]
fn getUserStakesInfoPerPool(pool_id: u8) -> UserInfo {

let user_stakes = storage.userInfoPerPool.get(pool_id, msg_sender()).unwrap();
return user_stakes.staking;
}


#[storage(read)]
fn getTotalStakesOfUser(pool_id: u8) -> u32 {
   let total_stakes = storage.userInfoPerPool.get(pool_id, msg_sender()).unwrap();
   return total_stakes.staking.entries;
}




// All Action Functions ------------->

#[storage(read, write)]
fn recoverAllTokens(token: ContractId, amount: u64) {

}

#[storage(read, write)]
fn setPoolPaused(pool_id: u8, flag: bool) {
let pool = storage.allPools.get(pool_id).unwrap();
pool.paused = flag;
}

#[storage(read, write)]
fn deposit(pool_id: u8, amount: u64) {
  let pool = storage.allPools.get(pool_id).unwrap();
require(amount <= pool.depositLimiters.limitPerUser,InteractionErrors::AmountExceedsAllowedDeposit);
require(pool.funds.balance + amount <=  pool.depositLimiters.capacity, InteractionErrors::PoolisAtCapacity);


  if (!storage.userInfoPerPool.get(msg_sender(), pool_id)) {
storage.userInfoPerPool.insert(msg_sender(), pool_id);
  };

let user_info = storage.userInfoPerPool.get(msg_sender(), pool_id).unwrap();

require(!pool.paused, InteractionErrors::PoolisPaused);
if (pool.poolTypeIsStaking == true) {
  require(timestamp() >= pool.depositLimiters.startTime && timestamp() <= pool.depositLimiters.endTime, InteractionErrors::DepositsNotAllowedRightNow)
};

require(msg_asset_id() == BASE_TOKEN,  InteractionErrors::NotTheCorrectCollateral);

transfer(amount, pool.tokenInfo, contract_id());

user_info.staking.balance = user_info.staking.balance + amount;
user_info.staking.time = timestamp();
user_info.staking.user = msg_sender();
user_info.staking.entries = user_info.staking.entries + 1;

if (!user_info.staking.poolUser) {
pool.uniqueUsers = pool.uniqueUsers + 1;
user_info.staking.poolUser = true;
}

pool.funds.balance = pool.funds.balance + amount;

storage.totalDeposits.insert(msg_sender(), amount);

log(DepositEvent {
address: msg_sender(),
poolId: pool_id,
amount: amount
})

}

#[storage(read, write)]
fn emergencyWithdraw(pool_id: u8 , amount: u64 ) {
let pool = storage.allPools.get(pool_id).unwrap();
let user_info = storage.userInfoPerPool.get(msg_sender(), pool_id).unwrap();

pool.funds.balance = pool.funds.balance - amount;

user_info.staking.withdrawTime = timestamp();
user_info.staking.balance = user_info.staking.balance - amount;

require(amount <= user_info.staking.balance, InteractionErrors::MoreThanUserDeposited);

transfer(amount, pool.tokenInfo, msg_sender());

if (user_info.staking.balance == 0) {
  user_info.staking.poolUser = false;
};

let fetch_deposits = storage.totalDeposits.get(msg_sender());
storage.totalDeposits.insert(msg_sender(), fetch_deposits - amount);

log(EmergencyWithdrawEvent {
address: msg_sender() ,
poolId: pool_id ,
amount: amount
})

}



#[storage(read, write)]
fn withdraw(pool_id: u8, amount: u64 ) {
let pool = storage.allPools.get(pool_id).unwrap();
let user_info = storage.userInfoPerPool.get(msg_sender(), pool_id).unwrap();

  if (timestamp() < pool.depositLimiters.endTime) {
    emergencyWithdraw(pool_id, amount);
    return
  }

  require(amount <= user_info.staking.balance, InteractionErrors::MoreThanUserDeposited );
  require(timestamp() >= pool.depositLimiters.endTime + pool.depositLimiters.duration, InteractionErrors::WithdrawingBeforeExpiration );
  require(pool.funds.balance >= pool.funds.loanedBalance + amount, InteractionErrors::FundUtilizationTooHigh);

let projected_utilization: u64 = calaculatePercentage(pool.funds.loanedBalance, (pool.funds.balance - amount) );
require( projected_utilization < pool.depositLimiters.maxUtilization, InteractionErrors::PastRecommendedUtilization);

user_info.staking.balance = user_info.staking.balance - amount;

transfer(amount, pool.tokenInfo, msg_sender());
transferRewards(pool_id, timestamp() - pool.depositLimiters.endTime, amount, msg_sender());

if (user_info.staking.balance == 0) {
  user_info.staking.poolUser = false;
}

pool.funds.balance.push(pool.funds.balance - amount);

let fetch_deposits = storage.totalDeposits.get(msg_sender());
storage.totalDeposits.insert(msg_sender(), fetch_deposits - amount);

log(WithdrawEvent {
address: msg_sender(),
poolId: pool_id,
amount: amount
})


}

#[storage(read, write)]
fn transferRewards(pool_id: u8, duration: u64, amount: u64) -> u64 {
let pool = storage.allPools.get(pool_id).unwrap();
let user_info = storage.userInfoPerPool.get(msg_sender(), pool_id).unwrap();

require(amount <= user_info.staking.balance, InteractionErrors::MoreThanUserDeposited);


let reward: u64 = calculateInterest(msg_sender(), pool_id, amount);
let claimable_reward: u64 = 0;

if (reward > user_info.staking.rewardsPaid) {
  claimable_reward = reward - user_info.staking.rewardsPaid;
}
else {
  claimable_reward = 0;
}

mint_to_address(claimable_reward, msg_sender());

user_info.staking.rewardsPaid = user_info.staking.rewardsPaid + claimable_reward;

log(TransferredEvent {
address: msg_sender(),
poolId: pool_id,
amount: amount
})

return claimable_reward;
}

#[storage(read, write)]
fn borrow(pool_id: u8, amount: u64 ) {
let pool = storage.allPools.get(pool_id).unwrap();
let user_info = storage.userInfoPerPool.get(msg_sender(), pool_id).unwrap();
let whitelist = storage.isWhiteListed.get(msg_sender(), pool_id).unwrap();

require(whitelist == true, InteractionErrors::NotWhiteListed);
require(pool.paused == false, InteractionErrors::PoolisPaused);
require(pool.funds.balance > 0, InteractionErrors::PoolIsEmpty);
assert(pool.poolType == loan);


let projected_utilization: u64 = calaculatePercentage(pool.funds.loanedBalance + amount, pool.funds.balance );
require(projected_utilization < pool.depositLimiters.maxUtilization, InteractionErrors::PastRecommendedUtilization);

transfer(amount, pool.tokenInfo, msg_sender());

pool.funds.loanedbalance = pool.funds.loanedBalance + amount;

user_info.borrowing.balance = user_info.borrowing.balance + amount;
user_info.borrowing.time = timestamp();
user_info.borrowing.user = msg_sender();
user_info.borrowing.poolUser = true; 

let fetch_loans = storage.totalLoans.get(msg_sender());
storage.totalLoans.insert(msg_sender(), fetch_loans + amount);

log( BorrowEvent {
address: msg_sender(),
poolId: pool_id,
amount: amount
  }
)

}

#[storage(read, write)]
fn repay(pool_id: u8, amount: u64) {
  let pool = storage.allPools.get(pool_id).unwrap();
  let user_info = storage.userInfoPerPool.get(msg_sender(), pool_id).unwrap();

  require(pool.poolType == loan, InteractionErrors::WrongPoolType );
  require(user_info.borrowing.balance >= amount, InteractionErrors::PayingMoreThanBorrowed);

  let interest: u64 = calculateInterest(msg_sender(), pool_id, amount);

  transfer(amount, pool.tokenInfo, contract_id());
  transfer(interest, pool.tokenInfo, contract_id());

user_info.borrowing.balance = user_info.borrowing.balance - amount;

user_info.borrowing.time = timestamp();

if (user_info.borrowing.balance == 0) {
user_info.borrowing.poolUser = false;
};

let fetch_loans = storage.totalLoans.get(msg_sender());
storage.totalLoans.insert(msg_sender(), fetch_loans - amount);

pool.funds.loanedbalance = pool.funds.loanedBalance - amount;

log( RepaidEvent {
address: msg_sender(),
poolId: pool_id,
amount: amount
  }
)

}

#[storage(read, write)]
fn claimQuarterlyPayout(pool_id: u8) {
let pool = storage.allPools.get(pool_id).unwrap();
let user_info = storage.userInfoPerPool.get(msg_sender(), pool_id).unwrap();
require(pool.quarterlyPayout == true, InteractionErrors::QuarterlyPayoutDisabled );
 require(pool.poolType == staking, InteractionErrors::WrongPoolType );
 require(timestamp() > pool.depositLimiters.endTime, InteractionErrors::ClaimsNotAllowedRightNow);

 let time_diff: u64 = timestamp() - pool.depositLimiters.endTime;

  if (time_diff > pool.depositLimiters.duration) {
    time_diff = pool.depositLimiters.duration;
 } 

 let qrts_passed: u64 = time_diff / (3 * month);
 let claim_amount: u64 = user_info.staking.balance;

 require(qrts_passed > 0, InteractionErrors::ClaimsNotAllowedRightNow);
transferRewards(pool_id, qrts_passed * (3 * month), claim_amount, msg_sender());
}

#[storage(read, write)]
fn whitelist(pool_id: u8, status: bool) {
storage.isWhiteListed.insert((msg_sender(), pool_id), status);
}

#[storage(read, write)]
fn createPool( pool_is_staking: bool, pool_name: str[15], apy: u64, qrt_payout: bool, duration: u64, start_time:u64, end_time:u64, max_utilization: u64, capacity: u64, limit_per_user: u64 ) {
if (storage.allPools.len() == null || storage.allPools.len() == 0) {
 let id: u8 = 0; 
} else {
id = storage.allPools.len() + 1;
}
if (pool_is_staking == true) {
require(start_time < end_time, InteractionErrors::TimesIncompatible)
};

let original_funds = Funds {
  balance: 0,
  loanBalance: 0
};


let deposit_details = DepositLimiters {
        duration: duration,
        startTime: start_time,
        endTime: end_time,
        limitPerUser:limit_per_user,
        capacity: capacity,
        maxUtilization: max_utilization
}


let new_pool = PoolInfo {
    poolName:str[15],
        poolTypeIsStaking: pool_is_staking,
        apy: apy,
        paused: false,
        quarterlyPayout: qrt_payout, 
        uniqueUsers: 0,
        tokenInfo: BASE_TOKEN,
        funds: original_funds, //do I have to initialize or will it do it by default
        pool_id: id,
        depositLimiters: deposit_details
}



storage.allPools.push(new_pool);

return "pool successfully created! New pool ID:" + id

}

#[storage(read, write)]
fn editPool(pool_id: u8, pool_name: str[15], pause: bool, apy: u32, max_utilization: u64, capacity: u64) {
let pool = storage.allPools.get(pool_id).unwrap();

let match_funds = Funds {
  balance: pool.funds.balance,
  loanBalance: pool.funds.loanBalance
}


let deposit_details = DepositLimiters {
        duration: pool.depositLimiters.duration,
        startTime: pool.depositLimiters.startTime,
        endTime: pool.depositLimiters.endTime,
        limitPerUser:pool.depositLimiters.limitPerUser,
        capacity: capcity,
        maxUtilization: max_utilization
}


let edits = PoolInfo {
    poolName:str[15],
        poolTypeIsStaking: pool.poolTypeIsStaking,
        apy: apy,
        paused: pause,
        quarterlyPayout: pool.quarterlyPayout, 
        uniqueUsers: pool.uniqueUsers,
        tokenInfo: pool.tokenInfo,
        funds: Funds,
        pool_id: pool.pool_id,
        depositLimiters: deposit_details,
}

pool = edits;

}

}
