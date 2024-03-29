/// q3D camera

enum cam_shader {
	pass,
	light
}

#region base
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
	self.q_azimut_s = 0
	self.q_zenit_s = 90
	
	self.q_xto = 1
	self.q_yto = 0
	self.q_zto = 0
	
	self.q_xto_s = 1
	self.q_yto_s = 0
	self.q_zto_s = 0
	
	self.q_smooth = 1.0
	
	self.q_xup = xup
	self.q_yup = yup
	self.q_zup = zup
	
	self.q_mouse_view = false
	
	self.q_temp_proj = undefined
	self.q_temp_view = undefined
	
	self.q_pass = cam_shader.pass
}
#endregion

#region update camera
function q3D_cam_fly(_speed) {
	if keyboard_check(ord("W")) {
		self.x += self.q_xto_s * _speed
		self.y += self.q_yto_s * _speed
		self.z += self.q_zto_s * _speed
	}
	
	if keyboard_check(ord("S")) {
		self.x -= self.q_xto_s * _speed
		self.y -= self.q_yto_s * _speed
		self.z -= self.q_zto_s * _speed
	}
	
	if keyboard_check(ord("A")) {
		var a = self.q_azimut_s + 90;
		
		self.x += dcos(a) * _speed
		self.y -= dsin(a) * _speed
	}
	
	if keyboard_check(ord("D")) {
		var a = self.q_azimut_s - 90;
		
		self.x += dcos(a) * _speed
		self.y -= dsin(a) * _speed
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
		
		self.q_azimut_s = lerp(self.q_azimut_s, self.q_azimut, self.q_smooth)
		self.q_zenit_s = lerp(self.q_zenit_s, self.q_zenit, self.q_smooth)
		
		self.q_xto_s = dcos(self.q_azimut_s) * -dsin(self.q_zenit_s)
		self.q_yto_s = -dsin(self.q_azimut_s) * -dsin(self.q_zenit_s)
		self.q_zto_s = dcos(self.q_zenit_s)
	}
}

function q3D_cam_smooth(smooth) {
	self.q_smooth = smooth
}
#endregion

#region camera set
function q3D_cam_set(aspect, add_z = 0, pass = cam_shader.pass) {
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
			self.z + add_z,
			self.x + self.q_xto_s,
			self.y + self.q_yto_s,
			self.z + self.q_zto_s + add_z,
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
			global.pass_shader = q3D_pass_sh
		break
		
		case cam_shader.light:
			q3D_light_set(
				self.x, self.y, self.z
			)
			global.pass_shader = q3D_light_sh
		break
	}
	q3D_set_quanted(false)
	q3D_set_water(false)
	qsh_f(global.pass_shader, "time", current_time * 0.001)
	
	self.q_pass = pass
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
	
	switch self.q_pass {
		case cam_shader.pass:
			shader_reset()
		break
		
		case cam_shader.light:
			q3D_light_reset()
		break
	}
}
#endregion

#region other
function q3D_view_set(w, h, scale = 1, app_port = true) {
	view_enabled = true
	view_visible[0] = true
	var cam = camera_get_active();
	
	camera_set_view_size(cam, w, h)
	
	view_wport[0] = w * scale
	view_hport[0] = h * scale
	
	if app_port {
		surface_resize(
			application_surface,
			view_wport[0],
			view_hport[0]
		)
	} else {
		surface_resize(
			application_surface,
			w,
			h
		)
	}
	
	if !window_get_fullscreen() {
		window_set_size(
			view_wport[0],
			view_hport[0]
		)
	}
}

function q3D_set_quanted(enable, quant = 1.0) {
	qsh_f(global.pass_shader, "is_quanted", enable)
	qsh_f(global.pass_shader, "vertex_quant", quant)
}

function q3D_set_water(enable) {
	qsh_f(global.pass_shader, "is_water", enable)
}
#endregion