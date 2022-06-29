attribute vec3 in_Position;                  // (x,y,z)
attribute vec3 in_Normal;                    // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 uv;
varying vec4 color;

uniform float is_quanted;
uniform float vertex_quant;

void main()
{
    vec4 ndc = vec4(in_Position, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * ndc;
	
	if (is_quanted == 1.0) {
		float quant = 1.0;
		gl_Position.xy = floor(gl_Position.xy / vertex_quant) * vertex_quant;
	}
    
    color = in_Colour;
    uv = in_TextureCoord;
}
