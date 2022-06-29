/// q3D light

#region base
function q3D_light_init() {
	global.light_count = 16
	global.light_data = array_create(6 * global.light_count)
	global.light_ambient_default = 0
	global.light_forward = q3D_light_sh
	global.light_global = array_create(5)
	global.light_flash = array_create(11)
}
#endregion

#region light sources
function q3D_light_point(index, x, y, z, color, lin = 0.014, quad = 0.0007) {
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

function q3D_light_flash(enable, x, y, z, xto, yto, zto, color = c_white, dist = 128, angle = dcos(22), angle_out = dcos(33)) {
	global.light_flash[0] = enable
	global.light_flash[1] = x
	global.light_flash[2] = y
	global.light_flash[3] = z
	global.light_flash[4] = xto
	global.light_flash[5] = yto
	global.light_flash[6] = zto
	global.light_flash[7] = qcol2f(color)
	global.light_flash[8] = angle
	global.light_flash[9] = angle_out
	global.light_flash[10] = dist
}
#endregion

#region light options
function q3D_light_ambient_get() {
	return global.light_ambient_default
}

function q3D_light_ambient(ambient) {
	global.light_ambient_default = ambient
}

function q3D_light_shading(shading) {
	qsh_f(global.light_forward, "is_shading", shading)
}

function q3D_light_normal(normal) {
	qsh_f(global.light_forward, "is_normal", normal)
}

function q3D_light_material(ambient, diffuse, shininess, specular) {
	qsh_f(global.light_forward, "m_ambient", ambient)
	qsh_f(global.light_forward, "m_diffuse", diffuse)
	qsh_f(global.light_forward, "m_shininess", shininess)
	qsh_s(global.light_forward, "m_specular", specular)
}

function q3D_light_material_default() {
	qsh_f(global.light_forward, "m_ambient", global.light_ambient_default)
	qsh_f(global.light_forward, "m_diffuse", 1.0)
	qsh_f(global.light_forward, "m_shininess", 16.0)
	qsh_s(global.light_forward, "m_specular", tex_q3D_spec)
}

function q3D_light_set_mat(material) {
	q3D_light_material(
		material[0], material[1], material[2], material[3]
	)
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