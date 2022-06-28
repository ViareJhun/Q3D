varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vPosition;
varying vec3 v_vNormal;

uniform float light_data[96];
uniform float flash_light[7];
uniform float global_light[5];
uniform vec3 view_pos;

uniform float m_ambient;
uniform float m_diffuse;
uniform float m_specular;
uniform float m_shininess;

uniform float is_shading;
uniform float is_normal;

vec3 unpack(float value) {
	return vec3(
		floor(value / 10000.0) / 100.0,
	    mod(floor(value / 100.0), 100.0) / 100.0,
	    mod(value, 100.0) / 100.0
	);
}

void main()
{
	// Prepare
	vec2 uv = v_vTexcoord;
	vec4 base = texture2D(gm_BaseTexture, uv);
	
	// Shading
	if (is_shading == 1.0) {
		// Prepare
		bool is_norm = (is_normal == 1.0);
		vec3 norm = normalize(v_vNormal);
		vec3 light = vec3(0.0);
		
		// Global
		if (global_light[0] == 1.0 && is_norm) {
			// Prepare
			vec3 global_color = vec3(1.0); //unpack(global_light[4]);
			
			vec3 global_dir = -vec3(
				global_light[1],
				global_light[2],
				global_light[3]
			);
			
			// Ambient
			light += global_color * m_ambient;
			
			// Diffuse
			light += (
				max(dot(norm, normalize(global_dir)), 0.0) *
				global_color * m_diffuse
			);
			
			// Specular
			vec3 view_dir = normalize(view_pos - v_vPosition);
			vec3 reflect_dir = reflect(-global_dir, norm);  
			light += (
				pow(max(dot(view_dir, reflect_dir), 0.0), 1.0 * m_shininess) *
				global_color * m_specular
			);
		}
		
		// Point
		/*
		for (int i = 0; i < 16; i ++) {
			// Prepare
			int idx = i * 6;
			vec3 light_pos = vec3(
				light_data[idx + 0],
				light_data[idx + 1],
				light_data[idx + 2]
			);
			vec3 light_color = vec3(1.0); //unpack(light_data[idx + 3]);
			float linear = light_data[idx + 4];
			float quadratic = light_data[idx + 5];
			vec3 light_dir = normalize(light_pos - v_vPosition);
			
			// Distance factor
			float dist = length(light_pos - v_vPosition);
			float factor = 1.0 / (
				1.0 + linear * dist + 
    		    quadratic * dist * dist
			);
			
			if (is_norm) {
				// Ambient
				light += light_color * m_ambient * factor;
				
				// Diffuse
				light += (
					max(dot(norm, light_dir), 0.0) *
					light_color * m_diffuse
				) * factor;
				
				// Specular
				vec3 view_dir = normalize(view_pos - v_vPosition);
				vec3 reflect_dir = reflect(-light_dir, norm);  
				light += (
					pow(max(dot(view_dir, reflect_dir), 0.0), m_shininess) *
					light_color * m_specular
				) * factor;
			} else {
				// Simple shading
				light += light_color * factor;
			}
		}
		*/
		// Flashlight
		
		// Finish
		base.rgb *= light;
	}
	
    gl_FragColor = v_vColour * base;
}
