
document.addEventListener('DOMContentLoaded', () => {
  "use strict";




  /**
   * Navbar links active state on scroll
   */
  let navbarlinks = document.querySelectorAll('#navbar a');

  function navbarlinksActive() {
    navbarlinks.forEach(navbarlink => {

      if (!navbarlink.hash) return;

      let section = document.querySelector(navbarlink.hash);
      if (!section) return;

      let position = window.scrollY + 200;

      if (position >= section.offsetTop && position <= (section.offsetTop + section.offsetHeight)) {
        navbarlink.classList.add('active');
      } else {
        navbarlink.classList.remove('active');
      }
    })
  }
  window.addEventListener('load', navbarlinksActive);
  document.addEventListener('scroll', navbarlinksActive);

  /**
   * Mobile nav toggle
   */
  const mobileNavShow = document.querySelector('.mobile-nav-show');
  const mobileNavHide = document.querySelector('.mobile-nav-hide');

  document.querySelectorAll('.mobile-nav-toggle').forEach(el => {
    el.addEventListener('click', function (event) {
      event.preventDefault();
      mobileNavToogle();
    })
  });

  function mobileNavToogle() {
    document.querySelector('body').classList.toggle('mobile-nav-active');
    mobileNavShow.classList.toggle('d-none');
    mobileNavHide.classList.toggle('d-none');
  }

  /**
   * Hide mobile nav on same-page/hash links
   */
  document.querySelectorAll('#navbar a').forEach(navbarlink => {

    if (!navbarlink.hash) return;

    let section = document.querySelector(navbarlink.hash);
    if (!section) return;

    navbarlink.addEventListener('click', () => {
      if (document.querySelector('.mobile-nav-active')) {
        mobileNavToogle();
      }
    });

  });

  /**
   * Toggle mobile nav dropdowns
   */
  const navDropdowns = document.querySelectorAll('.navbar .dropdown > a');

  navDropdowns.forEach(el => {
    el.addEventListener('click', function (event) {
      if (document.querySelector('.mobile-nav-active')) {
        event.preventDefault();
        this.classList.toggle('active');
        this.nextElementSibling.classList.toggle('dropdown-active');

        let dropDownIndicator = this.querySelector('.dropdown-indicator');
        dropDownIndicator.classList.toggle('bi-chevron-up');
        dropDownIndicator.classList.toggle('bi-chevron-down');
      }
    })
  });


  // tabs section javascript

  $(document).ready(function () {
    $('.tabs .tab-links a').on('click', function (e) {
      var currentAttrValue = $(this).attr('href');

      // Show/Hide Tabs
      $('.tabs ' + currentAttrValue).fadeIn(400).siblings().hide();
      // Change/remove current tab to active
      $(this).parent('li').addClass('active').siblings().removeClass('active');

      e.preventDefault();
    });
  });



  //when scroll down navbar hidden and scroll up navbar show

  let scroll1 = window.pageYOffset;
  window.onscroll = function () {
    let scroll2 = window.pageYOffset;
    if (scroll1 > scroll2) {
      document.querySelector('header').style.top = '0';
    }
    else {
      document.querySelector('header').style.top = '-90px';
    }

    scroll1 = scroll2;
  };

  /**
     * Scroll top button
     */
  const scrollTop = document.querySelector('.scroll-top');
  if (scrollTop) {
    const togglescrollTop = function () {
      window.scrollY > 100 ? scrollTop.classList.add('active') : scrollTop.classList.remove('active');
    }
    window.addEventListener('load', togglescrollTop);
    document.addEventListener('scroll', togglescrollTop);
    scrollTop.addEventListener('click', window.scrollTo({
      top: 0,
      behavior: 'smooth'
    }));
  }

  // owlCarousel js section

  $('.owl-carousel').owlCarousel({
    loop: true,
    margin: 10,
    dots: true,
    nav: true,
    autoplay: true,
    autoplayTimeout: 2000,
    autoplayHoverPause: true,

    responsive: {
      320: {
        items: 1
      },
      375: {
        items: 1
      },
      412: {
        items: 1
      },
      425: {
        items: 1
      },
      768: {
        items: 1
      },
      1024: {
        items: 2
      },
      1440: {
        items: 3
      }
    }
  })


// click menu scroll that section js

  $(function () {
    $(".navigation li a").on('click', function () {
      $("html, body").animate({
        scrollTop: $($.attr(this, 'href')).offset().top
      }, 1500);
    });
  });



});

 
  //terms and condition popup js

$(function () {
    $("#teamAndCondition").modal("show");
    $(".hide-btn").hide();
});
function closeModal(){
    $("#teamAndCondition").modal("hide");

}


//terms and condition popup buttons js

$(function () {
  $("#flexCheckDefault").click(function () {
      if ($(this).is(":checked")) {
          $(".hide-btn").show();
          $(".show-btn").hide();
      } else {
          $(".hide-btn").hide();
          $(".show-btn").show();
      }
  });
});

