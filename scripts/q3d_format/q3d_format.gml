/// q3D format

function q3D_format_init() {
	vertex_format_begin()
	vertex_format_add_position_3d()
	vertex_format_add_normal()
	vertex_format_add_color()
	vertex_format_add_texcoord()
	global.vb_format = vertex_format_end()
}

function vb_create() {
	return vertex_create_buffer()
}

function vb_begin(vb) {
	vertex_begin(vb, global.vb_format)
}

function vb_end(vb) {
	vertex_end(vb)
}

function vb_add_vertex(vb, x, y, z, nx, ny, nz, u, v, color, alpha) {
	vertex_position_3d(vb, x, y, z)
	vertex_normal(vb, nx, ny, nz)
	vertex_color(vb, color, alpha)
	vertex_texcoord(vb, u, v)
}

function vb_floor(x, y, w, h, z, hr, vr, freeze = true) {
	var _floor = vb_create();
	vb_begin(_floor)
	
	vb_add_vertex(_floor, x, y, z, 0, 0, 1, 0, 0, c_white, 1)
	vb_add_vertex(_floor, x + w, y, z, 0, 0, 1, hr, 0, c_white, 1)
	vb_add_vertex(_floor, x + w, y + h, z, 0, 0, 1, hr, vr, c_white, 1)
	
	vb_add_vertex(_floor, x, y, z, 0, 0, 1, 0, 0, c_white, 1)
	vb_add_vertex(_floor, x, y + h, z, 0, 0, 1, 0, vr, c_white, 1)
	vb_add_vertex(_floor, x + w, y + h, z, 0, 0, 1, hr, vr, c_white, 1)
	
	vb_end(_floor)
	
	if freeze vertex_freeze(_floor)
	
	return _floor
}

function vb_draw(
	vb, tex,
	x = 0, y = 0, z = 0,
	xa = 0, ya = 0, za = 0,
	xs = 1, ys = 1, zs = 1
) {
	var _world = matrix_get(matrix_world);
	
	matrix_set(
		matrix_world,
		matrix_build(
			x, y, z,
			xa, ya, za,
			xs, ys, zs
		)
	)
	
	vertex_submit(
		vb, pr_trianglelist, tex
	)
	
	matrix_set(
		matrix_world,
		_world
	)
}