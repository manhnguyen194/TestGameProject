// Bobbing animation
bob_offset += bob_speed;
y = start_y + sin(bob_offset) * 3;

if (can_pickup) {
    var dist = distance_to_object(obj_player);
    
    if (dist <= pickup_range && keyboard_check_pressed(ord("F"))) {
        pickup();
    }
}