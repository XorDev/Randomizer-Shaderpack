#version 120

uniform sampler2D texture;
uniform sampler2D lightmap;

uniform vec4 entityColor;
uniform float blindness;
uniform int worldDay;
uniform int isEyeInWater;

varying vec4 color;
varying vec2 coord0;
varying vec2 coord1;

vec2 hash(vec2 p)
{
    return (fract(cos(p*mat2(67.72,-93.51,-80.25,71.39))*591.5)-.5)*492.4;
}
void main()
{
    vec3 light = (1.-blindness) * texture2D(lightmap,coord1).rgb;
    float size = 4.;

    vec2 t = hash(floor(coord0*size)+float(worldDay));
    vec2 c = fract(coord0+t/size);
    vec4 a = texture2D(texture,c)*.8;
    vec4 b = texture2D(texture,coord0);
    vec4 col = color * vec4(light,1) * mix(b,a,a.a*b.a);
    col.rgb = mix(col.rgb,entityColor.rgb,entityColor.a);

    float fog = (isEyeInWater>0) ? 1.-exp(-gl_FogFragCoord * gl_Fog.density):
    clamp((gl_FogFragCoord-gl_Fog.start) * gl_Fog.scale, 0., 1.);

    col.rgb = mix(col.rgb, gl_Fog.color.rgb, fog);

    gl_FragData[0] = col;
}
