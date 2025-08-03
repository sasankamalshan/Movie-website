<template>
  <section id="about" class="introduction" ref="introSection">
    <div class="container">
      <div class="row align-items-center">
        <!-- Text Content -->
        <div class="col-lg-6 order-2 order-lg-1">
          <div class="intro-content" ref="introContent">
            <div class="intro-badge" ref="introBadge">
              <span class="badge-icon">✨</span>
              <span class="badge-text">About MovieWeb</span>
            </div>
            
            <h2 class="intro-title" ref="introTitle">
              <span class="title-line" ref="titleLine1">Discover Your Next</span>
              <span class="title-line" ref="titleLine2">Favorite Movie</span>
            </h2>
            
            <div class="intro-description" ref="introDescription">
              <p class="description-text" ref="descText1">
                Welcome to MovieWeb, your ultimate destination for exploring the world of cinema. 
                We bring you the latest movies, timeless classics, and hidden gems from around the globe.
              </p>
              <p class="description-text" ref="descText2">
                Our platform features comprehensive movie information, user reviews, ratings, and 
                personalized recommendations to help you discover your next favorite film.
              </p>
            </div>

            <div class="intro-features" ref="introFeatures">
              <div class="feature-item" ref="feature1">
                <div class="feature-icon">🎬</div>
                <div class="feature-content">
                  <h4>Latest Movies</h4>
                  <p>Stay updated with the newest releases</p>
                </div>
              </div>
              <div class="feature-item" ref="feature2">
                <div class="feature-icon">⭐</div>
                <div class="feature-content">
                  <h4>Expert Reviews</h4>
                  <p>Read professional and user reviews</p>
                </div>
              </div>
              <div class="feature-item" ref="feature3">
                <div class="feature-icon">🔍</div>
                <div class="feature-content">
                  <h4>Smart Search</h4>
                  <p>Find movies by genre, year, or rating</p>
                </div>
              </div>
            </div>

            <div class="intro-stats" ref="introStats">
              <div class="stat-item" ref="stat1">
                <div class="stat-number" data-count="50000">0</div>
                <div class="stat-label">Movies Available</div>
              </div>
              <div class="stat-item" ref="stat2">
                <div class="stat-number" data-count="1000000">0</div>
                <div class="stat-label">Happy Users</div>
              </div>
              <div class="stat-item" ref="stat3">
                <div class="stat-number" data-count="5000">0</div>
                <div class="stat-label">Daily Visitors</div>
              </div>
            </div>

            <div class="intro-actions" ref="introActions">
              <button class="btn btn-primary explore-btn" ref="exploreBtn">
                <span class="btn-text">Explore Movies</span>
                <span class="btn-icon">🚀</span>
              </button>
              <button class="btn btn-outline learn-more-btn" ref="learnMoreBtn">
                <span class="btn-text">Learn More</span>
                <span class="btn-arrow">→</span>
              </button>
            </div>
          </div>
        </div>

        <!-- Visual Content -->
        <div class="col-lg-6 order-1 order-lg-2">
          <div class="intro-visual" ref="introVisual">
            <div class="visual-container" ref="visualContainer">
              <div class="floating-element floating-element-1" ref="floating1">
                <div class="element-content">
                  <span class="element-icon">🎭</span>
                  <span class="element-text">Drama</span>
                </div>
              </div>
              <div class="floating-element floating-element-2" ref="floating2">
                <div class="element-content">
                  <span class="element-icon">🚀</span>
                  <span class="element-text">Sci-Fi</span>
                </div>
              </div>
              <div class="floating-element floating-element-3" ref="floating3">
                <div class="element-content">
                  <span class="element-icon">😂</span>
                  <span class="element-text">Comedy</span>
                </div>
              </div>
              <div class="floating-element floating-element-4" ref="floating4">
                <div class="element-content">
                  <span class="element-icon">💥</span>
                  <span class="element-text">Action</span>
                </div>
              </div>
              
              <div class="main-visual" ref="mainVisual">
                <div class="visual-bg"></div>
                <div class="visual-content">
                  <div class="visual-text">
                    <div class="visual-number" ref="visualNumber">50K+</div>
                    <div class="visual-label">Movies & Shows</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Background Decorations -->
    <div class="section-decorations" ref="sectionDecorations">
      <div class="decoration decoration-1"></div>
      <div class="decoration decoration-2"></div>
      <div class="decoration decoration-3"></div>
    </div>
  </section>
</template>

<script>
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'

gsap.registerPlugin(ScrollTrigger)

export default {
  name: 'IntroductionSection',
  mounted() {
    this.initializeAnimations()
  },
  beforeUnmount() {
    ScrollTrigger.getAll().forEach(trigger => trigger.kill())
  },
  methods: {
    initializeAnimations() {
      this.setupEntranceAnimations()
      this.setupCounterAnimations()
      this.setupFloatingAnimations()
      this.setupInteractiveAnimations()
      this.setupScrollAnimations()
    },

    setupEntranceAnimations() {
      // Set initial states
      gsap.set([this.$refs.introBadge, this.$refs.titleLine1, this.$refs.titleLine2], { y: 50, opacity: 0 })
      gsap.set([this.$refs.descText1, this.$refs.descText2], { y: 30, opacity: 0 })
      gsap.set([this.$refs.feature1, this.$refs.feature2, this.$refs.feature3], { x: -50, opacity: 0 })
      gsap.set([this.$refs.stat1, this.$refs.stat2, this.$refs.stat3], { scale: 0, opacity: 0 })
      gsap.set([this.$refs.exploreBtn, this.$refs.learnMoreBtn], { y: 30, opacity: 0 })
      gsap.set(this.$refs.introVisual, { x: 100, opacity: 0 })

      // Create scroll-triggered timeline
      const tl = gsap.timeline({
        scrollTrigger: {
          trigger: this.$refs.introSection,
          start: "top 80%",
          end: "bottom 20%",
          toggleActions: "play none none reverse"
        }
      })

      // Badge animation
      tl.to(this.$refs.introBadge, {
        y: 0,
        opacity: 1,
        duration: 0.6,
        ease: "back.out(1.7)"
      })

      // Title lines
      .to([this.$refs.titleLine1, this.$refs.titleLine2], {
        y: 0,
        opacity: 1,
        duration: 0.8,
        stagger: 0.2,
        ease: "power3.out"
      }, "-=0.3")

      // Description paragraphs
      .to([this.$refs.descText1, this.$refs.descText2], {
        y: 0,
        opacity: 1,
        duration: 0.6,
        stagger: 0.15,
        ease: "power2.out"
      }, "-=0.4")

      // Features
      .to([this.$refs.feature1, this.$refs.feature2, this.$refs.feature3], {
        x: 0,
        opacity: 1,
        duration: 0.6,
        stagger: 0.1,
        ease: "back.out(1.7)"
      }, "-=0.2")

      // Stats
      .to([this.$refs.stat1, this.$refs.stat2, this.$refs.stat3], {
        scale: 1,
        opacity: 1,
        duration: 0.5,
        stagger: 0.1,
        ease: "back.out(1.7)"
      }, "-=0.3")

      // Buttons
      .to([this.$refs.exploreBtn, this.$refs.learnMoreBtn], {
        y: 0,
        opacity: 1,
        duration: 0.6,
        stagger: 0.1,
        ease: "power2.out"
      }, "-=0.2")

      // Visual content
      .to(this.$refs.introVisual, {
        x: 0,
        opacity: 1,
        duration: 1,
        ease: "power3.out"
      }, "-=0.8")
    },

    setupCounterAnimations() {
      const statNumbers = this.$refs.introStats?.querySelectorAll('.stat-number')
      
      if (statNumbers) {
        statNumbers.forEach(number => {
          const targetValue = parseInt(number.dataset.count)
          
          ScrollTrigger.create({
            trigger: number,
            start: "top 80%",
            onEnter: () => {
              gsap.fromTo(number, {
                innerText: 0
              }, {
                innerText: targetValue,
                duration: 2,
                ease: "power2.out",
                snap: { innerText: 1 },
                onUpdate: function() {
                  const value = Math.round(this.targets()[0].innerText)
                  if (value >= 1000) {
                    this.targets()[0].innerText = (value / 1000).toFixed(0) + 'K+'
                  } else {
                    this.targets()[0].innerText = value.toLocaleString()
                  }
                }
              })
            }
          })
        })
      }
    },

    setupFloatingAnimations() {
      const floatingElements = [
        this.$refs.floating1, this.$refs.floating2,
        this.$refs.floating3, this.$refs.floating4
      ].filter(el => el)

      floatingElements.forEach((element, index) => {
        // Initial setup
        gsap.set(element, { 
          scale: 0, 
          rotation: Math.random() * 360,
          opacity: 0
        })

        // Entrance animation
        gsap.to(element, {
          scale: 1,
          opacity: 1,
          duration: 0.8,
          delay: 0.5 + index * 0.2,
          ease: "back.out(1.7)",
          scrollTrigger: {
            trigger: this.$refs.introVisual,
            start: "top 80%",
            toggleActions: "play none none reverse"
          }
        })

        // Continuous floating
        gsap.to(element, {
          y: -15,
          x: Math.sin(index) * 10,
          rotation: 360,
          duration: 4 + index * 0.5,
          repeat: -1,
          yoyo: true,
          ease: "sine.inOut",
          delay: index * 0.5
        })
      })
    },

    setupInteractiveAnimations() {
      // Feature items hover
      const features = [this.$refs.feature1, this.$refs.feature2, this.$refs.feature3].filter(f => f)
      
      features.forEach(feature => {
        feature.addEventListener('mouseenter', () => {
          gsap.to(feature, {
            scale: 1.05,
            y: -5,
            duration: 0.3,
            ease: "power2.out"
          })
        })

        feature.addEventListener('mouseleave', () => {
          gsap.to(feature, {
            scale: 1,
            y: 0,
            duration: 0.3,
            ease: "power2.out"
          })
        })
      })

      // Button hover animations
      if (this.$refs.exploreBtn) {
        this.$refs.exploreBtn.addEventListener('mouseenter', () => {
          gsap.to(this.$refs.exploreBtn.querySelector('.btn-icon'), {
            x: 5,
            rotation: 15,
            duration: 0.3,
            ease: "power2.out"
          })
        })

        this.$refs.exploreBtn.addEventListener('mouseleave', () => {
          gsap.to(this.$refs.exploreBtn.querySelector('.btn-icon'), {
            x: 0,
            rotation: 0,
            duration: 0.3,
            ease: "power2.out"
          })
        })
      }

      if (this.$refs.learnMoreBtn) {
        this.$refs.learnMoreBtn.addEventListener('mouseenter', () => {
          gsap.to(this.$refs.learnMoreBtn.querySelector('.btn-arrow'), {
            x: 10,
            duration: 0.3,
            ease: "power2.out"
          })
        })

        this.$refs.learnMoreBtn.addEventListener('mouseleave', () => {
          gsap.to(this.$refs.learnMoreBtn.querySelector('.btn-arrow'), {
            x: 0,
            duration: 0.3,
            ease: "power2.out"
          })
        })
      }

      // Stats hover
      const stats = [this.$refs.stat1, this.$refs.stat2, this.$refs.stat3].filter(s => s)
      
      stats.forEach(stat => {
        stat.addEventListener('mouseenter', () => {
          gsap.to(stat, {
            scale: 1.1,
            duration: 0.3,
            ease: "back.out(1.7)"
          })
        })

        stat.addEventListener('mouseleave', () => {
          gsap.to(stat, {
            scale: 1,
            duration: 0.3,
            ease: "power2.out"
          })
        })
      })
    },

    setupScrollAnimations() {
      // Parallax effect for decorations
      const decorations = this.$refs.sectionDecorations?.querySelectorAll('.decoration')
      
      if (decorations) {
        decorations.forEach((decoration, index) => {
          gsap.to(decoration, {
            yPercent: -50 * (index + 1),
            ease: "none",
            scrollTrigger: {
              trigger: this.$refs.introSection,
              start: "top bottom",
              end: "bottom top",
              scrub: true
            }
          })
        })
      }

      // Visual number animation on scroll
      if (this.$refs.visualNumber) {
        gsap.fromTo(this.$refs.visualNumber, {
          scale: 0.8,
          opacity: 0.5
        }, {
          scale: 1.2,
          opacity: 1,
          duration: 1,
          scrollTrigger: {
            trigger: this.$refs.visualNumber,
            start: "top 70%",
            end: "bottom 30%",
            scrub: 1
          }
        })
      }
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../assets/styles/variables.scss';

.introduction {
  padding: 8rem 0;
  background: linear-gradient(135deg, #0a0a0a 0%, #1a1a1a 100%);
  position: relative;
  overflow: hidden;

  // Background Decorations
  .section-decorations {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    pointer-events: none;
    z-index: 1;

    .decoration {
      position: absolute;
      border-radius: 50%;
      background: linear-gradient(45deg, rgba(229, 9, 20, 0.1), rgba(255, 215, 0, 0.1));
      filter: blur(2px);

      &.decoration-1 {
        width: 300px;
        height: 300px;
        top: 10%;
        right: -10%;
      }

      &.decoration-2 {
        width: 200px;
        height: 200px;
        bottom: 20%;
        left: -5%;
      }

      &.decoration-3 {
        width: 150px;
        height: 150px;
        top: 60%;
        right: 20%;
      }
    }
  }

  .intro-content {
    position: relative;
    z-index: 2;
  }

  // Badge
  .intro-badge {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    background: rgba(229, 9, 20, 0.1);
    border: 1px solid rgba(229, 9, 20, 0.3);
    border-radius: 50px;
    padding: 0.5rem 1rem;
    margin-bottom: 2rem;
    color: $accent-color;
    font-size: 0.9rem;
    font-weight: 500;

    .badge-icon {
      font-size: 1.2rem;
      animation: sparkle 2s infinite;
    }
  }

  // Title
  .intro-title {
    margin-bottom: 2rem;

    .title-line {
      display: block;
      font-size: 3rem;
      font-weight: 700;
      line-height: 1.1;
      background: linear-gradient(45deg, $text-light, $accent-color);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;

      &:first-child {
        margin-bottom: 0.5rem;
      }
    }
  }

  // Description
  .intro-description {
    margin-bottom: 3rem;

    .description-text {
      color: rgba($text-light, 0.8);
      font-size: 1.1rem;
      line-height: 1.6;
      margin-bottom: 1.5rem;

      &:last-child {
        margin-bottom: 0;
      }
    }
  }

  // Features
  .intro-features {
    margin-bottom: 3rem;

    .feature-item {
      display: flex;
      align-items: flex-start;
      gap: 1rem;
      margin-bottom: 2rem;
      padding: 1.5rem;
      background: rgba(255, 255, 255, 0.05);
      border-radius: 12px;
      border: 1px solid rgba(255, 255, 255, 0.1);
      transition: all 0.3s ease;
      cursor: pointer;

      .feature-icon {
        font-size: 1.5rem;
        flex-shrink: 0;
      }

      .feature-content {
        h4 {
          color: $text-light;
          font-size: 1.1rem;
          font-weight: 600;
          margin-bottom: 0.5rem;
        }

        p {
          color: rgba($text-light, 0.7);
          font-size: 0.9rem;
          line-height: 1.4;
          margin: 0;
        }
      }

      &:hover {
        background: rgba(229, 9, 20, 0.1);
        border-color: rgba(229, 9, 20, 0.3);
        transform: translateY(-2px);
      }
    }
  }

  // Stats
  .intro-stats {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 2rem;
    margin-bottom: 3rem;

    .stat-item {
      text-align: center;
      padding: 2rem 1rem;
      background: rgba(255, 255, 255, 0.05);
      border-radius: 12px;
      border: 1px solid rgba(255, 255, 255, 0.1);
      transition: all 0.3s ease;
      cursor: pointer;

      .stat-number {
        font-size: 2.5rem;
        font-weight: 700;
        color: $primary-color;
        display: block;
        margin-bottom: 0.5rem;
      }

      .stat-label {
        color: rgba($text-light, 0.8);
        font-size: 0.9rem;
        font-weight: 500;
      }

      &:hover {
        background: rgba(255, 215, 0, 0.1);
        border-color: rgba(255, 215, 0, 0.3);
      }
    }
  }

  // Actions
  .intro-actions {
    display: flex;
    gap: 1rem;
    flex-wrap: wrap;

    .btn {
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      padding: 1rem 2rem;
      border-radius: 50px;
      font-weight: 600;
      text-decoration: none;
      transition: all 0.3s ease;
      cursor: pointer;
      border: none;
      font-size: 1rem;

      &.btn-primary {
        background: linear-gradient(45deg, $primary-color, #ff1744);
        color: white;

        &:hover {
          transform: translateY(-2px);
          box-shadow: 0 10px 30px rgba(229, 9, 20, 0.4);
        }
      }

      &.btn-outline {
        background: transparent;
        color: $text-light;
        border: 2px solid rgba(255, 255, 255, 0.3);

        &:hover {
          background: rgba(255, 255, 255, 0.1);
          border-color: $accent-color;
          color: $accent-color;
        }
      }

      .btn-icon, .btn-arrow {
        transition: transform 0.3s ease;
      }
    }
  }

  // Visual Section
  .intro-visual {
    position: relative;
    height: 500px;

    .visual-container {
      position: relative;
      width: 100%;
      height: 100%;
    }

    .floating-element {
      position: absolute;
      background: rgba(255, 255, 255, 0.1);
      border: 1px solid rgba(255, 255, 255, 0.2);
      border-radius: 12px;
      padding: 1rem;
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);

      .element-content {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 0.5rem;
        text-align: center;

        .element-icon {
          font-size: 1.5rem;
        }

        .element-text {
          color: $text-light;
          font-size: 0.8rem;
          font-weight: 500;
        }
      }

      &.floating-element-1 {
        top: 10%;
        left: 10%;
      }

      &.floating-element-2 {
        top: 20%;
        right: 15%;
      }

      &.floating-element-3 {
        bottom: 30%;
        left: 5%;
      }

      &.floating-element-4 {
        bottom: 10%;
        right: 10%;
      }
    }

    .main-visual {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      width: 250px;
      height: 250px;
      border-radius: 50%;
      background: linear-gradient(45deg, $primary-color, $accent-color);
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 20px 60px rgba(229, 9, 20, 0.3);

      .visual-bg {
        position: absolute;
        top: 10px;
        left: 10px;
        right: 10px;
        bottom: 10px;
        border-radius: 50%;
        background: linear-gradient(135deg, #0a0a0a, #1a1a1a);
      }

      .visual-content {
        position: relative;
        z-index: 2;
        text-align: center;

        .visual-text {
          .visual-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: $accent-color;
            display: block;
            margin-bottom: 0.5rem;
          }

          .visual-label {
            color: rgba($text-light, 0.8);
            font-size: 0.9rem;
            font-weight: 500;
          }
        }
      }
    }
  }
}

// Animations
@keyframes sparkle {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.2);
  }
}

// Responsive Design
@media (max-width: 768px) {
  .introduction {
    padding: 4rem 0;

    .intro-title {
      .title-line {
        font-size: 2rem;
      }
    }

    .intro-stats {
      grid-template-columns: 1fr;
      gap: 1rem;

      .stat-item {
        padding: 1.5rem 1rem;

        .stat-number {
          font-size: 2rem;
        }
      }
    }

    .intro-actions {
      flex-direction: column;
      align-items: stretch;

      .btn {
        justify-content: center;
      }
    }

    .intro-visual {
      height: 300px;
      margin-top: 3rem;

      .main-visual {
        width: 180px;
        height: 180px;

        .visual-content .visual-text {
          .visual-number {
            font-size: 1.8rem;
          }

          .visual-label {
            font-size: 0.8rem;
          }
        }
      }

      .floating-element {
        padding: 0.5rem;

        .element-content {
          .element-icon {
            font-size: 1.2rem;
          }

          .element-text {
            font-size: 0.7rem;
          }
        }
      }
    }
  }
}

@media (max-width: 480px) {
  .introduction {
    .intro-features .feature-item {
      padding: 1rem;
    }

    .intro-visual {
      height: 250px;

      .main-visual {
        width: 150px;
        height: 150px;
      }
    }
  }
}

// Accessibility
@media (prefers-reduced-motion: reduce) {
  .introduction {
    * {
      animation-duration: 0.01ms !important;
      animation-iteration-count: 1 !important;
      transition-duration: 0.01ms !important;
    }
  }
}

// High contrast mode
@media (prefers-contrast: high) {
  .introduction {
    background: black;

    .intro-badge {
      background: rgba(255, 255, 255, 0.2);
      border-color: white;
      color: white;
    }

    .intro-title .title-line {
      -webkit-text-fill-color: white;
    }

    .description-text {
      color: white;
    }

    .feature-item {
      background: rgba(255, 255, 255, 0.1);
      border-color: white;

      .feature-content h4 {
        color: white;
      }

      .feature-content p {
        color: rgba(255, 255, 255, 0.8);
      }
    }

    .stat-item {
      background: rgba(255, 255, 255, 0.1);
      border-color: white;

      .stat-number {
        color: white;
      }

      .stat-label {
        color: white;
      }
    }

    .btn-outline {
      color: white;
      border-color: white;
    }
  }
}
</style>
