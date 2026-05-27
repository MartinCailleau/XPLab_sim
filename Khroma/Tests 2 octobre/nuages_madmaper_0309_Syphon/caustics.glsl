#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define MAX_ITER 3

// Uniforms que Processing envoie au shader
uniform vec2 resolution;   // taille de la fenêtre
uniform float time;        // temps en secondes (envoyé depuis Processing)
uniform float speed;       // vitesse d’animation
uniform bool reverse;      // sens de l’animation
uniform float scale;       // zoom de la texture
uniform float brightness;  // luminosité
uniform float contrast;    // contraste

void main() {
    // Coordonnées normalisées [0,1]
    vec2 uv = gl_FragCoord.xy / resolution.xy;

    // Calcul du temps avec la vitesse et éventuellement inversion
    float animation_time = time * speed * (reverse ? -1.0 : 1.0);

    // Mise à l’échelle (zoom)
    uv = vec2(0.5, 0.5) + (uv - vec2(0.5, 0.5)) * scale;
    vec2 p = uv * 8.0 - vec2(20.0);
    vec2 i = p;
    float c = 1.0;
    float inten = .05;

    for (int n = 0; n < MAX_ITER; n++) {
        float t = animation_time * (1.0 - (3.0 / float(n+1)));

        i = p + vec2(
            cos(t - i.x) + sin(t + i.y),
            sin(t - i.y) + cos(t + i.x)
        );

        c += 1.0 / length(vec2(
            p.x / (sin(i.x+t) / inten),
            p.y / (cos(i.y+t) / inten)
        ));
    }

    c /= float(MAX_ITER);
    c = 1.5 - sqrt(c);

    float value = 0.1 / (1.0 - (c + 0.05));
    value += brightness;
    value = mix(0.5, value, contrast);

    gl_FragColor = vec4(vec3(value), 1.0);
}
