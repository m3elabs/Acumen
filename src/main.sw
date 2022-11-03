contract;

dep interface;
dep errors;
dep events;

use events::{
  DepositEvent,
  WithdrawEvent,
  EmergencyWithdrawEvent,
  RewardHarvested,
  WhitelistedEvent,
  TransferredEvent,
  BorrowedEvent,
  RepaidEvent,
  RecievedEvent,
  RecoveredEvent
};
use errors::{InteractionErrors};
use interface::AcumenCore;
use interface::{
  PoolInfo,
  Whitelist,
  BorrowingTransaction,
  StakingTransaction,
  Transaction,
  Funds,
  DepositLimiters
  };

use std::{
    address::Address,
    block::timestamp,
    auth::msg_sender,
    constants::ZERO_B256,
    context::{
        msg_amount,
        this_balance, 
    },
    call_frames::{contract_id, msg_asset_id},
    contract_id::ContractId,
    identity::Identity,
    logging::log,
    result::Result, 
    revert::require,
    storage::{StorageMap, StorageVec},
    token::*
};

const BASE_TOKEN = ContractId::from(0x9ae5b658754e096e4d681c548daf46354495a437cc61492599e33fc64dcdc30c);

const DAY: u64 = 86400;
const MONTH: u64 = 2629743;


storage {
  allPools: StorageVec<PoolInfo> = StorageVec {},
  isWhiteListed: StorageMap<(Identity,u8), bool> = StorageMap {},
  userInfoPerPool: StorageMap<(Identity, u8), Transaction> = StorageMap {},
  totalDeposits: StorageMap<Identity, u64 > = StorageMap {},
  totalLoans: StorageMap<Identity, u64> = StorageMap {},
  // owner: Identity = Identity,
}

#[storage(read, write)]
fn transfer_rewards(pool_id: u8, duration: u64, amount: u64) {
let mut pool:PoolInfo = storage.allPools.get(pool_id).unwrap();
let mut user_info: Transaction = storage.userInfoPerPool.get((msg_sender().unwrap(), pool_id));

require(amount <= user_info.staking.balance, InteractionErrors::MoreThanUserDeposited);


let reward: u64 = calculate_interest(pool_id, amount);
let mut claimable_reward: u64 = 0;

if (reward > user_info.staking.rewardsPaid) {
  claimable_reward = reward - user_info.staking.rewardsPaid;
}
else {
  claimable_reward = 0;
}

mint_to(claimable_reward, msg_sender().unwrap());

user_info.staking.rewardsPaid = user_info.staking.rewardsPaid + claimable_reward;

log(TransferredEvent {
address: msg_sender().unwrap(),
poolId: pool_id,
amount: amount
})

}

#[storage(read)]
fn calculate_interest(pool_id:u8, amount: u64 ) -> u64 {
  let ts: u64 = timestamp();
              let pool_info: PoolInfo = storage.allPools.get(pool_id).unwrap();
              let mut user_info: Transaction = storage.userInfoPerPool.get((msg_sender().unwrap(), pool_id));
              require(user_info.staking.balance <= amount, InteractionErrors::MoreThanUserDeposited); //Throw error
              if (pool_info.poolTypeIsStaking == true) {
                if (ts < pool_info.depositLimiters.endTime) {
                 return 0;
                }
              };

            let mut utilization: u64 = 0;
              if (!pool_info.poolTypeIsStaking) {
                 utilization = get_pool_utilization(pool_id);
                 return utilization;
                } else {
                 utilization = 100;
                 return utilization;
                };

              let reward_calculation_start_time: u64 = if (pool_info.poolTypeIsStaking == true) {
               return pool_info.depositLimiters.endTime;
              } else {
               return user_info.borrowing.time;
              };

             return (amount * pool_info.apy * utilization * (ts - reward_calculation_start_time)) / (100 * 100 * 365 * DAY);

              } 
           
 
#[storage(read)]
fn calculate_percentage(whole: u64, percent: u64) -> u64 {

  if (percent == 0) {return 0};
 let percentage: u64 = (whole * 100) / percent;
 return percentage;
}

#[storage(read)]
fn get_pool_utilization(pool_id: u8) -> u64 {
  let mut pool:PoolInfo = storage.allPools.get(pool_id).unwrap();

  if (pool.funds.balance == 0) {
    return 0;
  }

  let mut utilization: u64 = calculate_percentage(pool.funds.balance, pool.funds.loanedBalance);

  if (utilization > 100) {
    utilization = 100;
  }

  return utilization;

}


#[storage(read, write)]
fn emergency_withdraw(pool_id: u8 , amount: u64 ) {
let mut pool: PoolInfo = storage.allPools.get(pool_id).unwrap();
let mut user_info :Transaction  = storage.userInfoPerPool.get((msg_sender().unwrap(), pool_id));

pool.funds.balance = pool.funds.balance - amount;

user_info.staking.withdrawTime = timestamp();
user_info.staking.balance = user_info.staking.balance - amount;

require(amount <= user_info.staking.balance, InteractionErrors::MoreThanUserDeposited);

transfer(amount, pool.tokenInfo, msg_sender().unwrap());

if (user_info.staking.balance == 0) {
  user_info.staking.poolUser = false;
};

let fetch_deposits: u64 = storage.totalDeposits.get(msg_sender().unwrap());
storage.totalDeposits.insert(msg_sender().unwrap(), fetch_deposits - amount);

log(EmergencyWithdrawEvent {
address: msg_sender().unwrap() ,
poolId: pool_id ,
amount: amount
})

}



impl AcumenCore for Contract {
   // @dev All Read Functions ------------->
#[storage(read)]
fn get_total_pools() -> u64 {
  // @dev Returning the length of allPools storage vector that contains all the pools. This acts similar to an array 
   return storage.allPools.len();
}

#[storage(read)]
fn get_pool_info_from_id(pool_id:u8) -> PoolInfo {
 return storage.allPools.get(pool_id).unwrap()
}

#[storage(read)]
fn get_user_stakes_info_per_pool(pool_id: u8) -> Transaction {

let user_stakes:Transaction = storage.userInfoPerPool.get((msg_sender().unwrap(), pool_id));
return user_stakes;
}


#[storage(read)]
fn get_total_stakes_of_user(pool_id: u8) -> u64 {
   let total_stakes:Transaction = storage.userInfoPerPool.get((msg_sender().unwrap(), pool_id));
   return total_stakes.staking.entries;
}



// All Action Functions ------------->


 

// #[storage(read, write)]
// fn recover_all_tokens(token: ContractId, amount: u64) {
//   require(ms)
//   transfer(amount, BASE_TOKEN, owner);

// }

#[storage(read, write)]
fn set_pool_paused(pool_id: u8, flag: bool) {
let mut pool: PoolInfo = storage.allPools.get(pool_id).unwrap();
pool.paused = flag;
}

#[storage(read, write)]
fn deposit(pool_id: u8, amount: u64) {
  let mut pool: PoolInfo = storage.allPools.get(pool_id).unwrap();
require(amount <= pool.depositLimiters.limitPerUser,InteractionErrors::AmountExceedsAllowedDeposit);
require(pool.funds.balance + amount <=  pool.depositLimiters.capacity, InteractionErrors::PoolisAtCapacity);


  
  let new_transact: Transaction = Transaction {
 staking: StakingTransaction {
        balance:0,
        time: 0,
        user: msg_sender().unwrap(),
        entries: 0,
        poolUser: false,
        withdrawTime: 0,
        rewardsPaid: 0
  },
    borrowing: BorrowingTransaction {
     balance: 0,
    time: 0,
    user: msg_sender().unwrap(),
    poolUser: false,

  }
  };
if (storage.userInfoPerPool.get((msg_sender().unwrap(), pool_id)).staking.entries == 0) {
storage.userInfoPerPool.insert((msg_sender().unwrap(),pool_id), new_transact);
};


let mut user_info: Transaction = storage.userInfoPerPool.get((msg_sender().unwrap(), pool_id));

require(!pool.paused, InteractionErrors::PoolisPaused);
if (pool.poolTypeIsStaking == true) {
  require(timestamp() >= pool.depositLimiters.startTime && timestamp() <= pool.depositLimiters.endTime, InteractionErrors::DepositsNotAllowedRightNow)
};

require(msg_asset_id() == BASE_TOKEN,  InteractionErrors::NotTheCorrectCollateral);

force_transfer_to_contract(amount, pool.tokenInfo, contract_id());

user_info.staking.balance = user_info.staking.balance + amount;
user_info.staking.time = timestamp();
user_info.staking.user = msg_sender().unwrap();
user_info.staking.entries = user_info.staking.entries + 1;

if (!user_info.staking.poolUser) {
pool.uniqueUsers = pool.uniqueUsers + 1;
user_info.staking.poolUser = true;
}

pool.funds.balance = pool.funds.balance + amount;

storage.totalDeposits.insert(msg_sender().unwrap(), amount);

log(DepositEvent {
address: msg_sender().unwrap(),
poolId: pool_id,
amount: amount
})

}

#[storage(read, write)]
fn withdraw(pool_id: u8, amount: u64 ) {
let mut pool: PoolInfo = storage.allPools.get(pool_id).unwrap();
let mut user_info: Transaction = storage.userInfoPerPool.get((msg_sender().unwrap(), pool_id));

  if (timestamp() < pool.depositLimiters.endTime) {
    emergency_withdraw(pool_id, amount);
    return
  }

  require(amount <= user_info.staking.balance, InteractionErrors::MoreThanUserDeposited );
  require(timestamp() >= pool.depositLimiters.endTime + pool.depositLimiters.duration, InteractionErrors::WithdrawingBeforeExpiration );
  require(pool.funds.balance >= pool.funds.loanedBalance + amount, InteractionErrors::FundUtilizationTooHigh);

let projected_utilization: u64 = calculate_percentage(pool.funds.loanedBalance, (pool.funds.balance - amount) );
require( projected_utilization < pool.depositLimiters.maxUtilization, InteractionErrors::PastRecommendedUtilization);

user_info.staking.balance = user_info.staking.balance - amount;

transfer(amount, pool.tokenInfo, msg_sender().unwrap());
transfer_rewards(pool_id, timestamp() - pool.depositLimiters.endTime, amount);

if (user_info.staking.balance == 0) {
  user_info.staking.poolUser = false;
}

pool.funds.balance = pool.funds.balance - amount;

let fetch_deposits: u64 = storage.totalDeposits.get(msg_sender().unwrap());
storage.totalDeposits.insert(msg_sender().unwrap(), fetch_deposits - amount);

log(WithdrawEvent {
address: msg_sender().unwrap(),
poolId: pool_id,
amount: amount
})


}



#[storage(read, write)]
fn borrow(pool_id: u8, amount: u64 ) {
let mut pool: PoolInfo = storage.allPools.get(pool_id).unwrap();

let mut user_info: Transaction = storage.userInfoPerPool.get((msg_sender().unwrap(), pool_id));
let whitelist: bool = storage.isWhiteListed.get((msg_sender().unwrap(), pool_id));

require(whitelist == true, InteractionErrors::NotWhiteListed);
require(pool.paused == false, InteractionErrors::PoolisPaused);
require(pool.funds.balance > 0, InteractionErrors::PoolIsEmpty);
require(!pool.poolTypeIsStaking , InteractionErrors::WrongPoolType );


let projected_utilization: u64 = calculate_percentage(pool.funds.loanedBalance + amount, pool.funds.balance );
require(projected_utilization < pool.depositLimiters.maxUtilization, InteractionErrors::PastRecommendedUtilization);

transfer(amount, pool.tokenInfo, msg_sender().unwrap());

pool.funds.loanedBalance = pool.funds.loanedBalance + amount;

user_info.borrowing.balance = user_info.borrowing.balance + amount;
user_info.borrowing.time = timestamp();
user_info.borrowing.user = msg_sender().unwrap();
user_info.borrowing.poolUser = true; 

let fetch_loans: u64 = storage.totalLoans.get(msg_sender().unwrap());
storage.totalLoans.insert(msg_sender().unwrap(), fetch_loans + amount);

log( BorrowedEvent {
address: msg_sender().unwrap(),
poolId: pool_id,
amount: amount
  }
)

}

#[storage(read, write)]
fn repay(pool_id: u8, amount: u64) {
  let mut pool: PoolInfo = storage.allPools.get(pool_id).unwrap();
  let mut user_info: Transaction = storage.userInfoPerPool.get((msg_sender().unwrap(), pool_id));

  require(pool.poolTypeIsStaking == false, InteractionErrors::WrongPoolType );
  require(user_info.borrowing.balance >= amount, InteractionErrors::PayingMoreThanBorrowed);

  let interest: u64 = calculate_interest(pool_id, amount);

  force_transfer_to_contract(amount, pool.tokenInfo,contract_id());
 force_transfer_to_contract(interest, pool.tokenInfo, contract_id());

user_info.borrowing.balance = user_info.borrowing.balance - amount;

user_info.borrowing.time = timestamp();

if (user_info.borrowing.balance == 0) {
user_info.borrowing.poolUser = false;
};

let fetch_loans: u64 = storage.totalLoans.get(msg_sender().unwrap());
storage.totalLoans.insert(msg_sender().unwrap(), fetch_loans - amount);

pool.funds.loanedBalance = pool.funds.loanedBalance - amount;

log( RepaidEvent {
address: msg_sender().unwrap(),
poolId: pool_id,
amount: amount
  }
)

}

#[storage(read, write)]
fn claim_quarterly_payout(pool_id: u8) {
let mut pool:PoolInfo = storage.allPools.get(pool_id).unwrap();
let mut user_info: Transaction = storage.userInfoPerPool.get((msg_sender().unwrap(), pool_id));
require(pool.quarterlyPayout == true, InteractionErrors::QuarterlyPayoutDisabled );
 require(pool.poolTypeIsStaking == true, InteractionErrors::WrongPoolType );
 require(timestamp() > pool.depositLimiters.endTime, InteractionErrors::ClaimsNotAllowedRightNow);

 let mut time_diff: u64 = timestamp() - pool.depositLimiters.endTime;

  if (time_diff > pool.depositLimiters.duration) {
    time_diff = pool.depositLimiters.duration;
 } 

 let qrts_passed: u64 = time_diff / (3 * MONTH);
 let claim_amount: u64 = user_info.staking.balance;

 require(qrts_passed > 0, InteractionErrors::ClaimsNotAllowedRightNow);
transfer_rewards(pool_id, (qrts_passed * (3 * MONTH)), claim_amount);
}

#[storage(read, write)]
fn whitelist(pool_id: u8, status: bool) {
storage.isWhiteListed.insert((msg_sender().unwrap(), pool_id), status);
}

#[storage(read, write)]
fn create_pool( pool_is_staking: bool, pool_name: str[15], apy: u64, qrt_payout: bool, duration: u64, start_time:u64, end_time:u64, max_utilization: u64, capacity: u64, limit_per_user: u64 ) -> u8 {
 let mut id: u8 = 0; 
//  require(msg_sender().unwrap() == OWNER, InteractionErrors::NotTheOwner);
if (storage.allPools.len() == 0) {
 id = 0;
} else {
id = storage.allPools.len() + 1;
}
if (pool_is_staking == true) {
require(start_time < end_time, InteractionErrors::TimesIncompatible)
};


let new_pool: PoolInfo = PoolInfo {
    poolName:pool_name,
        poolTypeIsStaking: pool_is_staking,
        apy: apy,
        paused: false,
        quarterlyPayout: qrt_payout, 
        uniqueUsers: 0,
        tokenInfo: BASE_TOKEN,
        funds: Funds {
        balance: 0,
        loanedBalance: 0
        },
        pool_id: id,
        depositLimiters: DepositLimiters {
        duration: duration,
        startTime: start_time,
        endTime: end_time,
        limitPerUser:limit_per_user,
        capacity: capacity,
        maxUtilization: max_utilization
        }
};



storage.allPools.push(new_pool);

return id;

}

#[storage(read, write)]
fn edit_pool(pool_id: u8, pool_name: str[15], pause: bool, apy: u32, max_utilization: u64, capacity: u64) {
// require(msg_sender().unwrap() == OWNER, InteractionErrors::NotTheOwner);
let mut pool: PoolInfo  = storage.allPools.get(pool_id).unwrap();


let edits: PoolInfo = PoolInfo {
        poolName:pool_name,
        poolTypeIsStaking: pool.poolTypeIsStaking,
        apy: apy,
        paused: pause,
        quarterlyPayout: pool.quarterlyPayout, 
        uniqueUsers: pool.uniqueUsers,
        tokenInfo: pool.tokenInfo,
        funds: Funds {
        balance: pool.funds.balance,
        loanedBalance: pool.funds.loanedBalance
        },
        pool_id: pool.pool_id,
        depositLimiters: DepositLimiters {
        duration: pool.depositLimiters.duration,
        startTime: pool.depositLimiters.startTime,
        endTime: pool.depositLimiters.endTime,
        limitPerUser:pool.depositLimiters.limitPerUser,
        capacity: capacity,
        maxUtilization: max_utilization
        }
};

pool = edits;

}

}
