<template>
  <section class="hero" id="home" ref="heroSection">
    <!-- Video Background -->
    <div class="video-background">
      <video 
        ref="heroVideo"
        autoplay 
        muted 
        loop 
        playsinline
        class="hero-video"
        @loadeddata="onVideoLoaded"
        @error="onVideoError"
      >
        <source src="/src/assets/videos/hero-video.mp4" type="video/mp4">
        Your browser does not support the video tag.
      </video>
      <div class="video-overlay" ref="videoOverlay"></div>
    </div>

    <!-- Slideshow Container -->
    <div class="slideshow-container" ref="slideshowContainer">
      <!-- Slides -->
      <div 
        v-for="(slide, index) in slides" 
        :key="index"
        class="slide"
        :class="{ 'active': currentSlide === index }"
        ref="slides"
      >
        <img 
          v-if="slide.type === 'image'"
          :src="slide.src" 
          :alt="slide.alt"
          class="slide-media"
        />
        
        <!-- Overlay -->
        <div class="slide-overlay"></div>
      </div>

      <!-- Navigation Dots -->
      <div class="slideshow-dots" ref="slideshowDots">
        <button
          v-for="(slide, index) in slides"
          :key="index"
          class="dot"
          :class="{ 'active': currentSlide === index }"
          @click="goToSlide(index)"
          :aria-label="`Go to slide ${index + 1}`"
        ></button>
      </div>

      <!-- Navigation Arrows -->
      <button class="nav-arrow nav-arrow-prev" @click="prevSlide" aria-label="Previous slide" ref="prevArrow">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M15 18L9 12L15 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </button>
      <button class="nav-arrow nav-arrow-next" @click="nextSlide" aria-label="Next slide" ref="nextArrow">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </button>
    </div>

    <!-- Hero Content -->
    <div class="hero-content" ref="heroContent">
      <div class="container">
        <!-- Current Page Title -->
        <div class="current-page-title" ref="pageTitle" v-if="currentPage !== 'HOME'">
          <h2 class="page-title-text">{{ currentPage }}</h2>
        </div>

        <!-- Hero Logo -->
        <div class="hero-logo" ref="heroLogo">
          <div class="logo-icon">
            <svg width="40" height="40" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
              <circle cx="20" cy="20" r="18" fill="url(#logoGradient)" stroke="currentColor" stroke-width="2"/>
              <path d="M15 12L25 20L15 28V12Z" fill="white"/>
              <defs>
                <linearGradient id="logoGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" style="stop-color:#e50914"/>
                  <stop offset="100%" style="stop-color:#ffd700"/>
                </linearGradient>
              </defs>
            </svg>
          </div>
          <span class="logo-text">MovieWeb</span>
        </div>
        
        <div class="hero-text" ref="heroText">
          <div class="hero-badge" ref="heroBadge">
            <span class="badge-icon">🎬</span>
            <span class="badge-text">Premium Movie Experience</span>
          </div>
          
          <h1 class="hero-title" ref="heroTitle">
            <span class="title-line" ref="titleLine1">Discover</span>
            <span class="title-line" ref="titleLine2">Amazing</span>
            <span class="title-line" ref="titleLine3">Movies</span>
          </h1>
          
          <p class="hero-subtitle" ref="heroSubtitle">
            Experience the magic of cinema with our curated collection of 
            the world's most captivating films and stories
          </p>
          
          <div class="hero-stats" ref="heroStats">
            <div class="stat-item" ref="stat1">
              <span class="stat-number" data-target="10000">0</span>
              <span class="stat-label">Movies</span>
            </div>
            <div class="stat-item" ref="stat2">
              <span class="stat-number" data-target="500">0</span>
              <span class="stat-label">Genres</span>
            </div>
            <div class="stat-item" ref="stat3">
              <span class="stat-number" data-target="1000000">0</span>
              <span class="stat-label">Users</span>
            </div>
          </div>
          
          <div class="hero-buttons" ref="heroButtons">
            <button class="btn btn-primary hero-btn-primary" ref="primaryBtn">
              <span class="btn-text">Explore Movies</span>
              <span class="btn-icon">→</span>
            </button>
            <button class="btn btn-outline hero-btn-secondary" ref="secondaryBtn">
              <span class="btn-text">Watch Trailer</span>
              <span class="btn-icon">▶</span>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Scroll Indicator -->
    <div class="scroll-indicator" ref="scrollIndicator" @click="scrollToNext">
      <div class="scroll-text">Scroll Down</div>
      <div class="scroll-arrow">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M7 13L12 18L17 13" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </div>
    </div>

    <!-- Page Title Display -->
    <div v-if="currentPageTitle" class="page-title-display" ref="pageTitleDisplay">
      <h2 class="page-title">{{ currentPageTitle }}</h2>
      <p v-if="currentPageSubtitle" class="page-subtitle">{{ currentPageSubtitle }}</p>
    </div>
  </section>
</template>

<script>
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'
import { TextPlugin } from 'gsap/TextPlugin'

gsap.registerPlugin(ScrollTrigger, TextPlugin)

export default {
  name: 'HeroSection',
  props: {
    currentPage: {
      type: String,
      default: 'HOME'
    }
  },
  data() {
    return {
      currentSlide: 0,
      autoplayInterval: null,
      videoLoaded: false,
      slides: [
        // No fallback images - video only
      ],
      tl: null
    }
  },
  computed: {
    currentPageTitle() {
      const pageMap = {
        'MOVIE LIBRARY': 'MOVIE LIBRARY',
        'OUR SCREENS': 'OUR SCREENS',
        'SCHEDULE': 'SHEDULE',
        'LOCATION & CONTACT': 'CONTACT US',
        'HOME': null
      }
      return pageMap[this.currentPage] || null
    },
    currentPageSubtitle() {
      const subtitleMap = {
        'MOVIE LIBRARY': 'Explore our extensive collection of movies across all genres',
        'OUR SCREENS': 'Discover our premium cinema experiences',
        'SCHEDULE': 'Check showtimes and book your tickets',
        'LOCATION & CONTACT': 'Get in touch with our team',
        'HOME': null
      }
      return subtitleMap[this.currentPage] || null
    }
  },
  watch: {
    currentPage(newPage) {
      // Animate page title when it changes
      if (newPage !== 'HOME' && this.$refs.pageTitleDisplay) {
        gsap.fromTo(this.$refs.pageTitleDisplay, 
          { 
            opacity: 0, 
            x: -50,
            scale: 0.8
          },
          { 
            opacity: 1, 
            x: 0,
            scale: 1,
            duration: 0.6,
            ease: "back.out(1.7)"
          }
        )
      } else if (newPage === 'HOME' && this.$refs.pageTitleDisplay) {
        // Hide page title when returning to home
        gsap.to(this.$refs.pageTitleDisplay, {
          opacity: 0,
          x: -50,
          duration: 0.3,
          ease: "power2.in"
        })
      }
    }
  },
  mounted() {
    this.initializeAnimations()
    this.setupEventListeners()
    
    // Start slideshow as fallback, will be hidden if video loads
    this.startAutoplay()
    
    // Keyboard navigation
    document.addEventListener('keydown', this.handleKeydown)
  },
  beforeUnmount() {
    this.stopAutoplay()
    document.removeEventListener('keydown', this.handleKeydown)
    
    // Kill GSAP animations
    if (this.tl) {
      this.tl.kill()
    }
    ScrollTrigger.getAll().forEach(trigger => trigger.kill())
  },
  methods: {
    initializeAnimations() {
      // Set initial states
      gsap.set([
        this.$refs.heroLogo,
        this.$refs.heroBadge,
        this.$refs.titleLine1,
        this.$refs.titleLine2, 
        this.$refs.titleLine3,
        this.$refs.heroSubtitle,
        this.$refs.heroStats,
        this.$refs.heroButtons,
        this.$refs.scrollIndicator
      ], {
        opacity: 0,
        y: 50
      })

      gsap.set(this.$refs.videoOverlay, {
        opacity: 0
      })

      // Create main timeline
      this.tl = gsap.timeline({ delay: 0.5 })

      // Logo animation
      this.tl.to(this.$refs.heroLogo, {
        opacity: 1,
        y: 0,
        duration: 0.8,
        ease: "back.out(1.7)"
      })

      // Badge animation
      this.tl.to(this.$refs.heroBadge, {
        opacity: 1,
        y: 0,
        duration: 0.8,
        ease: "back.out(1.7)"
      }, "-=0.4")

      // Title lines animation with stagger
      this.tl.to([this.$refs.titleLine1, this.$refs.titleLine2, this.$refs.titleLine3], {
        opacity: 1,
        y: 0,
        duration: 1,
        stagger: 0.2,
        ease: "power3.out"
      }, "-=0.4")

      // Subtitle with typewriter effect
      this.tl.to(this.$refs.heroSubtitle, {
        opacity: 1,
        y: 0,
        duration: 0.8,
        ease: "power2.out"
      }, "-=0.3")

      // Stats animation
      this.tl.to(this.$refs.heroStats, {
        opacity: 1,
        y: 0,
        duration: 0.8,
        ease: "power2.out",
        onComplete: () => this.animateCounters()
      }, "-=0.2")

      // Buttons animation
      this.tl.to(this.$refs.heroButtons, {
        opacity: 1,
        y: 0,
        duration: 0.8,
        ease: "back.out(1.7)"
      }, "-=0.3")

      // Scroll indicator
      this.tl.to(this.$refs.scrollIndicator, {
        opacity: 1,
        y: 0,
        duration: 0.6,
        ease: "power2.out"
      }, "-=0.2")

      // Video overlay fade in
      this.tl.to(this.$refs.videoOverlay, {
        opacity: 1,
        duration: 1.5,
        ease: "power2.inOut"
      }, 0)

      // Button hover animations
      this.setupButtonAnimations()

      // Scroll indicator pulse
      gsap.to(this.$refs.scrollIndicator, {
        y: 10,
        duration: 1.5,
        ease: "power2.inOut",
        yoyo: true,
        repeat: -1
      })
    },

    setupButtonAnimations() {
      const primaryBtn = this.$refs.primaryBtn
      const secondaryBtn = this.$refs.secondaryBtn

      if (primaryBtn) {
        primaryBtn.addEventListener('mouseenter', () => {
          gsap.to(primaryBtn.querySelector('.btn-icon'), {
            x: 5,
            duration: 0.3,
            ease: "power2.out"
          })
        })

        primaryBtn.addEventListener('mouseleave', () => {
          gsap.to(primaryBtn.querySelector('.btn-icon'), {
            x: 0,
            duration: 0.3,
            ease: "power2.out"
          })
        })
      }

      if (secondaryBtn) {
        secondaryBtn.addEventListener('mouseenter', () => {
          gsap.to(secondaryBtn.querySelector('.btn-icon'), {
            scale: 1.2,
            duration: 0.3,
            ease: "back.out(1.7)"
          })
        })

        secondaryBtn.addEventListener('mouseleave', () => {
          gsap.to(secondaryBtn.querySelector('.btn-icon'), {
            scale: 1,
            duration: 0.3,
            ease: "back.out(1.7)"
          })
        })
      }
    },

    animateCounters() {
      const counters = this.$refs.heroStats.querySelectorAll('.stat-number')
      
      counters.forEach(counter => {
        const target = parseInt(counter.dataset.target)
        
        gsap.to(counter, {
          innerHTML: target,
          duration: 2,
          ease: "power2.out",
          snap: { innerHTML: 1 },
          onUpdate: function() {
            const current = parseInt(this.targets()[0].innerHTML)
            const formatted = current >= 1000000 
              ? (current / 1000000).toFixed(1) + 'M'
              : current >= 1000 
              ? (current / 1000).toFixed(0) + 'K'
              : current.toString()
            
            this.targets()[0].innerHTML = formatted
          }
        })
      })
    },

    onVideoLoaded() {
      console.log('Video loaded successfully')
      this.videoLoaded = true
      
      // Hide slideshow when video loads
      if (this.$refs.slideshowContainer) {
        gsap.to(this.$refs.slideshowContainer, {
          opacity: 0,
          duration: 1,
          ease: "power2.inOut",
          onComplete: () => {
            this.$refs.slideshowContainer.style.display = 'none'
            this.stopAutoplay()
          }
        })
      }
      
      // Show video background
      if (this.$refs.heroVideo) {
        gsap.set(this.$refs.heroVideo, { opacity: 0 })
        gsap.to(this.$refs.heroVideo, {
          opacity: 1,
          duration: 1.5,
          ease: "power2.inOut"
        })
      }
    },

    onVideoError() {
      console.warn('Video failed to load, using slideshow fallback')
      this.videoLoaded = false
      // Keep slideshow running as fallback
    },

    scrollToNext() {
      gsap.to(window, {
        scrollTo: window.innerHeight,
        duration: 1,
        ease: "power2.inOut"
      })
    },

    setupEventListeners() {
      // Mouse move parallax effect
      this.$refs.heroSection.addEventListener('mousemove', (e) => {
        const { clientX, clientY } = e
        const { innerWidth, innerHeight } = window
        
        const xPos = (clientX / innerWidth - 0.5) * 30
        const yPos = (clientY / innerHeight - 0.5) * 30
        
        gsap.to(this.$refs.floatingElements, {
          x: xPos,
          y: yPos,
          duration: 0.5,
          ease: "power2.out"
        })
      })
    },

    // Slideshow methods (fallback)
    nextSlide() {
      this.currentSlide = (this.currentSlide + 1) % this.slides.length
      this.resetAutoplay()
    },
    
    prevSlide() {
      this.currentSlide = this.currentSlide === 0 ? this.slides.length - 1 : this.currentSlide - 1
      this.resetAutoplay()
    },
    
    goToSlide(index) {
      this.currentSlide = index
      this.resetAutoplay()
    },
    
    startAutoplay() {
      this.autoplayInterval = setInterval(() => {
        this.nextSlide()
      }, 5000)
    },
    
    stopAutoplay() {
      if (this.autoplayInterval) {
        clearInterval(this.autoplayInterval)
        this.autoplayInterval = null
      }
    },
    
    resetAutoplay() {
      this.stopAutoplay()
      this.startAutoplay()
    },
    
    handleKeydown(event) {
      if (event.key === 'ArrowLeft') {
        this.prevSlide()
      } else if (event.key === 'ArrowRight') {
        this.nextSlide()
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.hero {
  position: relative;
  height: 100vh;
  min-height: 700px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0;
  padding: 0;
}

// Video Background
.video-background {
  position: absolute;
  top: 0;
  left: 0;
  width: auto;
  height: 100vh;
  z-index: 1;
  margin: 0;
  padding: 0;
}

.hero-video {
  width: 100vw;
  height: 100vh;
  object-fit: cover;
  object-position: center;
  transform: scaleX(1.2);
  margin: 0;
  padding: 0;
}

.video-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(
    135deg,
    rgba($secondary-color, 0.8) 0%,
    rgba($secondary-color, 0.5) 30%,
    rgba($primary-color, 0.3) 70%,
    rgba($secondary-color, 0.6) 100%
  );
  backdrop-filter: blur(1px);
}

// Slideshow (Fallback)
.slideshow-container {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1;
}

.slide {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  opacity: 0;
  transition: opacity 1.5s cubic-bezier(0.4, 0.0, 0.2, 1);

  &.active {
    opacity: 1;
  }

  .slide-media {
    width: 100%;
    height: 100%;
    object-fit: cover;
    object-position: center;
    filter: brightness(0.7) contrast(1.1);
  }
}

.slide-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(
    135deg,
    rgba($secondary-color, 0.8) 0%,
    rgba($secondary-color, 0.5) 30%,
    rgba($primary-color, 0.3) 70%,
    rgba($secondary-color, 0.6) 100%
  );
}

// Hero Content
.hero-content {
  position: relative;
  z-index: 10;
  width: 100%;
  text-align: center;
  color: $text-primary;
}

// Current Page Title
.current-page-title {
  position: absolute;
  top: 2rem;
  left: 2rem;
  z-index: 15;

  .page-title-text {
    font-size: 2.5rem;
    font-weight: 700;
    color: $text-primary;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.8);
    text-transform: uppercase;
    letter-spacing: 2px;
    background: linear-gradient(45deg, $primary-color, $accent-color);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    animation: fadeInLeft 0.8s ease-out;

    @media (max-width: $breakpoint-md) {
      font-size: 1.8rem;
    }

    @media (max-width: $breakpoint-sm) {
      font-size: 1.5rem;
      letter-spacing: 1px;
    }
  }

  @media (max-width: $breakpoint-md) {
    top: 1rem;
    left: 1rem;
  }
}

// RTL Support for Page Title
[dir="rtl"] .current-page-title {
  left: auto;
  right: 2rem;

  .page-title-text {
    animation: fadeInRight 0.8s ease-out;
  }

  @media (max-width: $breakpoint-md) {
    right: 1rem;
  }
}

@keyframes fadeInLeft {
  from {
    opacity: 0;
    transform: translateX(-30px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes fadeInRight {
  from {
    opacity: 0;
    transform: translateX(30px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

// Hero Logo
.hero-logo {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: $spacing-xl;

  .logo-icon {
    margin-right: 0.5rem;
    display: flex;
    align-items: center;
    
    svg {
      transition: all 0.3s ease;
      filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));
    }
  }

  .logo-text {
    font-size: $font-size-xl;
    font-weight: 900;
    color: $text-primary;
    text-shadow: 2px 4px 8px rgba(0, 0, 0, 0.5);
    background: linear-gradient(135deg, $text-primary 0%, $accent-color 50%, $primary-color 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }
}

.hero-text {
  max-width: 800px;
  margin: 0 auto;
  padding: 0 $spacing-lg;
}

// Hero Badge
.hero-badge {
  display: inline-flex;
  align-items: center;
  gap: $spacing-sm;
  background: rgba(white, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(white, 0.2);
  border-radius: 50px;
  padding: $spacing-sm $spacing-lg;
  margin-bottom: $spacing-xl;
  font-size: $font-size-sm;
  font-weight: 500;
  letter-spacing: 0.5px;
  text-transform: uppercase;

  .badge-icon {
    font-size: $font-size-lg;
  }

  .badge-text {
    background: linear-gradient(45deg, $accent-color, white);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }
}

// Hero Title
.hero-title {
  font-size: clamp(2.5rem, 8vw, 6rem);
  font-weight: 900;
  line-height: 1.1;
  margin-bottom: $spacing-xl;
  text-shadow: 2px 4px 8px rgba(0, 0, 0, 0.5);

  .title-line {
    display: block;
    background: linear-gradient(
      135deg,
      $text-primary 0%,
      $accent-color 50%,
      $primary-color 100%
    );
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    position: relative;

    &::after {
      content: '';
      position: absolute;
      bottom: -10px;
      left: 50%;
      transform: translateX(-50%);
      width: 0;
      height: 4px;
      background: linear-gradient(45deg, $primary-color, $accent-color);
      border-radius: 2px;
      animation: lineGrow 1s ease-out forwards;
      animation-delay: 1.5s;
    }

    &:nth-child(2)::after {
      animation-delay: 1.7s;
    }

    &:nth-child(3)::after {
      animation-delay: 1.9s;
    }
  }
}

@keyframes lineGrow {
  to {
    width: 60px;
  }
}

// Hero Subtitle
.hero-subtitle {
  font-size: clamp(1rem, 3vw, 1.5rem);
  line-height: 1.6;
  margin-bottom: $spacing-2xl;
  color: rgba($text-primary, 0.9);
  text-shadow: 1px 2px 4px rgba(0, 0, 0, 0.5);
  max-width: 600px;
  margin-left: auto;
  margin-right: auto;
}

// Hero Stats
.hero-stats {
  display: flex;
  justify-content: center;
  gap: $spacing-2xl;
  margin-bottom: $spacing-2xl;

  @media (max-width: $breakpoint-md) {
    gap: $spacing-xl;
  }

  @media (max-width: $breakpoint-sm) {
    flex-direction: column;
    gap: $spacing-lg;
  }
}

.stat-item {
  text-align: center;
  padding: $spacing-lg;
  background: rgba(white, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(white, 0.2);
  border-radius: $border-radius-xl;
  transition: all 0.3s ease;

  &:hover {
    transform: translateY(-5px);
    background: rgba(white, 0.15);
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
  }

  .stat-number {
    display: block;
    font-size: clamp(1.5rem, 4vw, 2.5rem);
    font-weight: 900;
    color: $accent-color;
    text-shadow: 1px 2px 4px rgba(0, 0, 0, 0.5);
  }

  .stat-label {
    font-size: $font-size-sm;
    text-transform: uppercase;
    letter-spacing: 1px;
    color: rgba($text-primary, 0.8);
    margin-top: $spacing-xs;
  }
}

// Hero Buttons
.hero-buttons {
  display: flex;
  justify-content: center;
  gap: $spacing-lg;
  margin-bottom: $spacing-3xl;

  @media (max-width: $breakpoint-sm) {
    flex-direction: column;
    align-items: center;
    gap: $spacing-md;
  }
}

.hero-btn-primary,
.hero-btn-secondary {
  display: inline-flex;
  align-items: center;
  gap: $spacing-sm;
  padding: $spacing-lg $spacing-2xl;
  font-size: $font-size-lg;
  font-weight: 600;
  border-radius: 50px;
  text-decoration: none;
  transition: all 0.3s cubic-bezier(0.4, 0.0, 0.2, 1);
  position: relative;
  overflow: hidden;

  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(
      90deg,
      transparent,
      rgba(white, 0.2),
      transparent
    );
    transition: left 0.5s ease;
  }

  &:hover::before {
    left: 100%;
  }

  .btn-icon {
    transition: all 0.3s ease;
  }
}

.hero-btn-primary {
  background: linear-gradient(135deg, $primary-color, darken($primary-color, 10%));
  color: white;
  box-shadow: 0 8px 25px rgba($primary-color, 0.4);

  &:hover {
    transform: translateY(-3px);
    box-shadow: 0 12px 35px rgba($primary-color, 0.6);
  }
}

.hero-btn-secondary {
  background: rgba(white, 0.1);
  color: white;
  border: 2px solid rgba(white, 0.3);
  backdrop-filter: blur(10px);

  &:hover {
    background: rgba(white, 0.2);
    border-color: $accent-color;
    transform: translateY(-3px);
    box-shadow: 0 12px 35px rgba(0, 0, 0, 0.3);
  }
}

// Scroll Indicator
.scroll-indicator {
  position: absolute;
  bottom: $spacing-2xl;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: $spacing-sm;
  color: rgba($text-primary, 0.8);
  cursor: pointer;
  z-index: 10;
  transition: all 0.3s ease;

  &:hover {
    color: $accent-color;
    transform: translateX(-50%) scale(1.1);
  }

  .scroll-text {
    font-size: $font-size-sm;
    text-transform: uppercase;
    letter-spacing: 1px;
    font-weight: 500;
  }

  .scroll-arrow {
    opacity: 0.7;
  }
}

// Navigation (Fallback)
.slideshow-dots {
  position: absolute;
  bottom: $spacing-2xl;
  right: $spacing-2xl;
  display: flex;
  gap: $spacing-sm;
  z-index: 15;

  @media (max-width: $breakpoint-sm) {
    right: 50%;
    transform: translateX(50%);
  }
}

.dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background-color: rgba($text-primary, 0.4);
  border: 2px solid rgba($text-primary, 0.6);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0.0, 0.2, 1);

  &:hover {
    background-color: rgba($text-primary, 0.7);
    transform: scale(1.3);
  }

  &.active {
    background-color: $primary-color;
    border-color: $primary-color;
    transform: scale(1.4);
    box-shadow: 0 0 10px rgba($primary-color, 0.5);
  }
}

.nav-arrow {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  background-color: rgba($secondary-color, 0.8);
  color: $text-primary;
  border: 2px solid rgba(white, 0.3);
  width: 60px;
  height: 60px;
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0.0, 0.2, 1);
  z-index: 15;
  display: flex;
  align-items: center;
  justify-content: center;
  backdrop-filter: blur(10px);

  &:hover {
    background-color: $primary-color;
    border-color: $primary-color;
    transform: translateY(-50%) scale(1.1);
    box-shadow: 0 8px 25px rgba($primary-color, 0.4);
  }

  &.nav-arrow-prev {
    left: $spacing-2xl;
  }

  &.nav-arrow-next {
    right: $spacing-2xl;
  }

  @media (max-width: $breakpoint-md) {
    width: 50px;
    height: 50px;
    
    &.nav-arrow-prev {
      left: $spacing-lg;
    }

    &.nav-arrow-next {
      right: $spacing-lg;
    }
  }

  @media (max-width: $breakpoint-sm) {
    display: none;
  }
}

// Responsive Design
@media (max-width: $breakpoint-lg) {
  .hero-title {
    margin-bottom: $spacing-lg;
  }

  .hero-subtitle {
    margin-bottom: $spacing-xl;
  }

  .hero-stats {
    margin-bottom: $spacing-xl;
  }
}

@media (max-width: $breakpoint-md) {
  .hero {
    min-height: 600px;
    text-align: center;
  }

  .floating-shape {
    &.shape-1, &.shape-3 {
      display: none;
    }
  }
}

@media (max-width: $breakpoint-sm) {
  .hero {
    min-height: 500px;
  }

  .hero-badge {
    margin-bottom: $spacing-lg;
    padding: $spacing-xs $spacing-md;
    font-size: $font-size-xs;
  }

  .floating-shape {
    display: none;
  }

  .scroll-indicator {
    bottom: $spacing-lg;
  }
}

// Accessibility
@media (prefers-reduced-motion: reduce) {
  .slide {
    transition: none;
  }
  
  .floating-shape {
    animation: none !important;
  }
  
  .scroll-indicator {
    animation: none !important;
  }
  
  .hero-btn-primary,
  .hero-btn-secondary {
    transition: none;
    
    &:hover {
      transform: none;
    }
  }
  
  .stat-item:hover {
    transform: none;
  }
}

// High contrast mode
@media (prefers-contrast: high) {
  .hero-badge,
  .stat-item {
    border: 2px solid white;
    background: rgba(0, 0, 0, 0.8);
  }

  .hero-btn-secondary {
    border: 2px solid white;
    background: rgba(0, 0, 0, 0.8);
  }

  .nav-arrow,
  .dot {
    border: 2px solid white;
  }
}

// Focus styles for accessibility
.dot:focus,
.nav-arrow:focus,
.hero-btn-primary:focus,
.hero-btn-secondary:focus,
.scroll-indicator:focus {
  outline: 3px solid $accent-color;
  outline-offset: 3px;
}

// Page Title Display
.page-title-display {
  position: absolute;
  bottom: 100px;
  left: 50px;
  z-index: 15;
  color: white;
  text-shadow: 2px 4px 8px rgba(0, 0, 0, 0.7);

  @media (max-width: $breakpoint-md) {
    bottom: 80px;
    left: 30px;
  }

  @media (max-width: $breakpoint-sm) {
    bottom: 60px;
    left: 20px;
  }
}

.page-title {
  font-size: clamp(2rem, 4vw, 3rem);
  font-weight: 900;
  margin: 0 0 10px 0;
  background: linear-gradient(135deg, #ffffff 0%, #f0f0f0 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-shadow: none;
  filter: drop-shadow(2px 4px 8px rgba(0, 0, 0, 0.7));
}

.page-subtitle {
  font-size: clamp(0.9rem, 2vw, 1.1rem);
  margin: 0;
  color: rgba(255, 255, 255, 0.9);
  max-width: 400px;
  line-height: 1.4;
}
</style>
