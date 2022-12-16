import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { AcumenAbi__factory } from "./contracts";
import {
  borrowTransaction,
  CONTRACT_ID,
  deposit,
  depositTransaction,
  repayTransaction,
  wallet1,
  withdrawTransaction,
} from "./utils";
import { PoolInfoOutput } from "./contracts/AcumenAbi";

const Pools = () => {
  const { id } = useParams();

  const contract = AcumenAbi__factory.connect(CONTRACT_ID, wallet1);

  const [poolInfo, setPoolInfo] = useState({} as PoolInfoOutput);

  async function poolDetails() {
    const value1 = await contract.functions
      .get_pool_info_from_id(Number(id))
      .get();
    const { value } = value1;
    setPoolInfo(value);
  }

  const [value, setValue] = useState(0);

  const handleChange = (event: any) => {
    setValue(event.target.value);
  };

  const [value2, setValue2] = useState(0);

  const handleChange2 = (event: any) => {
    setValue2(event.target.value);
  };

  const [apy, setApy] = useState("");

  async function apyDetails() {
    const value1 = await contract.functions
      .get_pool_info_from_id(Number(id))
      .get();
    const { value } = value1;
    setApy(value.apy.toString());
  }

  useEffect(() => {
    poolDetails();
    apyDetails();
  }, []);
  //TODO add repay and borrow details.
  if (poolInfo.poolTypeIsStaking) {
    return (
      <>
        <div>
          <h1>Pool Details</h1>
          <h2>Pool ID: {id}</h2>
          <h2>Pool Name: {poolInfo.poolName}</h2>
          <h2>Pool Type: {poolInfo.poolTypeIsStaking ? "Staking" : "Loan"}</h2>
          <h2>Pool Interest: {apy}%</h2>
        </div>
        <div className="App-items">
          <input type="number" value={value} onChange={handleChange} />
          <button onClick={() => depositTransaction(value, Number(id))}>
            Deposit
          </button>
        </div>
        <div className="App-items">
          <input type="number" value={value2} onChange={handleChange2} />
          <button onClick={() => withdrawTransaction(value2, Number(id))}>
            Withdraw
          </button>
        </div>
      </>
    );
  } else {
    return (
      <>
        <div>
          <h1>Pool Details</h1>
          <h2>Pool ID: {id}</h2>
          <h2>Pool Name: {poolInfo.poolName}</h2>
          <h2>Pool Type: {poolInfo.poolTypeIsStaking ? "Staking" : "Loan"}</h2>
          <h2>Pool Interest: {apy}%</h2>
        </div>
        <div className="App-items">
          <input type="number" value={value} onChange={handleChange} />
          <button onClick={() => borrowTransaction(value, Number(id))}>
            Borrow
          </button>
        </div>
        <div className="App-items">
          <input type="number" value={value2} onChange={handleChange2} />
          <button onClick={() => repayTransaction(value2, Number(id))}>
            Repay
          </button>
        </div>
      </>
    );
  }
};

export default Pools;
