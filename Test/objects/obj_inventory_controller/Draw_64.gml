if (!inventory_open) exit;

var inv_x = (display_get_gui_width() - inv_width) / 2;
var inv_y = (display_get_gui_height() - inv_height) / 2;

// ===== DRAW BACKGROUND =====
// Main background
draw_set_alpha(0.95);
draw_set_color(make_color_rgb(30, 30, 40));
draw_roundrect(inv_x, inv_y, inv_x + inv_width, inv_y + inv_height, false);
draw_set_alpha(1);

// Border
draw_set_color(make_color_rgb(80, 80, 100));
draw_roundrect(inv_x, inv_y, inv_x + inv_width, inv_y + inv_height, true);

// Header bar
draw_set_color(make_color_rgb(50, 50, 70));
draw_roundrect_ext(inv_x + 2, inv_y + 2, inv_x + inv_width - 2, inv_y + header_height, 8, 8, false);

// Title
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(inv_x + inv_width/2, inv_y + header_height/2, "INVENTORY");

// ===== DRAW SLOTS =====
var slot_x, slot_y;
var max_slots = slots_cols * slots_rows;

for (var i = 0; i < max_slots; i++) {
    var col = i mod slots_cols;
    var row = i div slots_cols;
    
    slot_x = inv_x + padding + (col * slot_size);
    slot_y = inv_y + header_height + padding + (row * slot_size);
    
    // Skip drawing the slot being dragged
    if (dragging && i == drag_slot) {
        draw_set_color(make_color_rgb(40, 40, 50));
        draw_rectangle(slot_x + 2, slot_y + 2, slot_x + slot_size - 3, slot_y + slot_size - 3, false);
        continue;
    }
    
    // Slot background
    if (i == selected_slot) {
        draw_set_color(make_color_rgb(60, 60, 80));
    } else {
        draw_set_color(make_color_rgb(25, 25, 35));
    }
    draw_rectangle(slot_x + 2, slot_y + 2, slot_x + slot_size - 3, slot_y + slot_size - 3, false);
    
    // Slot border
    if (i == selected_slot) {
        draw_set_color(make_color_rgb(255, 220, 100));
        draw_rectangle(slot_x + 1, slot_y + 1, slot_x + slot_size - 2, slot_y + slot_size - 2, true);
    } else {
        draw_set_color(make_color_rgb(60, 60, 80));
        draw_rectangle(slot_x + 2, slot_y + 2, slot_x + slot_size - 3, slot_y + slot_size - 3, true);
    }
    
    // Draw item if exists in this slot
    if (i < array_length(obj_player.inventory)) {
        var item = obj_player.inventory[i];
        var data = item_get_data(item.id);
        
        if (data.sprite != -1) {
            draw_sprite_stretched(data.sprite, 0, slot_x + 6, slot_y + 6, slot_size - 12, slot_size - 12);
        }
        
        // Draw stack amount
        if (item.amount > 1) {
            draw_set_halign(fa_right);
            draw_set_valign(fa_bottom);
            draw_set_color(c_white);
            
            // Shadow
            draw_set_color(c_black);
            draw_text(slot_x + slot_size - 5, slot_y + slot_size - 3, string(item.amount));
            draw_set_color(c_white);
            draw_text(slot_x + slot_size - 6, slot_y + slot_size - 4, string(item.amount));
        }
    }
}

// ===== DRAW DRAGGED ITEM =====
if (dragging && drag_slot >= 0 && drag_slot < array_length(obj_player.inventory)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    
    var item = obj_player.inventory[drag_slot];
    var data = item_get_data(item.id);
    
    if (data.sprite != -1) {
        draw_sprite_stretched_ext(data.sprite, 0, 
            mx - drag_offset_x + 6, my - drag_offset_y + 6, 
            slot_size - 12, slot_size - 12, c_white, 0.8);
    }
}

// ===== DRAW FOOTER (Item Info) =====
var footer_y = inv_y + header_height + padding + (slots_rows * slot_size) + 8;

draw_set_color(make_color_rgb(40, 40, 55));
draw_roundrect(inv_x + padding, footer_y, inv_x + inv_width - padding, inv_y + inv_height - padding, false);

if (selected_slot >= 0 && selected_slot < array_length(obj_player.inventory)) {
    var item = obj_player.inventory[selected_slot];
    var data = item_get_data(item.id);
    
    // Item name
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_yellow);
    draw_text(inv_x + inv_width/2, footer_y + 5, data.name);
    
    // Item description
    draw_set_color(c_ltgray);
    draw_text(inv_x + inv_width/2, footer_y + 22, data.description);
    
    // Controls hint
    draw_set_color(make_color_rgb(100, 100, 120));
    draw_text(inv_x + inv_width/2, footer_y + 40, "[Enter] Use  |  [Q] Drop  |  [RMB] Drop");
} else {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(80, 80, 100));
    draw_text(inv_x + inv_width/2, footer_y + footer_height/2 - 8, "Select an item");
}

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);