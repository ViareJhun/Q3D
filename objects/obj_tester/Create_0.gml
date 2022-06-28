/// @description init

q3D_init()

my_floor = vb_floor(
	0, 0, room_width, room_height, 0,
	room_width / 32, room_height / 32
)

q3D_cam_init(16)
q3D_view_set(512, 288, 2)