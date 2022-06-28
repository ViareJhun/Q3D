/// q3D light

#region base
function q3D_light_init() {
	global.light_count = 16
	global.light_data = array_create(6 * global.light_count)
	global.light_ambient_default = 0
	global.light_forward = q3D_light_sh
	global.light_global = array_create(5)
	global.light_flash = array_create(7)
}
#endregion

#region light sources
function q3D_light_point(index, x, y, z, color, lin = 0.045, quad = 0.0075) {
	var idx = index * 6;
	
	global.light_data[idx + 0] = x
	global.light_data[idx + 1] = y
	global.light_data[idx + 2] = z
	global.light_data[idx + 3] = qcol2f(color)
	global.light_data[idx + 4] = lin
	global.light_data[idx + 5] = quad
}

function q3D_light_global(enable, x, y, z, color) {
	global.light_global[0] = enable
	global.light_global[1] = x
	global.light_global[2] = y
	global.light_global[3] = z
	global.light_global[4] = qcol2f(color)
}
#endregion

#region light options
function q3D_light_ambient(ambient) {
	global.light_ambient_default = ambient
}

function q3D_light_shading(shading) {
	qsh_f(global.light_forward, "is_shading", shading)
}

function q3D_light_normal(normal) {
	qsh_f(global.light_forward, "is_normal", normal)
}

function q3D_light_material(ambient, diffuse, specular, shininess) {
	qsh_f(global.light_forward, "m_ambient", ambient)
	qsh_f(global.light_forward, "m_diffuse", diffuse)
	qsh_f(global.light_forward, "m_specular", specular)
	qsh_f(global.light_forward, "m_shininess", shininess)
}

function q3D_light_material_default() {
	qsh_f(global.light_forward, "m_ambient", global.light_ambient_default)
	qsh_f(global.light_forward, "m_diffuse", 1.0)
	qsh_f(global.light_forward, "m_specular", 0.0)
	qsh_f(global.light_forward, "m_shininess", 0.0)
}
#endregion

#region light set
function q3D_light_set(vx, vy, vz) {
	shader_set(global.light_forward)
	
	qsh_fa(global.light_forward, "light_data", global.light_data)
	qsh_fa(global.light_forward, "flash_light", global.light_flash)
	qsh_fa(global.light_forward, "global_light", global.light_global)
	qsh_fa(global.light_forward, "view_pos", [vx, vy, vz])
	
	q3D_light_material_default()
	
	q3D_light_shading(true)
	q3D_light_normal(true)
}

function q3D_light_reset() {
	shader_reset()
}
#endregion