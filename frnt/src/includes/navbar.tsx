import "../assets/css/app-page.css";
import "../assets/css/bootstrap.min.css";
import "../assets/css/style.css";
import "../assets/css/responsive.css";

//TODO: Fix CSS

function Navbar() {
  return (
    <header id="header" className="header fixed-top d-flex align-items-center">
      <div className="container align-header">
        <a href="">
          <span className="logo navLogo">
            <a href="index">
              <img src={process.env.PUBLIC_URL + "/image/logo.png"} alt=""  width="150px"/>
            </a>
          </span>
        </a>

        <nav id="navbar" className="navbar">
          <ul>
            <li>
              <a href="https://docs.acumen.network/">Docs </a>
            </li>
            <li>
              <a href="https://tribeca.so/gov/acm/">Governance </a>
            </li>
            <li>
              <a href="#mission">Vision</a>
            </li>
            <li>
              <a href="faq.php">FAQ </a>
            </li>
            <li>
              <a href="">
                Staking
              </a>
            </li>
            <li className="app-btn">
              <a className="Connect" href="home">
                App
              </a>
            </li>
          </ul>
        </nav>

        <a
          className="header-btn header-connect-btn"
          href="javascript:void(0)"
          id="myBtn2"
        >
          Connect
        </a>
        <i className="mobile-nav-toggle mobile-nav-show bi bi-list"></i>
        <i className="mobile-nav-toggle mobile-nav-hide d-none bi bi-x"></i>
      </div>
    </header>
  );
}

export default Navbar;
