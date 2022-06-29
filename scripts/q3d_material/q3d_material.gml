/// q3D material

function q3D_mat_make(ambient, diffuse, shininess, specular = qstex(tex_q3D_spec)) {
	return [
		ambient, diffuse, shininess, specular
	]
}

function q3D_mat_default() {
	return q3D_mat_make(
		global.light_ambient_default,
		1.0,
		16.0,
		qstex(tex_q3D_spec)
	)
}