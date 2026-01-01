inventory_open = false;

// Layout settings
slot_size = INV_SLOT_SIZE;          // 48
slots_cols = INV_SLOTS_COLS;         // 5
slots_rows = INV_SLOTS_ROWS;         // 4
padding = 12;
header_height = 40;
footer_height = 60;

// Calculate window size
inv_width = (slot_size * slots_cols) + (padding * 2);
inv_height = header_height + (slot_size * slots_rows) + footer_height + (padding * 2);

// Selection
selected_slot = -1;
dragging = false;
drag_slot = -1;
drag_offset_x = 0;
drag_offset_y = 0;

// Tooltip delay
hover_time = 0;
tooltip_delay = 15; // frames before showing tooltip