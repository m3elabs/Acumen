import { useEffect, useState } from "react";
import { TAI64 } from "tai64";
import { Wallet, BN, bn, BigNumberish } from "fuels";

import "./assets/css/app-page.css";
import "./assets/css/bootstrap.min.css";
import "./assets/css/style.css";

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
  unixToTai64,
  wallet1,
  withdraw,
} from "./utils";
import { borderBottom } from "@mui/system";

function Home() {
  const [pools, setPools] = useState(0);

  async function poolDetails() {
    const value1 = await contract.functions.get_pool_info_from_id(0).get();
    const { value } = value1;
    console.log(value);
  }

  async function userDetails() {
    const { value } = await contract.functions
      .get_user_stakes_info_per_pool(bn("0"))
      .txParams({ gasPrice: 1 })
      .call();
    console.log(value);
  }

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
    userDetails();
    //poolDetails();
    // totalDeposits();
    allPoolDetails();
  }, []);

  // return (
  //   <div classNameNameName="App">
  //     <h4>Staking Pools</h4>
  //     <table classNameNameName="Pools">
  //       <tr>
  //         <th>Pool ID</th>
  //         <th>Pool Name</th>
  //         <th>APY</th>
  //         <th>Capacity</th>
  //         <th>Deposits</th>
  //         <th>Open</th>
  //       </tr>
  //       {stakingPoolData.map((pool) => (
  //         <p>
  //           <Link to={`pools/${pool.pool_id.toString()}`}>
  //             <tr>
  //               <td>{pool.pool_id.toString()}</td>
  //               <td>{pool.poolName}</td>
  //               <td>{pool.apy.toString()}</td>
  //               <td>{pool.depositLimiters.capacity.toString()}</td>
  //               <td>{pool.funds.balance.toString()}</td>
  //               <td>{isOpenStaking(pool.depositLimiters.endTime)}</td>
  //             </tr>
  //           </Link>
  //         </p>
  //       ))}
  //     </table>

  //     <h4>Loan Pools</h4>

  //     <table classNameNameName="Pools">
  //       <tr>
  //         <th>Pool ID</th>
  //         <th>Pool Name</th>
  //         <th>APY</th>
  //         <th>Capacity</th>
  //         <th>Loaned</th>
  //         <th>Deposits</th>
  //       </tr>
  //       {loanPoolData.map((pool) => (
  //         //TODO: Fix this... Why are the pool IDs off by 1?
  //         <p>
  //           <Link to={`pools/${(Number(pool.pool_id) - 1).toString()}`}>
  //             <tr>
  //               <td>{pool.pool_id.toString()}</td>
  //               <td>{pool.poolName}</td>
  //               <td>{pool.apy.toString()}</td>
  //               <td>{pool.depositLimiters.capacity.toString()}</td>
  //               <td>{pool.funds.loanedBalance.toString()}</td>
  //               <td>{pool.funds.balance.toString()}</td>
  //             </tr>
  //           </Link>
  //         </p>
  //       ))}
  //     </table>

  //   </div>

  // );
  return (
    <main className="main" id="blur">
      <section className="hero-section position-relative">
        <div className="header-img">
          <img
            src={
              process.env.PUBLIC_URL + "/image/app-page-image/header-img.svg"
            }
            alt=""
          />
        </div>
        <div className="header-left-blur-img">
          <img
            src={
              process.env.PUBLIC_URL +
              "/image/app-page-image/header-left-blur-img.svg"
            }
            alt=""
          />
        </div>
        <div className="container ">
          <div className="row">
            <div className="col-12">
              <div className="stable-text">
                <h1
                  data-aos="fade-up"
                  data-aos-anchor-placement="center-bottom"
                  data-aos-duration="1000"
                >
                  Stable
                </h1>
                <p
                  data-aos="fade-up"
                  data-aos-anchor-placement="center-bottom"
                  data-aos-duration="1100"
                >
                  Acumen uses Defi to power microfinance globally. Acumen
                  bridges crypto and Traditional assets to provide a stable,
                  uncorrelated yield to the Acumen community, enabling lower
                  cost for capital to Small and Medium Enterprises (SMEs).
                </p>
              </div>
              <div className="pool-info-text">
                <h1
                  data-aos="fade-up"
                  data-aos-anchor-placement="center-bottom"
                  data-aos-duration="1200"
                >
                  Pool <span className="text-color-gradient-title ">Info</span>
                </h1>
                <div className="pool-info-grid">
                  <div
                    className="position-relative"
                    data-aos="fade-up"
                    data-aos-anchor-placement="center-bottom"
                    data-aos-duration="1400"
                  >
                    <div className="subtract">
                      <img
                        src={
                          process.env.PUBLIC_URL +
                          "/image/app-page-image/Subtract.svg"
                        }
                        alt=""
                      />
                    </div>
                    <div className="pool-info-inner-text">
                      <span>Total supplied</span>
                      <p id="TotalSupplied"></p>
                    </div>
                  </div>
                  <div
                    className="position-relative"
                    data-aos="fade-up"
                    data-aos-anchor-placement="center-bottom"
                    data-aos-duration="1400"
                  >
                    <div className="subtract">
                      <img
                        src={
                          process.env.PUBLIC_URL +
                          "/image/app-page-image/Subtract.svg"
                        }
                        alt=""
                      />
                    </div>
                    <div className="pool-info-inner-text-2">
                      <span>Highest APY</span>
                      <p id="HighestAPY"></p>
                    </div>
                  </div>
                  <div
                    className="position-relative"
                    data-aos="fade-up"
                    data-aos-anchor-placement="center-bottom"
                    data-aos-duration="1400"
                  >
                    <div className="subtract">
                      <img
                        src={
                          process.env.PUBLIC_URL +
                          "/image/app-page-image/Subtract.svg"
                        }
                        alt=""
                      />
                    </div>
                    <div className="pool-info-inner-text-3">
                      <span>Pools full</span>
                      <p id="PollsFull"></p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className="header-right-blur-img">
          <img
            src={
              process.env.PUBLIC_URL +
              "/image/app-page-image/header-right-blur-img.svg"
            }
            alt=""
          />
        </div>
      </section>

      <section className="senior-pool-padding position-relative">
        <div className="container ">
          <div className="row">
            <div className="col-12">
              <div
                className="pools-text"
                data-aos="fade-up"
                data-aos-anchor-placement="center-bottom"
                data-aos-duration="1000"
              >
                <h1>Pools</h1>
              </div>
            </div>
          </div>
          <div className="row pool-margin-top">
            <div className="col-12">
              <div className="pools-text-inner">
                <h1
                  data-aos="fade-up"
                  data-aos-anchor-placement="center-bottom"
                  data-aos-duration="1200"
                >
                  Dept <span className="text-color-gradient-title ">Pool</span>
                </h1>
                <p
                  data-aos="fade-up"
                  data-aos-anchor-placement="center-bottom"
                  data-aos-duration="1300"
                >
                  The Senior Pool automatically diversifies capital across
                  Borrower Pools with no maturity
                </p>
              </div>
            </div>
          </div>
          <div
            className="row"
            data-aos="fade-up"
            data-aos-anchor-placement="center-bottom"
            data-aos-duration="1400"
          >
            <div className="col-12">
              <div className="card-body">
                <div className="row">
                  <div className="col-sm-12">
                    <div className="table-responsive">
                      <table className="table align-middle datatable ">
                        <thead>
                          <tr role="row" className="color">
                            <th rowSpan={1} colSpan={1} className="table-img">
                              Pool
                            </th>
                            <th rowSpan={1} colSpan={1}>
                              Stable APY
                            </th>
                            <th rowSpan={1} colSpan={1}>
                              Lockup Period
                            </th>
                            <th rowSpan={1} colSpan={1}>
                              Your Balance
                            </th>
                            <th rowSpan={1} colSpan={1}>
                              Status
                            </th>
                          </tr>
                        </thead>
                        <tbody id="listSeniorPool">
                          {stakingPoolData.map((pool) => (
                            <tr className="odd">
                              <td className="">
                                <div className="d-flex align-items-center">
                                  <div className="borrower-pool-img-wrap profile-img me-2">
                                    <img
                                      src={
                                        process.env.PUBLIC_URL +
                                        "/image/wallet_icon.svg"
                                      }
                                      alt=""
                                    />
                                  </div>
                                  {pool.poolName}
                                </div>
                              </td>
                              <td>{pool.apy.toString()}%</td>
                              <td>Duration</td>
                              <td>
                                <strong id="balance-display-${i}">
                                  Test Token
                                </strong>
                              </td>
                              <td>
                                {isOpenStaking(pool.depositLimiters.endTime)}
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div className="pool-right-blur-img">
          <img
            src={
              process.env.PUBLIC_URL +
              "/image/app-page-image/pool-right-blur-img.svg"
            }
            alt=""
          />
        </div>
      </section>

      <section className="borrower-pool-padding position-relative">
        <div className="container ">
          <div className="row">
            <div className="col-12">
              <div className="pools-text-inner">
                <h1
                  data-aos="fade-up"
                  data-aos-anchor-placement="center-bottom"
                  data-aos-duration="1000"
                >
                  Borrower{" "}
                  <span className="text-color-gradient-title ">Pool</span>
                </h1>
                <p
                  data-aos="fade-up"
                  data-aos-anchor-placement="center-bottom"
                  data-aos-duration="1100"
                >
                  The Active APY pool, earn higher APY by lending directly to
                  borrowers and submitting to the maturity period.
                </p>
              </div>
            </div>
          </div>
          <div
            className="row"
            data-aos="fade-up"
            data-aos-anchor-placement="center-bottom"
            data-aos-duration="1200"
          >
            <div className="col-12">
              <div className="card-body">
                <div className="row">
                  <div className="col-sm-12">
                    <div className="table-responsive">
                      <table className="table align-middle datatable ">
                        <thead>
                          <tr role="row" className="color">
                            <th rowSpan={1} colSpan={1} className="table-img">
                              Pool
                            </th>
                            <th rowSpan={1} colSpan={1}>
                              Stable APY
                            </th>
                            <th rowSpan={1} colSpan={1}>
                              Lockup Period
                            </th>
                            <th rowSpan={1} colSpan={1}>
                              Your Balance
                            </th>
                            <th rowSpan={1} colSpan={1}>
                              Status
                            </th>
                          </tr>
                        </thead>
                        <tbody id="listPoolBorrower">
                        {loanPoolData.map((pool) => (
                            <tr className="odd">
                              <td className="">
                                <div className="d-flex align-items-center">
                                  <div className="borrower-pool-img-wrap profile-img me-2">
                                    <img
                                      src={
                                        process.env.PUBLIC_URL +
                                        "/image/wallet_icon.svg"
                                      }
                                      alt=""
                                    />
                                  </div>
                                  {pool.poolName}
                                </div>
                              </td>
                              <td>{pool.apy.toString()}%</td>
                              <td>Duration</td>
                              <td>
                                <strong id="balance-display-${i}">
                                  Test Token
                                </strong>
                              </td>
                              <td>
                                {isOpenStaking(pool.depositLimiters.endTime)}
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className="borrow-left-blur-img">
          <img
            src={
              process.env.PUBLIC_URL +
              "/image/app-page-image/borrow-left-blur-img.svg"
            }
            alt=""
          />
        </div>
      </section>
    </main>
  );
}

export default Home;
