import { BN, bn, Wallet } from "fuels";
import { useEffect, useState } from "react";
import { AcumenAbi__factory } from "./contracts/factories/AcumenAbi__factory";

// The ID of the contract deployed to our local node.
// The contract ID is displayed when the `forc deploy` command is run.
export const CONTRACT_ID =
  "0x4ee4c29398955f571a33f0c418812d3e7f2dc055ab1dfa862db0c000ad12786f";

// The private key of the `owner` in chainConfig.json.
// This enables us to have an account with an initial balance.
export const WALLET_SECRET =
  "2ef4b3f83de6d32c9e31c796e3175fc48eeb875d9824782d7b8d56db8a87ef2f";

// Create a "Wallet" using the private key above.
export const wallet1 = Wallet.fromPrivateKey(
  WALLET_SECRET,
  "https://node-beta-2.fuel.network/graphql"
);

// Connect a "Contract" instance using the ID of the deployed contract and the
// wallet above.

export const contract = AcumenAbi__factory.connect(CONTRACT_ID, wallet1);
export const address =
  "0x0000000000000000000000000000000000000000000000000000000000000000";

// function used to deposit funds
export async function deposit(e: any) {
  e.preventDefault();
  const data = new FormData(e.target);
  const deposit = await contract.functions
    .deposit(bn(String(data.get("PoolID"))), bn(String(data.get("Amount"))))
    .txParams({ gasPrice: 1 })
    .callParams({ forward: [bn(String(data.get("Amount"))), address] })
    .call();

  console.log("transaction", deposit);
}

export async function depositTransaction(amount: any, pool_id: any) {
  const deposit = await contract.functions
    .deposit(bn(pool_id), bn(amount))
    .txParams({ gasPrice: 1 })
    .callParams({ forward: [bn(amount), address] })
    .call();

  console.log("transaction", deposit);
}

// function to withdraw funds
export async function withdraw(e: any) {
  e.preventDefault();
  const data = new FormData(e.target);
  const withdraw = await contract.functions
    .withdraw(bn(String(data.get("PoolID"))), bn(.5))
    .txParams({ gasPrice: 1 })
    .call();

  console.log("withdraw", withdraw);
}

export async function withdrawTransaction(amount: any, pool_id: any) {
  const withdraw = await contract.functions
    .withdraw(bn(pool_id), bn(amount))
    .txParams({ gasPrice: 1 })
    .call();

  console.log("transaction", withdraw);
}

//TODO: Check if this is correct
export async function borrowTransaction(amount: any, pool_id: any) {
  const withdraw = await contract.functions
    .borrow(bn(pool_id), bn(amount))
    .txParams({ gasPrice: 1 })
    .call();

  console.log("transaction", withdraw);
}

//TODO: Check if this is correct
export async function repayTransaction(amount: any, pool_id: any) {
  const withdraw = await contract.functions
    .repay(bn(pool_id), bn(amount))
    .txParams({ gasPrice: 1 })
    .call();

  console.log("transaction", withdraw);
}

// function to borrow funds
export async function borrow(e: any) {
  e.preventDefault();
  const data = new FormData(e.target);
  const withdraw = await contract.functions
    .withdraw(bn(String(data.get("PoolID"))), bn(String(data.get("Amount"))))
    .txParams({ gasPrice: 1 })
    .call();

  console.log("withdraw", withdraw);
}

// function to repay the loan
export async function repay(e: any) {
  e.preventDefault();
  const data = new FormData(e.target);
  const withdraw = await contract.functions
    .withdraw(bn(String(data.get("PoolID"))), bn(String(data.get("Amount"))))
    .txParams({ gasPrice: 1 })
    .call();

  console.log("withdraw", withdraw);
}

// function used to connect to the fuel web3 wallet
export function useFuelWeb3() {
  const windowLocal = window as any;
  const [error, setError] = useState("");
  const [fuelWeb3, setFuelWeb3] = useState<any>(windowLocal.FuelWeb3);

  useEffect(() => {
    const timeout = setTimeout(() => {
      if (windowLocal.FuelWeb3) {
        setFuelWeb3(windowLocal.FuelWeb3);
      } else {
        setError("FuelWeb3 not detected on the window!");
      }
    }, 500);
    return () => clearTimeout(timeout);
  }, []);

  return [fuelWeb3, error] as const;
}
// function to get the total deposits
export async function totalDeposits() {
  const value1 = await contract.functions.get_total_stakes_of_user(0).get();
  const { value } = value1;
  console.log(value);
}

// function to edit the pool
export async function editPool(e: any) {
  e.preventDefault();
  let paused: boolean;
  const data = new FormData(e.target);
  if (data.get("paused") === "yes") {
    paused = true;
  } else {
    paused = false;
  }

  const apple = await contract.functions
    .edit_pool(
      Number(data.get("poolId")),
      String(data.get("poolName")),
      paused,
      new BN(Number(data.get("apy"))),
      new BN(Number(data.get("maxUtilization"))),
      new BN(Number(data.get("capacity")))
    )
    .txParams({ gasPrice: 1 })
    .call();
}

// function to get the contract ID
export const checkId = async () => {
  const id = await contract.functions.get_contract_id().get();
  console.log(id);
};

//create a function to convert unix time to TAI64
// export function unixToTai64(unixTime: number) {
//   const value = TAI64.fromUnix(unixTime);
//   const valueString = value.toString();
//   const valueDecimal = parseInt(valueString, 16);
//   return valueDecimal;
// }

//function used to create a new pool
export async function createPool(e: any) {
  e.preventDefault();
  const data = new FormData(e.target);
  let qrtPayout: boolean;
  let isStaking: boolean;

  if (data.get("qrtPayout") === "yes") {
    qrtPayout = true;
  } else {
    qrtPayout = false;
  }

  if (data.get("staking") === "yes") {
    isStaking = true;
  } else {
    isStaking = false;
  }

  const poolId = await contract.functions
    .create_pool(
      isStaking,
      String(data.get("poolName")),
      new BN(Number(data.get("apy"))),
      qrtPayout,
      new BN(Number(data.get("duration"))),
      new BN(Number(data.get("maxUtilization"))),
      bn.parseUnits(String(data.get("capacity"))),
      new BN(Number(data.get("limitPerPerson")))
    )
    .txParams({ gasPrice: 1 })
    .call();

  console.log("Sent to the chain", poolId);

  // console.log((startTime), endTime, duration);

  // 4611686020099161000
  // 4611686020099284985
  // 9007199254740992
}
