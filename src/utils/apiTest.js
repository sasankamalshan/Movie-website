// Test TMDb API Integration
console.log('🧪 Testing TMDb API Integration...')

const API_KEY = '4e44d9029b1270a757cddc766a1bcb63'
const BASE_URL = 'https://api.themoviedb.org/3'

async function testTMDbAPI() {
  try {
    const response = await fetch(`${BASE_URL}/movie/popular?api_key=${API_KEY}&language=en-US&page=1`)
    
    if (!response.ok) {
      throw new Error(`API Error: ${response.status} - ${response.statusText}`)
    }
    
    const data = await response.json()
    console.log('✅ TMDb API Test Successful')
    console.log('📊 Movies received:', data.results.length)
    console.log('🎬 First movie:', data.results[0]?.title)
    
    return data
  } catch (error) {
    console.error('❌ TMDb API Test Failed:', error)
    return null
  }
}

async function testTVMazeAPI() {
  try {
    console.log('🧪 Testing TV Maze API Integration...')
    const response = await fetch('https://api.tvmaze.com/shows?page=1')
    
    if (!response.ok) {
      throw new Error(`API Error: ${response.status} - ${response.statusText}`)
    }
    
    const data = await response.json()
    console.log('✅ TV Maze API Test Successful')
    console.log('📊 Shows received:', data.length)
    console.log('📺 First show:', data[0]?.name)
    
    return data
  } catch (error) {
    console.error('❌ TV Maze API Test Failed:', error)
    return null
  }
}

// Export for use in component
export { testTMDbAPI, testTVMazeAPI }
