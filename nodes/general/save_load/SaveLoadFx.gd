"""
	@author: Obrymec
	@company: CodiTheck
	@famework: Godot Mega Assets
	@compatibility: Godot 3.x.x
	@platform: ANDROID || IOS || MACOSX || UWP || HTML5 || WINDOWS || LINUX
	@license: MIT
	@source: https://godot-mega-assets.herokuapp.com/docs/general/saveload
	@language: GDscript
	@dimension: 2D || 3D
	@level: Fx
	@category: General
	@saveable: False
	@type: SaveLoad
	@version: 0.2.4
	@created: 2020-11-26
	@updated: 2021-07-31
"""
################################################################################### [Main class] #############################################################################
"""
	@Description: SaveLoadFx is a module designed for saving and loading data in a game. The latter will allow developers to easily save and load their data.
		However, the game data is deposited in a file configured by the developer himself even.
		NB: Saving and loading data can be secure. Note also that this module is indestructible in nature, is compatible with a 2D, 3D game and is not saveable.
"""
tool class_name SaveLoadFx, "save_load.svg" extends Indestructible;

################################################################################### [Attributes] #############################################################################
# Contains all basics properties of a Godot Mega Assets module.
func _create_module_properties () -> void:
	# Contains the module title category.
	self.bind_prop (Dictionary ({title = "SaveLoadFx", index = 0}));
	"""@Description: Contains the different paths that this module supports. These paths represent the possible places where we can drop the save file of the game."""
	self.bind_prop (Dictionary ({source = "TargetPath", value = 0, type = TYPE_INT, attach = "TargetPath", min = 0,
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])}), max = 9,
		dropdown = Dictionary ({behavior = NaughtyAttributes.SYSTEM_DIR, paths = true})
	}));
	"""@Description: Contains the path pointing to the save file defined or created by the module during backups."""
	self.bind_prop (Dictionary ({source = "Source", value = (ProjectSettings ["application/config/name"] + "/save_game.dat"), type = TYPE_STRING, attach = "Source",
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])}), require = Dictionary ({
			statement = "AutoCompile && not Source", actions = Dictionary ({message = "Can't have an empty value on this field.", type = Message.ERROR})
		})
	}));
	"""
		@Description: Contains the name of the checkpoint to target for the management of game data on the save file. It also represents the point of active backup.
			This option puts the focus on the given save point among several others checkpoints where backups and data uploads will be performed. Note that the
			backup file can have one or more checkpoint(s). To be able to save and/or load the game data, it will be necessary to specify the checkpoint to target
			to perform the requested operation. For all processing to be done on the data of the game, we will ask by default, the active checkpoint at the save file level.
	"""
	self.bind_prop (Dictionary ({source = "ActiveCheckpoint", value = String (''), type = TYPE_STRING, attach = "ActiveCheckpoint",
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])})
	}));
	"""@Description: Contains the different possible security modes that can be used while backing up data from the Game."""
	self.bind_prop (Dictionary ({source = "Security", value = SecurityMethod.GODOT, type = TYPE_INT, dropdown = SecurityMethod.keys (),
		attach = PoolStringArray (["Security", "Level", "Key", "GeneratePassword", "FileChecksum"]), min = 0, max = 7,
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])}), require = Array ([Dictionary ({
				statement = "AutoCompile && not _game_running () && Security == 1",
				actions = Dictionary ({message = "AES encryption method is unstable for the moment.", type = Message.WARNING})
			}), Dictionary ({
				statement = "AutoCompile && not _game_running () && _pass_size () < 26 && Security == 2",
				actions = Dictionary ({message = "ARCFOUR encryption method is unstable for a low password size.", type = Message.WARNING})
			}), Dictionary ({
				statement = "AutoCompile && not _game_running () && _pass_size () > 18 && Security == 3",
				actions = Dictionary ({message = "CHACHA encryption method is unstable for big password size.", type = Message.WARNING})
			})
		])
	}));
	"""@Description: Contains the different possible security levels that can be used while saving game data."""
	self.bind_prop (Dictionary ({source = "Level", value = SecurityLevel.NORMAL, type = TYPE_INT, dropdown = SecurityLevel.keys (),
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])}), showif = "Security != 0",
		attach = PoolStringArray (["Level", "Key", "Security", "GeneratePassword"]), min = 0, max = 2, require = Array ([Dictionary ({
				statement = "AutoCompile && not _game_running () && Security == 4 && Level == 2",
				actions = Dictionary ({message = "Binary coding on this mode is untable for the moment.", type = Message.WARNING})
			}), Dictionary ({
				statement = "AutoCompile && not _game_running () && _pass_size () < 26 && Security == 5 && Level == 2",
				actions = Dictionary ({message = "Hexadecimal codding on this mode is unstable for a low password size.", type = Message.WARNING})
			}), Dictionary ({
				statement = "AutoCompile && not _game_running () && _pass_size () > 18 && Security == 6 && Level == 2",
				actions = Dictionary ({message = "Octal codding on this mode is unstable for big password size.", type = Message.WARNING})
			})
		])
	}));
	"""@Description: Which encryption method do you want to use this to generate the checksum of the backup file ?"""
	self.bind_prop (Dictionary ({source = "FileChecksum", value = Checksum.MD5, type = TYPE_INT, attach = "FileChecksum", showif = "Security != 7", max = 2,
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])}), dropdown = Checksum.keys (), visible = false, min = 0
	}));
	"""@Description: Contains the password to be used to secure the game data. You can automatically generate a password via "GeneratePassword" button."""
	self.bind_prop (Dictionary ({source = "Key", value = "?generate_key ()", type = TYPE_STRING, attach = PoolStringArray (["Key", "Security", "Level"]),
		showif = "Security > 0 && Security < 4 or Security == 7 && Level > 0 || Security >= 4 && Security <= 6 && Level == 2", require = Array ([Dictionary ({
				statement = ("AutoCompile && Security > 0 && Security < 4 && !Key or AutoCompile && Security == 7 && Level > 0 && !Key"\
				+ "|| AutoCompile && Security >= 4 && Security <= 6 && Level == 2 && not Key"),
				actions = Dictionary ({message = "We recommend you to donate a password to get more security.", type = Message.WARNING})
			}), Dictionary ({statement = "AutoCompile && _pass_size () > 32", actions = Dictionary ({
				message = "The password length must not be greater than 32", type = Message.ERROR
			})})
		]), changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])})
	}));
	"""@Description: Do you want to take a screen capture each time you save ?"""
	self.bind_prop (Dictionary ({source = "ScreenCapture", changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])}), value = false,
		attach = PoolStringArray (["ScreenCapture", "Size", "Quality", "CompressMode", "CompressSource", "CompressRatio", "Format"]), type = TYPE_BOOL
	}));
	"""@Description: Controls the resolution of screenshots to be generated during backups."""
	self.bind_prop (Dictionary ({source = "Size", value = Vector2 (64, 64), type = TYPE_VECTOR2, attach = PoolStringArray (["Size", "ScreenCapture"]), max = 256,
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])}), showif = "ScreenCapture", min = 0, visible = false
	}));
	"""@Description: Controls the quality of screenshots to generated during backups."""
	self.bind_prop (Dictionary ({source = "Quality", value = 2, type = TYPE_INT, attach = "Quality", visible = false,
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])}), showif = "ScreenCapture",
		dropdown = PoolStringArray (["NEAREST", "BILINEAR", "CUBIC", "TRILINEAR", "LANCZOS"]), min = 0, max = 4
	}));
	"""@Description: What compression mode do you want adopt to compress screenshots generated during backups ?"""
	self.bind_prop (Dictionary ({source = "CompressMode", value = 2, type = TYPE_INT, dropdown = ImageCompression.keys (), min = 0, max = 3,
		attach = PoolStringArray (["CompressMode", "CompressSource", "CompressRatio", "Format"]), showif = "ScreenCapture", visible = false,
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])})
	}));
	"""@Description: From what source of compression the screen captures generated during the backups will be compressed ?"""
	self.bind_prop (Dictionary ({source = "CompressSource", value = 1, type = TYPE_INT, attach = "CompressSource", visible = false, min = 0, max = 2,
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])}), showif = "ScreenCapture and CompressMode > 0",
		dropdown = PoolStringArray (["GENERIC", "SRGB", "NORMAL"]),
	}));
	"""@Description: What compression ratio applied to screenshots generated during backups ?"""
	self.bind_prop (Dictionary ({source = "CompressRatio", value = 1000.0, type = TYPE_REAL, attach = "CompressRatio", visible = false, min = 0.0,
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])}), showif = "ScreenCapture and CompressMode > 0"
	}));
	"""@Description: What will be the format of the screenshots at generated during backups ?"""
	self.bind_prop (Dictionary ({source = "Format", value = 6, type = TYPE_INT, attach = "Format", dropdown = ImageFormat.keys (), min = 0, max = 10, visible = false,
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])}), showif = "ScreenCapture and CompressMode > 0",
	}));
	"""@Description: Do you want to load the file from save chosen using the "Index" field when the game is initialized ?"""
	self.bind_prop (Dictionary ({source = "LoadAllData", value = true, type = TYPE_BOOL, attach = "LoadAllData",
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])})
	}));
	"""
		@Description: Contains all string names from characters from scenes to targeted. This option will allow the module to charge or reload the backup file
			targeted by the developer when one of the scenes specified by the developer will be charge and activate.
	"""
	self.bind_prop (Dictionary ({source = "TargetScenes", value = PoolStringArray ([]), type = TYPE_STRING_ARRAY, attach = "TargetScenes",
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])}),
		require = Dictionary ({statement = "AutoCompile", actions = Dictionary ({slot = "_check_array_clone ()"})})
	}));
	"""
		@Description: Would you like to automatically generate a password ? At this level, the value of the field "Key" will be updated on each generation.
			The scope of this field is only on the Godot engine.
	"""
	self.bind_prop (Dictionary ({source = "GeneratePassword", attach = "GeneratePassword", button = "generate_password",
		showif = "Security > 0 and Security < 4 or Security == 7 && Level > 0 or Security >= 4 and Security <= 6 && Level == 2"
	}));
	# Attaches "Source", "TargetScenes", "ActiveCheckpoint", "Security", "Level" and "Key" properties to "AutoCompile" property.
	self.override_prop (Dictionary ({attach = PoolStringArray (["Source", "TargetScenes", "ActiveCheckpoint", "Security", "Level", "Key"])}), "AutoCompile");

#################################################################################### [Signals] ###############################################################################
"""@Description: Called before updating the data manager data."""
signal before_update (data);
"""@Description: Called after updating the data manager data."""
signal after_update (data);
"""@Description: Called after saving the data manager data."""
signal after_save (datum_count);
"""@Description: Called after loading the data manager data."""
signal after_load (datum_count);
"""@Description: Called after destroying the data manager data."""
signal after_destroy (data);
"""@Description: Called when the save file is not defined on the computer hard disk."""
signal file_not_found (data);
"""@Description: Called when the save file was corrupted from the outside."""
signal file_corrupted (data);
"""@Description: Called while the save file is being saved."""
signal file_saving (data);
"""@Description: Called while the save file is being loaded."""
signal file_loading (data);
"""@Description: Called when there are some difficulties to open the save file or that its access has been denied."""
signal file_cant_open (data);
"""@Description: Called when the global game time changed."""
signal game_time_changed (time);
"""@Description: Called before destroying the data manager data."""
signal before_destroy (data);
"""@Description: Called before loading the data manager data."""
signal before_load ();
"""@Description: Called before saving the data manager data."""
signal before_save ();
"""@Description: Called when the game data manager has changed."""
signal game_data_changed ();

############################################################################## [Particulars variables] #######################################################################
# Contains all game data into a single dictionary.
var _game_data: Dictionary = Dictionary ({}) setget _unsetable_var_error;
# Contains the eleapsed game time since the game started.
var _game_time: int = 0 setget _unsetable_var_error;
# Contains the virtual time since some checkpoint(s) have/has been saved to the save file.
var _virtual_game_time: int = 0 setget _unsetable_var_error;
# Contains the last load date of the game save file.
var _old_date: Dictionary = Dictionary ({}) setget _unsetable_var_error;
# Contains the last load time of the game save file.
var _old_time: Dictionary = Dictionary ({}) setget _unsetable_var_error;
# Contains the old scene reference.
var _old_active_scene = null setget _unsetable_var_error;
# Contains the old simulation boolean value.
var _simulation_saved: bool = false setget _unsetable_var_error;
# The global game time has already started ?
var _is_game_time_running: bool = false setget _unsetable_var_error;

############################################################################### [Properties manager] #########################################################################
# Returns the game state (Running/Editor).
func _game_running (): return not Engine.editor_hint;

# Returns the password length.
func _pass_size (): return self.get_prop ("Key").length ();

# Unsetable module variables.
func _unsetable_var_error (_new_value) -> void: self.output ("Can't change value of this variable.", Message.ERROR, self);

# Checks a potential cloned values into an array.
func _check_array_clone () -> void:
	# Contains the value of "TargetScenes" module property.
	var array: Array = Array (self.get_prop ("TargetScenes"));
	# Searches some potentials duplications into "TargetScenes" module property.
	for t in len (array):
		# If you detect a duplication.
		if !array [t].empty () and array.count (array [t]) > 1:
			# Shows an error message and get out of the for loop.
			self.output (("Can't have severals values of {" + array [t] + "}::index " + str (t)), Message.ERROR, self); break;

############################################################################## [Logic and main tasks] ########################################################################
# This method is called on game initialization and before all nodes instanciation.
func _init (): self._create_module_properties ();

# Called before ready method run.
func _enter_tree ():
	# Checks the unicity of this module.
	self.check_unique (self.get_class ());
	# The module is now out of reach of scene changes.
	if self.get_parent ().name == "DontDestroyOnLoad":
		# Connects this module reference to "values_changed" signal.
		if !self.is_connected ("values_changed", self, "_run_first_treatments") && self.connect ("values_changed", self, "_run_first_treatments") != OK: pass;
		# Apply module firsts treatments.
		self._run_first_treatments (null);

# Apply the module firsts treatments.
func _run_first_treatments (_data) -> void:
	# Starts the global game time counting.
	if self.is_unlock (): self.set_process (true); else: self.set_process (false); self._increase_game_time (self._is_game_time_running);

# Executes module main treatment(s).
func _process (_delta) -> void:
	# The game is running.
	if self._game_running ():
		# Getting the current scene tree.
		var tree: SceneTree = self.get_tree ();
		# The current active scene has been changed.
		if self._old_active_scene != tree.current_scene:
			# Should us load the save file into the game data manger ? If yes, reloads the save file and ereases the old data from the game data manager.
			if self.get_prop ("LoadAllData") or tree.current_scene != null && Array (self.get_prop ("TargetScenes")).has (tree.current_scene.name): self.load_game_data ();
			# Updates the old active scene to the current active scene.
			_old_active_scene = tree.current_scene;

# Follows save file deserialization and thrown some event(s) so possible.
func _deserializer (path: String, is_loading: bool, loaded_data_count: int, _result, error) -> void:
	# An error has been detected.
	if error != null:
		# Contains the error data.
		var error_data: Dictionary = Dictionary ({"message": (self.get_object_prefix (self) + ": " + error.message), "type": error.type, "path": path});
		# The save file to be loaded is corrupted.
		if error.code == ERR_FILE_CORRUPT: self.emit_signal ("file_corrupted", error_data);
		# The save file not found.
		elif error.code == ERR_FILE_NOT_FOUND: self.emit_signal ("file_not_found", error_data);
		# The save file cannot be opened.
		else: self.emit_signal ("file_cant_open", error_data);
	# Otherwise.
	else: self.emit_signal ("file_loading", Dictionary ({"path": path, is_over = is_loading, progress = loaded_data_count}));

# Follows save file serialization and thrown some event(s) so possible.
func _serializer (path: String, progress: int, error) -> void:
	# An error has been detected.
	if error != null:
		# The file connot be opened.
		self.emit_signal ("file_cant_open", Dictionary ({"message": (self.get_object_prefix (self) + ": " + error.message), "type": error.type, "path": path}));
	# Otherwise.
	else: self.emit_signal ("file_saving", Dictionary ({"path": path, "progress": progress}));

# Parses game data before his saving into the save file.
func _parse_game_data (data: Dictionary, ignore) -> Dictionary:
	# Contains the final result.
	var result: Dictionary = Dictionary ({});
	# Searches all availables checkpoints.
	for checkpoint in data:
		# Filters all ignored checkpoint(s).
		if ignore is Array and !ignore.has (checkpoint) || not ignore is Array:
			# Filters all ignored key(s).
			for game_data in data [checkpoint]:
				# Checks whether the current must be ignored or not.
				if ignore is Array && !ignore.has (game_data) || !ignore is Array: result [(checkpoint + "#?#" + game_data)] = data [checkpoint] [game_data];
	# Returns the final result.
	return result;

# Deparses a parsed game data to get the original data.
func _deparse_game_data (data: Dictionary, ignore) -> Dictionary:
	# Contains the final result.
	var result: Dictionary = Dictionary ({});
	# Searches all availables checkpoints.
	for key in data:
		# Splits the current key.
		var keys: PoolStringArray = key.split ("#?#");
		# The current checkpoint is it already defined on the final result ?
		if not result.has (keys [0]): result [keys [0]] = Dictionary ({keys [1]: data [key]}); else: result [keys [0]] [keys [1]] = data [key];
		# The ignore value type is an array.
		if ignore is Array:
			# For checkpoint and key deletion.
			if ignore.has (keys [0]) and result.erase (keys [0]): pass; elif ignore.has (keys [1]) and result [keys [0]].erase (keys [1]): pass;
	# Returns the final result.
	return result;

# Removes all specials characters of the given entry.
func _correct_key (input):
	# Checks the given input value.
	if input != null:
		# Converts the passed input into an array.
		input = Array ([input]) if not self.is_array (input) else Array (input); var filter: Array = Array ([]);
		# Corrects all passed key(s) before any advanced treatment(s).
		for element in input: filter.append (self.str_replace (str (element), ["\n", "\t", "\a", "\b", "\r", "\v", "\f", ' ', '#', '?'], '')); return filter;
	# Otherwise.
	else: return input;

# Checks whether a key contains an existing checkpoint on the game data.
func _check_existing_checkpoint (key: String) -> bool:
	# Searches all existing into the passed key.
	for checkpoint in self._game_data.keys (): if key.find (checkpoint) != -1: return true; return false;

# Apply a basics conditions before any treatment(s).
func _check_basics_constraints (key: String, checkpoint: String) -> bool:
	# The given checkpoint is not empty.
	if not checkpoint.empty ():
		# The passed datum key is not empty.
		if not key.empty ():
			# Checks whether the given key contains a checkpoint name.
			if !self._game_data.has (key) and key.find (checkpoint) == -1 and not self._check_existing_checkpoint (key): return true;
			# Error message.
			else: self.output ("The key can't contains an existing checkpoint.", Message.ERROR, self);
		# Otherwise.
		else: self.output ("The key should not be empty.", Message.ERROR, self);
	# Error message.
	else: self.output ("No checkpoint found.", Message.ERROR, self); return false;

# Overrides a datum from his key into the game data manager.
func _set_game_datum (key: String, value, checkpoint: String) -> void:
	# Contains the event data that will be returned to all available(s) event(s) listener(s).
	var event_data: Dictionary = Dictionary ({"key": key, "value": value, "checkpoint": checkpoint});
	# Thrown "before_update" event.
	self.emit_signal ("before_update", event_data);
	# The target checkpoint is not defined on the game data manager.
	if !self._game_data.has (checkpoint): _game_data [checkpoint] = Dictionary ({key: value});
	# Updates the target key on the target checkpoint.
	else: _game_data [checkpoint] [key] = value; self.emit_signal ("after_update", event_data); self.emit_signal ("game_data_changed");

# Returns a datum from his key from the game data manager.
func _get_game_datum (key: String, default, checkpoint: String):
	# The passed checkpoint or key isn't defined.
	if not self._game_data.has (checkpoint): return default; elif not self._game_data [checkpoint].has (key): return default;
	# Otherwise.
	else: return self._game_data [checkpoint] [key];

# Counts the eleapsed time since the game checkpoint loaded.
func _increase_game_time (reset: bool) -> void:
	# The module is it enabled ?
	if self._game_running () and self.is_unlock () and not reset:
		# Waiting one second before increase the current eleapsed time.
		yield (self.get_tree ().create_timer (1.0), "timeout"); _game_time += 1; _virtual_game_time += 1; _is_game_time_running = true;
		# Warns all listener(s) about game time changing.
		self.emit_signal ("game_time_changed", self._game_time); self._increase_game_time (false);

# Returns value of basics module keys system.
func _get_system_key (key: String, checkpoint: String, default = Dictionary ({})):
	# Correcting the passed checkpoint parameter value.
	checkpoint = self._correct_key (self.get_prop ("Checkpoint") if checkpoint.empty () else checkpoint) [0];
	# Returns the final result with checkpoint definition.
	return self._get_game_datum (key, default, checkpoint);

# Corrects the user path to get better work.
func _correct_path (source: String) -> String:
	# Contains the target system path. Returns the corrected form of the given path with source value module property.
	var target_path: String = self.get_prop ("TargetPath", true); source = source.lstrip ('/').rstrip ('/');
	# Returns the corrected path with the given source value.
	return (target_path + source) if target_path.ends_with ('/') else (target_path + '/' + source);

############################################################################### [Availables features] ########################################################################
"""@Description: Returns the version a module."""
static func get_version () -> String: return "0.2.4";

"""@Description: Returns all origins of a module."""
static func get_origin_name () -> String: return "MegaAssets.Module.Indestructible.SaveLoadFx";

"""@Description: What is the supported dimensions of this module ?"""
static func get_supported_dimensions () -> String: return "2D || 3D";

"""@Description: What is the category of this module ?"""
static func get_category_name () -> String: return "General";

"""@Description: Returns a module class type."""
func get_class (): return "SaveLoadFx";

"""@Description: Returns the web link of "Godot Mega Assets" framework."""
static func get_source () -> String: return "https://godot-mega-assets.herokuapp.com/docs/general/saveload";

"""
	@Description: Generates at hazard, a password according to the configurations present at its level. The value of the field "Key" will be updated on
		each generation. Note that you can't generate a password when the game is running.
	@Parameters:
		float delay: What is the dead time before generation ?
"""
func generate_password (delay: float = 0.0) -> void:
	# The game is it running ?
	if not self._game_running ():
		# Waiting for the given delay.
		if delay > 0.0 and self._game_running (): yield (self.get_tree ().create_timer (delay), "timeout");
		# Contains the max password size.
		var key_size: int = 0; randomize (); var method: int = self.get_prop ("Security");
		# For AES, GODOT and BINARY encryption method.
		if method == 1 || method == 7 || method == 4 && self.get_prop ("Level") == SecurityLevel.ADVANCED: key_size = int (rand_range (16, 33));
		# For ARCFOUR and HEXADECIMAL encryption method.
		elif method == 2 || method == 5 && self.get_prop ("Level") == SecurityLevel.ADVANCED: key_size = int (rand_range (26, 33));
		# For CHACHA and OCTAL encryption method.
		elif method == 3 || method == 6 && self.get_prop ("Level") == SecurityLevel.ADVANCED: key_size = int (rand_range (16, 17));
		# Generates a password that respect the imposed constraints.
		self.override_prop (Dictionary ({value = self.generate_key (key_size)}), "Key");
	# Warning message.
	else: self.output ("Can't generate a password when the game is running.", Message.WARNING, self);

"""
	@Description: Restarts a module. Made very careful during module reboots. This can be problematic in certain cases.
	@Parameters:
		float delay: What is the timeout before restarting module ?
"""
func restart (delay: float = 0.0) -> void:
	# The module is it enabled ?
	if self.is_unlock ():
		# Waiting for the given delay.
		if delay > 0.0 and self._game_running (): yield (self.get_tree ().create_timer (delay), "timeout");
		# Resets all module particulars properties.
		_game_time = 0; _game_data.clear (); _virtual_game_time = 0; _old_date.clear (); _old_time.clear (); _old_active_scene = null; _simulation_saved = false;
		# Disconnects this module reference from "values_changed" signal.
		if self.is_connected ("values_changed", self, "_run_first_treatments") && self.disconnect ("values_changed", self, "_run_first_treatments") != OK: pass;
		# Restarts the module.
		self.emit_signal ("game_data_changed"); self._enter_tree (); self._ready ();

"""
	@Description: Gives an overview of operation of a module. In other words, it performs the main task of a module by depending on the configurations
		carried out at its level. This function is not present in all cases. It depends on the nature and operation of the module in question.
	@Parameters:
		float delay: What is the timeout before module simulation ?
"""
func simulate (delay: float = 0.0) -> void:
	# The module is it enabled ?
	if self.is_unlock ():
		# On editor only.
		if not self._game_running ():
			# Waiting for the given delay.
			if delay > 0.0 and self._game_running (): yield (self.get_tree ().create_timer (delay), "timeout");
			# The game data have not been save.
			if not self._simulation_saved:
				# Saves game data manager into the passed save file.
				self.save_game_data (self.get_prop ("ActiveCheckpoint")); _simulation_saved = true;
				# Warns the developer about saving game data.
				self.output ("The game data has been saved !", Message.NORMAL, self);
			# Otherwise.
			else:
				# Loads the given save file into the game data manager.
				self.load_game_data (); _simulation_saved = false;
				# Warns the developer about loading game data.
				self.output ("The game data has been loaded !", Message.NORMAL, self);
		# On game running.
		else: self.output ("Can't make a module simulation when the game is running.", Message.WARNING, self);

"""
	@Description: Saves the game data dictionary to the save file.
	@Parameters:
		String | PoolStringArray checkpoints: What is/are the checkpoint(s) to changed before full game data backup ? The update that will undergo different
			checkpoints will be nothing more than the insertion of the keys following specials: "__last_save_date__", "__last_save_time__", "__game_time__",
			"__game_screenshot__", "__last_load_date__" and "__last_load_time__" which is based certain module functionalities to perform their processing.
			Note that if none checkpoint is not specified, the active one will not be solicited.
		String | PoolStringArray ignore: Contains the list of keys to be ignored during data backup. Note that you have the option of ignoring a point of
			entire backup. In this case, all these keys will suffer the same fate.
		Camera active_camera: Do you want to make a screenshot from an other camera before global saving game data ?
		float delay: What is the timeout before saving game data ?
"""
func save_game_data (checkpoints = null, ignore = null, active_camera = null, delay: float = 0.0) -> void:
	# The module is it enabled ?
	if self.is_unlock ():
		# The game is running.
		if self._game_running ():
			# If the game is not initialised.
			if delay <= 0.0 && not is_game_initialised ():
				# Waiting for the given delay.
				yield (self.get_tree (), "idle_frame"); yield (self.get_tree (), "idle_frame");
			# Otherwise.
			elif delay > 0.0: yield (self.get_tree ().create_timer (delay), "timeout");
		# Contains the corrected given source value.
		var source: String = self._correct_key (self.get_prop ("Source")) [0];
		# The source isn't empty.
		if not source.empty ():
			# Correcting the passed checkpoint and key value.
			checkpoints = self._correct_key (checkpoints);
			# Some checkpoint(s) have been refered.
			if checkpoints is Array:
				# Apply these save configurations to all passed checkpoint(s).
				for savepoint in checkpoints:
					# The current checkpoint name isn't empty.
					if not savepoint.empty ():
						# Saves the save date and time.
						self._set_game_datum ("__last_save_date__", OS.get_date (), savepoint); self._set_game_datum ("__last_save_time__", OS.get_time (), savepoint);
						# Saves the current checkpoint game time from the eleapsed global virtual game time.
						self._set_game_datum ("__game_time__", (self._get_game_datum ("__game_time__", 0, savepoint) + self._virtual_game_time), savepoint);
						# Checks whether there was a last save file datatime.
						if !self._old_date.empty () and !self._old_time.empty ():
							# Saves the last load date of the current checkpoint.
							self._set_game_datum ("__last_load_date__", self._old_date, savepoint);
							# Saves the last load time of the current checkpoint.
							self._set_game_datum ("__last_load_time__", self._old_time, savepoint);
						# Can us take some screenshots ?
						if self.get_prop ("ScreenCapture"):
							# Contains the old active camera.
							var old_active_camera: Camera = self.get_viewport ().get_camera ();
							# We must create a screenshot from the other active camera.
							if active_camera is Camera:
								# Changes the active camera to the given camera reference.
								old_active_camera.current = false; active_camera.current = true; yield (self.get_tree (), "idle_frame");
							# Getting the game screenshot data from his viewport.
							var screenshot_data: Array = self.get_screen_shot_data (self, Dictionary ({size = self.get_prop ("Size"), quality = self.get_prop ("Quality"),
								format = self.get_prop ("Format"), comp_mode = self.get_prop ("CompressMode"), comp_source = self.get_prop ("CompressSource"),
								ratio = self.get_prop ("CompressRatio")
							}));
							# Should us create a screenshot from other camera.
							if active_camera is Camera:
								# Changes the current active camera to the old camera.
								old_active_camera.current = true; active_camera.current = false;
							# Updates the current checkpoint data with the created game screenshot.
							self._set_game_datum ("__game_screenshot__", screenshot_data, savepoint);
						# Resets the virtual game time for next save(s).
						_virtual_game_time = 0;
			# Contains the real path pointed the save file.
			self.emit_signal ("before_save"); var path: String = self._correct_path (source);
			# Contains the corrected form of the game data.
			var corrected_data: Dictionary = self._parse_game_data (self._game_data.duplicate (true), self._correct_key (ignore));
			# Serializes all game data into the save file.
			self.serialize (corrected_data, path, self, self.get_prop ("Key"), self.get_prop ("Security"), self.get_prop ("Level"),
				Dictionary ({"method": "_serializer ()"}), (Checksum.NONE if self.get_prop ("Security") == SecurityMethod.GODOT else self.get_prop ("FileChecksum"))
			); self.emit_signal ("after_save", corrected_data.size ());
		# Error message.
		else: self.output ("Missing the save file source.", Message.ERROR, self);

"""
	@Description: Loads the game data from the save file.
	@Parameters:
		String | PoolStringArray checkpoints: What is/are the checkpoint(s) to changed after full loading of game data ? Note that if you specify checkpoints
			in this parameter, only these save points will be redefined in the data manager. The others will keep their data. By default, all manager data are
			overwritten by those loaded to from the backup file.
		String | PoolStringArray ignore: Contains the list of keys to be ignored during data loading. Note that you have the option of ignoring a point of
			entire backup. In this case, all these keys will suffer the same fate.
		float delay: What is the timeout before saving game data ?
"""
func load_game_data (checkpoints = null, ignore = null, delay: float = 0.0) -> void:
	# The module is it enabled ?
	if self.is_unlock ():
		# Waiting for the given delay.
		if delay > 0.0 and self._game_running (): yield (self.get_tree ().create_timer (delay), "timeout");
		# Contains the corrected given source value.
		var source: String = self._correct_key (self.get_prop ("Source")) [0];
		# The source isn't empty.
		if not source.empty ():
			# Contains the real path pointed the save file and updates the last load datetime of the game save file
			self.emit_signal ("before_load"); var path: String = self._correct_path (source); _old_date = OS.get_date (); _old_time = OS.get_time ();
			# Contains the loaded data from the save file.
			var loaded_data: Dictionary = self.deserialize (path, self, self.get_prop ("Key"), self.get_prop ("Security"), self.get_prop ("Level"),
				Dictionary ({"method": "_deserializer ()"}), (Checksum.NONE if self.get_prop ("Security") == SecurityMethod.GODOT else self.get_prop ("FileChecksum"))
			); loaded_data = self._deparse_game_data (loaded_data, self._correct_key (ignore)); checkpoints = self._correct_key (checkpoints);
			# Calculates the total deparsed datum count loaded from the game save file.
			var datum_count: int = 0; for savepoint in loaded_data: datum_count += loaded_data [savepoint].size ();
			# No errors detected.
			if not loaded_data.empty ():
				# Should us override some checkpoint(s) without affected others existing checkpoint(s) into the game manager ?
				if checkpoints != null:
					# Updates the target checkpoint(s).
					for savepoint in checkpoints:
						# Checks whether the current checkpoint exists within game data manager.
						if loaded_data.has (savepoint):
							# Updates the target checkpoint and thrown "game_data_changed" event.
							_game_data [savepoint] = loaded_data [savepoint]; self.emit_signal ("game_data_changed");
				# No particular(s) checkpoint(s) will be overrided.
				else:
					# Updates all defined checkpoint(s) of the game data manager.
					_game_data = loaded_data; self.emit_signal ("game_data_changed");
			# Thrown "after_load" event.
			self.emit_signal ("after_load", datum_count);
		# Error message.
		else: self.output ("Missing the save file source.", Message.ERROR, self);

"""
	@Description: Updates the data manager.
	@Parameters:
		String key: Contains the name of the key that will be used identification to the value to be inserted. Avoid putting spaces, if you want to
			retrieved value contained in your key. If your key does not exist, it will be automatically created.
		Variant value: Contains the value of the key to added or to created.
		String checkpoint: Contains the name of the checkpoint to targeted. If the checkpoint is not defined in the data manager, it will be automatically created.
			By default, the active checkpoint is targeted.
		float delay: What is the timeout before updating the game data manager ?
"""
func set_data (key: String, value, checkpoint: String = '', delay: float = 0.0) -> void:
	# The module is it enabled ?
	if self.is_unlock ():
		# Waiting for the given delay.
		if delay > 0.0 and self._game_running (): yield (self.get_tree ().create_timer (delay), "timeout");
		# Correcting the passed checkpoint and key value.
		checkpoint = self._correct_key (self.get_prop ("Checkpoint") if checkpoint.empty () else checkpoint) [0]; key = self._correct_key (key) [0];
		# Checks basics constraints to the given parameters before updating game data manager.
		if self._check_basics_constraints (key, checkpoint): self._set_game_datum (key, value, checkpoint); 

"""
	@Description: Returns the corresponding value of "key".
	@Parameters:
		String key: Contains the name of the key that will be used identification to the value to be inserted.
		Variant default: What value are we going returned, when the name of the key or that of the savepoint is not defined in the data manager.
		String checkpoint: Contains the name of the point backup to targeted. By default, the active checkpoint is targeted.
"""
func get_data (key: String, default = null, checkpoint: String = ''):
	# The module is it enabled ?
	if self.is_unlock ():
		# Correcting the checkpoint and the passed key value.
		checkpoint = self._correct_key (self.get_prop ("Checkpoint") if checkpoint.empty () else checkpoint) [0]; key = self._correct_key (key) [0];
		# Checks the basics constraints from the given parameters.
		return self._get_game_datum (key, default, checkpoint);
	# Otherwise.
	else: return default;

"""@Description: Determines if there is any progress made in the game."""
func is_progress () -> bool:
	# The module is it enabled ?
	if self.is_unlock ():
		# Getting the current path of the game save file.
		var path: String = (self.get_prop ("TargetPath", true) + '/' + self._correct_key (self.get_prop ("Source")) [0]);
		# Checks the game manager progression.
		return true if !self._game_data.empty () and !File.new ().file_exists (path) or File.new ().file_exists (path) else false;
	# Returns a falsy value for other cases.
	else: return false;

"""@Description: Returns them parent folders of the backup file."""
func get_root_folders () -> String: return self._correct_path (self._correct_key (self.get_prop ("Source")) [0]).get_base_dir () if self.is_unlock () else "Null";

"""@Description: Returns the path full pointing to the backup file."""
func get_full_path () -> String: return self._correct_path (self._correct_key (self.get_prop ("Source")) [0]) if self.is_unlock () else "Null";

"""
	@Description: Returns the date of the last backup performed for a given backup point. This method uses "__last_save_date__" key to accomplish its task.
	@Parameters:
		String checkpoint: Contains the name of the point backup to targeted. By default, the active save point is used to do the requested treatment.
"""
func get_last_save_date (checkpoint: String = '') -> Dictionary: return self._get_system_key ("__last_save_date__", checkpoint) if self.is_unlock () else {};

"""
	@Description: Returns the time of the last backup performed for a given backup point. This method uses "__last_save_time__" key to accomplish its task.
	@Parameters:
		String checkpoint: Contains the name of the point backup to targeted. By default, the active save point is used to do the requested treatment.
"""
func get_last_save_time (checkpoint: String = '') -> Dictionary: return self._get_system_key ("__last_save_time__", checkpoint) if self.is_unlock () else {};

"""
	@Description: Returns the date of the last load performed for a given checkpoint. This method uses "__last_load_date__" key to accomplish its task.
		Note that in case of failure, the time of the last upload performed at the file level backup will be returned.
	@Parameters:
		String checkpoint: Contains the name of the point backup to targeted. By default, the active save point is used to do the requested treatment.
"""
func get_last_load_date (checkpoint: String = '') -> Dictionary:
	# The module is it enabled ?
	if self.is_unlock ():
		# Contains the result from the passed checkpoint.
		var checkpoint_last_load_date: Dictionary = self._get_system_key ("__last_load_date__", checkpoint);
		# No last load date data found.
		return self._old_date if checkpoint_last_load_date.empty () else checkpoint_last_load_date;
	# Otherwise.
	else: return Dictionary ({});

"""
	@Description: Returns the date of the last load performed for a given checkpoint. This method uses "__last_load_time__" key to accomplish its task.
		Note that in case of failure, the time of the last upload performed at the file level backup will be returned.
	@Parameters:
		String checkpoint: Contains the name of the point backup to targeted. By default, the active save point is used to do the requested treatment.
"""
func get_last_load_time (checkpoint: String = '') -> Dictionary:
	# The module is it enabled ?
	if self.is_unlock ():
		# Contains the result from the passed checkpoint.
		var checkpoint_last_load_time: Dictionary = self._get_system_key ("__last_load_time__", checkpoint);
		# No last load date data found.
		return self._old_time if checkpoint_last_load_time.empty () else checkpoint_last_load_time;
	# Otherwise.
	else: return Dictionary ({});

"""
	@Description: Returns the total time elapsed for all times the game was opened for a given save point. Note that in case of failure, the time elapsed since
		the game started will be returned. This method uses "__game_time__" key to accomplish its task.
	@Parameters:
		String checkpoint: Contains the name of the point backup to targeted. By default, the active save point is used to do the requested treatment.
"""
func get_game_time (checkpoint: String = '') -> int:
	# The module is it enabled ?
	if self.is_unlock ():
		# Contains the result from the passed checkpoint.
		var checkpoint_game_time: int = self._get_system_key ("__game_time__", checkpoint, -1);
		# Returns the final result with checkpoint definition.
		return self._game_time if checkpoint_game_time == -1 else checkpoint_game_time;
	# Returns an empty dictionary.
	else: return 0;

"""
	@Description: Returns the global time elapsed for all times the game was opened for a given save point. Note that in case of failure, the time elapsed since
		the game started will be returned. This method uses "__game_time__" key to accomplish its task.
	@Parameters:
		String checkpoint: Contains the name of the point backup to targeted. By default, the active save point is used to do the requested treatment.
"""
func get_global_game_time (checkpoint: String = '') -> int:
	# The module is it enabled ?
	if self.is_unlock ():
		# Contains the result from the passed checkpoint.
		var checkpoint_game_time: int = self._get_system_key ("__game_time__", checkpoint, -1);
		# Returns the final result with checkpoint definition.
		return self._game_time if checkpoint_game_time == -1 else (checkpoint_game_time + self._virtual_game_time);
	# Returns an empty dictionary.
	else: return 0;

"""
	@Description: Returns the screenshot generated for a given save point during a save. This method uses "__game_screenshot__" key to accomplish its task.
	@Parameters:
		String checkpoint: Contains the name of the point backup to targeted. By default, the active save point is used to do the requested treatment.
"""
func get_screen_capture (checkpoint: String = ''):
	# The module is it enabled ?
	if self.is_unlock () and self.get_prop ("ScreenCapture"):
		# Contains the screenshot data as an array of bytes.
		var screenshot_data: PoolByteArray = PoolByteArray (self._get_system_key ("__game_screenshot__", checkpoint, Array ([])));
		# The current screen capture data is not empty.
		if not screenshot_data.empty ():
			# Creating an instance of an Image and ImageTexture.
			var screenshot_image: Image = Image.new (); var screenshot_texture: ImageTexture = ImageTexture.new ();
			# Contains the screenshot image texture format.
			var format: int = self.get_real_image_format (self.get_prop ("Format"));
			# Creates the screen capture from his saved data loaded from the game data manager.
			screenshot_image.create_from_data (int (self.get_prop ("Size").x), int (self.get_prop ("Size").y), false, format, screenshot_data);
			# Generates the screen capture of the texture format.
			screenshot_texture.create_from_image (screenshot_image); return screenshot_texture;
	# Returns a null value for others cases.
	return null;

"""@Description: Returns all existing checkpoint(s) from the game data manager."""
func get_checkpoints_list (): return self._game_data.keys ();

"""
	@Description: The given checkpoint(s) are they defined into the game data manager ?
	@Parameters:
		String checkpoint: Contains the name(s) of the checkpoint(s) to targeted.
"""
func has_checkpoints (checkpoints) -> bool:
	# Correcting the passed "checkpoints" parameter value and checks whether all passed checkpoint(s) are exists into the game data manger.
	checkpoints = self._correct_key (checkpoints); checkpoints = Array ([]) if checkpoints == null else checkpoints;
	# Searches all available(s) checkpoint(s) into game data manager and returns a falsy value whether the passed checkpoint(s) is/aren't null.
	for savepoint in checkpoints: if !self._game_data.keys ().has (savepoint): return false; return not checkpoints.empty ();

"""
	@Description: Removes all game data within the manager. Be very careful when you use this function, because there is no backspace after such an operation.
	@Parameters:
		bool on_disk: Do you want to physically remove the hard disk backup file ?
		float delay: What is the dead time before cleaning data ?
"""
func destroy_game_data (on_disk: bool = false, delay: float = 0.0) -> void:
	# The module is it enabled ?
	if self.is_unlock () and not self._game_data.empty ():
		# Waiting for the given delay.
		if delay > 0.0 and self._game_running (): yield (self.get_tree ().create_timer (delay), "timeout"); self.emit_signal ("before_destroy", self._game_data);
		# Calculates total checkpoint an key count to be destroyed.
		var total: Array = Array ([self._game_data.keys (), Array ([])]); for savepoint in self._game_data: total [1] += self._game_data [savepoint].keys ();
		# Clears all game data.
		_game_data.clear (); var source: String = self._correct_key (self.get_prop ("Source")) [0];
		# Should us also delete the save file from the computer hard disk.
		if on_disk:
			# Contains the checksum path of the save file.
			var checksum_path: String = (OS.get_user_data_dir () + '/' + source.get_file ().split ('.') [0] + ".sum");
			# Getting the current path of the game save file and deletes the file from the disk whether that is allowed.
			var path: String = self._correct_path (source); if File.new ().file_exists (path) and Directory.new ().remove (path) != OK: pass;
			# Deletes the checksum file of the current game save file from the computer disk.
			if File.new ().file_exists (checksum_path) and Directory.new ().remove (checksum_path) != OK: pass;
		# Thrown "before_destroy" and "game_data_changed" events.
		self.emit_signal ("after_destroy", Dictionary ({checkpoints = total [0], keys = total [1]})); self.emit_signal ("game_data_changed");

"""
	@Description: Deletes one or more checkpoint(s).
	@Parameters:
		String | PoolStringArray checkpoints: What is/are the name(s) of the checkpoint(s) to be destroyed ? By default, the active checkpoint is targeted.
		float delay: What is the dead time before cleaning data ?
"""
func destroy_checkpoints (checkpoints = null, delay: float = 0.0) -> void:
	# The module is it enabled ?
	if self.is_unlock () and not self._game_data.empty ():
		# Waiting for the given delay.
		if delay > 0.0 and self._game_running (): yield (self.get_tree ().create_timer (delay), "timeout");
		# Correcting the passed checkpoint(s).
		checkpoints = self._correct_key (checkpoints if checkpoints != null else self.get_prop ("Checkpoint"));
		# Checks the final result of the correction.
		checkpoints = Array ([]) if not checkpoints is Array else checkpoints; var total: Array = Array ([Array ([]), Array ([])]);
		# Thrown "before_destroy" event.
		self.emit_signal ("before_destroy", checkpoints);
		# Removes all passed checkpoint(s) from the active loaded game data.
		for savepoint in checkpoints:
			# Calculates total checkpoint and key count to be destroyed and adds the current checkpoint to the checkpoint list.
			if self._game_data.has (savepoint): total [1] += self._game_data [savepoint].keys (); if _game_data.erase (savepoint): total [0].append (savepoint);
		# There are some destruction(s) ?
		if total [0].size () > 0:
			# Thrown "after_destroy" event whether some checkpoint(s) is/are destroyed and also "game_data_changed" event.
			self.emit_signal ("after_destroy", Dictionary ({checkpoints = total [0], keys = total [1]})); self.emit_signal ("game_data_changed");

"""
	@Description: Returns all data present within a checkpoint.
	@Parameters:
		String cname: Contains a checkpoint name. By default, the active checkpoint will be used to do the job.
		bool json: Do you want to get data as json format ?
"""
func get_checkpoint_data (checkpoint: String = '', json: bool = true):
	# The module is it enabled ?
	if self.is_unlock ():
		# Getting the active checkpoint whether no checkpoint has been donated.
		var cname: String = self._correct_key (checkpoint if not checkpoint.empty () else self.get_prop ("Checkpoint")) [0];
		# Returns the final value of the current loaded game data.
		return (self._game_data [cname] if !json else JSON.print (self._game_data [cname], "\t")) if self._game_data.has (cname) else null;
	# Returns a null value for other statements ?
	return null;

"""
	@Description: Returns all informations about the game's data handler.
	@Parameters:
		bool json: Do you want to get data as json format ?
"""
func get_game_data (json: bool = true):
	# The module is it enabled ?
	if self.is_unlock ():
		# Returns all existing data from the game data manager.
		if !json: return self._game_data; else: return JSON.print (self._game_data, "\t");
	# Returns a null value.
	else: return null;

"""
	@Description: Determines if one or more identifier(s) are indeed defined in one or more checkpoint(s).
	@Parameters:
		String | PoolStringArray keys: Contains all identifier(s) to seek.
		String | PoolStringArray checkpoints: What is/are the target checkpoint(s) name(s) ? By default, the active checkpoint will be used to perform the job.
"""
func has_keys (keys, checkpoints = null) -> bool:
	# The module is it enabled ?
	if self.is_unlock ():
		# Correcting the passed checkpoint(s).
		checkpoints = self._correct_key (checkpoints if checkpoints != null else self.get_prop ("Checkpoint"));
		# Correcting the passed key(s).
		keys = self._correct_key (keys); keys = Array ([]) if not keys is Array else keys;
		# Checks the final result.
		checkpoints = Array ([]) if not checkpoints is Array else checkpoints;
		# Searches each key on the given checkpoint.
		for key in keys:
			# Checks key existance into all available(s) checkpoint(s).
			for checkpoint in checkpoints:
				# If ever a key is not defined on the current checkpoint.
				if !self._game_data.has (checkpoint): return false; elif !self._game_data [checkpoint].has (key): return false;
		# Determines whether some key(s) and checkpoint(s) have/has been donated.
		return !keys.empty () and !checkpoints.empty ();
	# Otherwise.
	else: return false;

"""
	@Description: Removes one or more identifier(s) in one or more checkpoint(s). Note that the value of identifier(s) will also be deleted.
		Note that the value of the identifiers will also be deleted.
	@Parameters:
		String | PoolStringArray keys: Contains all identifier(s) to seek. If no key has been referred, we will attend a cleaning full passed checkpoint(s).
		String | PoolStringArray checkpoints: What is/are the target checkpoint(s) name(s) ? By default, we will target the active checkpoint to perform the processing.
		float delay: What is the dead time before updating the game data manager ?
"""
func destroy_keys (keys = null, checkpoints = null, delay: float = 0.0) -> void:
	# The module is it enabled ?
	if self.is_unlock ():
		# Waiting for the given delay.
		if delay > 0.0 and self._game_running (): yield (self.get_tree ().create_timer (delay), "timeout");
		# Correcting the passed checkpoint(s).
		checkpoints = self._correct_key (checkpoints if checkpoints != null else self.get_prop ("Checkpoint"));
		# Checks the final result.
		checkpoints = Array ([]) if not checkpoints is Array else checkpoints; var total: Array = Array ([]);
		# Thrown "before_destroy" event.
		self.emit_signal ("before_destroy", checkpoints);
		# The given "keys" parameter is null.
		if keys == null:
			# Destroys all found key(s) for all given checkpoint(s).
			for savepoint in checkpoints:
				# Remove all found key(s) from this current checkpoint.
				if self._game_data.has (savepoint):
					# Calculates total keys to be removed.
					total += self._game_data [savepoint].keys (); _game_data [savepoint] = Dictionary ({});
		# Otherwise.
		else:
			# Correcting the passed key(s).
			keys = self._correct_key (keys); keys = Array ([]) if not keys is Array else keys;
			# Destroying all passed key(s) from all available(s) checkpoint(s).
			for key in keys:
				# Searches some potential(s) checkpoint(s) that contains the given key(s).
				for savepoint in checkpoints: if self._game_data.has (savepoint) && _game_data [savepoint].erase (key): total.append (key);
		# Thrown "after_destroy" event to warns all listeners about potentials destructions.
		if total.size () > 0:
			# Thrown also "game_data_changed" event for generic changings.
			self.emit_signal ("after_destroy", Dictionary ({keys = total, checkpoints = Array ([])})); self.emit_signal ("game_data_changed");

"""@Description: Returns the total number data set within the game data manager."""
func get_total_data_count () -> int:
	# The module is it enabled ?
	if self.is_unlock ():
		# Returns the total datum count from the game manager.
		var total: int = 0; for savepoint in self._game_data: total += self._game_data [savepoint].size (); return total;
	# Otherwise.
	else: return 0;

"""
	@Description: Updates the data within a given checkpoint.
	@Parameters:
		Dictionary data: What are different data that constitute the passed checkpoint.
		String checkpoint: What is the name of the checkpoint to modified ? Note that if the latter is not defined in the manager, it will be automatically created.
			By default, we will target the active checkpoint to perform the processing.
		float delay: What is the dead time before updating the game data manager ?
"""
func set_checkpoint_data (data: Dictionary, checkpoint: String = '', delay: float = 0.0) -> void:
	# The module is it enabled ?
	if self.is_unlock ():
		# Corrects the given checkpoint name.
		checkpoint = self._correct_key (checkpoint if not checkpoint.empty () else self.get_prop ("Checkpoint")) [0];
		# The passed checkpoint name length is not empty.
		if not checkpoint.empty ():
			# Waiting for the given delay.
			if delay > 0.0 and self._game_running (): yield (self.get_tree ().create_timer (delay), "timeout");
			# Updates the target checkpoint to the passed data and thrown "game_data_changed" event.
			_game_data [checkpoint] = data; self.emit_signal ("game_data_changed");
		# Error message.
		else: self.output ("Missing checkpoint name.", Message.ERROR, self);

"""
	@Description: Opens the documentation associated with the class in question.
	@Parameters:
		Node object: Which node will be considered to perform the different operations ?
		String feature: The documentation will target which functionality of style ?
		float delay: What is the downtime before the opening of the documentation ?
"""
static func open_doc (object: Node, feature: String = '', delay: float = 0.0) -> void:
	# Waiting for the user delay.
	if delay > 0.0 and !Engine.editor_hint: yield (object.get_tree ().create_timer (delay), "timeout");
	# Open the default user browser with the class documentation path.
	if OS.shell_open (get_source () + (('#' + feature.lstrip ('(').rstrip ('(').lstrip (')').rstrip (')')) if not feature.empty () else '')) != OK: pass;
