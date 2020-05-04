#define RANDOM_SEED 43758.5453123

float random(float x){
    return fract(sin(x) * RANDOM_SEED);
}

float random (vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233)))* RANDOM_SEED);
}

vec2 random2D(vec2 uv){
  uv = vec2(dot(uv, vec2(127.1, 311.7)), dot(uv, vec2(269.5, 183.3)));
  return fract(sin(uv) *RANDOM_SEED);
}

vec3 random3D(vec3 uv){
  uv = vec3(dot(uv, vec3(127.1, 311.7, 120.9898)), dot(uv, vec3(269.5, 183.3, 150.457)), dot(uv, vec3(380.5, 182.3, 170.457)));
  return fract(sin(uv) * RANDOM_SEED);
}