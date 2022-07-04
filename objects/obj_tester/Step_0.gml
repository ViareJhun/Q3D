/// @description update

// Motion
if debug {
	q3D_cam_fly(4)
	self.q_z = self.z - 8
} else {
	var _moving = false;

	if keyboard_check(ord("W")) {
		q3D_phys_impulse(0.5, self.q_azimut_s)
		_moving = true
	}
	if keyboard_check(ord("S")) {
		q3D_phys_impulse(0.5, self.q_azimut_s + 180)
		_moving = true
	}
	if keyboard_check(ord("A")) {
		q3D_phys_impulse(0.5, self.q_azimut_s - 90)
		_moving = true
	}
	if keyboard_check(ord("D")) {
		q3D_phys_impulse(0.5, self.q_azimut_s + 90)
		_moving = true
	}

	if (_moving) {
		z_pitch = lerp(
			z_pitch,
			dcos(current_time * 1.0) * 1.5,
			0.1
		)
	} else {
		z_pitch = lerp(
			z_pitch,
			0,
			0.1
		)
	}

	var on_ground = q3D_phys_collision(0, 0, -1, obj_block_map);
	if (self.q_z <= 0) {
		self.q_z = 0
		self.q_speed[2] = 0
	
		on_ground = true
	} else {
		if !on_ground self.q_speed[2] -= z_gravity
	}

	if (on_ground) {
		self.q_speed[2] = 0
	
		if keyboard_check(vk_space) {
			self.q_speed[2] = z_jump
		}
	} else {
		z_pitch = 0
	}

	q3D_phys_endstep(obj_block_map)
	q3D_cam_phys_set(10)
}

q3D_cam_view(true)

if !block_compiled {
	mdl_block = vb_create()
	vb_begin(mdl_block)
	with obj_block_map {
		vb_add_block(
			obj_tester.mdl_block,
			x - sprite_xoffset,
			y - sprite_yoffset,
			z,
			16, 16, h,
			-1, -1
		)
	}
	vb_end(mdl_block, true)
	
	block_compiled = true
}

fx = lerp(fx, q_xto, 0.1)
fy = lerp(fy, q_yto, 0.1)
fz = lerp(fz, q_zto, 0.1)
if mouse_check_button_pressed(mb_left) fe = !fe
fp = lerp(fp, fe, 0.1)

if mouse_check_button_pressed(mb_right) ge = !ge
gp = lerp(gp, ge * 0.4, 0.1)

if keyboard_check_pressed(vk_f1) debug = !debug
if keyboard_check_pressed(ord("C")) dith = !dith
if keyboard_check_pressed(ord("V")) is_pbr = !is_pbr
if keyboard_check_pressed(vk_escape) game_end()