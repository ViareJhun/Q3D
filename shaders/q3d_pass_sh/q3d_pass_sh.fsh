varying vec2 uv;
varying vec4 color;

void main()
{
    gl_FragColor = color * texture2D( gm_BaseTexture, uv );
	if (gl_FragColor.a == 0.0) {
		discard;
	}
}
