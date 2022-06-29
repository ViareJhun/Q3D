function q3D_init() {
	q3D_format_init()
	q3D_light_init()
	
	global.pass_shader = q3D_pass_sh
	
	global.vb_base_billboard = vb_billboard(0, 0, 1, 1, 0, 1, -1, true, 0.5, 0)
}