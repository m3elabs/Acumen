library errors;


pub enum InteractionErrors {
  SenderNotOwner: (),
  StakeZero: (),
  WithdrawZero: (),
  BorrowZero: (),
  MoreThanUserDeposited: (),
  DepositsNotAllowedRightNow: (),
  ClaimsNotAllowedRightNow: (),
  PoolisPaused: (),
  AmountExceedsAllowedDeposit: (),
  PoolisAtCapacity: ();
  NotTheCorrectCollateral: (),
  WrongPoolType: (),
  WithdrawingBeforeExpiration: (),
  FundUtilizationIsTooHigh: (),
  NotWhiteListed: (),
  PoolIsEmpty: (),
  PayingMoreThanBorrowed: (),
  QuarterlyPayoutDisabled: (),
  TimesIncompatible: ()
}