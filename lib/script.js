// PM2.5 Configuration
const PM25_CONFIG = {
    // Sample PM2.5 value (μg/m³) - you can modify this
    currentValue: 35,
    
    // Particle spawn rates based on PM2.5 levels
    spawnRates: {
        good: { min: 1, max: 3 },      // 0-12 μg/m³
        moderate: { min: 3, max: 8 },  // 12-35 μg/m³
        unhealthy: { min: 8, max: 15 }, // 35-55 μg/m³
        veryUnhealthy: { min: 15, max: 25 }, // 55-150 μg/m³
        hazardous: { min: 25, max: 40 } // 150+ μg/m³
    },
    
    // Particle lifetime in milliseconds
    particleLifetime: 8000,
    
    // Maximum particles in scene
    maxParticles: 100,
    
    // Spawn radius around camera
    spawnRadius: 5
};

// Air quality categories
const AIR_QUALITY = {
    good: { min: 0, max: 12, text: "Good", color: "#00e400", health: "Air quality is good. No health effects expected." },
    moderate: { min: 12, max: 35, text: "Moderate", color: "#ffff00", health: "Air quality is acceptable. Some pollutants may be a concern for sensitive individuals." },
    unhealthy: { min: 35, max: 55, text: "Unhealthy for Sensitive Groups", color: "#ff7e00", health: "Members of sensitive groups may experience health effects." },
    veryUnhealthy: { min: 55, max: 150, text: "Unhealthy", color: "#ff0000", health: "Everyone may begin to experience health effects." },
    hazardous: { min: 150, max: 250, text: "Very Unhealthy", color: "#8f3f97", health: "Health warnings of emergency conditions." }
};

// Global variables
let particles = [];
let spawnInterval;
let lastSpawnTime = 0;

// Initialize the application
AFRAME.registerComponent('pm25-visualization', {
    init: function() {
        console.log('PM2.5 Visualization initialized');
        this.startParticleSystem();
        this.updateDisplay();
    },
    
    startParticleSystem: function() {
        // Start spawning particles
        spawnInterval = setInterval(() => {
            this.spawnParticles();
        }, 100);
        
        // Clean up old particles
        setInterval(() => {
            this.cleanupParticles();
        }, 1000);
    },
    
    spawnParticles: function() {
        const now = Date.now();
        const spawnRate = this.getSpawnRate();
        
        // Spawn particles based on rate
        for (let i = 0; i < spawnRate; i++) {
            if (particles.length < PM25_CONFIG.maxParticles) {
                this.createParticle();
            }
        }
        
        lastSpawnTime = now;
    },
    
    getSpawnRate: function() {
        const pm25 = PM25_CONFIG.currentValue;
        
        if (pm25 <= 12) return this.randomBetween(PM25_CONFIG.spawnRates.good.min, PM25_CONFIG.spawnRates.good.max);
        if (pm25 <= 35) return this.randomBetween(PM25_CONFIG.spawnRates.moderate.min, PM25_CONFIG.spawnRates.moderate.max);
        if (pm25 <= 55) return this.randomBetween(PM25_CONFIG.spawnRates.unhealthy.min, PM25_CONFIG.spawnRates.unhealthy.max);
        if (pm25 <= 150) return this.randomBetween(PM25_CONFIG.spawnRates.veryUnhealthy.min, PM25_CONFIG.spawnRates.veryUnhealthy.max);
        return this.randomBetween(PM25_CONFIG.spawnRates.hazardous.min, PM25_CONFIG.spawnRates.hazardous.max);
    },
    
    createParticle: function() {
        const particleContainer = document.getElementById('particle-container');
        
        // Generate random position around camera
        const angle = Math.random() * Math.PI * 2;
        const radius = Math.random() * PM25_CONFIG.spawnRadius;
        const height = (Math.random() - 0.5) * 3;
        
        const x = Math.cos(angle) * radius;
        const z = Math.sin(angle) * radius;
        const y = height;
        
        // Create particle element
        const particle = document.createElement('a-sphere');
        particle.setAttribute('radius', '0.05');
        particle.setAttribute('position', `${x} ${y} ${z}`);
        particle.setAttribute('color', this.getParticleColor());
        particle.setAttribute('opacity', '0.7');
        particle.setAttribute('transparent', 'true');
        
        // Add click event
        particle.addEventListener('click', () => {
            this.showInfoPanel();
        });
        
        // Add to scene
        particleContainer.appendChild(particle);
        
        // Store particle data
        const particleData = {
            element: particle,
            createdAt: Date.now(),
            position: { x, y, z }
        };
        
        particles.push(particleData);
        
        // Add floating animation
        this.addFloatingAnimation(particle);
    },
    
    getParticleColor: function() {
        const pm25 = PM25_CONFIG.currentValue;
        
        if (pm25 <= 12) return '#00e400'; // Green
        if (pm25 <= 35) return '#ffff00'; // Yellow
        if (pm25 <= 55) return '#ff7e00'; // Orange
        if (pm25 <= 150) return '#ff0000'; // Red
        return '#8f3f97'; // Purple
    },
    
    addFloatingAnimation: function(particle) {
        // Add subtle floating motion
        const originalPos = particle.getAttribute('position');
        const floatDistance = 0.2;
        const floatSpeed = 2 + Math.random() * 2;
        
        particle.setAttribute('animation', {
            property: 'position',
            dur: floatSpeed * 1000,
            easing: 'easeInOutSine',
            loop: true,
            to: `${originalPos.x} ${originalPos.y + floatDistance} ${originalPos.z}`
        });
    },
    
    cleanupParticles: function() {
        const now = Date.now();
        particles = particles.filter(particleData => {
            if (now - particleData.createdAt > PM25_CONFIG.particleLifetime) {
                // Remove from DOM
                if (particleData.element.parentNode) {
                    particleData.element.parentNode.removeChild(particleData.element);
                }
                return false;
            }
            return true;
        });
        
        this.updateParticleCount();
    },
    
    updateParticleCount: function() {
        document.getElementById('particle-count').textContent = particles.length;
    },
    
    updateDisplay: function() {
        document.getElementById('pm25-display').textContent = PM25_CONFIG.currentValue;
    },
    
    showInfoPanel: function() {
        const panel = document.getElementById('info-panel');
        const pm25Element = document.getElementById('panel-pm25');
        const airQualityElement = document.getElementById('air-quality-text');
        const healthElement = document.getElementById('health-info');
        
        // Update panel content
        pm25Element.textContent = PM25_CONFIG.currentValue;
        
        // Get air quality info
        const airQuality = this.getAirQualityInfo(PM25_CONFIG.currentValue);
        airQualityElement.textContent = airQuality.text;
        airQualityElement.style.color = airQuality.color;
        healthElement.textContent = airQuality.health;
        
        // Show panel
        panel.style.display = 'block';
    },
    
    getAirQualityInfo: function(pm25) {
        for (const [category, info] of Object.entries(AIR_QUALITY)) {
            if (pm25 >= info.min && pm25 <= info.max) {
                return info;
            }
        }
        return AIR_QUALITY.hazardous;
    },
    
    randomBetween: function(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }
});

// Close info panel function
function closeInfoPanel() {
    document.getElementById('info-panel').style.display = 'none';
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Add the component to the scene
    const scene = document.querySelector('a-scene');
    scene.setAttribute('pm25-visualization', '');
    
    // Add click event to close panel when clicking outside
    document.addEventListener('click', function(e) {
        const panel = document.getElementById('info-panel');
        if (e.target === panel) {
            closeInfoPanel();
        }
    });
});

// Optional: Add keyboard controls for testing
document.addEventListener('keydown', function(e) {
    switch(e.key) {
        case '1':
            PM25_CONFIG.currentValue = 10; // Good
            break;
        case '2':
            PM25_CONFIG.currentValue = 25; // Moderate
            break;
        case '3':
            PM25_CONFIG.currentValue = 45; // Unhealthy
            break;
        case '4':
            PM25_CONFIG.currentValue = 75; // Very Unhealthy
            break;
        case '5':
            PM25_CONFIG.currentValue = 180; // Hazardous
            break;
    }
    
    // Update display
    document.getElementById('pm25-display').textContent = PM25_CONFIG.currentValue;
}); 