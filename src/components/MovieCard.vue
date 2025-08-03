<template>
  <div class="movie-card" :data-movie-id="movie.id">
    <div class="movie-image-container">
      <img 
        :src="movie.image" 
        :alt="movie.title"
        class="movie-image"
        @error="handleImageError"
        loading="lazy"
      />
      <div class="movie-overlay">
        <div class="movie-rating" v-if="movie.rating">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <polygon points="12,2 15.09,8.26 22,9.27 17,14.14 18.18,21.02 12,17.77 5.82,21.02 7,14.14 2,9.27 8.91,8.26" fill="currentColor"/>
          </svg>
          <span>{{ formatRating(movie.rating) }}</span>
        </div>
        <button 
          class="close-button"
          @click="removeMovie"
          aria-label="Remove movie from list"
          title="Remove movie"
        >
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <line x1="18" y1="6" x2="6" y2="18" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <line x1="6" y1="6" x2="18" y2="18" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </button>
      </div>
      <div class="movie-genre" v-if="movie.releaseDate">
        {{ formatReleaseYear(movie.releaseDate) }}
      </div>
    </div>
    
    <div class="movie-content">
      <h3 class="movie-title">{{ movie.title }}</h3>
      <p class="movie-description">{{ truncatedDescription }}</p>
      
      <div class="movie-actions">
        <button class="btn btn-primary btn-sm" @click="viewDetails">
          View Details
        </button>
        <button class="btn btn-outline btn-sm" @click="addToWatchlist">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          Watchlist
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'MovieCard',
  props: {
    movie: {
      type: Object,
      required: true,
      validator(value) {
        return value && typeof value.id !== 'undefined' && value.title && value.description
      }
    }
  },
  computed: {
    truncatedDescription() {
      const maxLength = 120
      if (this.movie.description.length <= maxLength) {
        return this.movie.description
      }
      return this.movie.description.substring(0, maxLength).trim() + '...'
    }
  },
  methods: {
    removeMovie() {
      // Add confirmation for better UX
      if (confirm(`Are you sure you want to remove "${this.movie.title}" from the list?`)) {
        this.$emit('remove', this.movie.id)
      }
    },
    
    viewDetails() {
      // This could open a modal or navigate to a detail page
      alert(`Viewing details for: ${this.movie.title}`)
      // In a real app, you might do:
      // this.$router.push(`/movie/${this.movie.id}`)
    },
    
    addToWatchlist() {
      // This could add to local storage or send to an API
      alert(`Added "${this.movie.title}" to your watchlist!`)
      // In a real app, you might do:
      // this.$store.dispatch('addToWatchlist', this.movie)
    },
    
    formatRating(rating) {
      if (typeof rating === 'number') {
        return rating.toFixed(1)
      }
      return rating
    },
    
    formatReleaseYear(releaseDate) {
      if (!releaseDate) return ''
      const date = new Date(releaseDate)
      return date.getFullYear()
    },
    
    handleImageError(event) {
      // Fallback image if the original fails to load
      event.target.src = '/src/assets/images/placeholder-movie.jpg'
    }
  }
}
</script>

<style lang="scss" scoped>
.movie-card {
  background-color: white;
  border-radius: $border-radius-lg;
  overflow: hidden;
  box-shadow: $shadow-md;
  transition: all $transition-normal;
  height: 100%;
  display: flex;
  flex-direction: column;

  &:hover {
    transform: translateY(-8px);
    box-shadow: $shadow-xl;
  }

  &:focus-within {
    outline: 2px solid $primary-color;
    outline-offset: 2px;
  }
}

.movie-image-container {
  position: relative;
  width: 100%;
  height: 300px;
  overflow: hidden;

  @media (max-width: $breakpoint-sm) {
    height: 250px;
  }
}

.movie-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform $transition-slow;

  .movie-card:hover & {
    transform: scale(1.05);
  }
}

.movie-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(
    to bottom,
    rgba(0, 0, 0, 0.1) 0%,
    transparent 30%,
    transparent 70%,
    rgba(0, 0, 0, 0.7) 100%
  );
  opacity: 0;
  transition: opacity $transition-normal;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: $spacing-md;

  .movie-card:hover & {
    opacity: 1;
  }
}

.movie-rating {
  display: flex;
  align-items: center;
  gap: $spacing-xs;
  background-color: rgba($accent-color, 0.9);
  color: $text-dark;
  padding: $spacing-xs $spacing-sm;
  border-radius: $border-radius-md;
  font-size: $font-size-sm;
  font-weight: 600;

  svg {
    color: $accent-color;
  }
}

.movie-genre {
  position: absolute;
  bottom: $spacing-md;
  left: $spacing-md;
  background-color: rgba($primary-color, 0.9);
  color: $text-primary;
  padding: $spacing-xs $spacing-sm;
  border-radius: $border-radius-md;
  font-size: $font-size-sm;
  font-weight: 500;
}

.close-button {
  background-color: rgba($error-color, 0.9);
  color: white;
  border: none;
  border-radius: 50%;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all $transition-normal;

  &:hover {
    background-color: $error-color;
    transform: scale(1.1);
  }

  &:focus {
    outline: 2px solid white;
    outline-offset: 2px;
  }
}

.movie-content {
  padding: $spacing-lg;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.movie-title {
  font-size: $font-size-xl;
  font-weight: 600;
  color: $text-dark;
  margin-bottom: $spacing-sm;
  line-height: 1.3;

  @media (max-width: $breakpoint-sm) {
    font-size: $font-size-lg;
  }
}

.movie-description {
  font-size: $font-size-base;
  color: lighten($text-dark, 15%);
  line-height: 1.6;
  margin-bottom: $spacing-lg;
  flex: 1;

  @media (max-width: $breakpoint-sm) {
    font-size: $font-size-sm;
  }
}

.movie-actions {
  display: flex;
  gap: $spacing-sm;
  margin-top: auto;

  @media (max-width: $breakpoint-sm) {
    flex-direction: column;
  }
}

.btn-sm {
  padding: $spacing-xs $spacing-md;
  font-size: $font-size-sm;
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: $spacing-xs;

  &:hover {
    transform: translateY(-1px);
  }
}

// Loading state for images
.movie-image {
  background-color: lighten($text-dark, 80%);
  background-image: linear-gradient(
    45deg,
    transparent 35%,
    rgba(255, 255, 255, 0.5) 50%,
    transparent 65%
  );
  background-size: 200% 100%;
  animation: loading 1.5s infinite;

  &[src] {
    animation: none;
    background: none;
  }
}

@keyframes loading {
  0% {
    background-position: 200% 0;
  }
  100% {
    background-position: -200% 0;
  }
}

// Accessibility improvements
.movie-card {
  &:focus {
    outline: 2px solid $primary-color;
    outline-offset: 2px;
  }
}

.close-button,
.btn {
  &:focus {
    outline: 2px solid $accent-color;
    outline-offset: 2px;
  }
}

// Reduced motion support
@media (prefers-reduced-motion: reduce) {
  .movie-card {
    transition: none;

    &:hover {
      transform: none;
    }
  }

  .movie-image {
    transition: none;
    animation: none;

    .movie-card:hover & {
      transform: none;
    }
  }

  .movie-overlay {
    transition: none;
  }

  .close-button {
    transition: none;

    &:hover {
      transform: none;
    }
  }

  .btn-sm {
    &:hover {
      transform: none;
    }
  }
}

// High contrast mode support
@media (prefers-contrast: high) {
  .movie-card {
    border: 2px solid $text-dark;
  }

  .movie-rating {
    background-color: $accent-color;
    color: $text-dark;
    border: 1px solid $text-dark;
  }

  .movie-genre {
    background-color: $primary-color;
    border: 1px solid white;
  }

  .close-button {
    background-color: $error-color;
    border: 1px solid white;
  }
}
</style>
