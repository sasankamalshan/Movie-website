<template>
  <footer class="footer">
    <div class="container">
      <div class="footer-content">
        
        <!-- Company Info -->
        <div class="footer-section company-info">
          <div class="address">
            <h3 class="section-title">Amadeus IT Group</h3>
            <div class="address-content">
              <svg width="20" height="0.5" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M21 10C21 17 12 23 12 23S3 17 3 10C3 5.03 7.03 1 12 1S21 5.03 21 10Z" stroke="currentColor" stroke-width="2"/>
                <circle cx="12" cy="10" r="3" stroke="currentColor" stroke-width="2"/>
              </svg>
              <div class="address-text">
                <p><strong>C. Salvador de Madariaga, 1</strong></p>
                <p>28027 Madrid</p>
                <p>Spain</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Follow Us Section -->
        <div class="footer-section social-section">
          <h3 class="section-title">Follow Us</h3>
          <div class="social-icons">
            <a href="https://facebook.com" target="_blank" rel="noopener noreferrer" class="social-link facebook">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
              </svg>
            </a>
            <a href="https://youtube.com" target="_blank" rel="noopener noreferrer" class="social-link youtube">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z"/>
              </svg>
            </a>
          </div>
        </div>
      </div>

      <!-- Copyright Section -->
      <div class="footer-bottom">
        <div class="copyright">
          <p>Copyright &copy; {{ currentYear }} Amadeus Hotels</p>
          <p>All rights reserved.</p>
        </div>
        
        <div class="footer-controls">
          <!-- RTL Toggle Button -->
          <button 
            @click="toggleRTL"
            class="control-btn rtl-toggle-btn"
            :title="isRTL ? 'Switch to LTR' : 'Switch to RTL'"
            aria-label="Toggle text direction"
          >
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M9 4v2H7v2h2v2h2V8h2V6h-2V4H9zm0 8v2H7v2h2v2h2v-2h2v-2h-2v-2H9z" fill="currentColor"/>
              <path d="M15 4h2v2h-2V4zm0 4h2v2h-2V8zm0 4h2v2h-2v-2zm0 4h2v2h-2v-2z" fill="currentColor"/>
            </svg>
            <span class="btn-text">{{ isRTL ? 'LTR' : 'RTL' }}</span>
          </button>

          <button @click="scrollToTop" class="control-btn scroll-top-btn">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M18 15L12 9L6 15" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <span class="btn-text">Top</span>
          </button>
        </div>
      </div>
    </div>
  </footer>
</template>

<script>
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'

gsap.registerPlugin(ScrollTrigger)

export default {
  name: 'AppFooter',
  props: {
    isRTL: {
      type: Boolean,
      default: false
    }
  },
  emits: ['toggle-rtl', 'navigate'],
  data() {
    return {
      newsletterEmail: '',
      scrollTimer: null
    }
  },
  computed: {
    currentYear() {
      return new Date().getFullYear()
    }
  },
  mounted() {
    this.initializeAnimations()
    
    // Alternative: Show footer immediately if scroll is near bottom
    this.$nextTick(() => {
      setTimeout(() => {
        this.checkAndShowFooter()
      }, 500)
    })

    // Add scroll listener as backup
    window.addEventListener('scroll', this.handleScroll)
  },
  beforeUnmount() {
    ScrollTrigger.getAll().forEach(trigger => trigger.kill())
    window.removeEventListener('scroll', this.handleScroll)
  },
  methods: {
    initializeAnimations() {
      // Set initial states
      gsap.set('.footer-section', { y: 50, opacity: 0 })
      gsap.set('.social-link', { scale: 0, rotation: 0 })
      gsap.set('.footer-bottom', { y: 30, opacity: 0 })

      // Create scroll-triggered timeline with more lenient trigger settings
      const tl = gsap.timeline({
        scrollTrigger: {
          trigger: '.footer',
          start: "top 90%", // Trigger earlier
          end: "bottom 10%",
          toggleActions: "play none none none", // Don't reverse
          onEnter: () => {
            console.log('Footer animation triggered')
          }
        }
      })

      // Animate footer sections
      tl.to('.footer-section', {
        y: 0,
        opacity: 1,
        duration: 0.8,
        stagger: 0.2,
        ease: "power3.out"
      })

      // Animate social icons
      tl.to('.social-link', {
        scale: 1,
        rotation: 0,
        duration: 0.6,
        stagger: 0.1,
        ease: "back.out(1.7)"
      }, "-=0.4")

      // Animate footer bottom
      tl.to('.footer-bottom', {
        y: 0,
        opacity: 1,
        duration: 0.6,
        ease: "power2.out"
      }, "-=0.2")

      // Fallback: If not triggered within 2 seconds, show footer anyway
      setTimeout(() => {
        if (document.querySelector('.footer-section').style.opacity === '0') {
          console.log('Triggering footer animation manually')
          gsap.to('.footer-section', { y: 0, opacity: 1, duration: 0.5 })
          gsap.to('.social-link', { scale: 1, rotation: 0, duration: 0.5 })
          gsap.to('.footer-bottom', { y: 0, opacity: 1, duration: 0.5 })
        }
      }, 2000)

      // Setup hover animations
      this.setupHoverAnimations()
    },

    checkAndShowFooter() {
      // Check if footer is in viewport or near it
      const footer = document.querySelector('.footer')
      if (footer) {
        const rect = footer.getBoundingClientRect()
        const windowHeight = window.innerHeight
        
        // If footer is close to viewport or page is short, show it
        if (rect.top < windowHeight + 200 || document.body.scrollHeight < windowHeight * 1.5) {
          console.log('Showing footer immediately')
          gsap.to('.footer-section', { y: 0, opacity: 1, duration: 0.8, stagger: 0.2 })
          gsap.to('.social-link', { scale: 1, rotation: 0, duration: 0.6, stagger: 0.1 })
          gsap.to('.footer-bottom', { y: 0, opacity: 1, duration: 0.6 })
        }
      }
    },

    handleScroll() {
      // Throttle scroll events
      if (this.scrollTimer) return
      
      this.scrollTimer = setTimeout(() => {
        this.checkAndShowFooter()
        this.scrollTimer = null
      }, 100)
    },

    setupHoverAnimations() {
      // Social links hover animations
      document.querySelectorAll('.social-link').forEach(link => {
        link.addEventListener('mouseenter', () => {
          gsap.to(link, {
            scale: 1.2,
            rotation: 360,
            duration: 0.4,
            ease: "back.out(1.7)"
          })
        })

        link.addEventListener('mouseleave', () => {
          gsap.to(link, {
            scale: 1,
            rotation: 0,
            duration: 0.3,
            ease: "power2.out"
          })
        })
      })

      // Footer links hover animations
      document.querySelectorAll('.footer-link').forEach(link => {
        link.addEventListener('mouseenter', () => {
          gsap.to(link, {
            x: 10,
            color: '#e50914',
            duration: 0.3,
            ease: "power2.out"
          })
        })

        link.addEventListener('mouseleave', () => {
          gsap.to(link, {
            x: 0,
            color: '',
            duration: 0.3,
            ease: "power2.out"
          })
        })
      })

      // Screen items hover animations
      document.querySelectorAll('.screen-item').forEach(item => {
        item.addEventListener('mouseenter', () => {
          gsap.to(item, {
            scale: 1.02,
            backgroundColor: 'rgba(229, 9, 20, 0.1)',
            duration: 0.3,
            ease: "power2.out"
          })
        })

        item.addEventListener('mouseleave', () => {
          gsap.to(item, {
            scale: 1,
            backgroundColor: 'transparent',
            duration: 0.3,
            ease: "power2.out"
          })
        })
      })

      // Control buttons hover animations
      document.querySelectorAll('.control-btn').forEach(btn => {
        btn.addEventListener('mouseenter', () => {
          gsap.to(btn, {
            scale: 1.05,
            duration: 0.2,
            ease: "power2.out"
          })
        })

        btn.addEventListener('mouseleave', () => {
          gsap.to(btn, {
            scale: 1,
            duration: 0.2,
            ease: "power2.out"
          })
        })
      })
    },

    toggleRTL() {
      this.$emit('toggle-rtl')
    },

    navigateToPage(page) {
      this.$emit('navigate', page)
    },

    subscribeNewsletter() {
      if (this.newsletterEmail.trim()) {
        // Animation for successful subscription
        const form = document.querySelector('.newsletter-form')
        const btn = form.querySelector('.newsletter-btn')
        
        gsap.to(btn, {
          scale: 0.95,
          duration: 0.1,
          yoyo: true,
          repeat: 1,
          ease: "power2.inOut"
        })
        
        // Show success message with animation
        const successMessage = document.createElement('div')
        successMessage.textContent = 'Thank you for subscribing!'
        successMessage.style.cssText = `
          position: absolute;
          top: -30px;
          left: 0;
          right: 0;
          background: #4CAF50;
          color: white;
          padding: 8px;
          border-radius: 4px;
          font-size: 12px;
          text-align: center;
          opacity: 0;
          transform: translateY(10px);
        `
        
        form.style.position = 'relative'
        form.appendChild(successMessage)
        
        gsap.to(successMessage, {
          opacity: 1,
          y: 0,
          duration: 0.3,
          ease: "back.out(1.7)"
        })
        
        // Remove message after 3 seconds
        setTimeout(() => {
          gsap.to(successMessage, {
            opacity: 0,
            y: -10,
            duration: 0.3,
            ease: "power2.in",
            onComplete: () => successMessage.remove()
          })
        }, 3000)
        
        this.newsletterEmail = ''
      }
    },
    
    scrollToTop() {
      // Animate scroll to top
      gsap.to(window, {
        scrollTo: { y: 0 },
        duration: 1,
        ease: "power2.inOut"
      })
      
      // Animate the button
      const btn = event.target
      gsap.to(btn, {
        y: -5,
        duration: 0.2,
        yoyo: true,
        repeat: 1,
        ease: "power2.inOut"
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.footer {
  background: linear-gradient(135deg, $secondary-color 0%, darken($secondary-color, 10%) 100%);
  color: $text-primary;
  padding: $spacing-4xl 0 $spacing-3xl;
  min-height: 350px;
  position: relative;
  overflow: hidden;

  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 1px;
    background: linear-gradient(90deg, transparent, $primary-color, transparent);
  }
}

.footer-content {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: $spacing-3xl;

  @media (max-width: $breakpoint-md) {
    flex-direction: column;
    gap: $spacing-2xl;
    text-align: center;
  }
}

.footer-section {
  .section-title {
    font-size: $font-size-lg;
    font-weight: 600;
    margin-bottom: $spacing-lg;
    color: $text-primary;
    position: relative;

    &::after {
      content: '';
      position: absolute;
      bottom: -5px;
      left: 0;
      width: 40px;
      height: 2px;
      background: linear-gradient(45deg, $primary-color, $accent-color);
      border-radius: 1px;

      @media (max-width: $breakpoint-md) {
        left: 50%;
        transform: translateX(-50%);
      }
    }
  }
}

// Company Info
.company-info {
  .logo {
    display: flex;
    align-items: center;
    margin-bottom: $spacing-xl;

    @media (max-width: $breakpoint-md) {
      justify-content: center;
    }

    .logo-icon {
      margin-right: $spacing-sm;
      display: flex;
      align-items: center;
      
      svg {
        transition: all 0.3s ease;
        filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));
      }
    }

    .logo-text {
      font-size: $font-size-2xl;
      font-weight: bold;
      background: linear-gradient(45deg, $primary-color, $accent-color);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    &:hover {
      .logo-icon svg {
        transform: rotate(360deg) scale(1.1);
      }
    }
  }

  .address-content {
    display: flex;
    gap: $spacing-md;
    align-items: flex-start;

    @media (max-width: $breakpoint-md) {
      justify-content: center;
    }

    svg {
      color: $primary-color;
      flex-shrink: 0;
      margin-top: 2px;
    }

    .address-text p {
      margin: 0;
      line-height: 1.6;
      color: $text-secondary;

      &:first-child {
        font-weight: 600;
        color: $text-primary;
      }
    }
  }
}


// Social Section
.social-section {
  text-align: right;

  @media (max-width: $breakpoint-md) {
    text-align: center;
  }

  .social-icons {
    display: flex;
    gap: $spacing-lg;
    justify-content: flex-end;

    @media (max-width: $breakpoint-md) {
      justify-content: center;
    }
  }

  .social-link {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 44px;
    height: 44px;
    background-color: rgba($text-primary, 0.1);
    border-radius: 50%;
    color: $text-secondary;
    text-decoration: none;
    transition: all $transition-normal;

    &:hover {
      transform: translateY(-3px);
      box-shadow: $shadow-lg;
    }

    &.facebook:hover {
      background-color: #1877F2;
      color: white;
    }

    &.youtube:hover {
      background-color: #FF0000;
      color: white;
    }

    &.linkedin:hover {
      background-color: #0077B5;
      color: white;
    }
  }
}

// Newsletter
.newsletter {
  h4 {
    font-size: $font-size-base;
    font-weight: 600;
    margin-bottom: $spacing-sm;
    color: $text-primary;
  }

  p {
    font-size: $font-size-sm;
    color: $text-secondary;
    margin-bottom: $spacing-xl;
  }
}

.newsletter-form {
  display: flex;
  gap: $spacing-sm;

  @media (max-width: $breakpoint-sm) {
    flex-direction: column;
  }
}

.newsletter-input {
  flex: 1;
  padding: $spacing-md $spacing-lg;
  border: 1px solid rgba($text-primary, 0.2);
  border-radius: $border-radius-md;
  background-color: rgba($text-primary, 0.1);
  color: $text-primary;
  font-size: $font-size-sm;

  &::placeholder {
    color: $text-secondary;
  }

  &:focus {
    outline: none;
    border-color: $primary-color;
    box-shadow: 0 0 0 2px rgba($primary-color, 0.2);
  }
}

.newsletter-btn {
  padding: $spacing-md $spacing-xl;
  font-size: $font-size-sm;
  white-space: nowrap;

  @media (max-width: $breakpoint-sm) {
    width: 100%;
  }
}

// Footer Bottom
.footer-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: $spacing-2xl;
  border-top: 1px solid rgba($text-primary, 0.1);

  @media (max-width: $breakpoint-md) {
    flex-direction: column;
    gap: $spacing-lg;
    text-align: center;
  }
}

.copyright {
  p {
    margin: 0;
    font-size: $font-size-sm;
    color: $text-secondary;
    line-height: 1.5;

    &:first-child {
      font-weight: 500;
    }
  }
}

.footer-controls {
  display: flex;
  gap: $spacing-md;
  align-items: center;
}

.control-btn {
  display: flex;
  align-items: center;
  gap: $spacing-xs;
  padding: $spacing-xs $spacing-md;
  background-color: rgba($text-primary, 0.1);
  color: $text-secondary;
  border: 1px solid rgba($text-primary, 0.2);
  border-radius: $border-radius-md;
  font-size: $font-size-sm;
  cursor: pointer;
  transition: all $transition-normal;

  &:hover {
    background-color: $primary-color;
    color: white;
    border-color: $primary-color;
  }

  &.active {
    background-color: $primary-color;
    color: white;
    border-color: $primary-color;
  }

  &:focus {
    outline: 2px solid $accent-color;
    outline-offset: 2px;
  }
}

// Standard LTR Layout - ensuring proper left-to-right flow
.footer {
  direction: ltr;
  
  .footer-content {
    direction: ltr;
  }

  .company-info {
    .address-content {
      direction: ltr;
      text-align: left;
    }
  }

  .quick-links {
    .footer-link {
      text-align: left;
    }
  }

  .social-section {
    .social-icons {
      direction: ltr;
      justify-content: flex-start;
    }

    .newsletter-form {
      direction: ltr;
      
      .newsletter-input {
        text-align: left;
      }
    }

    h3, h4, p {
      text-align: left;

      @media (max-width: $breakpoint-md) {
        text-align: center;
      }
    }
  }

  .footer-bottom {
    direction: ltr;

    .copyright {
      text-align: left;

      @media (max-width: $breakpoint-md) {
        text-align: center;
      }
    }
  }

  .section-title {
    text-align: left;

    &::after {
      left: 0;
      right: auto;
    }

    @media (max-width: $breakpoint-md) {
      text-align: center;

      &::after {
        left: 50%;
        transform: translateX(-50%);
      }
    }
  }
}

// RTL Support for Footer
[dir="rtl"] .footer {
  .footer-content {
    direction: rtl;
  }

  .company-info {
    .address-content {
      direction: rtl;
      text-align: right;

      @media (max-width: $breakpoint-md) {
        justify-content: center;
        text-align: center;
      }
    }

    .address-line {
      text-align: right;
    }
  }

  .quick-links {
    .footer-link {
      text-align: right;

      &:hover {
        padding-left: 0;
        padding-right: $spacing-sm;
      }

      @media (max-width: $breakpoint-md) {
        text-align: center;

        &:hover {
          padding-right: 0;
        }
      }
    }
  }

  .social-section {
    text-align: left;

    @media (max-width: $breakpoint-md) {
      text-align: center;
    }

    .social-icons {
      direction: rtl;
      justify-content: flex-end;

      @media (max-width: $breakpoint-md) {
        justify-content: center;
      }
    }

    h3, h4, p {
      text-align: left;

      @media (max-width: $breakpoint-md) {
        text-align: center;
      }
    }
  }

  .footer-bottom {
    direction: rtl;

    .copyright {
      text-align: right;

      @media (max-width: $breakpoint-md) {
        text-align: center;
      }
    }

    .footer-controls {
      justify-content: flex-start;

      @media (max-width: $breakpoint-md) {
        justify-content: center;
      }
    }
  }

  .section-title {
    text-align: right;

    &::after {
      left: auto;
      right: 0;
    }

    @media (max-width: $breakpoint-md) {
      text-align: center;

      &::after {
        left: 50%;
        right: auto;
        transform: translateX(-50%);
      }
    }
  }

  // Links list RTL alignment
  .links-list {
    text-align: right;

    @media (max-width: $breakpoint-md) {
      text-align: center;
    }
  }
}

// Accessibility
@media (prefers-reduced-motion: reduce) {
  .footer-link,
  .social-link,
  .control-btn {
    transition: none;

    &:hover {
      transform: none;
    }
  }
}

// High contrast mode
@media (prefers-contrast: high) {
  .footer {
    border-top: 2px solid $text-primary;
  }

  .newsletter-input,
  .control-btn {
    border-color: $text-primary;
  }

  .social-link {
    border: 1px solid $text-secondary;
  }
}
</style>
