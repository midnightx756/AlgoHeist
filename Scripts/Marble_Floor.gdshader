shader_type canvas_item;

// Color settings for the marble
uniform vec4 base_color : source_color = vec4(0.9, 0.9, 0.9, 1.0); // Marble white
uniform vec4 vein_color : source_color = vec4(0.3, 0.3, 0.3, 1.0); // Gray veins
uniform float scale = 5.0;     // Overall scale
uniform float detail = 5.0;    // Complexity of the veins

// Standard pseudo-random function for GPU
float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

// Simple noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void fragment() {
    vec2 uv = UV * scale;
    
    // Marble effect: Layer multiple noises and distort them with sine waves
    float n = 0.0;
    vec2 q = uv + vec2(sin(uv.y * 2.0), cos(uv.x * 2.0));
    n = noise(q * detail);
    
    // Create the "vein" look by taking the sine of the noise
    float veins = abs(sin(n * 10.0));
    
    // Mix the colors
    vec3 final_color = mix(base_color.rgb, vein_color.rgb, veins);
    COLOR = vec4(final_color, 1.0);
}