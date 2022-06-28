/// q3D format

#region base
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

function vb_end(vb, freeze = false) {
	vertex_end(vb)
	if freeze vertex_freeze(vb)
}
#endregion

#region vb functions
function vb_add_vertex(vb, x, y, z, nx, ny, nz, u, v, color, alpha) {
	vertex_position_3d(vb, x, y, z)
	vertex_normal(vb, nx, ny, nz)
	vertex_color(vb, color, alpha)
	vertex_texcoord(vb, u, v)
}

function vb_add_wall(vb, _x, _y, _z, x2, y2, z2, hr, vr) {
	var normal;
	var nx;
	var ny;
	var nz;
	
	normal = q_normal_n(
	    _x, _y, _z,
	    x2, y2, z2,
	    x2, y2, _z
	);
	nx = normal[0];
	ny = normal[1];
	nz = normal[2];
	vb_add_vertex( vb, _x, _y, _z, nx, ny, nz, 0, 0, c_white, 1 );
	vb_add_vertex( vb, x2, y2, z2, nx, ny, nz, hr, vr, c_white, 1 );
	vb_add_vertex( vb, x2, y2, _z, nx, ny, nz, hr, 0, c_white, 1 );
	
	normal = q_normal_n(
	    _x, _y, _z,
	    _x, _y, z2,
	    x2, y2, z2
	);
	nx = normal[0];
	ny = normal[1];
	nz = normal[2];
	vb_add_vertex( vb, _x, _y, _z, nx, ny, nz, 0, 0, c_white, 1 );
	vb_add_vertex( vb, _x, _y, z2, nx, ny, nz, 0, vr, c_white, 1 );
	vb_add_vertex( vb, x2, y2, z2, nx, ny, nz, hr, vr, c_white, 1 );
}

function vb_add_floor(vb, _x, _y, w, d, z, nx, ny, nz, hr, vr) {
	vb_add_vertex(vb, _x, _y, z, nx, ny, nz, 0, 0, c_white, 1)
	vb_add_vertex(vb, _x + w, _y, z, nx, ny, nz, hr, 0, c_white, 1)
	vb_add_vertex(vb, _x + w, _y + d, z, nx, ny, nz, hr, vr, c_white, 1)

	vb_add_vertex(vb, _x, _y, z, nx, ny, nz, 0, 0, c_white, 1)
	vb_add_vertex(vb, _x, _y + d, z, nx, ny, nz, 0, vr, c_white, 1)
	vb_add_vertex(vb, _x + w, _y + d, z, nx, ny, nz, hr, vr, c_white, 1)
}

function vb_add_block(vb, _x, _y, _z, w, d, h, hr, vr) {
	// bottom
	vb_add_vertex( vb, _x, _y, _z, 0, 0, -1, 0, 0, c_white, 1 );
	vb_add_vertex( vb, _x + w, _y + d, _z, 0, 0, -1, hr, vr, c_white, 1 );
	vb_add_vertex( vb, _x, _y + d, _z, 0, 0, -1, 0, vr, c_white, 1 );

	vb_add_vertex( vb, _x, _y, _z, 0, 0, -1, 0, 0, c_white, 1 );
	vb_add_vertex( vb, _x + w, _y, _z, 0, 0, -1, hr, 0, c_white, 1 );
	vb_add_vertex( vb, _x + w, _y + d, _z, 0, 0, -1, hr, vr, c_white, 1 );

	// top
	vb_add_vertex( vb, _x, _y, _z + h, 0, 0, 1, 0, 0, c_white, 1 );
	vb_add_vertex( vb, _x + w, _y + d, _z + h, 0, 0, 1, hr, vr, c_white, 1 );
	vb_add_vertex( vb, _x, _y + d, _z + h, 0, 0, 1, 0, vr, c_white, 1 );

	vb_add_vertex( vb, _x, _y, _z + h, 0, 0, 1, 0, 0, c_white, 1 );
	vb_add_vertex( vb, _x + w, _y, _z + h, 0, 0, 1, hr, 0, c_white, 1 );
	vb_add_vertex( vb, _x + w, _y + d, _z + h, 0, 0, 1, hr, vr, c_white, 1 );

	// walls
	vb_add_wall( vb, _x, _y, _z, _x, _y + d, _z + h, hr, vr )
	vb_add_wall( vb, _x, _y + d, _z, _x + w, _y + d, _z + h, hr, vr )
	vb_add_wall( vb, _x + w, _y + d, _z, _x + w, _y, _z + h, hr, vr )
	vb_add_wall( vb, _x + w, _y, _z, _x, _y, _z + h, hr, vr )
}

function vb_floor(x, y, w, d, z, hr, vr, freeze = true) {
	var _floor = vb_create();
	vb_begin(_floor)
	
	vb_add_vertex(_floor, x, y, z, 0, 0, 1, 0, 0, c_white, 1)
	vb_add_vertex(_floor, x + w, y, z, 0, 0, 1, hr, 0, c_white, 1)
	vb_add_vertex(_floor, x + w, y + d, z, 0, 0, 1, hr, vr, c_white, 1)
	
	vb_add_vertex(_floor, x, y, z, 0, 0, 1, 0, 0, c_white, 1)
	vb_add_vertex(_floor, x, y + d, z, 0, 0, 1, 0, vr, c_white, 1)
	vb_add_vertex(_floor, x + w, y + d, z, 0, 0, 1, hr, vr, c_white, 1)
	
	vb_end(_floor)
	
	if freeze vertex_freeze(_floor)
	
	return _floor
}
#endregion

#region draw functions
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

function vb_fdraw(
	vb, tex
) {
	vertex_submit(
		vb, pr_trianglelist, tex
	)
}
#endregion