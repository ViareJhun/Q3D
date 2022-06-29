/// q3D SBO

function q3D_sbo_create() {
	return {
		count: 0,
		vb: noone,
		data: []
	}
}

function q3D_sbo_add(sbo, x, y, z, w, d, hr, vr) {
	sbo.count ++
	array_push(
		sbo.data,
		[x, y, z, w, d, hr, vr]
	)
}

function q3D_sbo_compile(sbo) {
	sbo.vb = vb_create()
	vb_begin(sbo.vb)
	for (var i = 0; i < sbo.count; i ++) {
		var bb = sbo.data[i];
		
		vb_add_wall(
			sbo.vb,
			bb[0], bb[1] - bb[3] / 2, bb[2],
			bb[0], bb[1] + bb[3] / 2, bb[2] + bb[4],
			bb[5], bb[6]
		)
	}
	vb_end(sbo.vb, false)
}

function q3D_sbo_update(sbo, angle = self.q_azimut_s) {
	/*
	var tb = buffer_create_from_vertex_buffer(sbo.vb, buffer_grow, 1);
	
	for (var i = 0; i < sbo.count; i ++) {
		var o = i * 216;
		var bb = sbo.data[i];
		var _x = bb[0];
		var _y = bb[1];
		var _z = bb[2];
		var w = bb[3];
		var h = bb[4];
		
		var cx;
		var cy;
		var cz;
		
		// 1 point
		cx = _x + dcos(angle + 90) * w / 2
		cy = _y - dsin(angle + 90) * w / 2
		cz = _z
		buffer_poke(tb, o + 36 * 0 + 0, buffer_f32, cx)
		buffer_poke(tb, o + 36 * 0 + 4, buffer_f32, cy)
		buffer_poke(tb, o + 36 * 0 + 8, buffer_f32, cz)
		
		// 2 point
		cx = _x + dcos(angle - 90) * w / 2
		cy = _y - dsin(angle - 90) * w / 2
		cz = _z + h
		buffer_poke(tb, o + 36 * 1 + 0, buffer_f32, cx)
		buffer_poke(tb, o + 36 * 1 + 4, buffer_f32, cy)
		buffer_poke(tb, o + 36 * 1 + 8, buffer_f32, cz)
		
		// 3 point
		cx = _x + dcos(angle - 90) * w / 2
		cy = _y - dsin(angle - 90) * w / 2
		cz = _z
		buffer_poke(tb, o + 36 * 2 + 0, buffer_f32, cx)
		buffer_poke(tb, o + 36 * 2 + 4, buffer_f32, cy)
		buffer_poke(tb, o + 36 * 2 + 8, buffer_f32, cz)
		
		// 4 point
		cx = _x + dcos(angle + 90) * w / 2
		cy = _y - dsin(angle + 90) * w / 2
		cz = _z
		buffer_poke(tb, o + 36 * 3 + 0, buffer_f32, cx)
		buffer_poke(tb, o + 36 * 3 + 4, buffer_f32, cy)
		buffer_poke(tb, o + 36 * 3 + 8, buffer_f32, cz)
		
		// 5 point
		cx = _x + dcos(angle + 90) * w / 2
		cy = _y - dsin(angle + 90) * w / 2
		cz = _z + h
		buffer_poke(tb, o + 36 * 4 + 0, buffer_f32, cx)
		buffer_poke(tb, o + 36 * 4 + 4, buffer_f32, cy)
		buffer_poke(tb, o + 36 * 4 + 8, buffer_f32, cz)
		
		// 6 point
		cx = _x + dcos(angle - 90) * w / 2
		cy = _y - dsin(angle - 90) * w / 2
		cz = _z + h
		buffer_poke(tb, o + 36 * 5 + 0, buffer_f32, cx)
		buffer_poke(tb, o + 36 * 5 + 4, buffer_f32, cy)
		buffer_poke(tb, o + 36 * 5 + 8, buffer_f32, cz)
	}
	
	vertex_delete_buffer(sbo.vb)
	sbo.vb = vertex_create_buffer_from_buffer(tb, global.vb_format)
	buffer_delete(tb)
	*/
	
	vertex_delete_buffer(sbo.vb)
	q3D_sbo_compile(sbo)
}

function q3D_sbo_draw(sbo, tex) {
	vb_draw(
		sbo.vb, tex
	)
}