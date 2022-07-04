/// q3D motions

function q3D_phys_init(speed_max, speed_factor, h, hitbox = sprite_index) {
	self.q_speed = [0, 0, 0]
	self.q_speed_max = speed_max
	self.q_speed_factor = speed_factor
	
	self.q_w = sprite_get_width(hitbox)
	self.q_d = sprite_get_height(hitbox)
	self.q_h = h
	
	self.q_z = 0
}

function q3D_cam_phys_set(z_eye) {
	self.z = self.q_z + z_eye
}

function q3D_zinit(z = 0, h = 16) {
	self.z = z
	self.h = h
}

function q3D_phys_impulse(speed, azimut, zenit = 90) {
	self.q_speed[0] += -dsin(zenit) * dcos(azimut) * speed
	self.q_speed[1] += -dsin(zenit) * -dsin(azimut) * speed
	self.q_speed[2] += dcos(zenit) * speed
}

function q3D_phys_endstep(obj, z_factor = false, z_norm = false) {
	// Friction
	self.q_speed[0] *= self.q_speed_factor
	self.q_speed[1] *= self.q_speed_factor
	if z_factor self.q_speed[2] *= self.q_speed_factor
	
	// Clamp
	var l = sqrt(
		sqr(self.q_speed[0]) +
		sqr(self.q_speed[1]) +
		sqr(self.q_speed[2])
	);
	l = max(l, 1)
	
	self.q_speed[0] /= l
	self.q_speed[1] /= l
	if z_norm self.q_speed[2] /= l
	
	l = min(l, self.q_speed_max)
	self.q_speed[0] *= l
	self.q_speed[1] *= l
	if z_norm self.q_speed[2] *= l
	
	// Collisions
	if q3D_phys_collision(self.q_speed[0], 0, 0, obj) self.q_speed[0] = 0
	self.x += self.q_speed[0]
	
	if q3D_phys_collision(0, self.q_speed[1], 0, obj) self.q_speed[1] = 0
	self.y += self.q_speed[1]
	
	if q3D_phys_collision(0, 0, self.q_speed[2], obj) self.q_speed[2] = 0
	self.q_z += self.q_speed[2]
}

function q3D_phys_collision(x, y, z, obj, prec = false) {
	var list = ds_list_create();
	
	var count = collision_rectangle_list(
		self.x + x - self.q_w / 2,
		self.y + y - self.q_d / 2,
		self.x + x + self.q_w / 2 - 0.001,
		self.y + y + self.q_d / 2 - 0.001,
		obj, prec, true, list, false
	);
	
	var _collision = false;
	var _z = self.q_z + z;
	for (var i = 0; i < count; i ++) {
		var _id = list[| i];
        
        if _z + self.q_h < _id.z
        {
            continue
        }
        
        if _z > _id.z + _id.h
        {
            continue
        }
        
        _collision = true
        break
	}
	
	ds_list_destroy(list)
	
	return _collision
}