    <!-- ======= Header ======= -->
    <header id="header" class="header fixed-top d-flex align-items-center">
        <div class="container align-header">

            <a href="">
                <span class="logo navLogo"><a href="index"><img src="./assets/image/logo.png"
                            width="150px"></a></span>

            </a>

            <nav id="navbar" class="navbar">
                <ul>
              
                    <li><a href="https://docs.acumen.network/">Docs </a></li>
                    <li><a href="https://tribeca.so/gov/acm/">Governance </a></li>
                    <li><a href="#mission">Vision</a></li>
                    <li><a href="faq.php">FAQ </a></li>
                    <li><a href="https://app.atrix.finance/liquidity/8SQCVgTFJPWTrRJzF5nnPoaRff6vvqAqm1kxZaeFxXc2/deposit">Staking</a></li>
                    <li class="app-btn"><a class="Connect" href="home">App</a></li>
    
                    
                </ul>
            </nav><!-- .navbar -->
            <?php if($connectpage==0){ ?>
                <a href="home" class="header-btn Connect">App</a>
            <?php }else { ?>
                <a class="header-btn header-connect-btn" href="javascript:void(0)" id="myBtn2" >Connect</a>
            <?php } ?>
            <i class="mobile-nav-toggle mobile-nav-show bi bi-list"></i>
            <i class="mobile-nav-toggle mobile-nav-hide d-none bi bi-x"></i>

        </div>
    </header>
    <!-- End Header -->
