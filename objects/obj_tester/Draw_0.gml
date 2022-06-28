/// @description draw all

q3D_light_ambient(0.4)
q3D_light_global(true, 1, 0, 0, c_white)
// q3D_light_point(0, x, y, z, c_white)

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