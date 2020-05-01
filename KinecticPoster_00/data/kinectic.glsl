//blend sources : http://wiki.polycount.com/wiki/Blending_functions
#version 430
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform sampler2D displacementMap;
uniform sampler2D speedMap;
uniform vec4 time; //x = time, y = normTime, z = modTime, w = loop
uniform vec2 mouse;

uniform vec3 blue = vec3(0, 90, 255);
uniform vec3 pink = vec3(254, 175, 216);

in vec4 vertTexCoord;
out vec4 fragColor;

void main(){
	vec2 uv = vertTexCoord.xy;
    //1- use a map to describe each part as a directional part
    // x = red  0 < 0.5 < 1 → -1.0 < 0.0 < 1.0 → Left | NoMove | Right
    // y = green  0 < 0.5 < 1 → -1.0 < 0.0 < 1.0 → Top | NoMove | Bottom

    vec4 oridirmap = texture2D(displacementMap, uv); 
    vec2 dirmap = ceil(oridirmap.xy * 2.0 - 1.0);
    float speedOffset = texture2D(speedMap, uv).r;
    float minSpeed = 0.975;
    float maxSpeed = 1.0;//0.2;
    
    float speed = mix(minSpeed, maxSpeed, speedOffset);
    uv = fract(uv + dirmap.xy * (speed + time.x * 0.1) );

    vec4 mask = abs(texture2D(displacementMap, uv) * 2.0 - 1.0); 
	vec4 tex = texture2D(texture, uv);

    vec3 type;
    if(abs(dirmap.x) > 0){
	    type.rgb = mask.r * tex.rgb;
    }else if(abs(dirmap.y) > 0){
	    type.rgb = mask.g * tex.rgb;
    }else{
        type.rgb = texture2D(texture, vertTexCoord.xy).rgb;
    }

    if(mod(time.w, 2.0) == 0){
        fragColor.rgb = mix(blue, pink, type) / 255.0;
    }else{
        fragColor.rgb = mix(blue, pink, 1.0 - type) / 255.0;
    }
    // fragColor.rgb += oridirmap.rgb;
    fragColor.a = 1.0;
}