right_key = keyboard_check(ord("D"));
left_key = keyboard_check(ord("A"));
up_key = keyboard_check(ord("W"));
down_key = keyboard_check(ord("S"));

var current_spd = move_spd
if (xspd != 0 && yspd != 0) {
    current_spd = dia_spd; // điều chỉnh đi chéo
}
if (keyboard_check(vk_shift))
{
    current_spd = run_spd;
}

xspd = (right_key - left_key) * current_spd;
yspd = (down_key - up_key) * current_spd;

//sprites
mask_index = sprite[DOWN];
if yspd == 0
	{
		if xspd > 0 {face = RIGHT}
		if xspd < 0 {face = LEFT}
	}
if xspd > 0 && face == LEFT {face = RIGHT}
if xspd < 0 && face == RIGHT {face = LEFT}
if xspd == 0
	{
		if yspd > 0 {face = DOWN}
		if yspd < 0 {face = UP}
	}
if yspd < 0 && face == UP {face = DOWN}
if yspd < 0 && face == DOWN	 {face = UP}

sprite_index = sprite[face];

// va chạm tường
if(place_meeting(x + xspd, y, obj_wall)) {
	xspd = 0;
}
if(place_meeting(x, y + yspd, obj_wall)) {
	yspd = 0;
}

// di chuyển
x += xspd;
y += yspd;


//animate
if xspd == 0 && yspd == 0
	{
		image_index = 0;
	}
