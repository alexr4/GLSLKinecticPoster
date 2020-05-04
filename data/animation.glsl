#include ../data/random.glsl
#include ../data/noise.glsl

#define PI 3.1415926535897932384626433832795
vec2 based = vec2(1.0);

vec2 stretchPow(in vec2 uv, in float displacementFactor, in vec2 dirmap){
    return uv * mix(based, vec2(pow(uv.x, displacementFactor), pow(uv.y, displacementFactor)), abs(dirmap));
}

vec2 stretchCos(in vec2 uv, in float displacementFactor, in vec2 dirmap){
    return uv * mix(based, abs(vec2(cos(uv.x * PI * 0.25), cos(uv.y * PI * 0.25))), abs(dirmap));
}

vec2 sinWave(in vec2 uv, in vec2 colsRow, in float time, in float speeduv, in float scaleiuv, in vec2 dirmap){
     colsRow = mix(based, colsRow, abs(dirmap.yx));
    vec2 nuv = uv * colsRow;
    vec2 iuv = floor(nuv);
    vec2 offsetuv = sin(iuv * scaleiuv + time * dirmap.yx) * speeduv;
    return uv + offsetuv.yx;
}

vec2 sinWave(in vec2 uv, in float frequency, in float amplitude, float time, in float axis){
    // vec2 basedSinAmp =  mix(based, vec2(scaleiuv), abs(dirmap));

    // // vec2 offsetuv = sin(uv * basedSinAmp + time * 0.0 * dirmap.yx) * speeduv;
    // vec2 offsetuv = sin(uv * scaleiuv) * speeduv;
    // return mix(uv, uv + offsetuv, dirmap);
    float x = uv.x + sin(uv.y * frequency + time) * amplitude;
    float y = uv.y + sin(uv.x * frequency + time) * amplitude;
    return mix(vec2(x, uv.y), vec2(uv.x, y), abs(axis));
}

vec2 sinWaveInvertAxis(in vec2 uv, in vec2 colsRow, in float time, in float speeduv, in float scaleiuv, in vec2 dirmap){
     colsRow = mix(based, colsRow, abs(dirmap.xy));
    vec2 nuv = uv * colsRow;
    vec2 iuv = floor(nuv);
    vec2 offsetuv = sin(iuv * scaleiuv + time * dirmap.xy) * speeduv;
    return uv + offsetuv.yx;
}

vec2 stitch(in vec2 uv, in vec2 minmax, in vec2 dirmap){
    // vec2 axisStitch = mix(based, vec2(minmax), abs(dirmap.xy));
    vec2 axisMinStitch = mix(uv, vec2(minmax.x), abs(dirmap.xy));
    vec2 axisMaxStitch = mix(uv, vec2(minmax.y), abs(dirmap.xy));
    // vec2 stepper = step(abs(dirmap) * minmax, uv);
    // return max(uv, 1.0-axisStitch);// - min(uv, axisStitch) * (1.0 - stepper);

    vec2 stepper1 = step(minmax.xx, uv * abs(dirmap));
    vec2 stepper2 = step(minmax.yy, uv * abs(dirmap));
    vec2 mask = ((1.0 - stepper2) * stepper1);
    return uv * mask + axisMaxStitch * stepper2 + axisMinStitch * (1.0 - stepper1);
}

vec2 randomOffset(in vec2 uv, in vec2 colsRow, in float scaler){
    vec2 nuv = uv * colsRow;
    vec2 iuv = floor(nuv);
    vec2 randomOffset = random2D(iuv) * 2.0 - 1.0;
    return uv + randomOffset * scaler;
}

vec2 tile(in vec2 uv, vec2 colsRow){
    return fract(uv * colsRow);
}

vec2 tileAndRotate(in vec2 uv, in vec2 colsRow, in float angle){
    vec2 nuv = uv * colsRow;
    vec2 fuv = fract(nuv);
    vec2 iuv = floor(nuv);
    
    mat2 matAngle = mat2(cos(angle), -sin(angle), 
                         sin(angle),  cos(angle));

    fuv = fuv * 2.0 - 1.0;
    fuv = matAngle * fuv;
    fuv = fuv * 0.5 + 0.5;

    return (fuv + iuv) / colsRow;
}

vec2 tileAndRotateWithOffset(in vec2 uv, in vec2 colsRow, in float angle, float offset){
    vec2 nuv = uv * colsRow;
    vec2 fuv = fract(nuv);
    vec2 iuv = floor(nuv);
    float i = iuv.x + iuv.y * colsRow.x;
    
    mat2 matAngle = mat2(cos(angle + i * offset), -sin(angle + i * offset), 
                         sin(angle + i * offset),  cos(angle + i * offset));

    fuv = fuv * 2.0 - 1.0;
    fuv = matAngle * fuv;
    fuv = fuv * 0.5 + 0.5;

    return (fuv + iuv) / colsRow;
}

vec2 randomTile(in vec2 uv, vec2 colsRow, in float percentOfFill){
    vec2 nuv = uv * colsRow;
    vec2 iuv = floor(nuv);
    float randomFill = random(iuv);
    return fract(nuv) * step(1.0 - percentOfFill, randomFill);
}

vec2 randomPixelisationReveal(in vec2 uv, in vec2 colsRow, in float scaler, in float percentOfFill, in float offset, in float time, in vec2 dirmap){
    vec2 stepper = step(vec2(1.0 - offset), 1.0 - abs(uv * 2.0 - 1.0) * abs(dirmap));

    vec2 nuv = uv * colsRow;
    vec2 iuv = floor(nuv);
    vec2 randomOffset = random2D(iuv + time) * 2.0 - 1.0;
    float randomFill = random(iuv + time);
    vec2 grid =  (uv + randomOffset * scaler) * step(1.0 - percentOfFill, randomFill);;
    

    return mix(grid, uv, stepper);
}

vec2 revealFromCenter(in vec2 uv, in float offset, in vec2 dirmap){
    vec2 stepper = step(vec2(1.0 - offset), 1.0 - abs(uv * 2.0 - 1.0) * abs(dirmap));


    return uv * stepper;
}

vec2 noiseUV(in vec2 uv, in vec2 scale, in float time, float offsetscale, in vec2 dirmap){
    float noised = snoise(uv * scale + time);
    vec2 offset = dirmap * noised;

    return uv + offset * offsetscale;
}

vec2 burn(in vec2 uv, in vec2 scale, in float time, in float edge, in float smoothness, in vec2 dirmap){
    float noised = snoise(vec3(uv * scale, time));
    float stepper = 1.0 - smoothstep(edge - smoothness * 0.5, edge + smoothness * 0.5, noised);
    return uv * stepper;
}