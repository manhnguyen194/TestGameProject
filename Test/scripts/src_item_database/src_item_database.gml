function item_database_init() {
	global.item_data = [];
	
	//load json file
	var json_string = "";
	var file = file_text_open_read(working_directory + "items.json");
	
	while (!file_text_eof(file)) {
		json_string += file_text_read_string(file);
		file_text_readln(file);
	}
	file_text_close(file);
	
	//parse json
	var data = json_parse(json_string);
	var items = data.items;
	
	//convert format
	for (var i = 0; i < array_length(items); i++) {
		var item = items[i];
		var spr = item.sprite == "" ? -1 : asset_get_index(item.sprite);
		
		global.item_data[item.id] = {
			name: item.name,
			sprite: spr,
			description: item.description,
			stackable: item.stackable,
			max_stack: item.max_stack,
			type: item.type,
		};
		// add extra properties if exist 
	}
}

function item_get_data(item_id) {
    if (item_id >= 0 && item_id < array_length(global.item_data) && global.item_data[item_id] != undefined) {
        return global.item_data[item_id];
    }
    return global.item_data[ITEM_NONE];
}