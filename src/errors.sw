library errors;


pub enum InteractionErrors {

  SenderNotOwner: (),
  StakeZero: (),
  WithdrawZero: (),
  BorrowZero: (),
  MoreThanUserDeposited: (),
  DepositsNotAllowedRightNow (),
  PoolisPaused: (),
  AmountExceedsAllowedDeposit: (),
  PoolisAtCapacity: ();
  NotTheCorrectCollateral: (),
  WrongPoolType: (),
  WithdrawingBeforeExpiration: (),
  FundUtilizationIsTooHigh: ()


}