// ============================================
// scr_pickup - Pickup and Item Use Functions
// ============================================
// Put this in: Scripts/scr_pickup (or src_pickup)
// ============================================

/// @function pickup()
/// @description Called when player picks up an item
function pickup() {
    var success = inventory_add(item_id, 1);
    
    if (success) {
        // Play pickup sound if you have one
        // audio_play_sound(snd_pickup, 1, false);
        
        // Show pickup message (optional)
        var data = item_get_data(item_id);
        show_debug_message("Picked up: " + data.name);
        
        instance_destroy();
    } else {
        show_debug_message("Inventory full!");
    }
}

/// @function use_item(item_id, slot_index)
/// @description Use an item from inventory
/// @param item_id The item to use
/// @param slot_index The slot it's in
/// @returns true if item was used
function use_item(item_id, slot_index) {
    var data = item_data(item_id);
    var used = false;
    
    switch (data.type) {
        case TYPE_CONSUMABLE:
            used = use_consumable(item_id, data);
            break;
            
        case TYPE_WEAPON:
            used = equip_weapon(item_id, slot_index);
            break;
            
        case TYPE_ARMOR:
            used = equip_armor(item_id, slot_index);
            break;
            
        case TYPE_KEY:
            show_debug_message("Keys are used automatically on locked doors");
            used = false;
            break;
            
        case TYPE_MATERIAL:
            show_debug_message("This item cannot be used directly");
            used = false;
            break;
            
        default:
            show_debug_message("Cannot use this item");
            used = false;
            break;
    }
    
    // Remove item if it was consumed
    if (used) {
        inventory_remove_at(slot_index, 1);
        // audio_play_sound(snd_use_item, 1, false);
    }
    
    return used;
}

/// @function use_consumable(item_id, data)
/// @description Use a consumable item (potions, food)
function use_consumable(item_id, data) {
    
    // Health items
    if (variable_struct_exists(data, "heal_amount")) {
        if (obj_player.hp < obj_player.hp_max) {
            obj_player.hp = min(obj_player.hp + data.heal_amount, obj_player.hp_max);
            show_debug_message("Healed for " + string(data.heal_amount) + " HP");
            // audio_play_sound(snd_heal, 1, false);
            return true;
        } else {
            show_debug_message("Already at full health!");
            return false;
        }
    }
    
    // Mana items
    if (variable_struct_exists(data, "mana_amount")) {
        if (variable_instance_exists(obj_player, "mp") && obj_player.mp < obj_player.mp_max) {
            obj_player.mp = min(obj_player.mp + data.mana_amount, obj_player.mp_max);
            show_debug_message("Restored " + string(data.mana_amount) + " MP");
            return true;
        } else {
            show_debug_message("Already at full mana!");
            return false;
        }
    }
    
    // Stamina items
    if (variable_struct_exists(data, "stamina_amount")) {
        if (variable_instance_exists(obj_player, "stamina") && obj_player.stamina < obj_player.stamina_max) {
            obj_player.stamina = min(obj_player.stamina + data.stamina_amount, obj_player.stamina_max);
            show_debug_message("Restored " + string(data.stamina_amount) + " Stamina");
            return true;
        } else {
            show_debug_message("Already at full stamina!");
            return false;
        }
    }
    
    return false;
}

/// @function equip_weapon(item_id, slot_index)
/// @description Equip a weapon
function equip_weapon(item_id, slot_index) {
    var data = item_get_data(item_id);
    
    // Swap with currently equipped weapon if any
    if (obj_player.equipped_weapon != ITEM_NONE) {
        // Put old weapon back in inventory
        var old_weapon = obj_player.equipped_weapon;
        obj_player.equipped_weapon = item_id;
        obj_player.inventory[slot_index].id = old_weapon;
        show_debug_message("Swapped weapons");
    } else {
        obj_player.equipped_weapon = item_id;
        inventory_remove_at(slot_index, 1);
    }
    
    // Update player stats
    obj_player.attack_damage = data.damage;
    show_debug_message("Equipped: " + data.name + " (DMG: " + string(data.damage) + ")");
    
    return false; // Don't remove from inventory (we handle it manually)
}

/// @function equip_armor(item_id, slot_index)
/// @description Equip armor
function equip_armor(item_id, slot_index) {
    var data = item_get_data(item_id);
    
    // Swap with currently equipped armor if any
    if (obj_player.equipped_armor != ITEM_NONE) {
        var old_armor = obj_player.equipped_armor;
        obj_player.equipped_armor = item_id;
        obj_player.inventory[slot_index].id = old_armor;
        show_debug_message("Swapped armor");
    } else {
        obj_player.equipped_armor = item_id;
        inventory_remove_at(slot_index, 1);
    }
    
    // Update player stats
    obj_player.defense = data.defense;
    show_debug_message("Equipped: " + data.name + " (DEF: " + string(data.defense) + ")");
    
    return false;
}

/// @function drop_item(slot_index, amount)
/// @description Drop an item from inventory into the world
function drop_item(slot_index, amount = 1) {
    if (slot_index < 0 || slot_index >= array_length(obj_player.inventory)) {
        return false;
    }
    
    var item = obj_player.inventory[slot_index];
    var drop_amount = min(amount, item.amount);
    
    // Create item in world near player
    var drop_x = obj_player.x + lengthdir_x(32, obj_player.face * 90);
    var drop_y = obj_player.y + lengthdir_y(32, obj_player.face * 90);
    
    // Create the appropriate item object based on item_id
    var dropped = instance_create_layer(drop_x, drop_y, "Instances", obj_item_parent);
    dropped.item_id = item.id;
    dropped.item_name = item_get_data(item.id).name;
    dropped.sprite_index = item_get_data(item.id).sprite;
    
    // Remove from inventory
    inventory_remove_at(slot_index, drop_amount);
    
    show_debug_message("Dropped: " + item_get_data(item.id).name);
    
    return true;
}
