#ifdef GL_ES
precision highp float;
precision highp int;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 u_direction;
uniform float u_speed;
uniform vec3 u_cloudColor;

// --- Noise basique ---
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b)* u.x * u.y;
}

float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i=0; i<5; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

void main(void) {
    vec2 uv = gl_FragCoord.xy / resolution.xy;

    // Ajout direction et vitesse
    vec2 dir = normalize(u_direction + 0.001); // éviter vecteur nul
    uv += dir * time * u_speed * 0.1;

    float n = fbm(uv * 4.0);

    // Toujours une couleur visible
    vec3 base = vec3(0.02, 0.02, 0.05); 
    vec3 col = mix(base, u_cloudColor, n);

    gl_FragColor = vec4(col, 1.0);
}
