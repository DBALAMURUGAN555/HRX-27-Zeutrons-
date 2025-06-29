# WebAR PM2.5 Visualization

A web-based augmented reality application that visualizes PM2.5 (fine particulate matter) air quality data using A-Frame and AR.js.

## Features

- **Real-time PM2.5 Visualization**: Particles spawn around the camera based on PM2.5 concentration levels
- **Interactive Particles**: Tap on particles to view detailed air quality information
- **Dynamic Particle System**: Particles automatically spawn, float, and disappear based on air quality levels
- **Color-coded Air Quality**: Particles change color based on PM2.5 levels:
  - 🟢 Green: Good (0-12 μg/m³)
  - 🟡 Yellow: Moderate (12-35 μg/m³)
  - 🟠 Orange: Unhealthy for Sensitive Groups (35-55 μg/m³)
  - 🔴 Red: Unhealthy (55-150 μg/m³)
  - 🟣 Purple: Very Unhealthy (150+ μg/m³)

## How to Use

### Setup
1. Open `index.html` in a web browser
2. Allow camera access when prompted
3. Point your device around to see the AR visualization

### Controls
- **Tap particles**: View detailed air quality information
- **Keyboard controls** (for testing):
  - Press `1`: Set PM2.5 to 10 (Good)
  - Press `2`: Set PM2.5 to 25 (Moderate)
  - Press `3`: Set PM2.5 to 45 (Unhealthy)
  - Press `4`: Set PM2.5 to 75 (Very Unhealthy)
  - Press `5`: Set PM2.5 to 180 (Hazardous)

### Current Configuration
- **Sample PM2.5 Value**: 35 μg/m³ (Moderate air quality)
- **Particle Lifetime**: 8 seconds
- **Maximum Particles**: 100
- **Spawn Radius**: 5 meters around camera

## Technical Details

### Technologies Used
- **A-Frame**: 3D web framework for VR/AR
- **AR.js**: WebAR library for camera-based AR
- **Three.js**: 3D graphics library (used internally by A-Frame)

### File Structure
```
├── index.html          # Main HTML file with AR scene
├── script.js           # JavaScript logic for particle system
└── README.md           # This file
```

### Customization

You can modify the PM2.5 value and behavior by editing the `PM25_CONFIG` object in `script.js`:

```javascript
const PM25_CONFIG = {
    currentValue: 35,        // Change this to your PM2.5 value
    particleLifetime: 8000,  // Particle lifetime in milliseconds
    maxParticles: 100,       // Maximum particles in scene
    spawnRadius: 5           // Spawn radius around camera
};
```

## Browser Compatibility

- **Mobile**: Chrome, Safari (iOS), Firefox
- **Desktop**: Chrome, Firefox, Edge
- **Requirements**: HTTPS connection required for camera access

## Testing

1. **Local Development**: Use a local server (e.g., `python -m http.server 8000`)
2. **HTTPS Required**: Camera access requires HTTPS in production
3. **Mobile Testing**: Test on actual mobile devices for best AR experience

## Air Quality Standards

The visualization follows EPA air quality standards:
- **Good**: 0-12 μg/m³
- **Moderate**: 12-35 μg/m³
- **Unhealthy for Sensitive Groups**: 35-55 μg/m³
- **Unhealthy**: 55-150 μg/m³
- **Very Unhealthy**: 150-250 μg/m³
- **Hazardous**: 250+ μg/m³

## Future Enhancements

- Real-time PM2.5 data integration via API
- Historical data visualization
- Multiple air quality metrics (PM10, Ozone, etc.)
- Location-based air quality data
- Social sharing features
- Custom particle effects and animations 