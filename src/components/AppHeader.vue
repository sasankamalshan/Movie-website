<template>
  <header class="header" :class="{ 'mobile-menu-open': isMobileMenuOpen, 'scrolled': isScrolled }" ref="header">
    <div class="container">
      <div class="header-content">
        <!-- Logo -->
        <div class="logo" ref="logo">
          <a href="#" class="logo-link">
            <div class="logo-icon" ref="logoIcon">
              <img 
                src="/src/assets/images/Logo White.svg" 
                class="logo-image"
                width="200" 
                height="100"
              />
            </div>
          </a>
        </div>

        <!-- Desktop Navigation -->
        <nav class="nav-desktop d-none d-lg-block" ref="navDesktop">
          <ul class="nav-list">
            <li class="nav-item" ref="navItem1">
              <a @click.prevent="navigate('HOME')" href="#" class="nav-link" :class="{ 'active': currentPage === 'HOME' }">
                <span class="nav-text">HOME</span>
                <span class="nav-indicator"></span>
              </a>
            </li>
            <li class="nav-item" ref="navItem2">
              <a @click.prevent="navigate('OUR SCREENS')" href="#" class="nav-link" :class="{ 'active': currentPage === 'OUR SCREENS' }">
                <span class="nav-text">OUR SCREENS</span>
                <span class="nav-indicator"></span>
              </a>
            </li>
            <li class="nav-item" ref="navItem3">
              <a @click.prevent="navigate('SCHEDULE')" href="#" class="nav-link" :class="{ 'active': currentPage === 'SCHEDULE' }">
                <span class="nav-text">SCHEDULE</span>
                <span class="nav-indicator"></span>
              </a>
            </li>
            <li class="nav-item" ref="navItem4">
              <a @click.prevent="navigate('MOVIE LIBRARY')" href="#" class="nav-link" :class="{ 'active': currentPage === 'MOVIE LIBRARY' }">
                <span class="nav-text">MOVIE LIBRARY</span>
                <span class="nav-indicator"></span>
              </a>
            </li>
            <li class="nav-item" ref="navItem5">
              <a @click.prevent="navigate('LOCATION & CONTACT')" href="#" class="nav-link" :class="{ 'active': currentPage === 'LOCATION & CONTACT' }">
                <span class="nav-text">LOCATION & CONTACT</span>
                <span class="nav-indicator"></span>
              </a>
            </li>
          </ul>
        </nav>

        <!-- Mobile Menu Button -->
        <button 
          class="hamburger d-lg-none"
          @click="toggleMenu"
          :class="{ 'is-active': isMobileMenuOpen }"
          aria-label="Toggle navigation menu"
          ref="hamburger"
        >
          <span class="hamburger-line"></span>
          <span class="hamburger-line"></span>
          <span class="hamburger-line"></span>
        </button>
      </div>

      <!-- Mobile Navigation -->
      <nav class="nav-mobile d-lg-none" :class="{ 'is-open': isMobileMenuOpen }" ref="navMobile">
        <ul class="nav-list-mobile">
          <li class="nav-item-mobile" ref="mobileItem1">
            <a @click.prevent="navigate('HOME')" href="#" class="nav-link-mobile">
              <span class="mobile-nav-icon">🏠</span>
              <span class="mobile-nav-text">HOME</span>
            </a>
          </li>
          <li class="nav-item-mobile" ref="mobileItem2">
            <a @click.prevent="navigate('OUR SCREENS')" href="#" class="nav-link-mobile">
              <span class="mobile-nav-icon">🎥</span>
              <span class="mobile-nav-text">OUR SCREENS</span>
            </a>
          </li>
          <li class="nav-item-mobile" ref="mobileItem3">
            <a @click.prevent="navigate('SCHEDULE')" href="#" class="nav-link-mobile">
              <span class="mobile-nav-icon">📅</span>
              <span class="mobile-nav-text">SCHEDULE</span>
            </a>
          </li>
          <li class="nav-item-mobile" ref="mobileItem4">
            <a @click.prevent="navigate('MOVIE LIBRARY')" href="#" class="nav-link-mobile">
              <span class="mobile-nav-icon">🎬</span>
              <span class="mobile-nav-text">MOVIE LIBRARY</span>
            </a>
          </li>
          <li class="nav-item-mobile" ref="mobileItem5">
            <a @click.prevent="navigate('LOCATION & CONTACT')" href="#" class="nav-link-mobile">
              <span class="mobile-nav-icon">📍</span>
              <span class="mobile-nav-text">LOCATION & CONTACT</span>
            </a>
          </li>
        </ul>
      </nav>
    </div>

    <!-- Background Elements -->
    <div class="header-bg-elements" ref="headerBgElements">
      <div class="bg-shape bg-shape-1"></div>
      <div class="bg-shape bg-shape-2"></div>
    </div>
  </header>
</template>

<script>
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'

gsap.registerPlugin(ScrollTrigger)

export default {
  name: 'AppHeader',
  props: {
    isMobileMenuOpen: {
      type: Boolean,
      default: false
    },
    currentPage: {
      type: String,
      default: 'HOME'
    }
  },
  data() {
    return {
      isScrolled: false
    }
  },
  mounted() {
    this.initializeAnimations()
    this.setupScrollListener()
  },
  beforeUnmount() {
    window.removeEventListener('scroll', this.handleScroll)
  },
  methods: {
    initializeAnimations() {
      // Set initial states
      gsap.set(this.$refs.header, { y: 0, opacity: 1 })
      // Logo elements are immediately visible without animation
      gsap.set(this.$refs.logoIcon, { rotation: 0, scale: 1, opacity: 1 })
      
      // Header entrance animation
      const headerTl = gsap.timeline({ delay: 0.2 })
      
      headerTl.to(this.$refs.header, {
        y: 0,
        opacity: 1,
        duration: 0.8,
        ease: "power3.out"
      })

      // Stagger nav items
      const navItems = [
        this.$refs.navItem1, this.$refs.navItem2,
        this.$refs.navItem3, this.$refs.navItem4, this.$refs.navItem5
      ].filter(item => item)

      if (navItems.length > 0) {
        gsap.set(navItems, { y: -20, opacity: 0 })
        headerTl.to(navItems, {
          y: 0,
          opacity: 1,
          duration: 0.5,
          stagger: 0.08,
          ease: "power2.out"
        }, "-=0.3")
      }

      // Hamburger animation
      if (this.$refs.hamburger) {
        gsap.set(this.$refs.hamburger, { scale: 0, rotation: 180 })
        headerTl.to(this.$refs.hamburger, {
          scale: 1,
          rotation: 0,
          duration: 0.4,
          ease: "back.out(1.7)"
        }, "-=0.4")
      }

      // Background elements
      this.animateBackgroundElements()
      
      // Setup hover animations
      this.setupHoverAnimations()
    },

    animateBackgroundElements() {
      const shapes = this.$refs.headerBgElements?.querySelectorAll('.bg-shape')
      if (shapes) {
        shapes.forEach((shape, index) => {
          gsap.set(shape, { scale: 0, opacity: 0.3 })
          gsap.to(shape, {
            scale: 1,
            duration: 1.5,
            delay: index * 0.4,
            ease: "power2.out"
          })

          // Floating animation
          gsap.to(shape, {
            y: -8,
            x: index % 2 === 0 ? 4 : -4,
            duration: 3 + index,
            ease: "sine.inOut",
            yoyo: true,
            repeat: -1
          })
        })
      }
    },

    setupHoverAnimations() {
      // Desktop nav links
      const navLinks = this.$refs.navDesktop?.querySelectorAll('.nav-link')
      if (navLinks) {
        navLinks.forEach(link => {
          const indicator = link.querySelector('.nav-indicator')
          
          link.addEventListener('mouseenter', () => {
            gsap.to(indicator, {
              scaleX: 1,
              duration: 0.3,
              ease: "power2.out"
            })
            gsap.to(link.querySelector('.nav-text'), {
              y: -2,
              duration: 0.3,
              ease: "power2.out"
            })
          })

          link.addEventListener('mouseleave', () => {
            gsap.to(indicator, {
              scaleX: 0,
              duration: 0.3,
              ease: "power2.out"
            })
            gsap.to(link.querySelector('.nav-text'), {
              y: 0,
              duration: 0.3,
              ease: "power2.out"
            })
          })
        })
      }
    },

    setupScrollListener() {
      window.addEventListener('scroll', this.handleScroll, { passive: true })
    },

    handleScroll() {
      this.isScrolled = window.scrollY > 50
    },

    toggleMenu() {
      this.$emit('toggle-menu')
      
      if (!this.isMobileMenuOpen) {
        // Opening mobile menu
        this.animateMobileMenuOpen()
      } else {
        // Closing mobile menu
        this.animateMobileMenuClose()
      }
    },

    animateMobileMenuOpen() {
      const mobileItems = [
        this.$refs.mobileItem1, this.$refs.mobileItem2,
        this.$refs.mobileItem3, this.$refs.mobileItem4, this.$refs.mobileItem5
      ].filter(item => item)

      gsap.set(mobileItems, { x: -80, opacity: 0 })
      
      gsap.to(this.$refs.navMobile, {
        height: 'auto',
        duration: 0.3,
        ease: "power2.out"
      })

      gsap.to(mobileItems, {
        x: 0,
        opacity: 1,
        duration: 0.3,
        stagger: 0.08,
        delay: 0.15,
        ease: "back.out(1.7)"
      })
    },

    animateMobileMenuClose() {
      const mobileItems = [
        this.$refs.mobileItem1, this.$refs.mobileItem2,
        this.$refs.mobileItem3, this.$refs.mobileItem4, this.$refs.mobileItem5
      ].filter(item => item)

      gsap.to(mobileItems, {
        x: -80,
        opacity: 0,
        duration: 0.2,
        stagger: 0.04,
        ease: "power2.in"
      })

      gsap.to(this.$refs.navMobile, {
        height: 0,
        duration: 0.2,
        delay: 0.15,
        ease: "power2.inOut"
      })
    },

    closeMenu() {
      if (this.isMobileMenuOpen) {
        this.$emit('toggle-menu')
      }
    },

    navigate(page) {
      this.$emit('navigate', page)
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../assets/styles/variables.scss';

.header {
  position: relative; /* Changed from fixed to relative to scroll with page */
  left: 0;
  right: 0;
  z-index: 1000;
  background: rgba(10, 10, 10, 0.95);
  backdrop-filter: blur(15px);
  -webkit-backdrop-filter: blur(15px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.3s ease;
  direction: ltr; /* Ensure LTR layout */

  &.scrolled {
    background: rgba(10, 10, 10, 0.98);
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
  }

  .header-content {
    display: flex;
    align-items: safe center; /* Changed to stretch for better alignment */
    justify-content: space-between;
    padding: 0 1rem; /* Reduced padding */
    direction: ltr; /* Ensure LTR layout */
  }

  // Background Elements
  .header-bg-elements {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    pointer-events: none;
    overflow: hidden;
    z-index: -1;

    .bg-shape {
      position: absolute;
      border-radius: 50%;
      background: linear-gradient(45deg, rgba(229, 9, 20, 0.1), rgba(255, 215, 0, 0.1));
      filter: blur(1px);

      &.bg-shape-1 {
        width: 80px; /* Reduced size */
        height: 80px;
        top: -40px;
        right: 10%;
        animation: float1 6s ease-in-out infinite;
      }

      &.bg-shape-2 {
        width: 50px; /* Reduced size */
        height: 50px;
        top: -25px;
        left: 20%;
        animation: float2 8s ease-in-out infinite;
      }
    }
  }

  // Logo Styles
  .logo {
    .logo-link {
      display: flex;
      align-items: center;
      text-decoration: none;
      color: $text-light;
      transition: all 0.3s ease;

      .logo-icon {
        margin-right: 0.5rem; /* Reduced margin */
        display: flex;
        align-items: center;
        
        .logo-image {
          width: 155px;
          height: 75px;
          transition: all 0.3s ease;
          filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));
        }
      }
    }
  }

  // Desktop Navigation
  .nav-desktop {
    direction: ltr;
    
    .nav-list {
      display: flex;
      align-items: center;
      list-style: none;
      margin: 0;
      padding-left: 275px; /* Reduced padding */
      gap: 1.5rem; /* Reduced gap */
      direction: ltr;

      .nav-item {
        position: relative;

        .nav-link {
          position: relative;
          display: block;
          color: $text-light;
          text-decoration: none;
          font-weight: 500;
          padding: 0.3rem 0; /* Reduced padding */
          transition: all 0.3s ease;
          overflow: hidden;
          text-align: left;

          .nav-text {
            position: relative;
            left: 100;
            z-index: 2;
            display: block;
            transition: transform 0.3s ease;
            font-size: 0.9rem; /* Reduced font size */
            direction: ltr;
          }

          .nav-indicator {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(45deg, $primary-color, $accent-color);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.3s ease;
          }

          &:hover {
            color: $accent-color;
          }

          &.active {
            color: $primary-color;
            
            .nav-indicator {
              transform: scaleX(1);
            }
          }
        }
      }
    }
  }

  // Mobile Menu Button
  .hamburger {
    position: relative;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    width: 25px; /* Reduced size */
    height: 25px;
    background: none;
    border: none;
    cursor: pointer;
    padding: 0;
    z-index: 1001;

    .hamburger-line {
      width: 20px; /* Reduced size */
      height: 2px;
      background: $text-light;
      margin: 2px 0; /* Reduced margin */
      transition: all 0.3s ease;
      transform-origin: center;
      border-radius: 2px;
    }

    &.is-active {
      .hamburger-line {
        &:nth-child(1) {
          transform: rotate(45deg) translate(4px, 4px);
          background: $primary-color;
        }

        &:nth-child(2) {
          opacity: 0;
          transform: scaleX(0);
        }

        &:nth-child(3) {
          transform: rotate(-45deg) translate(6px, -5px);
          background: $primary-color;
        }
      }
    }

    &:hover {
      .hamburger-line {
        background: $accent-color;
      }

      &.is-active .hamburger-line {
        &:nth-child(1),
        &:nth-child(3) {
          background: $primary-color;
        }
      }
    }
  }

  // Mobile Navigation
  .nav-mobile {
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    background: rgba(10, 10, 10, 0.98);
    backdrop-filter: blur(15px);
    -webkit-backdrop-filter: blur(15px);
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    overflow: hidden;
    height: 0;
    transition: height 0.3s ease;
    direction: ltr;

    &.is-open {
      height: auto;
    }

    .nav-list-mobile {
      list-style: none;
      margin: 0;
      padding: 0.8rem 0; /* Reduced padding */
      direction: ltr;

      .nav-item-mobile {
        .nav-link-mobile {
          display: flex;
          align-items: center;
          color: $text-light;
          text-decoration: none;
          padding: 0.8rem 1.2rem; /* Reduced padding */
          font-weight: 500;
          transition: all 0.3s ease;
          border-left: 3px solid transparent;
          direction: ltr;
          text-align: left;

          .mobile-nav-icon {
            margin-right: 0.8rem; /* Reduced margin */
            font-size: 1rem; /* Reduced size */
            filter: grayscale(1);
            transition: filter 0.3s ease;
          }

          .mobile-nav-text {
            flex: 1;
            font-size: 0.9rem; /* Reduced font size */
            text-align: left;
          }

          &:hover {
            background: rgba(229, 9, 20, 0.1);
            border-left-color: $primary-color;
            color: $accent-color;
            transform: translateX(8px);

            .mobile-nav-icon {
              filter: grayscale(0);
            }
          }

          &.active {
            background: rgba(229, 9, 20, 0.2);
            border-left-color: $primary-color;
            color: $primary-color;
          }
        }
      }
    }
  }
}

// Keyframe Animations
@keyframes float1 {
  0%, 100% {
    transform: translateY(0px) rotate(0deg);
  }
  50% {
    transform: translateY(-15px) rotate(180deg);
  }
}

@keyframes float2 {
  0%, 100% {
    transform: translateY(0px) rotate(0deg);
  }
  50% {
    transform: translateY(-10px) rotate(-180deg);
  }
}

// Responsive Design
@media (max-width: 768px) {
  .header {
    .header-content {
      padding: 0.15rem 0; /* Further reduced padding */
    }

    .logo {
      .logo-link {
        .logo-icon {
          margin-right: 0.03rem;
          
          .logo-image {
            width: 32px; /* Increased from 24px */
            height: 32px;
          }
        }
      }
    }

    .nav-mobile {
      .nav-list-mobile {
        .nav-item-mobile {
          .nav-link-mobile {
            padding: 0.6rem 0.8rem; /* Further reduced padding */
            font-size: 0.85rem; /* Further reduced font size */
          }
        }
      }
    }
  }
}

// High contrast mode
@media (prefers-contrast: high) {
  .header {
    background: rgba(0, 0, 0, 0.95);
    border-bottom: 2px solid white;

    .nav-desktop .nav-list .nav-item .nav-link {
      color: white;

      &:hover, &.active {
        color: yellow;
      }
    }

    .hamburger .hamburger-line {
      background: white;
    }

    .nav-mobile .nav-list-mobile .nav-item-mobile .nav-link-mobile {
      color: white;

      &:hover {
        background: rgba(255, 255, 255, 0.2);
        color: yellow;
      }
    }
  }
}

// RTL Support for Header
[dir="rtl"] .header {
  .header-content {
    direction: rtl;
  }

  .logo {
    .logo-icon {
      margin-right: 0;
      margin-left: 0.03rem;
      order: 2;
    }
  }

  .nav-desktop {
    direction: rtl;
    
    .nav-list {
      direction: rtl;

      .nav-item {
        .nav-link {
          text-align: right;

          .nav-text {
            direction: rtl;
          }

          .nav-indicator {
            transform-origin: right;
          }
        }
      }
    }
  }

  .nav-mobile {
    direction: rtl;

    .nav-list-mobile {
      direction: rtl;

      .nav-item-mobile {
        .nav-link-mobile {
          direction: rtl;
          text-align: right;
          border-left: none;
          border-right: 3px solid transparent;

          &:hover {
            border-left: none;
            border-right-color: $primary-color;
            transform: translateX(-8px);
          }

          &.active {
            border-left: none;
            border-right-color: $primary-color;
          }

          .mobile-nav-icon {
            margin-right: 0;
            margin-left: 0.8rem;
          }

          .mobile-nav-text {
            text-align: right;
          }
        }
      }
    }
  }
}

// Reduced motion
@media (prefers-reduced-motion: reduce) {
  .header {
    * {
      animation-duration: 0.01ms !important;
      animation-iteration-count: 1 !important;
      transition-duration: 0.01ms !important;
      scroll-behavior: auto !important;
    }
  }
}
</style>