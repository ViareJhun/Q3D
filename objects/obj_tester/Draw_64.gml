/// @description debug

show_debug_overlay(debug)

if debug {
	draw_text(
		32, 32,
		"z = " + string(self.q_z) +
		"\nz_speed = " + string(self.q_speed[2])
	)
}
