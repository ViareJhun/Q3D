attribute vec3 in_Position;                  // (x,y,z)
attribute vec3 in_Normal;                    // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vPosition;
varying vec3 v_vNormal;

void main()
{
    vec4 ndc = vec4(in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * ndc;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
	
	v_vPosition = (gm_Matrices[MATRIX_WORLD] * ndc).xyz;
	v_vNormal = (
		gm_Matrices[MATRIX_WORLD] *
		vec4(in_Normal.x, in_Normal.y, in_Normal.z, 0.0)
	).xyz;
}
