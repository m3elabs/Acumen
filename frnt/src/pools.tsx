import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { AcumenAbi__factory } from "./contracts/factories/AcumenAbi__factory";
import {
  borrowTransaction,
  CONTRACT_ID,
  deposit,
  depositTransaction,
  repayTransaction,
  wallet1,
  withdraw,
  withdrawTransaction,
} from "./utils";
import { PoolInfoOutput } from "./contracts/AcumenAbi";

import "./assets/css/app-page.css";
import "./assets/css/bootstrap.min.css";
import "./assets/css/style.css";
import "./assets/css/responsive.css";
import "./assets/css/senior-pool.css";

const Pools = () => {
  const { id } = useParams();

  const contract = AcumenAbi__factory.connect(CONTRACT_ID, wallet1);

  const [poolInfo, setPoolInfo] = useState({} as PoolInfoOutput);

  const [apy, setApy] = useState("");

  const [maxUtilization, setMaxUtilization] = useState("");

  const [realPoolId, setRealPoolId] = useState('');

  const [poolAmount, setPoolAmount] = useState('');

  async function poolDetails() {
    const value1 = await contract.functions
      .get_pool_info_from_id(Number(id))
      .get();
    const { value } = value1;
    setPoolInfo(value);

    //TODO: Figure out why I have to do this. Shouldn't be necessary.
    setApy(value.apy.toString());
    setMaxUtilization(value.depositLimiters.maxUtilization.toString());
    setRealPoolId(value.pool_id.toString());
    setPoolAmount(value.funds.balance.toString());
  }

  const [value, setValue] = useState(0);

  const handleChange = (event: any) => {
    setValue(event.target.value);
  };

  const [value2, setValue2] = useState(0);

  const handleChange2 = (event: any) => {
    setValue2(event.target.value);
  };



  useEffect(() => {
    poolDetails();
  }, []);
  //TODO add repay and borrow details.
  // if (poolInfo.poolTypeIsStaking) {
    //   return (
    //     <>
    //       <div>
    //         <h1>Pool Details</h1>
    //         <h2>Pool ID: {id}</h2>
    //         <h2>Real ID: {realPoolId}</h2>
    //         <h2>Pool Name: {poolInfo.poolName}</h2>
    //         <h2>Pool Type: {poolInfo.poolTypeIsStaking ? "Staking" : "Loan"}</h2>
    //         <h2>Pool Interest: {apy}%</h2>
    //       </div>
    //       <div className="App-items">
    //         <input type="number" value={value} onChange={handleChange} />
    //         <button onClick={() => depositTransaction(value, Number(id))}>
    //           Deposit
    //         </button>
    //       </div>
    //       <div className="App-items">
    //         <input type="number" value={value2} onChange={handleChange2} />
    //         <button onClick={() => withdrawTransaction(value2, Number(id))}>
    //           Withdraw
    //         </button>
    //       </div>
    //     </>
    //   );
    // } else {
    //   return (
    //     <>
    //       <div>
    //         <h1>Pool Details</h1>
    //         <h2>Pool ID: {id}</h2>
    //         <h2>Real ID: {realPoolId}</h2>
    //         <h2>Pool Name: {poolInfo.poolName}</h2>
    //         <h2>Pool Type: {poolInfo.poolTypeIsStaking ? "Staking" : "Loan"}</h2>
    //         <h2>Pool Interest: {apy}%</h2>
    //         <h2>Pool Max Utilization: {maxUtilization}%</h2>
    //       </div>
    //       <div className="App-items">
    //         <input type="number" value={value} onChange={handleChange} />
    //         <button onClick={() => borrowTransaction(value, Number(id))}>
    //           Borrow
    //         </button>
    //       </div>
    //       <div className="App-items">
    //         <input type="number" value={value2} onChange={handleChange2} />
    //         <button onClick={() => repayTransaction(value2, Number(id))}>
    //           Repay
    //         </button>
    //       </div>
    //     </>
    //   );
    // }

    return (
      <body data-aos-easing="ease" data-aos-duration="400" data-aos-delay="0">

        <main className="main">

          <section className="hero-section position-relative">
            <div className="header-img">
              <img src="https://acumen.network/assets/image/app-page-image/header-img.svg" alt="" />
            </div>
            <div className="header-left-blur-img">
              <img src="https://acumen.network/assets/image/app-page-image/header-left-blur-img.svg" alt="" />
            </div>
            <div className="container ">
              <div className="row">
                <div className="col-12">
                  <div className="profile-align">
                    <div className="profile-img-1 aos-init aos-animate" id="imagespace" data-aos="fade-up" data-aos-anchor-placement="center-bottom" data-aos-duration="1000"> <img src="https://acumen.network/assets/image/token-icons/usdc.png" alt="" /></div>
                    <div className="profile-text aos-init aos-animate" data-aos="fade-up" data-aos-anchor-placement="center-bottom" data-aos-duration="1200">
                      <h1>Acumen Microfinance Dapp <span className="text-color-gradient-title " id="buttonsStatus"><button className="btn open"> Open </button></span></h1>

                      <h3>Name : <span className="profile-span" id="nameToken">{poolInfo.poolName}</span></h3>

                    </div>
                  </div>
                  <div>

                    <div  style={{color: "white"}} className="profile-text aos-init aos-animate" id="description" data-aos="fade-up" data-aos-anchor-placement="center-bottom" data-aos-duration="1200">   <h6>Funds are deposited with Acumen's Financial Partners to provide a stable, attractive yield to our community. Funds are locked for specified time period, if you do not withdraw during the redemption window, funds will automatically renew for another period. <span></span></h6>
                    </div>
                  </div>
                  <div className="profile-info-text">
                    <div className="profile-info-grid">
                      <div className="position-relative pool-info-img aos-init aos-animate" data-aos="fade-up" data-aos-anchor-placement="center-bottom" data-aos-duration="1400">
                        <div className="profile-subtract-img">
                          <img src="https://acumen.network/assets/image/senior-pool-page-image/profile-subtract-img.svg" alt="" />
                        </div>
                        <div className="profile-info-inner-text">
                          <span>Deposit Start</span>
                          <p id="startDate"><p>2/7/2023</p></p>

                        </div>
                      </div>
                      <div className="position-relative pool-info-img aos-init aos-animate" data-aos="fade-up" data-aos-anchor-placement="center-bottom" data-aos-duration="1400">
                        <div className="profile-subtract-img">
                          <img src="https://acumen.network/assets/image/senior-pool-page-image/profile-subtract-img-2.svg" alt="" />
                        </div>
                        <div className="profile-info-inner-text">

                          <span>Deposit End</span>
                          <p id="endDate"><p>2/8/2023</p></p>

                        </div>
                      </div>
                      <div className="position-relative pool-info-img aos-init aos-animate" data-aos="fade-up" data-aos-anchor-placement="center-bottom" data-aos-duration="1400">
                        <div className="profile-subtract-img">
                          <img src="https://acumen.network/assets/image/senior-pool-page-image/profile-subtract-img-3.svg" alt="" />
                        </div>
                        <div className="profile-info-inner-text">
                          <span>Pool Type</span>
                          <p id="typePool">Short Term</p>
                        </div>
                      </div>
                    </div>


                  </div>
                </div>
              </div>
            </div>
            <div className="header-right-blur-img">
              <img src="https://acumen.network/assets/image/app-page-image/header-right-blur-img.svg" alt="" />
            </div>
          </section>


          <section className="">
            <div className="black-bg-section">
              <div className="container">
                <div className="row">
                  <div className="col-xl-6 col-lg-6">
                    <div className="token-text-col-1">
                      <div className="token-text aos-init aos-animate" style={{ borderBottom: "2px solid #281D32" }} data-aos="fade-up" data-aos-anchor-placement="center-bottom" data-aos-duration="1000">
                        <h3>Total Tokens Locked</h3>
                        <span id="totalTokensLocked">{poolAmount}</span>
                      </div>
                      <div className="token-text aos-init aos-animate" style={{ borderBottom: "2px solid #281D32" }} data-aos="fade-up" data-aos-anchor-placement="center-bottom" data-aos-duration="1100">
                        <h3>Maximun Deposit</h3>
                        <span id="maximunDeposit">1,000,000 USDC</span>
                      </div>
                      <div className="token-text aos-init aos-animate" style={{ borderBottom: "2px solid #281D32" }} data-aos="fade-up" data-aos-anchor-placement="center-bottom" data-aos-duration="1200">
                        <h3>Pool Capacity</h3>
                        <span id="poolCapacity">3,500,000 USDC</span>
                      </div>
                      <div className="token-text aos-init" style={{ borderBottom: "2px solid #281D32" }} data-aos="fade-up" data-aos-anchor-placement="center-bottom" data-aos-duration="1300">
                        <h3>APY</h3>
                        <span id="poolApy">{apy}%</span>

                      </div>
                      <div className="token-text aos-init" data-aos="fade-up" data-aos-anchor-placement="center-bottom" data-aos-duration="1400">
                        <h3>Pool Users</h3>
                        <span className="token-bg " id="TotalUser">+1</span>
                      </div>
                    </div>
                  </div>

                  <div className="col-xl-6 col-lg-6">
                    <div className="token-text-col-2">
                      <div className="label-bar aos-init aos-animate" data-aos="fade-up" data-aos-anchor-placement="center-bottom" data-aos-duration="1000">
                        <label className="label d-flex justify-content-between">Pool Completion<span id="percentageBar">0%</span></label>
                        <div className="progress-1">
                          <div className="progress-bar-1 progress-backg-purple" id="listpercentage"><div className="progress">
                            <div className="progress-bar progress-bar-striped progress-bar-animated" role="progressbar"  aria-label={"Animated striped example"} aria-valuenow={75} aria-valuemin={0} aria-valuemax={100} style={{ width: "0%" }}></div>
                          </div></div>
                        </div>
                      </div>
                      <div className="input-line-1 aos-init" data-aos="fade-up" data-aos-anchor-placement="center-bottom" data-aos-duration="1100">

                        <div className="balance-form-area position-relative">
                          <input onChange={handleChange} type="text" id="stake-input" placeholder="0" className="pool-emil-input" />
                          <span className="input-text" id="max" style={{ cursor: "pointer" }}>MAX</span>
                          <div onClick={() => deposit("hi")} className="white-shape-small approve bg-button-stake button-send pool-submit-btn mt-4" id="stake-button"><input type="submit" value="Stake" /></div>
                          <div onClick={() => withdraw("hi")} className="white-shape-small approve bg-button-stake button-send pool-submit-btn mt-4" id="stake-button2"><input type="submit" value="Withdraw" /></div>
          
                        </div>
                      </div>
                    </div>

                  </div>
                </div>
                <div className="row senior-pool-table aos-init aos-animate" data-aos="fade-up" data-aos-anchor-placement="center-bottom" data-aos-duration="1600" id="stakes-list-container" style={{ display: "none" }}>
                  <div className="col-12">
                    <div className="card-body">
                      <div className="row">
                        <div className="col-sm-12">
                          <div className="table-responsive">
                            <table className="table align-middle datatable " id="stakes-list">
                              <thead>
                                <tr role="row" className="color">
                                  <th rowSpan={1} colSpan={1}>S.no</th>
                                  <th rowSpan={1} colSpan={1}>Start</th>
                                  <th rowSpan={1} colSpan={1}>Locked</th>
                                  <th rowSpan={1} colSpan={1}>Accumulated Interest</th>
                                  <th rowSpan={1} colSpan={1}>Status</th>
                                </tr>
                              </thead>
                              <tbody>
                              </tbody>
                            </table>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div className="leaderboard pt-5 pb-5" id="stakes-error-container">
                  <div className="container">
                    <div className="row">
                      <div className="col">
                       
                       
                      </div>
                    </div>
                  </div></div>
              </div>
            </div>
          </section>

        </main>
        <div id="loadingdiv" className="d-none" style={{ position: "fixed", top: "0", left: "0", width: "100%", height: "100%", zIndex: "2000" }}>
          <div className="" style={{ display: "flex", justifyContent: "center", alignContent: "center", flexDirection: "column", width: "100%", height: "100vh", backdropFilter: "blur(10px)", backgroundColor: "#0d0d0db8" }}>
            <img src="https://acumen.network/assets/img/rings.svg" className="rounded-pill" width="105px" height="105px" />
            <h3 className="text-white">Transaction in progress. Please wait and do not refresh the page.</h3>
          </div>
        </div>


        <script src="pool.js?v=1674845255"></script>

        <footer className="footer">
          <div className="container">
            <div className="row">
              <div className="col-xl-3 col-md-6">
                <div>
                  <ul className="footer-text">
                    <h2>Find us on</h2>
                    <li>
                      <a href="https://www.coingecko.com/en/coins/acumen">CoinGecko</a>
                    </li>
                    <li>
                      <a href="https://coinmarketcap.com/">CoinMarketCap</a>
                    </li>
                    <li>
                      <a href="https://defillama.com/">DeFi Llama</a>
                    </li>

                  </ul>
                </div>
              </div>
              <div className="col-xl-3 col-md-6">
                <div className="second-data-text">
                  <ul className="footer-text">
                    <h2>Protocol</h2>
                    <li>
                      <a href="https://docs.acumen.network/">Docs</a>
                    </li>
                    <li>
                      <a href="https://tribeca.so/gov/acm/">Governance</a>
                    </li>
                  </ul>
                </div>
              </div>
              <div className="col-xl-6 col-md-6">
                <div className="right-footer-text">
                  <h2>Follow us</h2>
                  <div className="footer-icon">
                    <a href="https://discord.gg/UXDnngxRmn"><img src="https://acumen.network/assets/image/footer-discord-1.svg" alt="" /> </a>
                    <a href="https://acumenofficial.medium.com/"><img src="https://acumen.network/assets/image/footer-medium.svg" alt="" /> </a>
                    <a href="https://t.me/AcumenOfficial"><img src="https://acumen.network/assets/image/footer-telegram.svg" alt="" />
                    </a><a href="https://twitter.com/acumenofficial"> <img src="https://acumen.network/assets/image/footer-twitter.svg" alt="" /></a>
                  </div>
                </div>

              </div>
            </div>
          </div>
        </footer>

        <a href="#" className="scroll-top d-flex align-items-center justify-content-center active"><i className="bi bi-arrow-up-short"></i></a>


        <div className="modal fade" id="staticBackdrop" data-bs-keyboard="false" aria-labelledby="staticBackdropLabel" aria-hidden="true">
          <div className="modal-dialog">
            <div className="modal-content position-modal modal-content-bg">
              <div className="modal-header content-header-modal justify-content-center">

                <h2 className="dashboard text-center mb-0" id="staticBackdropLabel">Wallet Manager</h2>

              </div>
              <div className="modal-body popup-5 dashboard-text">

                <div id="listBalance">
                  <div className="content-info-balance">
                  </div>
                </div>
                <div>
                  <br />

                  <div id="ListTotalGrowth">

                  </div>
                </div>

                <hr />
                <div className="container-footer">
                  <div className="popup-btn-mt disconnect-wallet-btn">
                    <button className="text-disconnect w-100" >Disconnect Wallet</button>
                  </div>
                </div>

              </div>

            </div>
          </div>
        </div>
        <div className="modal fade" id="exampleModal" tabIndex={-1} aria-labelledby="exampleModalLabel" aria-hidden="true">
          <div className="modal-dialog">
            <div className="modal-content">
              <div className="modal-header">
                <h5 className="modal-title" id="exampleModalLabel">Connect Wallet</h5>
                <button type="button" className="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div className="modal-body">
                <div className="wallet-text">
                  <p>By connecting your wallet, you agree to our <br />
                    Terms of Service and Privacy Policy</p>
                  <div className=" popup-btn-mb but-modal" id="walletConnect" data-bs-dismiss="modal" aria-label="Close">
                    <div color="primary" className="popup-btn sc-gtsrHT GXQFF">WalletConnect
                      <img src="https://acumen.network/assets/image/popup-image/wallet-icon.svg" alt="" /></div>

                  </div>
                  <div className="but-modal" id="metamask" data-bs-dismiss="modal" aria-label="Close">
                    <div color="primary" className="popup-btn sc-gtsrHT GXQFF">Metamask
                      <img src="https://acumen.network/assets/image/popup-image/metamask-icon.svg" alt="" /></div>

                  </div>

                </div>
              </div>
            </div>
          </div>

          <script src="https://acumen.network/assets/js/jquery-3.6.0.min.js"></script>
          <script src="https://acumen.network/assets/js/bootstrap.min.js"></script>
          <script src="https://acumen.network/assets/js/custom.js"></script>
          <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>

          <script src="https://acumen.network/assets/js/jquery-3.2.1.slim.min.js"></script>


          <script src="https://acumen.network/assets/js/owl.carousel.min.js"></script>


          <script type="text/javascript" src="https://unpkg.com/web3@1.2.11/dist/web3.min.js"></script>
          <script type="text/javascript" src="https://unpkg.com/web3modal@1.9.0/dist/index.js"></script>
          <script type="text/javascript" src="https://unpkg.com/evm-chains@0.2.0/dist/umd/index.min.js"></script>
          <script type="text/javascript" src="https://unpkg.com/@walletconnect/web3-provider@1.7.1/dist/umd/index.min.js"></script>
          <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
          <script src="./scripts/contract.js?v=1674845296"></script>
          <script src="./scripts/connect.js?v=1674845287"></script>
          <script src="index.js?v=1674845269"></script>
          {/* <script>
        AOS.init({

        });
    </script> */}

        </div></body>




    )

  };



  export default Pools;
