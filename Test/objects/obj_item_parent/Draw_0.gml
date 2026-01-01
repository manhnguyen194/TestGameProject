draw_self();

// Show pickup prompt when player is near
if (can_pickup && instance_exists(obj_player)) {
    var dist = distance_to_object(obj_player);
    
    if (dist <= pickup_range) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        draw_set_font(-1);
        
        // Draw background for text
        var text = "F - Pick up";
        var tx = x;
        var ty = y - sprite_height - 8;
        var tw = string_width(text) + 10;
        var th = string_height(text) + 6;
        
        draw_set_alpha(0.7);
        draw_set_color(c_black);
        draw_roundrect(tx - tw/2, ty - th, tx + tw/2, ty, false);
        draw_set_alpha(1);
        
        // Draw text
        draw_set_color(c_white);
        draw_text(tx, ty - 3, text);
        
        // Draw item name
        draw_set_color(c_yellow);
        draw_text(tx, ty - th - 5, item_name);
    }
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);