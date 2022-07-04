/// @description init

randomize()

window_set_fullscreen(true)

q3D_init()

// Generation
palms = []
palms_count = 0
var w = 1024 / 16;
var h = 1024 / 16;
for (var i = 0; i < w; i ++) {
	for (var j = 0; j < h; j ++) {
		if irandom(99) < 5 {
			with instance_create_depth(
				i * 16 + 8,
				j * 16 + 8,
				0,
				obj_block_map
			) {
				// if irandom(99) < 15 z = 16
			}
		}
	}
}

repeat 16 {
	instance_create_depth(
		irandom(room_width),
		irandom(room_height),
		depth,
		obj_light_test
	)
}
q3D_lmap_process(obj_light_test)

light_colors = [c_red, c_red, c_orange, c_red]
// [c_lime, c_white, c_aqua, c_fuchsia]

/*
for (var i = 0; i < 16; i ++) {
	q3D_light_point(
		i,
		irandom_range(64, room_width - 64),
		irandom_range(64, room_height - 64),
		8, light_colors[i mod 4] //make_color_hsv(i / 16 * 255, 255, 255)
	)
}
*/

// pass = cam_shader.pass
pass = cam_shader.light

my_floor = vb_floor(
	0, 0, room_width, room_height, 0,
	room_width / 32, room_height / 32
)

fx = 1
fy = 0
fz = 0
fp = 0
fe = 0

gp = 0
ge = 0

debug = 0

dith = false

game_set_speed(60, gamespeed_fps)
q3D_cam_init()
q3D_cam_smooth(0.5)
q3D_phys_init(0.9, 0.9, 14)
// q3D_view_set(512, 288, 2, false)
q3D_view_set(256, 144, 2, false)

z_pitch = 0
z_gravity = 0.15
z_jump = 2.4

water = 0

block_compiled = false
box_material = q3D_mat_make(
	0.2, 1.0, 16.0,
	qstex(tex_box_spec),
	qstex(tex_box_roug),
	1
)

skybox = vb_create()
vb_begin(skybox)
vb_add_sphere(
	skybox,
	32, 4000
)
vb_end(skybox)
vertex_freeze(skybox)

mdl_water = vb_create()
vb_begin(mdl_water)
var s = 32;
w = 1024 / s;
h = 1024 / s;
for (var i = 0; i < w; i ++) {
	for (var j = 0; j < h; j ++) {
		vb_add_floor(
			mdl_water,
			i * s,
			j * s,
			s, s,
			2,
			0, 0, 1,
			1, 1
		)
	}
}
vb_end(mdl_water)
vertex_freeze(mdl_water)

test_material = q3D_mat_make(
	0.2, 1.0, 12.0,
	qstex(tex_box_spec),
	qstex(tex_box_roug),
	// qstex(tex_q3D_spec),
	// qstex(tex_block_roug),
	3
)
mdl_test = vb_create()
is_pbr = false
vb_begin(mdl_test)
 /*
vb_add_block(
	mdl_test,
	-1, -1, -1,
	2, 2, 2,
	1, -1
)
// */
// /*
vb_add_sphere(
	mdl_test, 32, 2
)
// */
vb_end(mdl_test)

application_surface_draw_enable(false)
// window_set_fullscreen(true)