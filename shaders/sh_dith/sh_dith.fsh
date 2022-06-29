varying vec2 v_vTexcoord;
varying vec4 v_vColour;

const float color_factor = 10.0;
const mat4 dither = mat4(
    -4.0, 0.0, -3.0, 1.0,
    2.0, -2.0, 3.0, -1.0,
    -3.0, 1.0, -4.0, 0.0,
    3.0, -1.0, 2.0, -2.0
);

uniform vec2 texel;

void main()
{
	// Coords
    vec2 uv = v_vTexcoord;
    vec2 q = texel * 2.0;
    uv = floor(uv / q) * q;
    
    vec4 base = texture2D(gm_BaseTexture, uv);
    
    // Dith
    vec2 ruv = uv * (1.0 / q);
    ruv = floor(ruv + 0.001);
    base.rgb += dither[int(mod(ruv.x, 4.0))][int(mod(ruv.y, 4.0))] * 0.005;
    
    // Color
    base.rgb = floor(base.rgb * color_factor) / color_factor;
    
    gl_FragColor = v_vColour * base;
}
