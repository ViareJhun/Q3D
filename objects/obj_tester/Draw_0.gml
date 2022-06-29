/// @description draw all

q3D_light_ambient(0.5)
q3D_light_global(
	gp,
	dcos(current_time * 0.1),
	-dsin(current_time * 0.1),
	-0.5,
	c_white
)
for (var i = 0; i < 16; i ++) {
	q3D_light_point(
		i,
		64 + i div 4 * 96,
		64 + i mod 4 * 96,
		8, make_color_hsv(i / 16 * 255, 255, 255)
	)
}
q3D_light_flash(
	fp,
	x, y, z,
	fx, fy, fz,
	c_white, 256
)

q3D_cam_set(window_get_width() / window_get_height(), pass)
gpu_set_texrepeat(true)

vb_fdraw(
	my_floor,
	qstex(tex_floor_test)
)

// q3D_set_quanted(true)
vb_fdraw(
	mdl_block,
	qstex(tex_block_test)
)

q3D_light_normal(false)
bb_draw(
	tex_billboard_test, 0,
	256, 256, 0, 256, 256
)
q3D_light_normal(true)
// q3D_set_quanted(false)

gpu_set_texrepeat(false)
q3D_cam_reset()