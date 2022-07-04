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
q3D_set_quanted(true, 0.8)
q3D_light_set_lmap(false)

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

q3D_light_set_lmap(true)
// All draw
 /*
if is_pbr q3D_light_set_mat(test_material)
vb_draw(
	mdl_test,
	qstex(tex_box_diffuse),
	256, 256, 8,
	// self.x + self.q_xto_s * 10,
	// self.y + self.q_yto_s * 10,
	// self.z + self.q_zto_s * 10,
	current_time * 0.05,
	current_time * 0.05,
	current_time * 0.05
)
q3D_light_material_default()
// */

q3D_light_normal(false)
vb_fdraw(
	my_floor,
	qstex(tex_floor_test)
)
vb_draw(
	my_floor,
	qstex(tex_floor_test),
	0, 0, 16
)
q3D_light_normal(true)

q3D_light_set_mat(box_material)
vb_draw(
	mdl_block,
	qstex(tex_box_diffuse)
)
q3D_light_material_default()

// Opacity
q3D_set_water(true)
q3D_light_normal(false)
vb_draw(
	mdl_water,
	qstex(tex_water_test)
)
q3D_light_normal(true)
q3D_set_water(false)

gpu_set_texrepeat(false)
q3D_cam_reset()