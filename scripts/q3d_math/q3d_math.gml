/// q3D math

function q_normal(ax, ay, az, bx, by, bz, cx, cy, cz) {
	var vx1 = ax - bx;
	var vy1 = ay - by;
	var vz1 = az - bz;
	var vx2 = bx - cx;
	var vy2 = by - cy;
	var vz2 = bz - cz;
	
	return [
		vy1 * vz2 - vz1 * vy2,
		vz1 * vx2 - vx1 * vz2,
		vx1 * vy2 - vy1 * vx2
	]
}

function q_normal_n(ax, ay, az, bx, by, bz, cx, cy, cz) {
	var vx1 = ax - bx;
	var vy1 = ay - by;
	var vz1 = az - bz;
	var vx2 = bx - cx;
	var vy2 = by - cy;
	var vz2 = bz - cz;
	
	var nx = vy1 * vz2 - vz1 * vy2;
	var ny = vz1 * vx2 - vx1 * vz2;
	var nz = vx1 * vy2 - vy1 * vx2;
	
	var l = sqrt(
		sqr(nx) + sqr(ny) + sqr(nz)
	);
	
	return [
		nx / l, ny / l, nz / l
	]
}