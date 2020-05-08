//blend sources : http://wiki.polycount.com/wiki/Blending_functions
#version 430
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform sampler2D displacementmap;
uniform vec4 time; //x = time, y = normTime, z = modTime, w = loop
uniform float minSpeed = 0.975;
uniform float maxSpeed = 1.0;
uniform float offset;
uniform vec2 mouse;
uniform vec2 dirmap = vec2(0.0, 0.0);
uniform float isTimeAnimated = 1.0;


in vec4 vertTexCoord;
out vec4 fragColor;

#include ../data/animation.glsl

void main(){
	vec2 uv          = vertTexCoord.xy;
    //1- use a map to describe each part as a directional part
    // x = red  0 < 0.5 < 1 → -1.0 < 0.0 < 1.0 → Left | NoMove | Right
    // y = green  0 < 0.5 < 1 → -1.0 < 0.0 < 1.0 → Top | NoMove | Bottom
	vec4 displacergb = texture2D(displacementmap, uv);
    // vec2 dirmap    = ceil(displacergb.xy * 2.0 -1.0);
    float speed    = 1.0;//mix(minSpeed, maxSpeed, displacergb.z);
    //   dirmap = vec2(-1.0, -0.0);
    // dirmap = keymap.xy;
    
    //animate uv 
    #ifndef TYPE
    uv = stretchPow(uv, 4.0, dirmap);
    #elif TYPE == 0
    uv = stretchPow(uv, 4.0, dirmap);
    #elif TYPE == 1
    uv = stretchCos(uv, 4.0, dirmap);
    #elif TYPE == 2
    uv = sinWave(uv, 4.0, 0.1, time.x, 0.0);
    #elif TYPE == 3
    uv = sinWave(uv, vec2(20.0), time.x, 0.1, 0.25, dirmap);
    #elif TYPE == 4
    uv = sinWaveInvertAxis(uv, vec2(20.0), time.x, 0.1, 0.25, dirmap);
    #elif TYPE == 5
    uv = stitch(uv, vec2(0.25, 0.75), dirmap);
    #elif TYPE == 6
    uv = randomTile(uv, vec2(4.0), 0.5);
    #elif TYPE == 7
    uv = mix(uv, randomOffset(uv, vec2(100.0, 100) * dirmap.yx, 0.1), 0.5 - abs(time.y * 2.0 - 1.0));
    #elif TYPE == 8
    uv = tile(uv, vec2(1.0, 4.0));
    #elif TYPE == 9
    uv = randomPixelisationReveal(uv, vec2(80.0), 0.05, 0.95, abs(time.y * 2.0 - 1.0), time.x * 0.00005, dirmap.xy);
    #elif TYPE == 10
    uv = revealFromCenter(uv, abs(sin(time.x * 1.5)), dirmap.xy);
    #elif TYPE == 11
    uv = tileAndRotateWithOffset(uv, vec2(10.0), time.x, 0.005);
    #elif TYPE == 12
    uv = noiseUV(uv, vec2(8.0), time.x * 0.1, 0.015, dirmap);
    #elif TYPE == 13
    uv = burn(uv, vec2(2.5), time.x * 0.1, 0.35, 0.1, dirmap);
    #elif TYPE == 14
    float rep = sin(time.x * .5) * .5 + .5;
    uv = unzoomAndRepeat(uv, rep * vec2(4.) + 1.);
    #endif
    
    uv = fract(uv
        + dirmap.xy * (offset + time.x * 0.125 + speed) * isTimeAnimated);

    vec4 maskrgb = abs(texture2D(displacementmap, uv) * 2.0 - 1.0);
    float mask = clamp(maskrgb.x + maskrgb.y, 0.0, 1.0) * clamp(abs(dirmap.x + dirmap.y), 0.0, 1.0); 
	vec4 tex  = texture2D(texture, uv);

	fragColor = tex * mask;// + vec4(uv, 0, 1.0);
}