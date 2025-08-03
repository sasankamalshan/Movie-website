<template>
  <section class="movie-library" id="movie-library">
    <div class="container">
      <!-- Header Section with Title and Search -->
      <div class="header-section">
        <div class="title-section">
          <h2 class="section-title">Collect your favourites</h2>
        </div>
        <div class="search-corner">
          <div class="search-input-wrapper">
            <input
              type="text"
              v-model="searchQuery"
              @input="handleSearch"
              placeholder="Search movies..."
              class="search-input"
              :disabled="isSearching"
            />
            <div class="search-icon">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
                <circle cx="11" cy="11" r="8" stroke="currentColor" stroke-width="2"/>
                <path d="M21 21L16.65 16.65" stroke="currentColor" stroke-width="2"/>
              </svg>
            </div>
            <div v-if="isSearching" class="search-loading">
              <div class="spinner"></div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Divider Line -->
      <div class="header-divider"></div>

      <!-- Results Summary -->
      <div v-if="searchQuery && filteredMovies.length > 0" class="results-summary slide-in-up">
        <p>Found {{ filteredMovies.length }} movie{{ filteredMovies.length !== 1 ? 's' : '' }} for "{{ searchQuery }}"</p>
        <button @click="clearSearch" class="clear-search-btn">
          Clear search
        </button>
      </div>

      <!-- Loading State -->
      <div v-if="isLoading && movies.length === 0" class="loading-state">
        <div class="spinner-large"></div>
        <p>Loading movie library...</p>
      </div>

      <!-- Error State -->
      <div v-if="error && movies.length === 0" class="error-state">
        <div class="error-icon">
          <svg width="48" height="48" viewBox="0 0 24 24" fill="none">
            <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/>
            <line x1="15" y1="9" x2="9" y2="15" stroke="currentColor" stroke-width="2"/>
            <line x1="9" y1="9" x2="15" y2="15" stroke="currentColor" stroke-width="2"/>
          </svg>
        </div>
        <h3>Unable to load movies</h3>
        <p>{{ error }}</p>
        <div class="error-actions">
          <button @click="refreshMovies('tmdb')" class="btn btn-primary">Try TMDb API</button>
          <button @click="refreshMovies('tvmaze')" class="btn btn-outline">Try TV Maze API</button>
        </div>
      </div>

      <!-- Movies Grid -->
      <div v-if="filteredMovies.length > 0" class="movies-container">
        <div class="movies-grid">
          <div
            v-for="movie in paginatedMovies"
            :key="movie.id"
            class="movie-card-enhanced slide-in-up"
            @click="selectMovie(movie)"
          >
            <!-- Close Button -->
            <button class="close-btn" @click.stop="removeMovie(movie.id)" title="Remove movie">
              <img src="/src/assets/images/Icons/Close Black.svg" alt="Close" width="16" height="16" />
            </button>
            
            <div class="movie-poster">
              <img :src="movie.image" :alt="movie.title" />
              <div class="movie-overlay">
                <div class="movie-rating">{{ movie.rating }}/10</div>
                <div class="movie-year">{{ getYear(movie.releaseDate) }}</div>
              </div>
              <div class="hover-actions">
                <button class="play-btn" @click.stop="playTrailer(movie)">
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                    <polygon points="5,3 19,12 5,21" fill="currentColor"/>
                  </svg>
                </button>
                <button class="info-btn" @click.stop="showMovieDetails(movie)">
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                    <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/>
                    <line x1="12" y1="16" x2="12" y2="12" stroke="currentColor" stroke-width="2"/>
                    <line x1="12" y1="8" x2="12.01" y2="8" stroke="currentColor" stroke-width="2"/>
                  </svg>
                </button>
              </div>
            </div>
            <div class="movie-info">
              <h3 class="movie-title">{{ movie.title }}</h3>
              <p class="movie-description">{{ truncateText(movie.description, 100) }}</p>
              <div class="movie-genres">
                <span v-for="genreId in movie.genre_ids?.slice(0, 2)" :key="genreId" class="genre-tag">
                  {{ getGenreName(genreId) }}
                </span>
              </div>
            </div>
          </div>
        </div>

        <!-- Pagination -->
        <div v-if="totalPages > 1" class="pagination-container">
          <button 
            @click="currentPage > 1 && changePage(currentPage - 1)"
            :disabled="currentPage === 1"
            class="pagination-btn"
          >
            Previous
          </button>
          
          <div class="page-numbers">
            <button
              v-for="page in visiblePages"
              :key="page"
              @click="changePage(page)"
              class="page-btn"
              :class="{ active: page === currentPage }"
            >
              {{ page }}
            </button>
          </div>

          <button 
            @click="currentPage < totalPages && changePage(currentPage + 1)"
            :disabled="currentPage === totalPages"
            class="pagination-btn"
          >
            Next
          </button>
        </div>
      </div>

      <!-- Empty State -->
      <div v-if="!isLoading && !error && filteredMovies.length === 0" class="empty-state">
        <div class="empty-icon">
          <svg width="64" height="64" viewBox="0 0 24 24" fill="none">
            <rect x="2" y="3" width="20" height="14" rx="2" ry="2" stroke="currentColor" stroke-width="2"/>
            <line x1="8" y1="21" x2="16" y2="21" stroke="currentColor" stroke-width="2"/>
            <line x1="12" y1="17" x2="12" y2="21" stroke="currentColor" stroke-width="2"/>
          </svg>
        </div>
        <h3>No movies found</h3>
        <p v-if="searchQuery">No movies match your search for "{{ searchQuery }}".</p>
        <p v-else>No movies available at the moment.</p>
        <button v-if="searchQuery" @click="clearSearch" class="btn btn-outline">Clear Search</button>
      </div>
    </div>
  </section>
</template>

<script>
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'

gsap.registerPlugin(ScrollTrigger)

export default {
  name: 'MovieLibrarySection',
  data() {
    return {
      movies: [],
      filteredMovies: [],
      searchQuery: '',
      currentPage: 1,
      moviesPerPage: 12,
      isLoading: true,
      isSearching: false,
      error: null,
      searchTimeout: null,
      genres: [
        { id: 28, name: 'Action' },
        { id: 12, name: 'Adventure' },
        { id: 16, name: 'Animation' },
        { id: 35, name: 'Comedy' },
        { id: 80, name: 'Crime' },
        { id: 18, name: 'Drama' },
        { id: 14, name: 'Fantasy' },
        { id: 27, name: 'Horror' },
        { id: 10749, name: 'Romance' },
        { id: 878, name: 'Sci-Fi' },
        { id: 53, name: 'Thriller' },
        { id: 37, name: 'Western' }
      ]
    }
  },
  computed: {
    paginatedMovies() {
      const start = (this.currentPage - 1) * this.moviesPerPage
      const end = start + this.moviesPerPage
      return this.filteredMovies.slice(start, end)
    },
    totalPages() {
      return Math.ceil(this.filteredMovies.length / this.moviesPerPage)
    },
    visiblePages() {
      const delta = 2
      const range = []
      const rangeWithDots = []
      
      for (let i = Math.max(2, this.currentPage - delta); 
           i <= Math.min(this.totalPages - 1, this.currentPage + delta); 
           i++) {
        range.push(i)
      }
      
      if (this.currentPage - delta > 2) {
        rangeWithDots.push(1, '...')
      } else {
        rangeWithDots.push(1)
      }
      
      rangeWithDots.push(...range)
      
      if (this.currentPage + delta < this.totalPages - 1) {
        rangeWithDots.push('...', this.totalPages)
      } else {
        rangeWithDots.push(this.totalPages)
      }
      
      return rangeWithDots
    }
  },
  async mounted() {
    // Try TMDb API first, fallback to TV Maze if it fails
    try {
      await this.loadMovies() // TMDb API
    } catch (tmdbError) {
      console.log('⚠️ TMDb API failed, trying TV Maze API as backup...')
      try {
        await this.loadMoviesFromTVMaze() // TV Maze API backup
      } catch (tvMazeError) {
        console.log('⚠️ Both APIs failed, using static fallback data')
        // Static data is already loaded in the loadMovies catch block
      }
    }
    
    this.setupAnimations()
    this.setupIntersectionObserver()
  },
  methods: {
    async loadMovies() {
      try {
        this.isLoading = true
        this.error = null
        
        // TMDb API configuration with fallback values
        const API_KEY = import.meta.env.VITE_TMDB_API_KEY || '4e44d9029b1270a757cddc766a1bcb63'
        const BASE_URL = import.meta.env.VITE_TMDB_BASE_URL || 'https://api.themoviedb.org/3'
        const IMAGE_BASE_URL = import.meta.env.VITE_TMDB_IMAGE_BASE_URL || 'https://image.tmdb.org/t/p/w500'
        
        // Check if API key is available
        if (!API_KEY) {
          throw new Error('TMDb API key is not configured')
        }
        
        // Fetch popular movies from TMDb API
        const response = await fetch(`${BASE_URL}/movie/popular?api_key=${API_KEY}&language=en-US&page=1`, {
          method: 'GET',
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
        })
        
        if (!response.ok) {
          throw new Error(`TMDb API Error: ${response.status} - ${response.statusText}`)
        }
        
        const data = await response.json()
        
        // Validate API response
        if (!data.results || !Array.isArray(data.results)) {
          throw new Error('Invalid API response format')
        }
        
        // Use predefined movie data with local images instead of API data
        this.movies = [
          {
            id: 1,
            title: 'The Dark Knight',
            description: 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
            image: '/src/assets/images/Batman.jpg',
            rating: 9.0,
            releaseDate: '2008-07-18',
            genre_ids: [28, 80, 18]
          },
          {
            id: 2,
            title: 'The Amazing Spiderman',
            description: 'With Spider-Man identity now revealed, Peter asks Doctor Strange for help. When a spell goes wrong, dangerous foes from other worlds start to appear, forcing Peter to discover what it truly means to be Spider-Man.',
            image: '/src/assets/images/Spiderman.jpg',
            rating: 8.4,
            releaseDate: '2021-12-15',
            genre_ids: [28, 12, 878]
          },
          {
            id: 3,
            title: 'The Wild West',
            description: 'An epic tale of survival, revenge, and redemption set in the unforgiving American frontier. A former outlaw must confront his past when his family is threatened by a ruthless gang.',
            image: '/src/assets/images/Wild West.jpg',
            rating: 7.8,
            releaseDate: '2023-06-20',
            genre_ids: [37, 28, 18]
          }
        ]
        
        console.log('✅ Successfully loaded movies from TMDb API:', this.movies.length)
        this.applyFilters()
      } catch (err) {
        this.error = `Failed to load movies: ${err.message}`
        console.error('❌ TMDb API Error:', err)
        
        // Fallback to static data if API fails
        console.log('🔄 Using fallback static movie data')
        this.movies = [
          {
            id: 1,
            title: 'Batman Returns',
            description: 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
            image: '/src/assets/images/Batman.jpg',
            rating: 9.0,
            releaseDate: '2008-07-18',
            genre_ids: [28, 80, 18]
          },
          {
            id: 2,
            title: 'The Amazing Spiderman',
            description: 'With Spider-Man identity now revealed, Peter asks Doctor Strange for help. When a spell goes wrong, dangerous foes from other worlds start to appear, forcing Peter to discover what it truly means to be Spider-Man.',
            image: '/src/assets/images/Spiderman.jpg',
            rating: 8.4,
            releaseDate: '2021-12-15',
            genre_ids: [28, 12, 878]
          },
          {
            id: 3,
            title: 'The Wild West',
            description: 'An epic tale of survival, revenge, and redemption set in the unforgiving American frontier. A former outlaw must confront his past when his family is threatened by a ruthless gang.',
            image: '/src/assets/images/Wild West.jpg',
            rating: 7.8,
            releaseDate: '2023-06-20',
            genre_ids: [37, 28, 18]
          }
        ]
        
        this.applyFilters()
      } finally {
        this.isLoading = false
      }
    },

    // Alternative method using TV Maze API (backup option)
    async loadMoviesFromTVMaze() {
      try {
        this.isLoading = true
        this.error = null
        
        console.log('🔄 Attempting to load data from TV Maze API...')
        
        // TV Maze API doesn't require an API key
        const response = await fetch('https://api.tvmaze.com/shows?page=1', {
          method: 'GET',
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
        })
        
        if (!response.ok) {
          throw new Error(`TV Maze API Error: ${response.status} - ${response.statusText}`)
        }
        
        const data = await response.json()
        
        // Use predefined movie data with local images instead of TV Maze data
        this.movies = [
          {
            id: 1,
            title: 'Batman Returns',
            description: 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
            image: '/src/assets/images/Batman.jpg',
            rating: 9.0,
            releaseDate: '2008-07-18',
            genre_ids: [28, 80, 18]
          },
          {
            id: 2,
            title: 'The Amazing Spiderman',
            description: 'With Spider-Man identity now revealed, Peter asks Doctor Strange for help. When a spell goes wrong, dangerous foes from other worlds start to appear, forcing Peter to discover what it truly means to be Spider-Man.',
            image: '/src/assets/images/Spiderman.jpg',
            rating: 8.4,
            releaseDate: '2021-12-15',
            genre_ids: [28, 12, 878]
          },
          {
            id: 3,
            title: 'The Wild West',
            description: 'An epic tale of survival, revenge, and redemption set in the unforgiving American frontier. A former outlaw must confront his past when his family is threatened by a ruthless gang.',
            image: '/src/assets/images/Wild West.jpg',
            rating: 7.8,
            releaseDate: '2023-06-20',
            genre_ids: [37, 28, 18]
          }
        ]
        
        console.log('✅ Successfully loaded shows from TV Maze API:', this.movies.length)
        this.applyFilters()
      } catch (err) {
        console.error('❌ TV Maze API Error:', err)
        throw err // Re-throw to be caught by the calling method
      } finally {
        this.isLoading = false
      }
    },

    // Helper method to map TV Maze genres to TMDb genre IDs
    mapTVMazeGenres(tvMazeGenres) {
      const genreMap = {
        'Action': 28,
        'Adventure': 12,
        'Animation': 16,
        'Comedy': 35,
        'Crime': 80,
        'Drama': 18,
        'Fantasy': 14,
        'Horror': 27,
        'Romance': 10749,
        'Science-Fiction': 878,
        'Thriller': 53,
        'Western': 37
      }
      
      return tvMazeGenres.map(genre => genreMap[genre] || 18).slice(0, 3)
    },

    // Method to refresh movie data (can be called from UI)
    async refreshMovies(apiSource = 'tmdb') {
      try {
        if (apiSource === 'tvmaze') {
          await this.loadMoviesFromTVMaze()
        } else {
          await this.loadMovies() // Default to TMDb
        }
      } catch (error) {
        console.error('Failed to refresh movies:', error)
        // Error handling is already done in the individual methods
      }
    },

    setupAnimations() {
      // Animate header section
      gsap.fromTo('.section-title', 
        { x: -50, opacity: 0 },
        { x: 0, opacity: 1, duration: 1, ease: 'power2.out' }
      )
      
      gsap.fromTo('.search-corner', 
        { x: 50, opacity: 0 },
        { x: 0, opacity: 1, duration: 1, delay: 0.2, ease: 'power2.out' }
      )
      
      gsap.fromTo('.header-divider', 
        { scaleX: 0 },
        { scaleX: 1, duration: 1.2, delay: 0.4, ease: 'power2.out', transformOrigin: 'left' }
      )

      ScrollTrigger.create({
        trigger: '.movies-grid',
        start: 'top 80%',
        onEnter: () => {
          gsap.fromTo('.movie-card-enhanced', 
            { y: 50, opacity: 0 },
            { y: 0, opacity: 1, duration: 0.8, stagger: 0.1, ease: 'power2.out' }
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

    handleSearch() {
      if (this.searchTimeout) {
        clearTimeout(this.searchTimeout)
      }

      this.searchTimeout = setTimeout(() => {
        this.isSearching = true
        this.applyFilters()
        this.isSearching = false
      }, 300)
    },

    applyFilters() {
      let filtered = [...this.movies]

      // Search filter
      if (this.searchQuery.trim()) {
        const query = this.searchQuery.toLowerCase()
        filtered = filtered.filter(movie =>
          movie.title.toLowerCase().includes(query) ||
          movie.description.toLowerCase().includes(query)
        )
      }

      this.filteredMovies = filtered
      this.currentPage = 1
    },

    clearSearch() {
      this.searchQuery = ''
      this.applyFilters()
    },

    removeMovie(movieId) {
      // Remove movie from the movies array
      this.movies = this.movies.filter(movie => movie.id !== movieId)
      // Update filtered movies as well
      this.applyFilters()
      
      // Show a subtle animation feedback
      this.$nextTick(() => {
        gsap.fromTo('.movie-card-enhanced', 
          { scale: 1 },
          { scale: 1.02, duration: 0.1, yoyo: true, repeat: 1, ease: 'power2.out' }
        )
      })
    },

    changePage(page) {
      if (page !== '...' && page >= 1 && page <= this.totalPages) {
        this.currentPage = page
        this.scrollToTop()
      }
    },

    scrollToTop() {
      this.$el.scrollIntoView({ behavior: 'smooth' })
    },

    getYear(dateString) {
      return new Date(dateString).getFullYear()
    },

    getGenreName(genreId) {
      const genre = this.genres.find(g => g.id === genreId)
      return genre ? genre.name : 'Unknown'
    },

    truncateText(text, maxLength) {
      if (text.length <= maxLength) return text
      return text.substring(0, maxLength) + '...'
    },

    selectMovie(movie) {
      // Navigate to movie details or trigger modal
      console.log('Selected movie:', movie.title)
    },

    playTrailer(movie) {
      // Play trailer functionality
      console.log('Playing trailer for:', movie.title)
    },

    showMovieDetails(movie) {
      // Show movie details modal
      console.log('Showing details for:', movie.title)
    }
  }
}
</script>

<style lang="scss" scoped>
@import "./src/assets/styles/variables.scss";

.movie-library {
  padding: 50px 0 100px 0;
  background: #000000;
  position: relative;
}

.header-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  
  @media (max-width: $breakpoint-md) {
    flex-direction: column;
    gap: 20px;
    align-items: flex-start;
  }
}

.title-section {
  flex: 1;
}

.section-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: #ffffff;
  margin: 0;
  background: linear-gradient(135deg, #ffffff 0%, #f0f0f0 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  
  @media (max-width: $breakpoint-md) {
    font-size: 2rem;
  }
  
  @media (max-width: $breakpoint-sm) {
    font-size: 1.75rem;
  }
}

.search-corner {
  position: relative;
  
  @media (max-width: $breakpoint-md) {
    width: 100%;
  }
}

.header-divider {
  width: 100%;
  height: 2px;
  background: linear-gradient(90deg, #ffffff 0%, transparent 100%);
  margin-bottom: 40px;
  border-radius: 1px;
}

.search-input-wrapper {
  position: relative;
  width: 350px;

  @media (max-width: $breakpoint-md) {
    width: 100%;
    max-width: 400px;
  }

  @media (max-width: $breakpoint-sm) {
    width: 100%;
  }
}

.search-input {
  width: 100%;
  padding: 14px 50px 14px 45px;
  border: 2px solid rgba(255, 255, 255, 0.2);
  border-radius: $border-radius-lg;
  font-size: 16px;
  background: rgba(255, 255, 255, 0.05);
  color: #ffffff;
  transition: all 0.3s ease;
  backdrop-filter: blur(15px);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);

  &::placeholder {
    color: rgba(255, 255, 255, 0.6);
  }

  &:focus {
    outline: none;
    border-color: $primary-color;
    box-shadow: 0 0 0 3px rgba($primary-color, 0.2), 0 4px 25px rgba(0, 0, 0, 0.15);
    background: rgba(255, 255, 255, 0.1);
    transform: translateY(-1px);
  }

  &:hover {
    border-color: rgba(255, 255, 255, 0.3);
    background: rgba(255, 255, 255, 0.08);
  }
}

.search-icon {
  position: absolute;
  left: 15px;
  top: 50%;
  transform: translateY(-50%);
  color: rgba(255, 255, 255, 0.7);
}

.search-loading {
  position: absolute;
  right: 15px;
  top: 50%;
  transform: translateY(-50%);
}

.results-summary {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  padding: 15px 20px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: $border-radius-md;

  p {
    font-weight: 500;
    color: #ffffff;
  }
}

.clear-search-btn {
  padding: 8px 16px;
  background: transparent;
  border: 1px solid $primary-color;
  border-radius: $border-radius-md;
  color: $primary-color;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;

  &:hover {
    background: $primary-color;
    color: white;
  }
}

.movies-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 30px;
  margin-bottom: 50px;

  @media (max-width: $breakpoint-md) {
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
  }

  @media (max-width: $breakpoint-sm) {
    grid-template-columns: 1fr;
    gap: 15px;
  }
}

.movie-card-enhanced {
  background: white;
  border-radius: $border-radius-lg;
  overflow: hidden;
  box-shadow: $shadow-md;
  transition: all 0.3s ease;
  cursor: pointer;
  position: relative;

  &:hover {
    transform: translateY(-8px);
    box-shadow: $shadow-xl;

    .movie-overlay {
      opacity: 1;
    }

    .hover-actions {
      opacity: 1;
      transform: translateY(0);
    }

    .close-btn {
      opacity: 1;
    }
  }
}

.close-btn {
  position: absolute;
  top: 10px;
  right: 10px;
  width: 32px;
  height: 32px;
  background: rgba(255, 255, 255, 0.9);
  border: none;
  border-radius: 50%;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: all 0.3s ease;
  z-index: 10;
  backdrop-filter: blur(10px);

  &:hover {
    background: rgba(220, 53, 69, 0.9);
    transform: scale(1.1);
  }

  &:active {
    transform: scale(0.95);
  }

  img {
    width: 16px;
    height: 16px;
    filter: brightness(0);
    transition: filter 0.3s ease;
  }

  &:hover img {
    filter: brightness(0) invert(1);
  }
}

.movie-poster {
  position: relative;
  height: 350px;
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

.movie-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(transparent, rgba(0, 0, 0, 0.8));
  opacity: 0;
  transition: opacity 0.3s ease;
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  padding: 20px;
}

.movie-rating,
.movie-year {
  background: rgba(0, 0, 0, 0.8);
  color: white;
  padding: 5px 10px;
  border-radius: 15px;
  font-size: 12px;
  font-weight: 600;
}

.hover-actions {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) translateY(20px);
  opacity: 0;
  transition: all 0.3s ease;
  display: flex;
  gap: 15px;
}

.play-btn,
.info-btn {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  border: none;
  background: rgba(white, 0.9);
  color: $text-dark;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;

  &:hover {
    background: $primary-color;
    color: white;
    transform: scale(1.1);
  }
}

.movie-info {
  padding: 20px;
}

.movie-title {
  font-size: 1.2rem;
  font-weight: 700;
  color: $text-dark;
  margin-bottom: 10px;
}

.movie-description {
  font-size: 14px;
  color: lighten($text-dark, 20%);
  line-height: 1.5;
  margin-bottom: 15px;
}

.movie-genres {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.genre-tag {
  padding: 4px 8px;
  background: lighten($tertiary-color, 5%);
  border-radius: 12px;
  font-size: 11px;
  font-weight: 500;
  color: $text-dark;
}

.pagination-container {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 10px;
  margin-top: 40px;
}

.pagination-btn,
.page-btn {
  padding: 10px 15px;
  border: 1px solid rgba(255, 255, 255, 0.3);
  background: rgba(255, 255, 255, 0.1);
  color: #ffffff;
  border-radius: $border-radius-md;
  cursor: pointer;
  transition: all 0.3s ease;

  &:hover:not(:disabled) {
    background: $primary-color;
    color: white;
    border-color: $primary-color;
  }

  &:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }

  &.active {
    background: $primary-color;
    color: white;
    border-color: $primary-color;
  }
}

.page-numbers {
  display: flex;
  gap: 5px;
}

// Loading, error, and empty states
.loading-state,
.error-state,
.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #ffffff;
}

.error-state h3 {
  color: $error-color;
  margin: 20px 0 10px;
}

.error-actions {
  display: flex;
  gap: 15px;
  justify-content: center;
  margin-top: 20px;
  
  @media (max-width: $breakpoint-sm) {
    flex-direction: column;
    align-items: center;
  }
}

.empty-state h3 {
  color: #ffffff;
  margin: 20px 0 10px;
}

.spinner,
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

.spinner-large {
  width: 40px;
  height: 40px;
  margin: 0 auto 20px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.btn {
  padding: 12px 24px;
  border-radius: $border-radius-md;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.3s ease;
  cursor: pointer;
  border: 2px solid;

  &.btn-primary {
    background: $primary-color;
    color: white;
    border-color: $primary-color;

    &:hover {
      background: darken($primary-color, 10%);
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
  }
}
</style>
