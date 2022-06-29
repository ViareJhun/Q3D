/// @description post draw

var data = application_get_position();
var w = data[2] - data[0];
var h = data[3] - data[1];
var sh = sh_dith;

if dith {
	shader_set(sh)
	qsh_fa(sh, "texel", [1 / w, 1 / h])
}

draw_surface_stretched(
	application_surface,
	data[0], data[1], w, h
)

if dith {
	shader_reset()
}