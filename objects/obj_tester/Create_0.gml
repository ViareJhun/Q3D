/// @description init

q3D_init()

// Generation
palms = []
palms_count = 0
var w = 1024 / 16;
var h = 1024 / 16;
for (var i = 0; i < w; i ++) {
	for (var j = 0; j < h; j ++) {
		if irandom(99) < 15 {
			with instance_create_depth(
				i * 16 + 8,
				j * 16 + 8,
				0,
				obj_block_map
			) {
				if irandom(99) < 15 z = 16
			}
		} else {
			if irandom(99) < 5 {
				palms_count ++
				array_push(
					palms,
					[
						i * 16 + 8,
						j * 16 + 8
					]
				)
			}
		}
	}
}

light_colors = [c_lime, c_yellow, c_aqua, c_fuchsia]

for (var i = 0; i < 16; i ++) {
	q3D_light_point(
		i,
		irandom_range(64, room_width - 64),
		irandom_range(64, room_height - 64),
		8, light_colors[i mod 4] //make_color_hsv(i / 16 * 255, 255, 255)
	)
}

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
q3D_phys_init(3, 0.9, 14)
q3D_view_set(512, 288, 2)

z_pitch = 0
z_gravity = 0.15
z_jump = 2.4

water = 0

block_compiled = false
box_material = q3D_mat_make(0.2, 1.0, 16.0, qstex(tex_box_spec))

skybox = vb_create()
vb_begin(skybox)
vb_add_sphere(
	skybox,
	32, 4000
)
vb_end(skybox)
vertex_freeze(skybox)

application_surface_draw_enable(false)
// window_set_fullscreen(true)