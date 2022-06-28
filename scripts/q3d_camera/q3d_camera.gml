/// q3D camera

enum cam_shader {
	pass,
	light
}

function q3D_cam_init(
	z = 0,
	fov = 65,
	zmin = 1, zmax = 32000,
	sens = 0.1,
	xup = 0,
	yup = 0,
	zup = -1
) {
	self.z = z
	
	self.q_fov = fov
	
	self.q_zmin = zmin
	self.q_zmax = zmax
	
	self.q_sens = sens
	self.q_azimut = 0
	self.q_zenit = 90
	
	self.q_xto = 1
	self.q_yto = 0
	self.q_zto = 0
	
	self.q_xup = xup
	self.q_yup = yup
	self.q_zup = zup
	
	self.q_mouse_view = false
	
	self.q_temp_proj = undefined
	self.q_temp_view = undefined
}

function q3D_cam_fly(_speed) {
	if keyboard_check(ord("W")) {
		self.x += self.q_xto * _speed
		self.y += self.q_yto * _speed
		self.z += self.q_zto * _speed
	}
	
	if keyboard_check(ord("S")) {
		self.x -= self.q_xto * _speed
		self.y -= self.q_yto * _speed
		self.z -= self.q_zto * _speed
	}
}

function q3D_cam_view(debug) {
	if debug {
		if mouse_check_button_pressed(mb_middle) {
			self.q_mouse_view = !self.q_mouse_view
		}
	}
	
	if self.q_mouse_view {
		var az = window_mouse_get_x() - window_get_width() / 2;
		var ze = window_mouse_get_y() - window_get_height() / 2;
		
		window_mouse_set(
			window_get_width() / 2,
			window_get_height() / 2
		)
		
		self.q_azimut += az * self.q_sens
		self.q_zenit += ze * self.q_sens
		
		self.q_zenit = clamp(self.q_zenit, 1, 179)
		
		self.q_xto = dcos(self.q_azimut) * -dsin(self.q_zenit)
		self.q_yto = -dsin(self.q_azimut) * -dsin(self.q_zenit)
		self.q_zto = dcos(self.q_zenit)
	}
}

function q3D_cam_set(aspect, pass = cam_shader.pass) {
	var cam = camera_get_active();
	
	self.q_temp_proj = camera_get_proj_mat(cam)
	self.q_temp_view = camera_get_view_mat(cam)
	
	camera_set_proj_mat(
		cam,
		matrix_build_projection_perspective_fov(
			self.q_fov,
			aspect,
			self.q_zmin,
			self.q_zmax
		)
	)
	camera_set_view_mat(
		cam,
		matrix_build_lookat(
			self.x,
			self.y,
			self.z,
			self.x + self.q_xto,
			self.y + self.q_yto,
			self.z + self.q_zto,
			self.q_xup,
			self.q_yup,
			self.q_zup
		)
	)
	
	gpu_set_ztestenable(true)
	gpu_set_zwriteenable(true)
	gpu_set_alphatestenable(true)
	
	camera_apply(cam)
	
	switch pass {
		case cam_shader.pass:
			shader_set(q3D_pass_sh)
		break
		
		case cam_shader.light:
			q3D_light_set()
		break
	}
}

function q3D_cam_reset() {
	var cam = camera_get_active();
	
	camera_set_proj_mat(
		cam,
		self.q_temp_proj
	)
	camera_set_view_mat(
		cam,
		self.q_temp_view
	)
	
	camera_apply(cam)
	
	shader_reset()
}


function q3D_view_set(w, h, scale = 1) {
	view_enabled = true
	view_visible[0] = true
	var cam = camera_get_active();
	
	camera_set_view_size(cam, w, h)
	
	view_wport[0] = w * scale
	view_hport[0] = h * scale
	
	surface_resize(
		application_surface,
		view_wport[0],
		view_hport[0]
	)
	
	if !window_get_fullscreen() {
		window_set_size(
			view_wport[0],
			view_hport[0]
		)
	}
}