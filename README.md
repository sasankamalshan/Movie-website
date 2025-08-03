# MovieWeb - Vue.js Movie Discovery Platform

A modern, responsive movie discovery website built with Vue.js, featuring a sleek black design, live movie data integration, and premium cinema experience showcase.

## 🎬 Features

### Core Requirements ✅
- **Vue.js 3** - Modern component-based architecture with Composition API
- **HTML5** - Semantic markup with proper accessibility
- **SCSS/CSS** - Advanced styling with variables and mixins
- **Vanilla JavaScript** - No jQuery or TypeScript dependencies
- **Responsive Design** - Mobile-first approach for all devices
- **Cross-browser Compatible** - Chrome, Firefox, Edge, Safari

### Sections Implemented
- ✅ **Header** - Dynamic logo with mobile hamburger menu
- ✅ **Hero Section** - Dynamic page titles with smooth animations
- ✅ **Movie Library** - Live API integration with TMDb and TV Maze fallback
- ✅ **Schedule Section** - Movie showtime display with date navigation
- ✅ **Premium Screens** - Showcase of cinema facilities with stats
- ✅ **Contact Form** - Full validation with black theme styling
- ✅ **Footer** - Social media links (Facebook, YouTube, LinkedIn)

### Advanced Features ✅
- ✅ **GSAP Animations** - Professional scroll-triggered animations
- ✅ **API Integration** - Dual API system (TMDb primary, TV Maze backup)
- ✅ **Search Functionality** - Real-time movie search with filtering
- ✅ **Error Handling** - Comprehensive fallback systems
- ✅ **Dark Theme** - Modern black background with premium aesthetics
- ✅ **Custom Icons** - SVG icon integration throughout the app
- ✅ **Component Architecture** - Modular and reusable Vue components

## 🚀 Getting Started

### Prerequisites
- Node.js (v16 or higher)
- npm or yarn

### Installation
1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm run dev
   ```

4. Build for production:
   ```bash
   npm run build
   ```

### API Configuration
MovieWeb uses dual API integration for reliable movie data:

#### Primary API - TMDb (The Movie Database)
1. Get a free API key from [The Movie Database (TMDB)](https://developers.themoviedb.org/3)
2. Create a `.env` file in the root directory:
   ```env
   VITE_TMDB_API_KEY=your_tmdb_api_key_here
   VITE_TMDB_BASE_URL=https://api.themoviedb.org/3
   VITE_TMDB_IMAGE_BASE_URL=https://image.tmdb.org/t/p/w500
   ```

#### Backup API - TV Maze
- TV Maze API is used as a fallback when TMDb is unavailable
- No API key required for TV Maze
- Automatic failover system implemented

### Browser Icon Configuration
The app uses a custom SVG logo as the favicon:
- Located at: `/src/assets/images/Logo Black.svg`
- Automatically loads as browser tab icon

## 📁 Project Structure

```
src/
├── components/              # Vue components
│   ├── AppHeader.vue       # Navigation header with logo
│   ├── HeroSection.vue     # Dynamic hero with page titles
│   ├── MovieLibrarySection.vue # Movie display with API integration
│   ├── ScheduleSection.vue # Movie schedule and showtimes
│   ├── OurScreensSection.vue # Premium cinema screens showcase
│   ├── ContactSection.vue  # Contact form with validation
│   └── AppFooter.vue       # Footer with social links
├── assets/
│   ├── styles/             # SCSS stylesheets
│   │   ├── variables.scss  # Design system variables
│   │   └── main.scss       # Global styles
│   ├── images/             # Image assets
│   │   ├── Icons/          # SVG icons
│   │   ├── Batman.jpg      # Movie poster
│   │   ├── Spiderman.jpg   # Movie poster
│   │   ├── Wild West.jpg   # Movie poster
│   │   └── Logo Black.svg  # App logo
│   └── videos/             # Video assets (if any)
├── App.vue                 # Root component
├── main.js                 # Application entry point
└── .env                    # Environment variables
```

## 🎨 Design Features

### Theme & Aesthetics
- **Dark Mode Design** - Premium black background throughout
- **Modern UI** - Clean, minimalist interface design
- **Custom Branding** - Consistent use of Logo Black.svg
- **Professional Typography** - Optimized font sizing and spacing

### Color Scheme
- **Primary Background**: #000000 (Pure Black)
- **Text**: #ffffff (White) for maximum contrast
- **Accent**: #ffd700 (Gold) for highlights and numbers
- **Interactive Elements**: Yellow hover states and focus indicators
- **Cards**: Semi-transparent white backgrounds with blur effects

### Responsive Breakpoints
- **Mobile**: < 576px
- **Tablet**: 576px - 768px  
- **Desktop**: 768px - 992px
- **Large Desktop**: > 992px

### Animation Features
- **GSAP Integration** - Professional scroll-triggered animations
- **Smooth Transitions** - 0.3s ease transitions throughout
- **Hover Effects** - Interactive button and card animations
- **Loading States** - Spinner animations for API calls
- **Scroll Animations** - Elements animate into view on scroll

## 🎯 Key Features

### Movie Library
- **Live Data Integration** - Real movie data from TMDb API
- **Fallback System** - TV Maze API backup for reliability
- **Search Functionality** - Real-time movie search and filtering
- **Movie Cards** - Interactive cards with close buttons
- **Responsive Grid** - 3 movies per row on desktop, adaptive on mobile

### Cinema Showcase
- **Premium Screens Section** - IMAX, Dolby Cinema, VIP Lounge displays
- **Statistics Cards** - Compact stat display (3 screens, 310 seats, 4K, 360° sound)
- **Professional Layout** - Single-row card arrangement with perfect centering

### Navigation & UX
- **Dynamic Titles** - Page titles update in hero section based on navigation
- **Smooth Scrolling** - GSAP-powered scroll animations
- **Mobile-First** - Responsive hamburger menu and touch-friendly interface
- **Loading States** - Professional loading indicators during API calls

### Form & Contact
- **Dark Theme Forms** - Black background with yellow accent buttons
- **Social Integration** - Facebook, YouTube, LinkedIn links in footer
- **Input Validation** - Real-time form validation and error handling

## � Technical Implementation

### API Integration
```javascript
// Dual API system with fallback
async loadMovies() {
  try {
    // Primary: TMDb API
    const response = await fetch(`${TMDB_BASE_URL}/movie/popular?api_key=${API_KEY}`)
    // Process TMDb data
  } catch (error) {
    // Fallback: TV Maze API
    await this.loadMoviesFromTVMaze()
  }
}
```

### Animation System
```javascript
// GSAP ScrollTrigger animations
ScrollTrigger.create({
  trigger: '.movie-card',
  start: 'top 80%',
  onEnter: () => {
    gsap.fromTo('.movie-card', 
      { y: 50, opacity: 0 },
      { y: 0, opacity: 1, duration: 0.8, stagger: 0.1 }
    )
  }
})
```

## � Available Scripts

- `npm run dev` - Start development server (runs on localhost:3005)
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run serve` - Serve production build

## 🌍 Browser Support

- Chrome (latest) ✅
- Firefox (latest) ✅
- Safari (latest) ✅
- Edge (latest) ✅

## 📱 Mobile Features

- Touch-friendly navigation with hamburger menu
- Responsive movie cards (1 column on mobile, 3 on desktop)
- Optimized images and performance
- Mobile-first CSS approach
- Swipe-friendly date navigation

## 🎯 Performance & Optimization

- **Lazy Loading** - Images load on demand
- **API Caching** - Efficient data management
- **Bundle Optimization** - Vite-powered build system
- **GPU Acceleration** - Hardware-accelerated CSS animations
- **Code Splitting** - Component-based loading

## � Security Features

- **Environment Variables** - Secure API key management
- **Input Validation** - XSS protection in forms
- **Secure API Calls** - HTTPS-only external requests
- **Error Handling** - Graceful degradation on failures

## 📊 Project Statistics

- **Components**: 6 main Vue components
- **API Integration**: 2 movie databases (TMDb + TV Maze)
- **Animations**: GSAP-powered scroll triggers
- **Icons**: Custom SVG icon system
- **Theme**: Dark mode with gold accents
- **Responsive**: Mobile-first design approach

## � License & Credits

This project is created for educational purposes.

- **Movie Data**: Provided by [The Movie Database (TMDB)](https://www.themoviedb.org/)
- **Backup Data**: Provided by [TV Maze API](https://www.tvmaze.com/api)
- **Icons**: Custom SVG icons designed for MovieWeb
- **Animations**: Powered by [GSAP](https://greensock.com/gsap/)
- **Build Tool**: [Vite.js](https://vitejs.dev/)
- **Framework**: [Vue.js 3](https://vuejs.org/)

## 🤝 Contributing

We welcome contributions! To contribute:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Vue.js 3 Composition API patterns
- Use SCSS for styling with existing variable system
- Maintain dark theme consistency
- Add proper error handling for new features
- Test on multiple devices and browsers

## 📞 Support & Contact

- **Website**: Contact form available on the MovieWeb application
- **Issues**: Please report bugs via GitHub Issues
- **Features**: Submit feature requests via GitHub Discussions

## 🌟 Acknowledgments

- The Movie Database (TMDB) for providing comprehensive movie data
- TV Maze for reliable backup API service
- GSAP team for smooth animation capabilities
- Vue.js team for the excellent framework
- All contributors who help improve this project

---

**MovieWeb** - Discover, explore, and collect your favorite movies with style! 🎬
