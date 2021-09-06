tool extends Label;
onready var languages: LanguagesFx = MegaAssets.get_languages_manager (self);
onready var data_manager: SaveLoadFx = MegaAssets.get_data_manager (self);

func _init ():
	pass;

func _ready ():
#	languages = MegaAssets.get_languages_manager (self);
#	data_manager = MegaAssets.get_data_manager (self);
	# warning-ignore: return_value_discarded
	languages.connect ("language_changed", self, "_on_language_changed");
	# warning-ignore: return_value_discarded
	languages.connect ("before_load_data", self, "_on_before_load_data");
	# warning-ignore: return_value_discarded
	languages.connect ("after_load_data", self, "_on_after_load_data");
	# warning-ignore: return_value_discarded
	languages.connect ("before_update_data", self, "_on_before_update_data");
	# warning-ignore: return_value_discarded
	languages.connect ("after_update_data", self, "_on_after_update_data");
	# warning-ignore: return_value_discarded
	languages.connect ("before_save_data", self, "_on_before_save_data");
	# warning-ignore: return_value_discarded
	languages.connect ("after_save_data", self, "_on_after_save_data");
	# warning-ignore: return_value_discarded
	languages.connect ("before_destroy_data", self, "_on_before_destroy_data");
	# warning-ignore: return_value_discarded
	languages.connect ("after_destroy_data", self, "_on_after_destroy_data");
	# warning-ignore: return_value_discarded
	languages.connect ("start", self, "_on_start");
	# warning-ignore: return_value_discarded
	data_manager.connect ("game_data_changed", self, "_on_game_data_changed");
	# warning-ignore: return_value_discarded
	data_manager.connect ("file_not_found", self, "_on_file_not_found");
	pass;

func _on_language_changed (data) -> void:
	print ("Active language has been changed: ", data);
	self.text = languages.get_value_at ("newGame");
	pass

func _on_before_load_data () -> void: print ("Before load module data !");
func _on_after_load_data () -> void: print ("After load module data !");
func _on_before_update_data () -> void: print ("Before update module data !");
func _on_after_update_data () -> void: print ("After update module data !");
func _on_before_save_data () -> void: print ("Before save module data !");
func _on_after_save_data () -> void: print ("After save module data !");
func _on_before_destroy_data () -> void: print ("Before destroy module data !");
func _on_after_destroy_data () -> void: print ("After destroy module data !");
func _on_start () -> void: print ("Module started !");

func _on_game_data_changed () -> void: print ("Game data changed: ", data_manager.get_game_data ());
func _on_file_not_found (error): printerr (error.message, " code: ", error.type)
