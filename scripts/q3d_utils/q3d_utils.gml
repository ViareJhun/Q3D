/// q3D utils

function qsh_f(shader, name, value) {
	shader_set_uniform_f(
		shader_get_uniform(
			shader,
			name
		),
		value
	)
}

function qsh_fa(shader, name, array) {
	shader_set_uniform_f_array(
		shader_get_uniform(
			shader,
			name
		),
		array
	)
}

function qcol2f(color) {
	return (
		(floor(colour_get_red(color) / 256) * 100) +
		(floor(colour_get_green(color) / 256) * 100) * 100 +
		(floor(colour_get_blue(color) / 256) * 100) * 10000
	)
}