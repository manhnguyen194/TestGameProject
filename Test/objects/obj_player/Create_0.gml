// di chuyển
xspd = 0;
yspd = 0;

move_spd = 1;
dia_spd = 0.7071;
run_spd = 2;

sprite[RIGHT] = spr_player_right;
sprite[UP] = spr_player_up;
sprite[LEFT] = spr_player_left;
sprite[DOWN] = spr_player_down;

face = DOWN;

// Stats
hp = 100;
hp_max = 100;
mp = 50;
mp_max = 50;
stamina = 100;
stamina_max = 100;

// Combat stats
attack_damage = 1;
defense = 0;

// Equipment
equipped_weapon = ITEM_NONE;
equipped_armor = ITEM_NONE;

// Inventory
inventory = [];
inventory_max = INV_MAX_SLOTS;

// Initialize item database (do this once at game start)
item_database_init();