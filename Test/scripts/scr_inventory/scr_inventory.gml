/// @function inventory_add(item_id, amount)
/// @description Add an item to the player's inventory
/// @param item_id The ID of the item to add
/// @param amount (optional) Number of items to add, default 1
/// @returns true if successful, false if inventory full
function inventory_add(item_id, amount = 1) {
    var data = item_get_data(item_id);
    
    // If stackable, try to find existing stack first
    if (data.stackable) {
        for (var i = 0; i < array_length(obj_player.inventory); i++) {
            if (obj_player.inventory[i].id == item_id) {
                var space_left = data.max_stack - obj_player.inventory[i].amount;
                var add_amount = min(amount, space_left);
                
                if (add_amount > 0) {
                    obj_player.inventory[i].amount += add_amount;
                    amount -= add_amount;
                    
                    if (amount <= 0) return true;
                }
            }
        }
    }
    
    // Add to new slots while there's inventory space and items to add
    while (amount > 0 && array_length(obj_player.inventory) < obj_player.inventory_max) {
        var stack_amount = data.stackable ? min(amount, data.max_stack) : 1;
        array_push(obj_player.inventory, {id: item_id, amount: stack_amount});
        amount -= stack_amount;
    }
    
    return (amount <= 0);
}

/// @function inventory_remove(item_id, amount)
/// @description Remove an item from the player's inventory
/// @param item_id The ID of the item to remove
/// @param amount (optional) Number of items to remove, default 1
/// @returns true if successful
function inventory_remove(item_id, amount = 1) {
    for (var i = array_length(obj_player.inventory) - 1; i >= 0; i--) {
        if (obj_player.inventory[i].id == item_id) {
            var remove_amount = min(amount, obj_player.inventory[i].amount);
            obj_player.inventory[i].amount -= remove_amount;
            amount -= remove_amount;
            
            // Remove empty slots
            if (obj_player.inventory[i].amount <= 0) {
                array_delete(obj_player.inventory, i, 1);
            }
            
            if (amount <= 0) return true;
        }
    }
    return (amount <= 0);
}

/// @function inventory_remove_at(slot_index, amount)
/// @description Remove an item from a specific slot
/// @param slot_index The slot index
/// @param amount (optional) Number of items to remove, default 1
/// @returns true if successful
function inventory_remove_at(slot_index, amount = 1) {
    if (slot_index < 0 || slot_index >= array_length(obj_player.inventory)) {
        return false;
    }
    
    obj_player.inventory[slot_index].amount -= amount;
    
    if (obj_player.inventory[slot_index].amount <= 0) {
        array_delete(obj_player.inventory, slot_index, 1);
    }
    
    return true;
}

/// @function inventory_has(item_id)
/// @description Check if player has an item
/// @param item_id The ID of the item to check
/// @returns true if player has the item
function inventory_has(item_id) {
    for (var i = 0; i < array_length(obj_player.inventory); i++) {
        if (obj_player.inventory[i].id == item_id) {
            return true;
        }
    }
    return false;
}

/// @function inventory_count(item_id)
/// @description Count how many of an item the player has
/// @param item_id The ID of the item to count
/// @returns Total amount of the item
function inventory_count(item_id) {
    var total = 0;
    for (var i = 0; i < array_length(obj_player.inventory); i++) {
        if (obj_player.inventory[i].id == item_id) {
            total += obj_player.inventory[i].amount;
        }
    }
    return total;
}

/// @function inventory_swap(slot1, slot2)
/// @description Swap two inventory slots
/// @param slot1 First slot index
/// @param slot2 Second slot index
function inventory_swap(slot1, slot2) {
    if (slot1 < 0 || slot2 < 0) return;
    if (slot1 >= array_length(obj_player.inventory) && slot2 >= array_length(obj_player.inventory)) return;
    
    // Extend inventory temporarily if needed
    var max_slot = max(slot1, slot2);
    while (array_length(obj_player.inventory) <= max_slot) {
        array_push(obj_player.inventory, {id: ITEM_NONE, amount: 0});
    }
    
    var temp = obj_player.inventory[slot1];
    obj_player.inventory[slot1] = obj_player.inventory[slot2];
    obj_player.inventory[slot2] = temp;
    
    // Clean up empty slots at the end
    inventory_cleanup();
}

/// @function inventory_cleanup()
/// @description Remove empty slots from the end of inventory
function inventory_cleanup() {
    for (var i = array_length(obj_player.inventory) - 1; i >= 0; i--) {
        if (obj_player.inventory[i].id == ITEM_NONE || obj_player.inventory[i].amount <= 0) {
            array_delete(obj_player.inventory, i, 1);
        }
    }
}

/// @function inventory_get_at(slot_index)
/// @description Get item data at a specific slot
/// @param slot_index The slot index
/// @returns Item struct or undefined
function inventory_get_at(slot_index) {
    if (slot_index >= 0 && slot_index < array_length(obj_player.inventory)) {
        return obj_player.inventory[slot_index];
    }
    return undefined;
}

/// @function inventory_is_full()
/// @description Check if inventory is full
/// @returns true if inventory is full
function inventory_is_full() {
    return (array_length(obj_player.inventory) >= obj_player.inventory_max);
}
