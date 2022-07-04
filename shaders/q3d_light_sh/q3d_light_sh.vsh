attribute vec3 in_Position;                  // (x,y,z)
attribute vec3 in_Normal;                    // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vPosition;
varying vec3 v_vNormal;

uniform float is_quanted;
uniform float vertex_quant;
uniform float is_water;

uniform float time;

// Noise functions
float random(in vec2 _st) {
    return fract(sin(dot(_st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}
float noise(in vec2 _st) {
    vec2 i = floor(_st);
    vec2 f = fract(_st);
	
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}
float fbm(in vec2 _st) {
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(100.0);
    mat2 rot = mat2(cos(0.5), sin(0.5),
                    -sin(0.5), cos(0.50));
	
    for (int i = 0; i < 4; ++i) {
        v += a * noise(_st);
        _st = rot * _st * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}

void main()
{
	v_vColour = in_Colour;
	v_vTexcoord = in_TextureCoord;
	
	vec3 in_pos = in_Position;
	
	float e = noise(time + in_pos.xy * 0.02);
	in_pos.z += e * 4.0 * is_water;
	v_vColour.rgb -= (1.0 - e) * 0.2 * is_water;
	v_vColour.a += is_water * 0.6;
	v_vTexcoord += mod(is_water * time * 0.5, 1.0);
	
    vec4 ndc = vec4(in_pos, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * ndc;
	
	if (is_quanted == 1.0) {
		gl_Position.xy = floor(gl_Position.xy / vertex_quant) * vertex_quant;
	}
	
	v_vPosition = (gm_Matrices[MATRIX_WORLD] * ndc).xyz;
	v_vNormal = (
		gm_Matrices[MATRIX_WORLD] *
		vec4(in_Normal.x, in_Normal.y, in_Normal.z, 0.0)
	).xyz;
}
