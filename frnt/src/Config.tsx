import { useEffect, useState } from "react";
import { TAI64 } from "tai64";
import { Wallet, BN, bn, BigNumberish } from "fuels";


// Import the contract factory from the folder generated by the fuelchain
// command
import { AcumenAbi__factory } from "./contracts/factories/AcumenAbi__factory";
import { PoolInfoOutput } from "./contracts/AcumenAbi";
import { Link, Router } from "react-router-dom";
import {
  address,
  borrow,
  contract,
  CONTRACT_ID,
  createPool,
  deposit,
  editPool,
  wallet1,
  withdraw,
} from "./utils";

function Config() {
  const [pools, setPools] = useState(0);

  async function poolDetails() {
    const value1 = await contract.functions.get_pool_info_from_id(0).get();
    const { value } = value1;
    console.log(value);
  }

  // async function userDetails() {
  //   const { value } = await contract.functions
  //     .get_user_stakes_info_per_pool(bn("0"))
  //     .txParams({ gasPrice: 1 })
  //     .call();
  //   console.log(Number(value.staking.balance));
  // }

  const [loanPoolData, setLoanPoolData] = useState<PoolInfoOutput[]>([]);
  const [stakingPoolData, setStakingPoolData] = useState<PoolInfoOutput[]>([]);

  async function allPoolDetails() {
    const { value } = await contract.functions.get_total_pools().get();
    console.log(Number(value));
    setPools(Number(value));

    for (let i = 0; i < Number(value); i++) {
      const value1 = await contract.functions.get_pool_info_from_id(i).get();
      const { value } = value1;

      const PoolInfoOutput: PoolInfoOutput = value;

      if (PoolInfoOutput.poolTypeIsStaking) {
        setStakingPoolData((stakingPoolData) => [
          ...stakingPoolData,
          PoolInfoOutput,
        ]);
      } else {
        setLoanPoolData((loanPoolData) => [...loanPoolData, PoolInfoOutput]);
      }
    }
  }

  console.log()

  function isOpenStaking(endDate: BigNumberish) {
    //get today's date in tai64
    const today = TAI64.now();
    //convert today to string
    const todayString = today.toString();
    //convert todayString to decimal from hex
    const todayDecimal = parseInt(todayString, 16);

    console.log(todayDecimal, endDate);
    if (todayDecimal > endDate) {
      return "Closed";
    } else {
      return "Open";
    }
  }

  useEffect(() => {
    // checkId()
    // allPools();
    // userDetails();
    //poolDetails();
    // totalDeposits();
    // allPoolDetails();
  }, []);

  return (
    <div style={{color: "white"}} className="App">
      <header className="App-header">
        <br/>   <br/>   <br/>   <br/> 
        <div className="App-items">
          <p>Deposit</p>
          <form onSubmit={deposit}>
            <input name="PoolID" className="" placeholder="PoolID"></input>
            <input
              name="Amount"
              className=""
              placeholder="Amount"
              step=".001"
            ></input>
            <button type="submit">Submit</button>
          </form>
        </div>

        <div className="App-items">
          <p>Withdraw</p>
          <form onSubmit={withdraw}>
            <input name="PoolID" className=""></input>
            <input name="Amount" className=""></input>
            <button type="submit">Submit</button>
          </form>
        </div>

        <div className="App-items">
          <p>Borrow</p>
          <form onSubmit={borrow}>
            <input name="PoolID" className=""></input>
            <input name="Amount" className=""></input>
            <button type="submit">Submit</button>
          </form>
        </div>

        <div className="App-items">
          <p>Repay</p>
          <input name="PoolID" className=""></input>
          <input name="Amount" className=""></input>
          <button type="submit">Submit</button>
        </div>

        <div className="App-items">
          <p>Create Pool: {pools}</p>
          <form onSubmit={createPool} className="Input">
            <p>Yes is Left, No is Right</p>
            <span>
              Staking?
              <input
                name="staking"
                value="yes"
                type="radio"
                className="App-inputs"
              ></input>{" "}
              <input
                name="staking"
                value="no"
                type="radio"
                className="App-inputs"
              ></input>
            </span>
            <input
              name="poolName"
              placeholder="Name"
              className="App-inputs"
            ></input>
            <input name="apy" placeholder="apy" className="App-inputs"></input>
            <span>
              qrtPayout
              <input
                name="qrtPayout"
                value="yes"
                type="radio"
                className="App-inputs"
              ></input>
              <input
                name="qrtPayout"
                value="no"
                type="radio"
                className="App-inputs"
              ></input>
            </span>
            <input
              name="duration"
              placeholder="duration"
              className="App-inputs"
            ></input>

        

            <input
              name="maxUtilization"
              placeholder="Max Utilization"
              className="App-inputs"
            ></input>
            <input
              name="capacity"
              placeholder="capacity"
              className="App-inputs"
            ></input>
            <input
              name="limitPerPerson"
              placeholder="Limit Per Person"
              className="App-inputs"
            ></input>

            <button className="App-inputs" type="submit">
              Submit
            </button>
          </form>
        </div>

        <div className="App-items">
          <p>Edit Pool</p>
          <form onSubmit={editPool} className="Input">
            <input
              className="App-inputs"
              name="poolId"
              placeholder="pool_id"
            ></input>
            <input
              className="App-inputs"
              name="poolName"
              placeholder="pool_name"
            ></input>
            <span>
              paused
              <input
                name="paused"
                value="yes"
                type="radio"
                className="App-inputs"
              ></input>
              <input
                name="paused"
                value="no"
                type="radio"
                className="App-inputs"
              ></input>
            </span>
            <input className="App-inputs" name="apy" placeholder="apy"></input>
            <input
              className="App-inputs"
              name="maxUtilization"
              placeholder="max_utilization"
            ></input>
            <input
              className="App-inputs"
              name="capacity"
              placeholder="capacity"
            ></input>
            <button className="App-inputs" type="submit">
              Submit
            </button>
          </form>
        </div>
      </header>
    </div>
  );
}

export default Config;
