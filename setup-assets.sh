#!/bin/bash

# Script to create placeholder images for MovieWeb
# This creates colored placeholder images using ImageMagick (if available)
# or provides download URLs for free stock images

echo "Setting up MovieWeb placeholder images..."

# Create assets directory structure
mkdir -p src/assets/images
mkdir -p src/assets/videos
mkdir -p public

# Hero Images (you can replace these with actual movie images)
echo "Creating hero section placeholders..."

# Create simple colored rectangles as placeholders (1920x1080)
# You should replace these with actual movie images

cat > src/assets/images/hero-1.jpg << 'EOF'
<!-- Replace this with actual hero image 1 (1920x1080) -->
<!-- Suggested: Movie poster or cinematic landscape -->
<!-- Free sources: Unsplash, Pexels, Pixabay -->
<!-- Search terms: "cinema", "movie theater", "film strip" -->
EOF

cat > src/assets/images/hero-2.jpg << 'EOF'
<!-- Replace this with actual hero image 2 (1920x1080) -->
<!-- Suggested: Different movie scene or poster -->
EOF

cat > src/assets/images/about-image.jpg << 'EOF'
<!-- Replace with movie theater interior image (800x600) -->
<!-- Suggested: Empty theater seats, projector, screen -->
EOF

# Movie placeholders
echo "Creating movie card placeholders..."

for i in {1..6}; do
  cat > src/assets/images/movie-$i.jpg << EOF
<!-- Replace with movie poster $i (300x450) -->
<!-- Suggested: Popular movie posters -->
<!-- Ensure you have rights to use the images -->
EOF
done

# Create placeholder movie image
cat > src/assets/images/placeholder-movie.jpg << 'EOF'
<!-- Default placeholder for movies (300x450) -->
<!-- This should be a generic "No Image Available" placeholder -->
EOF

# Video placeholder
echo "Creating video placeholder..."
cat > src/assets/videos/hero-video.mp4 << 'EOF'
<!-- Replace with actual hero video -->
<!-- Suggested: Movie trailer or cinematic background video -->
<!-- Keep file size reasonable for web delivery -->
<!-- Recommended: 1920x1080, MP4 format, <10MB -->
EOF

echo ""
echo "✅ Placeholder structure created!"
echo ""
echo "📝 Next steps:"
echo "1. Replace placeholder files with actual images/videos"
echo "2. Get TMDB API key from: https://developers.themoviedb.org/3"
echo "3. Get Google Maps API key from: https://console.cloud.google.com/"
echo "4. Update API keys in the respective component files"
echo ""
echo "🎨 Recommended image sources:"
echo "- Unsplash: https://unsplash.com/s/photos/cinema"
echo "- Pexels: https://pexels.com/search/movie/"
echo "- Pixabay: https://pixabay.com/images/search/film/"
echo ""
echo "📐 Required image dimensions:"
echo "- Hero images: 1920x1080 (landscape)"
echo "- Movie posters: 300x450 (portrait, 2:3 ratio)"
echo "- About image: 800x600 (landscape)"
echo "- Logo: 120x40 (landscape)"
echo ""
echo "🚀 To start development server:"
echo "cd /Users/sasankamalshan/Desktop/Movieweb"
echo "npm run dev"
