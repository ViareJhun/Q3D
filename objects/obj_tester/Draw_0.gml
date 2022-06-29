/// @description draw all

water = (water + 0.005) mod 1
q3D_light_ambient(0.5)
q3D_light_global(
	gp,
	0.5,
	0.75,
	-0.5,
	c_white
)
q3D_light_flash(
	fp,
	x, y, z,
	fx, fy, fz,
	c_white, 128
)

q3D_cam_set(window_get_width() / window_get_height(), z_pitch, pass)
gpu_set_texrepeat(true)

// Skybox
q3D_light_normal(false)
vb_draw(
	skybox,
	qstex(tex_skybox_test),
	self.x,
	self.y,
	self.z
)
q3D_light_normal(true)

// All draw
vb_fdraw(
	my_floor,
	qstex(tex_floor_test)
)

q3D_light_normal(false)
for (var i = 0; i < palms_count; i ++) {
	bb_draw(
		tex_billboard_test, 0,
		palms[i][0], palms[i][1],
		0,
		64, 64
	)
}
q3D_light_normal(true)

q3D_light_set_mat(box_material)
vb_draw(
	mdl_block,
	qstex(tex_box_diffuse)
)
q3D_light_material_default()


// Opacity
draw_set_alpha(0)
vb_draw(
	my_floor,
	qstex(tex_water_test),
	-water * 32, -water * 32, 2
)
draw_set_alpha(1)

gpu_set_texrepeat(false)
q3D_cam_reset()