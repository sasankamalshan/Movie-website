<template>
  <section class="movie-grid" id="movies">
    <div class="container">
      <div class="section-header">
        <h2 class="section-title fade-in">Featured Movies</h2>
        <p class="section-subtitle fade-in">Discover amazing films from around the world</p>
      </div>

      <!-- Search Bar -->
      <div class="search-container fade-in">
        <div class="search-input-wrapper">
          <input
            type="text"
            v-model="searchQuery"
            @input="handleSearch"
            placeholder="Search to add movies..."
            class="search-input"
            :disabled="isSearching"
          />
          <div class="search-icon">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <circle cx="11" cy="11" r="8" stroke="currentColor" stroke-width="2"/>
              <path d="M21 21L16.65 16.65" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div v-if="isSearching" class="search-loading">
            <div class="spinner"></div>
          </div>
        </div>
      </div>

      <!-- Movies Grid (Static 3 movies) -->
      <div class="movies-container">
        <div class="movies-grid">
          <MovieCard
            v-for="movie in movies"
            :key="movie.id"
            :movie="movie"
            @remove="removeMovie"
            class="movie-card-animation"
            :data-movie-id="movie.id"
          />
        </div>
      </div>

      <!-- Search Results -->
      <div v-if="searchResults.length > 0" class="search-results">
        <h3>Search Results (Click to add):</h3>
        <div class="search-movies-grid">
          <div
            v-for="movie in searchResults"
            :key="'search-' + movie.id"
            class="search-movie-card"
            @click="addMovie(movie)"
          >
            <img :src="movie.image" :alt="movie.title" />
            <div class="search-movie-info">
              <h4>{{ movie.title }}</h4>
              <p>{{ movie.description.substring(0, 100) }}...</p>
              <div class="add-button">+ Add to Grid</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
import MovieCard from './MovieCard.vue'

export default {
  name: 'MovieGridSection',
  components: {
    MovieCard
  },
  data() {
    return {
      movies: [
        {
          id: 1,
          title: 'The Shawshank Redemption',
          description: 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.',
          image: '/src/assets/images/movie-1.jpg',
          rating: 9.3,
          releaseDate: '1994-09-23'
        },
        {
          id: 2,
          title: 'The Godfather',
          description: 'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
          image: '/src/assets/images/movie-2.jpg',
          rating: 9.2,
          releaseDate: '1972-03-24'
        },
        {
          id: 3,
          title: 'The Dark Knight',
          description: 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests.',
          image: '/src/assets/images/movie-3.jpg',
          rating: 9.0,
          releaseDate: '2008-07-18'
        }
      ],
      searchResults: [],
      searchQuery: '',
      isSearching: false,
      error: null,
      searchTimeout: null,
      apiKey: 'your-tmdb-api-key', // Replace with actual TMDB API key
      apiBaseUrl: 'https://api.themoviedb.org/3',
      imageBaseUrl: 'https://image.tmdb.org/t/p/w500'
    }
  },
  mounted() {
    this.setupIntersectionObserver()
  },
  methods: {
    async searchMovies(query) {
      try {
        this.isSearching = true
        this.error = null
        
        const url = `${this.apiBaseUrl}/search/movie?api_key=${this.apiKey}&query=${encodeURIComponent(query)}`
        const response = await fetch(url)
        
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`)
        }
        
        const data = await response.json()
        
        // Transform API data
        this.searchResults = data.results.slice(0, 6).map(movie => ({
          id: movie.id,
          title: movie.title,
          description: movie.overview || 'No description available.',
          image: movie.poster_path 
            ? `${this.imageBaseUrl}${movie.poster_path}`
            : '/src/assets/images/placeholder-movie.jpg',
          rating: movie.vote_average,
          releaseDate: movie.release_date
        }))
        
      } catch (err) {
        console.error('Error searching movies:', err)
        this.error = 'Failed to search movies. Please check your API key and try again.'
        this.searchResults = []
      } finally {
        this.isSearching = false
      }
    },

    handleSearch() {
      if (this.searchTimeout) {
        clearTimeout(this.searchTimeout)
      }

      this.searchTimeout = setTimeout(() => {
        if (this.searchQuery.trim()) {
          this.searchMovies(this.searchQuery.trim())
        } else {
          this.searchResults = []
        }
      }, 500)
    },

    addMovie(movie) {
      // Check if movie already exists
      const exists = this.movies.find(m => m.id === movie.id)
      if (!exists) {
        this.movies.push(movie)
        // Remove from search results
        this.searchResults = this.searchResults.filter(m => m.id !== movie.id)
      }
    },

    removeMovie(movieId) {
      const index = this.movies.findIndex(movie => movie.id === movieId)
      if (index !== -1) {
        const movieElement = document.querySelector(`[data-movie-id="${movieId}"]`)
        if (movieElement) {
          movieElement.classList.add('removing')
          
          setTimeout(() => {
            this.movies.splice(index, 1)
          }, 300)
        } else {
          this.movies.splice(index, 1)
        }
      }
    },

    setupIntersectionObserver() {
      const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            entry.target.classList.add('animate')
          }
        })
      }, {
        threshold: 0.1
      })

      this.$nextTick(() => {
        const movieCards = this.$el.querySelectorAll('.movie-card-animation')
        movieCards.forEach(card => observer.observe(card))
      })
    }
  },

  watch: {
    movies: {
      handler() {
        this.$nextTick(() => {
          this.setupIntersectionObserver()
        })
      },
      deep: true
    }
  }
}
</script>

<style lang="scss" scoped>
.movie-grid {
  padding: $spacing-3xl 0;
  background-color: $tertiary-color;
}

.section-header {
  text-align: center;
  margin-bottom: $spacing-2xl;
}

.section-title {
  font-size: $font-size-4xl;
  font-weight: bold;
  color: $text-dark;
  margin-bottom: $spacing-md;

  @media (max-width: $breakpoint-md) {
    font-size: $font-size-3xl;
  }
}

.section-subtitle {
  font-size: $font-size-lg;
  color: lighten($text-dark, 20%);
  max-width: 600px;
  margin: 0 auto;

  @media (max-width: $breakpoint-md) {
    font-size: $font-size-base;
  }
}

// Search Container
.search-container {
  margin-bottom: $spacing-2xl;
  display: flex;
  justify-content: center;
}

.search-input-wrapper {
  position: relative;
  max-width: 500px;
  width: 100%;
}

.search-input {
  width: 100%;
  padding: $spacing-md $spacing-xl $spacing-md 50px;
  border: 2px solid #ddd;
  border-radius: $border-radius-xl;
  font-size: $font-size-lg;
  background-color: white;
  transition: all $transition-normal;

  &:focus {
    outline: none;
    border-color: $primary-color;
    box-shadow: 0 0 0 3px rgba($primary-color, 0.1);
  }

  &:disabled {
    opacity: 0.6;
    cursor: not-allowed;
  }

  @media (max-width: $breakpoint-md) {
    font-size: $font-size-base;
    padding: $spacing-sm $spacing-lg $spacing-sm 45px;
  }
}

.search-icon {
  position: absolute;
  left: $spacing-md;
  top: 50%;
  transform: translateY(-50%);
  color: lighten($text-dark, 30%);
  pointer-events: none;
}

.search-loading {
  position: absolute;
  right: $spacing-md;
  top: 50%;
  transform: translateY(-50%);
}

// Loading States
.loading-state,
.error-state,
.empty-state {
  text-align: center;
  padding: $spacing-3xl 0;
}

.error-state {
  h3 {
    color: $error-color;
    margin: $spacing-lg 0 $spacing-md;
  }

  p {
    color: lighten($text-dark, 20%);
    margin-bottom: $spacing-xl;
  }
}

.empty-state {
  h3 {
    color: $text-dark;
    margin: $spacing-lg 0 $spacing-md;
  }

  p {
    color: lighten($text-dark, 20%);
  }
}

.error-icon,
.empty-icon {
  color: lighten($text-dark, 40%);
  margin-bottom: $spacing-lg;
}

// Movies Grid
.movies-container {
  margin-top: $spacing-2xl;
}

.movies-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: $spacing-xl;
  margin-bottom: $spacing-2xl;

  @media (max-width: $breakpoint-md) {
    grid-template-columns: repeat(2, 1fr);
    gap: $spacing-lg;
  }

  @media (max-width: $breakpoint-sm) {
    grid-template-columns: 1fr;
    gap: $spacing-lg;
  }
}

// Search Results
.search-results {
  margin-top: $spacing-2xl;
  
  h3 {
    color: $text-dark;
    margin-bottom: $spacing-lg;
    text-align: center;
  }
}

.search-movies-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: $spacing-md;
}

.search-movie-card {
  background: white;
  border-radius: $border-radius-lg;
  overflow: hidden;
  box-shadow: $shadow-sm;
  cursor: pointer;
  transition: all 0.3s ease;

  &:hover {
    transform: translateY(-5px);
    box-shadow: $shadow-md;
  }

  img {
    width: 100%;
    height: 250px;
    object-fit: cover;
  }
}

.search-movie-info {
  padding: $spacing-md;

  h4 {
    font-size: $font-size-lg;
    font-weight: 600;
    color: $text-dark;
    margin-bottom: $spacing-sm;
  }

  p {
    font-size: $font-size-sm;
    color: lighten($text-dark, 20%);
    margin-bottom: $spacing-md;
    line-height: 1.4;
  }
}

.add-button {
  background: $primary-color;
  color: white;
  padding: $spacing-sm $spacing-md;
  border-radius: $border-radius-md;
  text-align: center;
  font-weight: 500;
  transition: background 0.3s ease;

  &:hover {
    background: darken($primary-color, 10%);
  }
}

.movie-card-animation {
  opacity: 0;
  transform: translateY(30px);
  transition: all 0.6s ease;

  &.animate {
    opacity: 1;
    transform: translateY(0);
  }

  &.removing {
    opacity: 0;
    transform: scale(0.8);
    transition: all 0.3s ease;
  }

  // Stagger animation for multiple cards
  @for $i from 1 through 20 {
    &:nth-child(#{$i}) {
      transition-delay: #{$i * 0.1}s;
    }
  }
}

// Load More
.load-more-container {
  text-align: center;
  margin-top: $spacing-2xl;
}

.load-more-btn {
  min-width: 200px;

  .loading-text {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: $spacing-sm;
  }
}

// Spinners
.spinner,
.spinner-small,
.spinner-large {
  border: 2px solid #f3f3f3;
  border-top: 2px solid $primary-color;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

.spinner {
  width: 20px;
  height: 20px;
}

.spinner-small {
  width: 16px;
  height: 16px;
}

.spinner-large {
  width: 40px;
  height: 40px;
  margin: 0 auto $spacing-lg;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

// Accessibility
@media (prefers-reduced-motion: reduce) {
  .movie-card-animation {
    transition: none;
    opacity: 1;
    transform: none;

    &.removing {
      transition: none;
    }
  }

  .spinner,
  .spinner-small,
  .spinner-large {
    animation: none;
  }
}

.search-input:focus {
  outline: 2px solid $primary-color;
  outline-offset: 2px;
}
</style>
