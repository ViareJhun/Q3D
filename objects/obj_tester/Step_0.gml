/// @description update

q3D_cam_fly(2)
q3D_cam_view(true)

fx = lerp(fx, q_xto, 0.1)
fy = lerp(fy, q_yto, 0.1)
fz = lerp(fz, q_zto, 0.1)
if mouse_check_button_pressed(mb_left) fe = !fe
fp = lerp(fp, fe, 0.1)

if mouse_check_button_pressed(mb_right) ge = !ge
gp = lerp(gp, ge * 0.5, 0.1)

if keyboard_check_pressed(vk_f1) debug = !debug
if keyboard_check_pressed(ord("C")) dith = !dith