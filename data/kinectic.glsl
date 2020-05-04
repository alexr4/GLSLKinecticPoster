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

in vec4 vertTexCoord;
out vec4 fragColor;

void main(){
	vec2 uv          = vertTexCoord.xy;
    //1- use a map to describe each part as a directional part
    // x = red  0 < 0.5 < 1 → -1.0 < 0.0 < 1.0 → Left | NoMove | Right
    // y = green  0 < 0.5 < 1 → -1.0 < 0.0 < 1.0 → Top | NoMove | Bottom
	vec4 displacergb = texture2D(displacementmap, uv);
    vec2 dirmap      = ceil(displacergb.xy * 2.0 -1.0);
    float speed    = mix(minSpeed, maxSpeed, displacergb.z);

    //animate uv 
    uv = fract(uv + dirmap.xy * (offset + time.x * 0.125 + speed));

    vec4 maskrgb = abs(texture2D(displacementmap, uv) * 2.0 - 1.0);
    float mask = maskrgb.x + maskrgb.y; 
	vec4 tex  = texture2D(texture, uv);

	fragColor = tex * mask + vec4(vec3(0, displacergb.z, 0), 1.0) * 0.0;
}