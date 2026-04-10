// ============================================================
// NEXGEN ESPORTS - ULTIMATE GAMING BACKGROUND ENGINE
// Multi-layered interactive animation system
// ============================================================

document.addEventListener("DOMContentLoaded", () => {
    const canvas = document.createElement("canvas");
    canvas.id = "esports-bg-canvas";
    document.body.appendChild(canvas);
    const ctx = canvas.getContext("2d");

    let W, H;
    let mouse = { x: null, y: null, px: null, py: null, speed: 0, active: false };
    let touchFadeStrength = 0; // 1.0 = full glow, fades to 0 after touch release
    let isTouching = false;
    let frameCount = 0;
    let lastTime = 0;

    // === COLOR PALETTE ===
    const CYAN    = { r: 0,   g: 229, b: 255 };
    const MAGENTA = { r: 255, g: 0,   b: 127 };
    const VIOLET  = { r: 138, g: 43,  b: 226 };
    const GOLD    = { r: 255, g: 215, b: 0   };

    // === SYSTEM ARRAYS ===
    let hexGrid = [];
    let energyParticles = [];
    let floatingShapes = [];
    let pulseWaves = [];
    let trailPoints = [];
    let speedLines = [];
    let embers = [];

    // =========================================================
    //  LAYER 1: HEXAGONAL GRID (subtle pulsing background)
    // =========================================================
    class HexCell {
        constructor(cx, cy, size) {
            this.cx = cx;
            this.cy = cy;
            this.size = size;
            this.baseAlpha = 0.03 + Math.random() * 0.04;
            this.alpha = this.baseAlpha;
            this.pulsePhase = Math.random() * Math.PI * 2;
            this.pulseSpeed = 0.005 + Math.random() * 0.01;
            this.activated = 0; // 0-1 proximity glow
        }

        update() {
            this.pulsePhase += this.pulseSpeed;
            const pulse = Math.sin(this.pulsePhase) * 0.5 + 0.5;
            
            // Mouse proximity activation (use touchFadeStrength on mobile)
            const effectiveStrength = isTouching ? 1.0 : (mouse.active ? 1.0 : touchFadeStrength);
            if (effectiveStrength > 0 && mouse.x !== null) {
                const dx = mouse.x - this.cx;
                const dy = mouse.y - this.cy;
                const dist = Math.sqrt(dx * dx + dy * dy);
                const activationRadius = 200;
                if (dist < activationRadius) {
                    this.activated = Math.min(effectiveStrength, this.activated + 0.08);
                } else {
                    this.activated = Math.max(0, this.activated - 0.015);
                }
            } else {
                this.activated = Math.max(0, this.activated - 0.01);
            }
            
            this.alpha = this.baseAlpha + pulse * 0.03 + this.activated * 0.15;
        }

        draw() {
            ctx.beginPath();
            for (let i = 0; i < 6; i++) {
                const angle = (Math.PI / 3) * i - Math.PI / 6;
                const px = this.cx + this.size * Math.cos(angle);
                const py = this.cy + this.size * Math.sin(angle);
                if (i === 0) ctx.moveTo(px, py);
                else ctx.lineTo(px, py);
            }
            ctx.closePath();

            // Glow color shifts from cyan to magenta when activated
            const r = Math.floor(CYAN.r + (MAGENTA.r - CYAN.r) * this.activated);
            const g = Math.floor(CYAN.g + (MAGENTA.g - CYAN.g) * this.activated);
            const b = Math.floor(CYAN.b + (MAGENTA.b - CYAN.b) * this.activated);

            ctx.strokeStyle = `rgba(${r}, ${g}, ${b}, ${this.alpha})`;
            ctx.lineWidth = 0.5 + this.activated * 1.5;
            ctx.stroke();

            if (this.activated > 0.3) {
                ctx.fillStyle = `rgba(${r}, ${g}, ${b}, ${this.activated * 0.05})`;
                ctx.fill();
            }
        }
    }

    function buildHexGrid() {
        hexGrid = [];
        const size = 40;
        const h = size * Math.sqrt(3);
        const cols = Math.ceil(W / (size * 1.5)) + 2;
        const rows = Math.ceil(H / h) + 2;

        for (let row = -1; row < rows; row++) {
            for (let col = -1; col < cols; col++) {
                const cx = col * size * 1.5;
                const cy = row * h + (col % 2 === 1 ? h / 2 : 0);
                hexGrid.push(new HexCell(cx, cy, size));
            }
        }
    }

    // =========================================================
    //  LAYER 2: ENERGY PARTICLES (burst from cursor)
    // =========================================================
    class EnergyParticle {
        constructor(x, y, type) {
            this.x = x;
            this.y = y;
            this.type = type; // 'burst', 'ambient', 'ember'

            if (type === 'burst') {
                const angle = Math.random() * Math.PI * 2;
                const speed = 2 + Math.random() * 6;
                this.vx = Math.cos(angle) * speed;
                this.vy = Math.sin(angle) * speed;
                this.life = 1.0;
                this.decay = 0.01 + Math.random() * 0.02;
                this.size = 1 + Math.random() * 3;
                this.color = Math.random() > 0.5 ? CYAN : MAGENTA;
            } else {
                // ambient floating particles
                this.vx = (Math.random() - 0.5) * 0.5;
                this.vy = -0.3 - Math.random() * 0.7; // float upward
                this.life = 1.0;
                this.decay = 0.002 + Math.random() * 0.003;
                this.size = 0.5 + Math.random() * 2;
                this.color = Math.random() > 0.7 ? MAGENTA : (Math.random() > 0.5 ? CYAN : VIOLET);
                this.wobblePhase = Math.random() * Math.PI * 2;
                this.wobbleSpeed = 0.02 + Math.random() * 0.03;
            }
            this.trail = [];
        }

        update() {
            // Store trail
            if (this.type === 'burst' && this.life > 0.3) {
                this.trail.push({ x: this.x, y: this.y, alpha: this.life });
                if (this.trail.length > 8) this.trail.shift();
            }

            this.x += this.vx;
            this.y += this.vy;
            this.life -= this.decay;

            if (this.type === 'burst') {
                this.vx *= 0.97;
                this.vy *= 0.97;
                this.vy += 0.02; // slight gravity
            } else {
                this.wobblePhase += this.wobbleSpeed;
                this.vx += Math.sin(this.wobblePhase) * 0.02;
            }
        }

        draw() {
            if (this.life <= 0) return;
            const c = this.color;

            // Draw trail
            for (let i = 0; i < this.trail.length; i++) {
                const t = this.trail[i];
                const a = (i / this.trail.length) * this.life * 0.3;
                ctx.beginPath();
                ctx.arc(t.x, t.y, this.size * 0.5, 0, Math.PI * 2);
                ctx.fillStyle = `rgba(${c.r}, ${c.g}, ${c.b}, ${a})`;
                ctx.fill();
            }

            // Main particle with glow
            const alpha = this.life * 0.8;
            ctx.beginPath();
            ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
            ctx.fillStyle = `rgba(${c.r}, ${c.g}, ${c.b}, ${alpha})`;
            ctx.fill();

            // Glow
            if (this.size > 1.5) {
                ctx.beginPath();
                ctx.arc(this.x, this.y, this.size * 3, 0, Math.PI * 2);
                ctx.fillStyle = `rgba(${c.r}, ${c.g}, ${c.b}, ${alpha * 0.1})`;
                ctx.fill();
            }
        }
    }

    // =========================================================
    //  LAYER 3: FLOATING GEOMETRIC SHAPES
    // =========================================================
    class FloatingShape {
        constructor() {
            this.reset();
        }

        reset() {
            this.x = Math.random() * W;
            this.y = Math.random() * H;
            this.vx = (Math.random() - 0.5) * 0.3;
            this.vy = (Math.random() - 0.5) * 0.3;
            this.rotation = Math.random() * Math.PI * 2;
            this.rotSpeed = (Math.random() - 0.5) * 0.01;
            this.size = 15 + Math.random() * 35;
            this.sides = [3, 4, 5, 6][Math.floor(Math.random() * 4)];
            this.alpha = 0.02 + Math.random() * 0.04;
            this.baseAlpha = this.alpha;
            this.pulsePhase = Math.random() * Math.PI * 2;
            this.color = [CYAN, MAGENTA, VIOLET][Math.floor(Math.random() * 3)];
            this.glowIntensity = 0;
        }

        update() {
            this.x += this.vx;
            this.y += this.vy;
            this.rotation += this.rotSpeed;
            this.pulsePhase += 0.015;

            // Wrap around
            if (this.x < -this.size * 2) this.x = W + this.size;
            if (this.x > W + this.size * 2) this.x = -this.size;
            if (this.y < -this.size * 2) this.y = H + this.size;
            if (this.y > H + this.size * 2) this.y = -this.size;

            // Mouse proximity glow (use touchFadeStrength on mobile)
            const effectiveStrength = isTouching ? 1.0 : (mouse.active ? 1.0 : touchFadeStrength);
            if (effectiveStrength > 0 && mouse.x !== null) {
                const dx = mouse.x - this.x;
                const dy = mouse.y - this.y;
                const dist = Math.sqrt(dx * dx + dy * dy);
                if (dist < 250) {
                    this.glowIntensity = Math.min(effectiveStrength, this.glowIntensity + 0.05);
                    // Slight attraction
                    this.vx += (dx / dist) * 0.01 * effectiveStrength;
                    this.vy += (dy / dist) * 0.01 * effectiveStrength;
                } else {
                    this.glowIntensity = Math.max(0, this.glowIntensity - 0.02);
                }
            } else {
                this.glowIntensity = Math.max(0, this.glowIntensity - 0.01);
            }

            const pulse = Math.sin(this.pulsePhase) * 0.5 + 0.5;
            this.alpha = this.baseAlpha + pulse * 0.02 + this.glowIntensity * 0.12;

            // Dampen velocity
            this.vx *= 0.995;
            this.vy *= 0.995;
        }

        draw() {
            const c = this.color;
            ctx.save();
            ctx.translate(this.x, this.y);
            ctx.rotate(this.rotation);

            ctx.beginPath();
            for (let i = 0; i < this.sides; i++) {
                const angle = (Math.PI * 2 / this.sides) * i - Math.PI / 2;
                const px = this.size * Math.cos(angle);
                const py = this.size * Math.sin(angle);
                if (i === 0) ctx.moveTo(px, py);
                else ctx.lineTo(px, py);
            }
            ctx.closePath();

            ctx.strokeStyle = `rgba(${c.r}, ${c.g}, ${c.b}, ${this.alpha})`;
            ctx.lineWidth = 1 + this.glowIntensity * 2;
            ctx.stroke();

            if (this.glowIntensity > 0.2) {
                ctx.fillStyle = `rgba(${c.r}, ${c.g}, ${c.b}, ${this.glowIntensity * 0.03})`;
                ctx.fill();

                // Outer glow
                ctx.shadowColor = `rgba(${c.r}, ${c.g}, ${c.b}, ${this.glowIntensity * 0.5})`;
                ctx.shadowBlur = 20;
                ctx.stroke();
                ctx.shadowBlur = 0;
            }

            ctx.restore();
        }
    }

    // =========================================================
    //  LAYER 4: PULSE WAVES (radiate from click/touch)
    // =========================================================
    class PulseWave {
        constructor(x, y) {
            this.x = x;
            this.y = y;
            this.radius = 0;
            this.maxRadius = 300 + Math.random() * 200;
            this.speed = 3 + Math.random() * 2;
            this.life = 1.0;
            this.color = Math.random() > 0.5 ? CYAN : MAGENTA;
            this.lineWidth = 2;
        }

        update() {
            this.radius += this.speed;
            this.life = 1 - (this.radius / this.maxRadius);
        }

        draw() {
            if (this.life <= 0) return;
            const c = this.color;
            const alpha = this.life * 0.4;

            ctx.beginPath();
            ctx.arc(this.x, this.y, this.radius, 0, Math.PI * 2);
            ctx.strokeStyle = `rgba(${c.r}, ${c.g}, ${c.b}, ${alpha})`;
            ctx.lineWidth = this.lineWidth * this.life;
            ctx.stroke();

            // Secondary inner ring
            if (this.radius > 20) {
                ctx.beginPath();
                ctx.arc(this.x, this.y, this.radius * 0.7, 0, Math.PI * 2);
                ctx.strokeStyle = `rgba(${c.r}, ${c.g}, ${c.b}, ${alpha * 0.3})`;
                ctx.lineWidth = 1;
                ctx.stroke();
            }
        }
    }

    // =========================================================
    //  LAYER 5: CURSOR TRAIL (energy ribbon)
    // =========================================================
    function updateTrail() {
        if (mouse.x !== null && mouse.active) {
            trailPoints.push({ x: mouse.x, y: mouse.y, life: 1.0 });
        }
        if (trailPoints.length > 50) trailPoints.shift();

        for (let i = trailPoints.length - 1; i >= 0; i--) {
            trailPoints[i].life -= 0.02;
            if (trailPoints[i].life <= 0) {
                trailPoints.splice(i, 1);
            }
        }
    }

    function drawTrail() {
        if (trailPoints.length < 3) return;

        for (let i = 1; i < trailPoints.length; i++) {
            const p0 = trailPoints[i - 1];
            const p1 = trailPoints[i];
            const alpha = p1.life * 0.6;
            const width = p1.life * 4;

            // Gradient from cyan to magenta along trail
            const ratio = i / trailPoints.length;
            const r = Math.floor(CYAN.r + (MAGENTA.r - CYAN.r) * ratio);
            const g = Math.floor(CYAN.g + (MAGENTA.g - CYAN.g) * ratio);
            const b = Math.floor(CYAN.b + (MAGENTA.b - CYAN.b) * ratio);

            ctx.beginPath();
            ctx.moveTo(p0.x, p0.y);
            ctx.lineTo(p1.x, p1.y);
            ctx.strokeStyle = `rgba(${r}, ${g}, ${b}, ${alpha})`;
            ctx.lineWidth = width;
            ctx.lineCap = 'round';
            ctx.stroke();

            // Glow layer
            ctx.beginPath();
            ctx.moveTo(p0.x, p0.y);
            ctx.lineTo(p1.x, p1.y);
            ctx.strokeStyle = `rgba(${r}, ${g}, ${b}, ${alpha * 0.2})`;
            ctx.lineWidth = width * 4;
            ctx.stroke();
        }
    }

    // =========================================================
    //  LAYER 6: SPEED LINES (when mouse moves fast)
    // =========================================================
    class SpeedLine {
        constructor(x, y, angle) {
            this.x = x;
            this.y = y;
            this.angle = angle + (Math.random() - 0.5) * 0.5;
            this.length = 30 + Math.random() * 80;
            this.speed = 5 + Math.random() * 10;
            this.life = 1.0;
            this.decay = 0.03 + Math.random() * 0.02;
            this.color = Math.random() > 0.5 ? CYAN : MAGENTA;
        }

        update() {
            this.x += Math.cos(this.angle) * this.speed;
            this.y += Math.sin(this.angle) * this.speed;
            this.life -= this.decay;
            this.speed *= 0.96;
        }

        draw() {
            if (this.life <= 0) return;
            const c = this.color;
            const alpha = this.life * 0.5;
            const endX = this.x + Math.cos(this.angle) * this.length * this.life;
            const endY = this.y + Math.sin(this.angle) * this.length * this.life;

            ctx.beginPath();
            ctx.moveTo(this.x, this.y);
            ctx.lineTo(endX, endY);
            ctx.strokeStyle = `rgba(${c.r}, ${c.g}, ${c.b}, ${alpha})`;
            ctx.lineWidth = 1.5 * this.life;
            ctx.lineCap = 'round';
            ctx.stroke();
        }
    }

    // =========================================================
    //  LAYER 7: RISING EMBERS (ambient atmosphere)
    // =========================================================
    class Ember {
        constructor() {
            this.reset(true);
        }

        reset(randomY) {
            this.x = Math.random() * W;
            this.y = randomY ? Math.random() * H : H + 10;
            this.size = 0.5 + Math.random() * 2;
            this.vy = -(0.2 + Math.random() * 0.8);
            this.vx = (Math.random() - 0.5) * 0.3;
            this.wobble = Math.random() * Math.PI * 2;
            this.wobbleSpeed = 0.01 + Math.random() * 0.03;
            this.alpha = 0.1 + Math.random() * 0.4;
            this.color = [CYAN, MAGENTA, VIOLET, GOLD][Math.floor(Math.random() * 4)];
            this.flickerPhase = Math.random() * Math.PI * 2;
        }

        update() {
            this.wobble += this.wobbleSpeed;
            this.x += this.vx + Math.sin(this.wobble) * 0.3;
            this.y += this.vy;
            this.flickerPhase += 0.1;

            if (this.y < -10) this.reset(false);
        }

        draw() {
            const flicker = 0.5 + Math.sin(this.flickerPhase) * 0.5;
            const a = this.alpha * flicker;
            const c = this.color;

            ctx.beginPath();
            ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
            ctx.fillStyle = `rgba(${c.r}, ${c.g}, ${c.b}, ${a})`;
            ctx.fill();

            // Soft glow
            ctx.beginPath();
            ctx.arc(this.x, this.y, this.size * 4, 0, Math.PI * 2);
            ctx.fillStyle = `rgba(${c.r}, ${c.g}, ${c.b}, ${a * 0.08})`;
            ctx.fill();
        }
    }

    // =========================================================
    //  LAYER 8: SCANLINE + VIGNETTE (cinematic polish)
    // =========================================================
    function drawScanlines() {
        ctx.fillStyle = 'rgba(0, 0, 0, 0.03)';
        for (let y = 0; y < H; y += 4) {
            ctx.fillRect(0, y, W, 1);
        }
    }

    function drawVignette() {
        const gradient = ctx.createRadialGradient(W / 2, H / 2, H * 0.3, W / 2, H / 2, H * 0.9);
        gradient.addColorStop(0, 'rgba(0, 0, 0, 0)');
        gradient.addColorStop(1, 'rgba(0, 0, 0, 0.4)');
        ctx.fillStyle = gradient;
        ctx.fillRect(0, 0, W, H);
    }

    // =========================================================
    //  INITIALIZATION
    // =========================================================
    function init() {
        W = canvas.width = window.innerWidth;
        H = canvas.height = window.innerHeight;

        buildHexGrid();

        // Floating shapes
        floatingShapes = [];
        const shapeCount = Math.min(Math.floor((W * H) / 80000), 20);
        for (let i = 0; i < shapeCount; i++) {
            floatingShapes.push(new FloatingShape());
        }

        // Ambient embers
        embers = [];
        const emberCount = Math.min(Math.floor((W * H) / 15000), 60);
        for (let i = 0; i < emberCount; i++) {
            embers.push(new Ember());
        }

        // Some ambient energy particles
        energyParticles = [];
        for (let i = 0; i < 15; i++) {
            energyParticles.push(new EnergyParticle(
                Math.random() * W, Math.random() * H, 'ambient'
            ));
        }
    }

    // =========================================================
    //  MOUSE / TOUCH HANDLERS
    // =========================================================
    function handleMove(x, y) {
        mouse.px = mouse.x;
        mouse.py = mouse.y;
        mouse.x = x;
        mouse.y = y;
        mouse.active = true;

        if (mouse.px !== null) {
            const dx = x - mouse.px;
            const dy = y - mouse.py;
            mouse.speed = Math.sqrt(dx * dx + dy * dy);

            // Spawn burst particles on fast movement
            if (mouse.speed > 8) {
                const count = Math.min(Math.floor(mouse.speed / 4), 5);
                for (let i = 0; i < count; i++) {
                    energyParticles.push(new EnergyParticle(x, y, 'burst'));
                }
            }

            // Speed lines on very fast movement
            if (mouse.speed > 20) {
                const angle = Math.atan2(dy, dx);
                for (let i = 0; i < 3; i++) {
                    speedLines.push(new SpeedLine(x, y, angle + Math.PI));
                }
            }
        }
    }

    window.addEventListener("mousemove", (e) => handleMove(e.clientX, e.clientY));
    window.addEventListener("touchmove", (e) => {
        handleMove(e.touches[0].clientX, e.touches[0].clientY);
    }, { passive: true });
    window.addEventListener("touchstart", (e) => {
        isTouching = true;
        touchFadeStrength = 1.0;
        handleMove(e.touches[0].clientX, e.touches[0].clientY);
        // Pulse wave on touch
        pulseWaves.push(new PulseWave(e.touches[0].clientX, e.touches[0].clientY));
        // Burst particles
        for (let i = 0; i < 15; i++) {
            energyParticles.push(new EnergyParticle(e.touches[0].clientX, e.touches[0].clientY, 'burst'));
        }
    });

    window.addEventListener("click", (e) => {
        // Pulse wave on click
        pulseWaves.push(new PulseWave(e.clientX, e.clientY));
        // Burst particles
        for (let i = 0; i < 20; i++) {
            energyParticles.push(new EnergyParticle(e.clientX, e.clientY, 'burst'));
        }
    });

    window.addEventListener("mouseleave", () => {
        mouse.active = false;
        mouse.x = null;
        mouse.y = null;
    });
    window.addEventListener("touchend", () => {
        mouse.active = false;
        isTouching = false;
        // touchFadeStrength will decay in the animation loop
    });

    window.addEventListener("resize", () => init());

    // =========================================================
    //  MAIN ANIMATION LOOP
    // =========================================================
    function animate(timestamp) {
        requestAnimationFrame(animate);
        frameCount++;
        
        const dt = timestamp - lastTime;
        lastTime = timestamp;

        // Fade out touch glow on mobile (~2.5 seconds)
        if (!isTouching && touchFadeStrength > 0) {
            touchFadeStrength -= 0.007; // ~143 frames => ~2.4s at 60fps
            if (touchFadeStrength <= 0) {
                touchFadeStrength = 0;
                mouse.x = null;
                mouse.y = null;
            }
        }

        ctx.clearRect(0, 0, W, H);

        // --- Layer 1: Hex Grid ---
        for (let i = 0; i < hexGrid.length; i++) {
            hexGrid[i].update();
            hexGrid[i].draw();
        }

        // --- Layer 3: Floating Shapes ---
        for (let i = 0; i < floatingShapes.length; i++) {
            floatingShapes[i].update();
            floatingShapes[i].draw();
        }

        // --- Layer 7: Embers ---
        for (let i = 0; i < embers.length; i++) {
            embers[i].update();
            embers[i].draw();
        }

        // --- Layer 4: Pulse Waves ---
        for (let i = pulseWaves.length - 1; i >= 0; i--) {
            pulseWaves[i].update();
            pulseWaves[i].draw();
            if (pulseWaves[i].life <= 0) pulseWaves.splice(i, 1);
        }

        // --- Layer 6: Speed Lines ---
        for (let i = speedLines.length - 1; i >= 0; i--) {
            speedLines[i].update();
            speedLines[i].draw();
            if (speedLines[i].life <= 0) speedLines.splice(i, 1);
        }

        // --- Layer 2: Energy Particles ---
        for (let i = energyParticles.length - 1; i >= 0; i--) {
            energyParticles[i].update();
            energyParticles[i].draw();
            if (energyParticles[i].life <= 0) {
                energyParticles.splice(i, 1);
            }
        }

        // --- Layer 5: Cursor Trail ---
        updateTrail();
        drawTrail();

        // --- Layer 8: Post-processing ---
        if (frameCount % 2 === 0) drawScanlines(); // Every other frame for perf
        drawVignette();

        // Spawn ambient particles periodically
        if (frameCount % 60 === 0 && energyParticles.length < 50) {
            energyParticles.push(new EnergyParticle(
                Math.random() * W, H + 10, 'ambient'
            ));
        }

        // Auto pulse waves periodically (every ~5 seconds)
        if (frameCount % 300 === 0) {
            pulseWaves.push(new PulseWave(
                W * 0.2 + Math.random() * W * 0.6,
                H * 0.2 + Math.random() * H * 0.6
            ));
        }

        // Cap arrays to prevent memory issues
        if (energyParticles.length > 200) energyParticles.splice(0, 50);
        if (speedLines.length > 50) speedLines.splice(0, 20);
        if (pulseWaves.length > 10) pulseWaves.splice(0, 5);
    }

    init();
    animate(0);
});
