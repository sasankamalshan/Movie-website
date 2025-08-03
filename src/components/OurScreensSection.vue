<template>
  <section class="screens" id="screens">
    <div class="container">
      <div class="section-header">
        <h2 class="section-title fade-in">OUR PREMIUM SCREENS</h2>
        <p class="section-subtitle fade-in">Experience cinema like never before with our state-of-the-art screening facilities</p>
      </div>

      <div class="screens-grid">
        <!-- Screen 1 -->
        <div class="screen-card slide-in-left" ref="screenCard1">
          <div class="screen-image">
            <img src="/src/assets/images/Batman.jpg" alt="IMAX Theatre" />
            <div class="screen-overlay">
              <div class="screen-badge">PREMIUM</div>
            </div>
          </div>
          <div class="screen-content">
            <h3 class="screen-title">IMAX Theatre</h3>
            <p class="screen-description">
              Immerse yourself in crystal-clear visuals and thunderous sound with our 
              70mm IMAX screen - the ultimate cinematic experience.
            </p>
            <div class="screen-features">
              <div class="feature">
                <span class="feature-icon">📺</span>
                <span class="feature-text">70mm IMAX Screen</span>
              </div>
              <div class="feature">
                <span class="feature-icon">🔊</span>
                <span class="feature-text">Dolby Atmos Sound</span>
              </div>
              <div class="feature">
                <span class="feature-icon">💺</span>
                <span class="feature-text">150 Luxury Seats</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Screen 2 -->
        <div class="screen-card slide-in-up" ref="screenCard2">
          <div class="screen-image">
            <img src="/src/assets/images/Spiderman.jpg" alt="Dolby Cinema" />
            <div class="screen-overlay">
              <div class="screen-badge">4K</div>
            </div>
          </div>
          <div class="screen-content">
            <h3 class="screen-title">Dolby Cinema</h3>
            <p class="screen-description">
              Experience movies in stunning 4K resolution with Dolby Vision HDR 
              and Dolby Atmos surround sound technology.
            </p>
            <div class="screen-features">
              <div class="feature">
                <span class="feature-icon">🎭</span>
                <span class="feature-text">4K Dolby Vision</span>
              </div>
              <div class="feature">
                <span class="feature-icon">🎵</span>
                <span class="feature-text">Dolby Atmos</span>
              </div>
              <div class="feature">
                <span class="feature-icon">🪑</span>
                <span class="feature-text">120 Reclining Seats</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Screen 3 -->
        <div class="screen-card slide-in-right" ref="screenCard3">
          <div class="screen-image">
            <img src="/src/assets/images/Wild West.jpg" alt="VIP Lounge" />
            <div class="screen-overlay">
              <div class="screen-badge">VIP</div>
            </div>
          </div>
          <div class="screen-content">
            <h3 class="screen-title">VIP Lounge Cinema</h3>
            <p class="screen-description">
              Indulge in luxury with our exclusive VIP cinema featuring premium 
              leather recliners and personalized service.
            </p>
            <div class="screen-features">
              <div class="feature">
                <span class="feature-icon">👑</span>
                <span class="feature-text">Luxury Experience</span>
              </div>
              <div class="feature">
                <span class="feature-icon">🍿</span>
                <span class="feature-text">Premium Dining</span>
              </div>
              <div class="feature">
                <span class="feature-icon">🛋️</span>
                <span class="feature-text">40 Luxury Recliners</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Screen Stats -->
      <div class="screen-stats slide-in-up" ref="screenStats">
        <div class="stat-card">
          <div class="stat-number">3</div>
          <div class="stat-label">Premium Screens</div>
        </div>
        <div class="stat-card">
          <div class="stat-number">310</div>
          <div class="stat-label">Total Seats</div>
        </div>
        <div class="stat-card">
          <div class="stat-number">4K</div>
          <div class="stat-label">Ultra HD</div>
        </div>
        <div class="stat-card">
          <div class="stat-number">360°</div>
          <div class="stat-label">Surround Sound</div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'

gsap.registerPlugin(ScrollTrigger)

export default {
  name: 'OurScreensSection',
  mounted() {
    this.setupAnimations()
    this.setupIntersectionObserver()
  },
  methods: {
    setupAnimations() {
      // Screen cards animation
      ScrollTrigger.create({
        trigger: '.screens-grid',
        start: 'top 80%',
        end: 'bottom 20%',
        onEnter: () => {
          gsap.fromTo('.screen-card', 
            { y: 50, opacity: 0 },
            { y: 0, opacity: 1, duration: 0.8, stagger: 0.2, ease: 'power2.out' }
          )
        }
      })

      // Stats animation
      ScrollTrigger.create({
        trigger: '.screen-stats',
        start: 'top 80%',
        onEnter: () => {
          gsap.fromTo('.stat-card', 
            { scale: 0, opacity: 0 },
            { scale: 1, opacity: 1, duration: 0.6, stagger: 0.1, ease: 'back.out(1.7)' }
          )
        }
      })
    },

    setupIntersectionObserver() {
      const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            entry.target.classList.add('animate')
          }
        })
      }, {
        threshold: 0.2
      })

      const animatedElements = this.$el.querySelectorAll('.fade-in, .slide-in-left, .slide-in-right, .slide-in-up')
      animatedElements.forEach(el => observer.observe(el))
    }
  }
}
</script>

<style lang="scss" scoped>
@import "./src/assets/styles/variables.scss";

.screens {
  padding: 100px 0 50px 0; // Reduced bottom padding to ensure footer space
  background: #000000;
  position: relative;
  overflow: visible; // Changed from hidden to visible
  width: 100%;
  
  // Ensure this section doesn't interfere with footer
  margin-bottom: 0;
  min-height: auto; // Don't force height

  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="50" cy="50" r="0.5" fill="rgba(255,255,255,0.03)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
    pointer-events: none;
  }
}

.section-header {
  text-align: center;
  margin-bottom: 40px;
}

.section-title {
  font-size: clamp(2.5rem, 5vw, 4rem);
  font-weight: 900;
  color: #ffffff;
  margin-bottom: 10px;
  text-shadow: 2px 4px 8px rgba(0, 0, 0, 0.3);
  text-align: center;
  text-transform: uppercase;
  letter-spacing: 2px;
}

.section-subtitle {
  font-size: clamp(1rem, 2.5vw, 1.25rem);
  color: rgba(255, 255, 255, 0.8);
  max-width: 600px;
  margin: 0 auto;
  line-height: 1.6;
}

.screens-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
  gap: 40px;
  margin-bottom: 80px;

  @media (max-width: $breakpoint-md) {
    grid-template-columns: 1fr;
    gap: 30px;
  }
}

.screen-card {
  background: rgba(white, 0.95);
  border-radius: $border-radius-xl;
  overflow: hidden;
  box-shadow: $shadow-lg;
  transition: all 0.3s ease;
  border: 1px solid rgba(white, 0.2);

  &:hover {
    transform: translateY(-10px);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
  }
}

.screen-image {
  position: relative;
  height: 250px;
  overflow: hidden;

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.3s ease;
  }

  &:hover img {
    transform: scale(1.05);
  }
}

.screen-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(
    135deg,
    rgba($primary-color, 0.3) 0%,
    rgba($secondary-color, 0.1) 100%
  );
  display: flex;
  align-items: flex-start;
  justify-content: flex-end;
  padding: 20px;
}

.screen-badge {
  background: $accent-color;
  color: white;
  padding: 8px 16px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.screen-content {
  padding: 30px;
}

.screen-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: $text-dark;
  margin-bottom: 15px;
}

.screen-description {
  color: lighten($text-dark, 15%);
  line-height: 1.6;
  margin-bottom: 25px;
}

.screen-features {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.feature {
  display: flex;
  align-items: center;
  gap: 12px;
}

.feature-icon {
  font-size: 18px;
  width: 24px;
  text-align: center;
}

.feature-text {
  font-size: 14px;
  color: $text-dark;
  font-weight: 500;
}

.screen-stats {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  max-width: 1000px;
  margin: 0 auto;

  @media (max-width: $breakpoint-md) {
    grid-template-columns: repeat(2, 1fr);
    gap: 15px;
  }

  @media (max-width: $breakpoint-sm) {
    grid-template-columns: repeat(2, 1fr);
    gap: 15px;
  }
}

.stat-card {
  text-align: center;
  padding: 20px 15px;
  background: rgba(white, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(white, 0.2);
  border-radius: $border-radius-lg;
  transition: all 0.3s ease;
  min-height: 120px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;

  &:hover {
    transform: translateY(-5px);
    background: rgba(white, 0.15);
  }
}

.stat-number {
  font-size: clamp(1.8rem, 3.5vw, 2.5rem);
  font-weight: 900;
  color: $accent-color;
  display: block;
  margin-bottom: 8px;
  text-align: center;
}

.stat-label {
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 1px;
  color: #ffffff;
  font-weight: 600;
  text-align: center;
  line-height: 1.3;
}

// Animation classes
.fade-in {
  opacity: 0;
  transform: translateY(30px);
  transition: all 0.6s ease;

  &.animate {
    opacity: 1;
    transform: translateY(0);
  }
}

.slide-in-left {
  opacity: 0;
  transform: translateX(-50px);
  transition: all 0.8s ease;

  &.animate {
    opacity: 1;
    transform: translateX(0);
  }
}

.slide-in-right {
  opacity: 0;
  transform: translateX(50px);
  transition: all 0.8s ease;

  &.animate {
    opacity: 1;
    transform: translateX(0);
  }
}

.slide-in-up {
  opacity: 0;
  transform: translateY(50px);
  transition: all 0.8s ease;

  &.animate {
    opacity: 1;
    transform: translateY(0);
  }
}

// Accessibility
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
</style>
