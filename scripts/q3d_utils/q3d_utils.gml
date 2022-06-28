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
	return floor(color_get_red(color) / 256 * 100) +
		floor(color_get_green(color) / 256 * 100) * 100 +
		floor(color_get_blue(color) / 256 * 100) * 10000
}

function qstex(sprite, index = 0) {
	return sprite_get_texture(sprite, index)
}