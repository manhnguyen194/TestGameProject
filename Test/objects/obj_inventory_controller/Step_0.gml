// Toggle inventory with E key
if (keyboard_check_pressed(ord("E"))) {
    inventory_open = !inventory_open;
    selected_slot = -1;
    dragging = false;
    
    if (inventory_open) {
        // Pause player movement when inventory is open (optional)
        // obj_player.can_move = false;
    } else {
        // obj_player.can_move = true;
    }
}

// Close with Escape
if (keyboard_check_pressed(vk_escape) && inventory_open) {
    inventory_open = false;
    selected_slot = -1;
    dragging = false;
}

if (!inventory_open) exit;

// Get inventory window position (centered on screen)
var inv_x = (display_get_gui_width() - inv_width) / 2;
var inv_y = (display_get_gui_height() - inv_height) / 2;

// Get mouse position
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Calculate slot area
var slot_area_x = inv_x + padding;
var slot_area_y = inv_y + header_height + padding;

// Find which slot mouse is over
var prev_selected = selected_slot;
selected_slot = -1;

if (mx >= slot_area_x && my >= slot_area_y) {
    var slot_col = floor((mx - slot_area_x) / slot_size);
    var slot_row = floor((my - slot_area_y) / slot_size);
    
    if (slot_col >= 0 && slot_col < slots_cols && slot_row >= 0 && slot_row < slots_rows) {
        selected_slot = slot_row * slots_cols + slot_col;
    }
}

// Tooltip hover time
if (selected_slot == prev_selected && selected_slot >= 0) {
    hover_time++;
} else {
    hover_time = 0;
}

// ===== DRAG AND DROP =====
if (mouse_check_button_pressed(mb_left) && selected_slot >= 0) {
    if (selected_slot < array_length(obj_player.inventory)) {
        // Start dragging
        dragging = true;
        drag_slot = selected_slot;
        drag_offset_x = mx - (slot_area_x + (selected_slot mod slots_cols) * slot_size);
        drag_offset_y = my - (slot_area_y + (selected_slot div slots_cols) * slot_size);
    }
}

if (mouse_check_button_released(mb_left) && dragging) {
    if (selected_slot >= 0 && selected_slot != drag_slot) {
        // Swap items
        inventory_swap(drag_slot, selected_slot);
    }
    dragging = false;
    drag_slot = -1;
}

// ===== USE ITEM (Double-click or Enter) =====
if (mouse_check_button_pressed(mb_left) && !dragging) {
    // Double-click detection could be added here
}

if (keyboard_check_pressed(vk_enter) && selected_slot >= 0) {
    if (selected_slot < array_length(obj_player.inventory)) {
        var item = obj_player.inventory[selected_slot];
        use_item(item.id, selected_slot);
    }
}

// ===== DROP ITEM (Right-click or Q) =====
if (mouse_check_button_pressed(mb_right) && selected_slot >= 0) {
    if (selected_slot < array_length(obj_player.inventory)) {
        drop_item(selected_slot, 1);
    }
}

if (keyboard_check_pressed(ord("Q")) && selected_slot >= 0) {
    if (selected_slot < array_length(obj_player.inventory)) {
        // Hold Shift to drop all
        if (keyboard_check(vk_shift)) {
            var item = obj_player.inventory[selected_slot];
            drop_item(selected_slot, item.amount);
        } else {
            drop_item(selected_slot, 1);
        }
    }
}
