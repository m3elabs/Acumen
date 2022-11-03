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
    PoolisAtCapacity: (),
    NotTheOwner: (),
    NotTheCorrectCollateral: (),
    WrongPoolType: (),
    WithdrawingBeforeExpiration: (),
    FundUtilizationTooHigh: (),
    NotWhiteListed: (),
    PoolIsEmpty: (),
    PayingMoreThanBorrowed: (),
    QuarterlyPayoutDisabled: (),
    TimesIncompatible: (),
    PastRecommendedUtilization: ()
}
