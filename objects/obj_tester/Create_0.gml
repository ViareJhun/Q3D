/// @description init

q3D_init()

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

q3D_cam_init(16)
q3D_cam_smooth(0.3)
q3D_view_set(512, 288, 2)

mdl_block = vb_create()
vb_begin(mdl_block)
with obj_block_map {
	vb_add_block(
		obj_tester.mdl_block,
		x - sprite_xoffset,
		y - sprite_yoffset,
		0,
		16, 16, 16,
		-1, -1
	)
}
vb_end(mdl_block, true)

application_surface_draw_enable(false)