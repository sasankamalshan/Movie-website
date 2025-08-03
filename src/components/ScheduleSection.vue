<template>
  <section class="schedule" id="schedule">
    <div class="container">
      <div class="section-header">
        <h2 class="section-title fade-in">MOVIE SCHEDULE</h2>
        <p class="section-subtitle fade-in">Check out today's showtimes and book your perfect movie experience</p>
      </div>

      <!-- Date Selector -->
      <div class="date-selector slide-in-up" ref="dateSelector">
        <div class="date-nav">
          <button class="date-btn prev" @click="previousDay">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
              <path d="M15 18L9 12L15 6" stroke="currentColor" stroke-width="2"/>
            </svg>
          </button>
          <div class="date-list">
            <div 
              v-for="(date, index) in dates" 
              :key="index"
              class="date-item"
              :class="{ active: selectedDate === index }"
              @click="selectDate(index)"
            >
              <div class="date-day">{{ date.day }}</div>
              <div class="date-date">{{ date.date }}</div>
            </div>
          </div>
          <button class="date-btn next" @click="nextDay">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
              <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2"/>
            </svg>
          </button>
        </div>
      </div>

      <!-- Movie Schedule Grid -->
      <div class="schedule-grid slide-in-up" ref="scheduleGrid">
        <div v-for="movie in movieSchedule" :key="movie.id" class="movie-schedule-card">
          <div class="movie-poster">
            <img :src="movie.poster" :alt="movie.title" />
            <div class="movie-rating">{{ movie.rating }}</div>
          </div>
          <div class="movie-details">
            <h3 class="movie-title">{{ movie.title }}</h3>
            <div class="movie-info">
              <span class="movie-genre">{{ movie.genre }}</span>
              <span class="movie-duration">{{ movie.duration }}</span>
            </div>
            <div class="showtimes">
              <div 
                v-for="time in movie.showtimes" 
                :key="time.id"
                class="showtime-slot"
                :class="{ booked: time.isBooked, available: time.availableSeats > 0 }"
                @click="!time.isBooked && selectShowtime(movie, time)"
              >
                <div class="showtime-time">{{ time.time }}</div>
                <div class="showtime-screen">{{ time.screen }}</div>
                <div class="showtime-seats">{{ time.availableSeats }} seats</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Quick Booking Panel -->
      <div v-if="selectedShowtime" class="booking-panel slide-in-up" ref="bookingPanel">
        <div class="booking-content">
          <h4>Quick Booking</h4>
          <div class="booking-details">
            <span>{{ selectedShowtime.movie.title }}</span>
            <span>{{ selectedShowtime.time.time }} - {{ selectedShowtime.time.screen }}</span>
            <span>{{ dates[selectedDate].day }}, {{ dates[selectedDate].date }}</span>
          </div>
          <div class="booking-actions">
            <button class="btn btn-outline" @click="cancelBooking">Cancel</button>
            <button class="btn btn-primary" @click="confirmBooking">Book Now</button>
          </div>
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
  name: 'ScheduleSection',
  data() {
    return {
      selectedDate: 0,
      selectedShowtime: null,
      dates: [
        { day: 'Today', date: 'Aug 2' },
        { day: 'Tomorrow', date: 'Aug 3' },
        { day: 'Sunday', date: 'Aug 4' },
        { day: 'Monday', date: 'Aug 5' },
        { day: 'Tuesday', date: 'Aug 6' },
        { day: 'Wednesday', date: 'Aug 7' },
        { day: 'Thursday', date: 'Aug 8' }
      ],
      movieSchedule: [
        {
          id: 1,
          title: 'Batman Returns',
          poster: '/src/assets/images/Batman.jpg',
          genre: 'Action, Drama',
          duration: '2h 32m',
          rating: '9.0',
          showtimes: [
            { id: 1, time: '10:30 AM', screen: 'IMAX Theatre', availableSeats: 45, isBooked: false },
            { id: 2, time: '2:15 PM', screen: 'IMAX Theatre', availableSeats: 23, isBooked: false },
            { id: 3, time: '6:00 PM', screen: 'IMAX Theatre', availableSeats: 67, isBooked: false },
            { id: 4, time: '9:45 PM', screen: 'IMAX Theatre', availableSeats: 0, isBooked: true }
          ]
        },
        {
          id: 2,
          title: 'The Amazing Spiderman',
          poster: '/src/assets/images/Spiderman.jpg',
          genre: 'Action, Adventure',
          duration: '2h 28m',
          rating: '8.4',
          showtimes: [
            { id: 5, time: '11:00 AM', screen: 'Dolby Cinema', availableSeats: 34, isBooked: false },
            { id: 6, time: '3:30 PM', screen: 'Dolby Cinema', availableSeats: 56, isBooked: false },
            { id: 7, time: '7:15 PM', screen: 'Dolby Cinema', availableSeats: 12, isBooked: false },
            { id: 8, time: '10:30 PM', screen: 'Dolby Cinema', availableSeats: 78, isBooked: false }
          ]
        },
        {
          id: 3,
          title: 'The Wild West',
          poster: '/src/assets/images/Wild West.jpg',
          genre: 'Western, Action',
          duration: '2h 15m',
          rating: '7.8',
          showtimes: [
            { id: 9, time: '12:45 PM', screen: 'VIP Lounge', availableSeats: 18, isBooked: false },
            { id: 10, time: '4:20 PM', screen: 'VIP Lounge', availableSeats: 25, isBooked: false },
            { id: 11, time: '8:00 PM', screen: 'VIP Lounge', availableSeats: 7, isBooked: false },
            { id: 12, time: '11:15 PM', screen: 'VIP Lounge', availableSeats: 0, isBooked: true }
          ]
        }
      ]
    }
  },
  mounted() {
    this.setupAnimations()
    this.setupIntersectionObserver()
  },
  methods: {
    setupAnimations() {
      ScrollTrigger.create({
        trigger: '.schedule-grid',
        start: 'top 80%',
        onEnter: () => {
          gsap.fromTo('.movie-schedule-card', 
            { y: 50, opacity: 0 },
            { y: 0, opacity: 1, duration: 0.8, stagger: 0.2, ease: 'power2.out' }
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

      const animatedElements = this.$el.querySelectorAll('.fade-in, .slide-in-up')
      animatedElements.forEach(el => observer.observe(el))
    },

    selectDate(index) {
      this.selectedDate = index
      this.selectedShowtime = null
    },

    previousDay() {
      if (this.selectedDate > 0) {
        this.selectedDate--
        this.selectedShowtime = null
      }
    },

    nextDay() {
      if (this.selectedDate < this.dates.length - 1) {
        this.selectedDate++
        this.selectedShowtime = null
      }
    },

    selectShowtime(movie, time) {
      this.selectedShowtime = { movie, time }
      
      // Animate booking panel
      this.$nextTick(() => {
        gsap.fromTo(this.$refs.bookingPanel, 
          { y: 50, opacity: 0 },
          { y: 0, opacity: 1, duration: 0.5, ease: 'power2.out' }
        )
      })
    },

    cancelBooking() {
      gsap.to(this.$refs.bookingPanel, {
        y: 50,
        opacity: 0,
        duration: 0.3,
        ease: 'power2.in',
        onComplete: () => {
          this.selectedShowtime = null
        }
      })
    },

    confirmBooking() {
      // Here you would integrate with booking system
      alert(`Booking confirmed for ${this.selectedShowtime.movie.title} at ${this.selectedShowtime.time.time}!`)
      this.cancelBooking()
    }
  }
}
</script>

<style lang="scss" scoped>
@import "./src/assets/styles/variables.scss";

.schedule {
  padding: 100px 0;
  background: linear-gradient(135deg, lighten($secondary-color, 5%) 0%, $secondary-color 100%);
  position: relative;
}

.section-header {
  text-align: center;
  margin-bottom: 60px;
}

.section-title {
  font-size: clamp(2.5rem, 5vw, 4rem);
  font-weight: 900;
  color: $text-primary;
  margin-bottom: 20px;
  text-shadow: 2px 4px 8px rgba(250, 242, 242, 0.3);
}

.section-subtitle {
  font-size: clamp(1rem, 2.5vw, 1.25rem);
  color: lighten($text-dark, 20%);
  max-width: 600px;
  margin: 0 auto;
  line-height: 1.6;
}

.date-selector {
  margin-bottom: 50px;
}

.date-nav {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  max-width: 800px;
  margin: 0 auto;

  @media (max-width: $breakpoint-md) {
    gap: 10px;
  }
}

.date-btn {
  background: rgba(white, 0.1);
  border: 1px solid rgba(white, 0.2);
  border-radius: 50%;
  width: 50px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: $text-primary;
  cursor: pointer;
  transition: all 0.3s ease;

  &:hover {
    background: rgba(white, 0.2);
    transform: scale(1.1);
  }

  &:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
}

.date-list {
  display: flex;
  gap: 15px;
  overflow-x: auto;
  padding: 10px 0;

  @media (max-width: $breakpoint-md) {
    gap: 10px;
  }
}

.date-item {
  text-align: center;
  padding: 15px 20px;
  background: rgba(rgb(230, 225, 225), 0.1);
  border: 1px solid rgba(rgb(250, 248, 248), 0.2);
  border-radius: $border-radius-lg;
  cursor: pointer;
  transition: all 0.3s ease;
  min-width: 110px;

  &:hover {
    background: rgba(white, 0.15);
    transform: translateY(-2px);
  }

  &.active {
    background: $primary-color;
    border-color: $primary-color;
    color: rgb(252, 249, 249);
  }
}

.date-day {
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 1px;
  margin-bottom: 5px;
  font-weight: 600;
}

.date-date {
  font-size: 14px;
  font-weight: 700;
}

.schedule-grid {
  display: grid;
  gap: 30px;
  margin-bottom: 40px;
}

.movie-schedule-card {
  background: rgba(rgb(218, 206, 206), 0.95);
  border-radius: $border-radius-xl;
  padding: 25px;
  box-shadow: $shadow-lg;
  display: grid;
  grid-template-columns: 120px 1fr;
  gap: 25px;
  transition: all 0.3s ease;

  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 15px 30px rgba(146, 143, 143, 0.1);
  }

  @media (max-width: $breakpoint-md) {
    grid-template-columns: 100px 1fr;
    gap: 20px;
    padding: 20px;
  }

  @media (max-width: $breakpoint-sm) {
    grid-template-columns: 1fr;
    text-align: center;
  }
}

.movie-poster {
  position: relative;
  
  img {
    width: 100%;
    height: 160px;
    object-fit: cover;
    border-radius: $border-radius-md;
  }
}

.movie-rating {
  position: absolute;
  top: 10px;
  right: 10px;
  background: $accent-color;
  color: rgb(165, 161, 161);
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 700;
}

.movie-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: $text-dark;
  margin-bottom: 10px;
}

.movie-info {
  display: flex;
  gap: 15px;
  margin-bottom: 20px;
  font-size: 14px;
  color: lighten($text-dark, 15%);

  @media (max-width: $breakpoint-sm) {
    justify-content: center;
  }
}

.movie-genre,
.movie-duration {
  background: lighten($tertiary-color, 10%);
  padding: 4px 12px;
  border-radius: 15px;
  font-weight: 500;
}

.showtimes {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
  gap: 12px;

  @media (max-width: $breakpoint-sm) {
    grid-template-columns: repeat(2, 1fr);
  }
}

.showtime-slot {
  padding: 12px;
  background: lighten($tertiary-color, 8%);
  border: 2px solid transparent;
  border-radius: $border-radius-md;
  cursor: pointer;
  transition: all 0.3s ease;
  text-align: center;

  &.available {
    &:hover {
      border-color: $primary-color;
      background: lighten($primary-color, 45%);
    }
  }

  &.booked {
    background: lighten($text-dark, 60%);
    color: lighten($text-dark, 20%);
    cursor: not-allowed;
  }
}

.showtime-time {
  font-weight: 700;
  font-size: 14px;
  margin-bottom: 4px;
}

.showtime-screen {
  font-size: 11px;
  color: lighten($text-dark, 20%);
  margin-bottom: 4px;
}

.showtime-seats {
  font-size: 10px;
  color: lighten($text-dark, 30%);
}

.booking-panel {
  background: rgb(227, 226, 224);
  border-radius: $border-radius-xl;
  padding: 25px;
  box-shadow: $shadow-lg;
  border: 2px solid $primary-color;
}

.booking-content {
  text-align: center;

  h4 {
    font-size: 1.25rem;
    font-weight: 700;
    color: $text-dark;
    margin-bottom: 15px;
  }
}

.booking-details {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 20px;
  font-size: 14px;
  color: lighten($text-dark, 15%);
}

.booking-actions {
  display: flex;
  gap: 15px;
  justify-content: center;

  @media (max-width: $breakpoint-sm) {
    flex-direction: column;
  }
}

.btn {
  padding: 12px 30px;
  border-radius: 25px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.3s ease;
  cursor: pointer;
  border: 2px solid;

  &.btn-primary {
    background: $primary-color;
    color: rgb(140, 135, 135);
    border-color: $primary-color;

    &:hover {
      background: darken($primary-color, 10%);
      border-color: darken($primary-color, 10%);
    }
  }

  &.btn-outline {
    background: transparent;
    color: $text-dark;
    border-color: $text-dark;

    &:hover {
      background: $text-dark;
      color: white;
    }
  }
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

.slide-in-up {
  opacity: 0;
  transform: translateY(50px);
  transition: all 0.8s ease;

  &.animate {
    opacity: 1;
    transform: translateY(0);
  }
}

@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
</style>
