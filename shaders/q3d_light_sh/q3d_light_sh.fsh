varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vPosition;
varying vec3 v_vNormal;

uniform float light_data[96];
uniform float flash_light[11];
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
		if (is_norm) {
			// Prepare
			vec3 global_color = unpack(global_light[4]);
			
			vec3 global_dir = -vec3(
				global_light[1],
				global_light[2],
				global_light[3]
			);
			global_dir = normalize(global_dir);
			
			// Ambient
			light += global_color * m_ambient * global_light[0];
			
			// Diffuse
			light += (
				max(dot(norm, global_dir), 0.0) *
				global_color * m_diffuse
			) * global_light[0];
			
			// Specular
			vec3 view_dir = normalize(view_pos - v_vPosition);
			vec3 reflect_dir = reflect(-global_dir, norm);  
			light += (
				pow(max(dot(view_dir, reflect_dir), 0.0), m_shininess) *
				global_color * m_specular
			) * global_light[0];
		}
		
		// Point
		for (int i = 0; i < 16; i ++) {
			// Prepare
			int idx = i * 6;
			vec3 light_pos = vec3(
				light_data[idx + 0],
				light_data[idx + 1],
				light_data[idx + 2]
			);
			vec3 light_color = unpack(light_data[idx + 3]);
			float line = light_data[idx + 4];
			float quad = light_data[idx + 5];
			vec3 light_dir = normalize(light_pos - v_vPosition);
			
			// Distance factor
			float d = length(light_pos - v_vPosition);
			float factor = 1.0 / (
				1.0 + line * d + 
    		    quad * (d * d)
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
		
		// Flashlight
		// Prepare
		float flash_factor = flash_light[0];
		vec3 flash_pos = vec3(flash_light[1], flash_light[2], flash_light[3]);
		vec3 flash_dir = vec3(flash_light[4], flash_light[5], flash_light[6]);
		vec3 flash_color = unpack(flash_light[7]);
		float flash_angle = flash_light[8];
		float flash_angle_out = flash_light[9];
		float flash_dist = flash_light[10];
		
		vec3 light_dir = normalize(flash_pos - v_vPosition);
		float theta = dot(light_dir, normalize(-flash_dir));
		float dist = length(flash_pos - v_vPosition);
		
		if (theta > flash_angle_out) {
			float eps = flash_angle - flash_angle_out;
			float intensity = clamp(
				(theta - flash_angle_out) / eps, 0.0, 1.0
			);
			
			float factor = (
				1.0 - clamp(distance(v_vPosition, flash_pos) / flash_dist, 0.0, 1.0)
			);
			
			// Ambient
			light += flash_color * m_ambient * factor * intensity * flash_factor;
			
			// Diffuse
			light += flash_color * (
				max(dot(norm, light_dir), 0.0) *
				flash_color * m_diffuse
			) * factor * intensity * flash_factor;
			
			// Specular
			vec3 view_dir = normalize(view_pos - v_vPosition);
			vec3 reflect_dir = reflect(-light_dir, norm);  
			light += (
				pow(max(dot(view_dir, reflect_dir), 0.0), m_shininess) *
				flash_color * m_specular
			) * factor * intensity * flash_factor;
		}
		
		// Finish
		base.rgb *= light;
	}
	
    gl_FragColor = v_vColour * base;
}
