<template>
  <div id="app" :dir="isRTL ? 'rtl' : 'ltr'">
    <AppHeader 
      @toggle-menu="toggleMobileMenu" 
      :is-mobile-menu-open="isMobileMenuOpen"
      @navigate="handleNavigation"
      :current-page="currentPage"
    />
    
    <!-- Page Content Based on Current Page -->
    <main class="main-content">
      <transition name="page-fade" mode="out-in">
        <!-- Home Page -->
        <div key="home" v-if="currentPage === 'HOME'" class="page-content">
          <HeroSection :current-page="currentPage" />
          <OurScreensSection />
          <ScheduleSection />
          <MovieLibrarySection />
          <ContactSection />
        </div>

        <!-- Our Screens Page -->
        <div key="screens" v-else-if="currentPage === 'OUR SCREENS'" class="page-content">
          <HeroSection :current-page="currentPage" />
          <OurScreensSection />
        </div>

        <!-- Schedule Page -->
        <div key="schedule" v-else-if="currentPage === 'SCHEDULE'" class="page-content">
          <HeroSection :current-page="currentPage" />
          <ScheduleSection />
        </div>

        <!-- Movie Library Page -->
        <div key="library" v-else-if="currentPage === 'MOVIE LIBRARY'" class="page-content">
          <HeroSection :current-page="currentPage" />
          <MovieLibrarySection />
        </div>

        <!-- Contact Page -->
        <div key="contact" v-else-if="currentPage === 'LOCATION & CONTACT'" class="page-content">
          <HeroSection :current-page="currentPage" />
          <ContactSection />
        </div>
      </transition>
    </main>

    <AppFooter 
      @toggle-rtl="toggleRTL"
      @navigate="handleNavigation"
      :is-rtl="isRTL"
    />
  </div>
</template>

<script>
import AppHeader from './components/AppHeader.vue'
import HeroSection from './components/HeroSection.vue'
import OurScreensSection from './components/OurScreensSection.vue'
import ScheduleSection from './components/ScheduleSection.vue'
import MovieLibrarySection from './components/MovieLibrarySection.vue'
import ContactSection from './components/ContactSection.vue'
import AppFooter from './components/AppFooter.vue'

export default {
  name: 'App',
  components: {
    AppHeader,
    HeroSection,
    OurScreensSection,
    ScheduleSection,
    MovieLibrarySection,
    ContactSection,
    AppFooter
  },
  data() {
    return {
      isMobileMenuOpen: false,
      isRTL: false,
      currentPage: 'HOME'
    }
  },
  methods: {
    toggleMobileMenu() {
      this.isMobileMenuOpen = !this.isMobileMenuOpen;
    },
    handleNavigation(page) {
      this.currentPage = page;
      this.isMobileMenuOpen = false; // Close mobile menu when navigating
      
      // Scroll to top when changing pages
      window.scrollTo({ top: 0, behavior: 'smooth' });
    },
    toggleRTL() {
      this.isRTL = !this.isRTL;
      // Update document direction
      document.documentElement.dir = this.isRTL ? 'rtl' : 'ltr';
      document.documentElement.lang = this.isRTL ? 'ar' : 'en';
      
      // Save preference to localStorage
      localStorage.setItem('rtl-preference', this.isRTL.toString());
    }
  },
  mounted() {
    // Check for saved RTL preference
    const savedRTL = localStorage.getItem('rtl-preference');
    if (savedRTL !== null) {
      this.isRTL = savedRTL === 'true';
    }
    
    // Set initial direction
    document.documentElement.dir = this.isRTL ? 'rtl' : 'ltr';
    document.documentElement.lang = this.isRTL ? 'ar' : 'en';
    
    // Initialize overall app layout
    setTimeout(() => {
      if (typeof gsap !== 'undefined') {
        gsap.set("#app", { opacity: 1 });
      }
    }, 100);
  }
}
</script>

<style lang="scss">
// Global styles to ensure proper layout
html, body {
  margin: 0;
  padding: 0;
  height: 100%;
  overflow-x: hidden;
}

#app {
  transition: all 0.3s ease;
  margin: 0;
  padding: 0;
  direction: ltr; // Default LTR, will be overridden by :dir attribute
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  
  &[dir="rtl"] {
    direction: rtl;
  }
}

// Main content container
.main-content {
  flex: 1 0 auto; // Ensure main content takes available space
  overflow-x: hidden;
  width: 100%;
  
  // Ensure there's space for the footer
  padding-bottom: 0;
  margin-bottom: 0;
}

// Page content wrapper
.page-content {
  width: 100%;
  min-height: calc(100vh - 80px); // Account for header height
  display: flex;
  flex-direction: column;
  
  // Specific styling for single-section pages
  &:has(> :only-child:not(.hero)) {
    min-height: auto;
  }
}

// Page transition animations
.page-fade-enter-active,
.page-fade-leave-active {
  transition: all 0.4s ease;
}

.page-fade-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.page-fade-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

// RTL page transitions
[dir="rtl"] {
  .page-fade-enter-from {
    transform: translateX(-30px);
  }

  .page-fade-leave-to {
    transform: translateX(30px);
  }
}

// Ensure full-screen hero section
.hero {
  margin: 0 !important;
  padding: 0 !important;
  
  .video-background,
  .hero-video {
    margin: 0 !important;
    padding: 0 !important;
  }
}

// Ensure footer is always at the bottom
.footer {
  flex-shrink: 0; // Prevent footer from shrinking
  position: relative;
  z-index: 10;
  width: 100%;
  margin-top: auto;
  
  // Ensure footer visibility with important styles
  display: block !important;
  visibility: visible !important;
  opacity: 1 !important;
}

// Prevent content overflow that might hide footer
.main-content {
  overflow: visible;
  position: relative;
}

// Ensure page content doesn't overlap footer
.page-content {
  margin-bottom: 0;
  padding-bottom: 0;
  position: relative;
}
</style>