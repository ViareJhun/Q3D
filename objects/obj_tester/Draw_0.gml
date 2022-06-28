/// @description draw all

q3D_cam_set(window_get_width() / window_get_height())
gpu_set_texrepeat(true)
vb_draw(my_floor, sprite_get_texture(spr_floor_test, 0))
gpu_set_texrepeat(false)
q3D_cam_reset()