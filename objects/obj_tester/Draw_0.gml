/// @description draw all

q3D_light_ambient(0.1)
// q3D_light_global(0.2, -0.5, -0.2, -0.5, c_white)
// q3D_light_point(0, x, y, z, c_white)
q3D_light_flash(
	0.5,
	x, y, z,
	q_xto, q_yto, q_zto,
	c_white, 128
)

q3D_cam_set(window_get_width() / window_get_height(), pass)
gpu_set_texrepeat(true)

vb_fdraw(
	my_floor,
	qstex(tex_floor_test)
)
vb_fdraw(
	mdl_block,
	qstex(tex_block_test)
)

gpu_set_texrepeat(false)
q3D_cam_reset()