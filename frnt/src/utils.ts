import {  bn, Wallet } from "fuels";
import { useEffect, useState } from "react";
import { AcumenAbi__factory } from "./contracts/factories/AcumenAbi__factory";

// The ID of the contract deployed to our local node.
// The contract ID is displayed when the `forc deploy` command is run.
export const CONTRACT_ID =
  "0x0dbd80aa82b6ea76478cf0386f5e7f5e8781cad04eab9491b13c25de4c484a6a";

// The private key of the `owner` in chainConfig.json.
// This enables us to have an account with an initial balance.
export const WALLET_SECRET =
  "01cb41149d240a6793240134ecc29ff6a43dbd1ab411f678011a6b3191b5190b";

// Create a "Wallet" using the private key above.
export const wallet1 = Wallet.fromPrivateKey(
  WALLET_SECRET,
  "https://beta-3.fuel.network/graphql"
);

// Connect a "Contract" instance using the ID of the deployed contract and the
// wallet above.

export const contract = AcumenAbi__factory.connect(CONTRACT_ID, wallet1);
export const address =
  "0x0000000000000000000000000000000000000000000000000000000000000000";

// function used to deposit funds
export async function deposit(e: any) {
  // e.preventDefault();
  // const data = new FormData(e.target);
  // console.log(bn(Number(data.get("Amount"))).toNumber())
  const deposit = await contract.functions
    .deposit(bn(String(1)), bn(Number(0.1)))
    .txParams({ gasPrice: 1 })
    .callParams({ forward: [bn(Number(0.1) * (10 ** 8)), address] })
    .call();
    alert("Transaction submitted successfully: "+deposit.transactionId);
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
  // e.preventDefault();
  // const data = new FormData(e.target);
  // console.log(bn(Number(data.get("Amount"))).toNumber())
  const withdraw = await contract.functions
    .withdraw(bn(String(1)), bn(Number(0.1) * (10 ** 8)))
    .txParams({ gasPrice: 1 })
    .call();

  console.log("withdraw", withdraw);
  //notify the user that the transaction has been submitted
  alert("Transaction submitted successfully: "+withdraw.transactionId);

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
      bn(Number(data.get("apy"))),
      bn(Number(data.get("maxUtilization"))),
      bn(Number(data.get("capacity")))
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
      bn(Number(data.get("apy"))),
      qrtPayout,
      bn(Number(data.get("duration"))),
      bn(Number(data.get("maxUtilization"))),
      bn.parseUnits(String(data.get("capacity"))),
      bn(Number(data.get("limitPerPerson")))
    )
    .txParams({ gasPrice: 1 })
    .call();

  console.log("Sent to the chain", poolId);

  // console.log((startTime), endTime, duration);

  // 4611686020099161000
  // 4611686020099284985
  // 9007199254740992
}
