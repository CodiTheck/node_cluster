"""
	@author: Obrymec
	@company: CodiTheck
	@famework: Godot Mega Assets
	@compatibility: Godot 3.x.x
	@platform: ANDROID || IOS || MACOSX || UWP || HTML5 || WINDOWS || LINUX
	@license: MIT
	@source: https://godot-mega-assets.herokuapp.com/docs/general/languages
	@language: GDscript
	@dimension: 2D || 3D
	@level: Fx
	@category: General
	@saveable: True
	@type: Languages
	@version: 0.4.5
	@created: 2021-08-24
	@updated: 2021-08-31
"""
################################################################################### [Main class] #############################################################################
"""
	@Description: LanguagesFx is a module designed for managing the languages of a game. It ensures the loading of the different languages of the game. These languages
		are decided by the developer (YOU). In other words, it is the developer himself who integrates the different languages he can load thanks to this module. This
		will allow it to support as many languages as possible.
"""
tool class_name LanguagesFx, "languages.svg" extends Recordable;

################################################################################### [Attributes] #############################################################################
# Contains all basics properties of a Godot Mega Assets module.
func _basic_module_properties () -> void:
	# Contains the module title category.
	self.bind_prop (Dictionary ({title = "LanguagesFx", index = 0}));
	"""
		@Description: Contains the different paths that this module supports. These paths represent the possible places where you can access to the file (.csv).
			The possible values are those defined within the method "get_os_dir ()" from "MegaAssets" class. The scope of this field is only on the Godot engine.
	"""
	self.bind_prop (Dictionary ({source = "TargetPath", value = 0, type = TYPE_INT, attach = "TargetPath", min = 0,
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])}), max = 9,
		dropdown = Dictionary ({behavior = NaughtyAttributes.SYSTEM_DIR, paths = true})
	}));
	"""
		@Description: Contains the path pointing to the language file at take charge. The extension of this file must be (.csv). The scope of this field is only
			on the Godot engine.
	"""
	self.bind_prop (Dictionary ({source = "Input", value = String (''), type = TYPE_STRING, attach = "Input",
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])}), require = Dictionary ({
			statement = "AutoCompile && !Input && !_game_running () && !Output", actions = {message = "Can't have an empty value on this field.", type = Message.WARNING}
		})
	}));
	"""@Description: Contains the different separators supported by this module. The scope of this field is only on the Godot engine."""
	self.bind_prop (Dictionary ({source = "Separator", value = 0, type = TYPE_INT, attach = "Separator", min = 0, max = 2,
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])}), dropdown = PoolStringArray (["COMMA", "SEMICOLON", "TAB"])
	}));
	"""@Description: Contains the path pointing to the file(s) of language in (.lang) format. The scope of this field is only on the Godot engine."""
	self.bind_prop (Dictionary ({source = "Output", value = String (''), type = TYPE_STRING, attach = "Output",
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])})
	}));
	"""@Description: Do you want to put a security on the language file(s) ? The scope of this field is only on the Godot engine."""
	self.bind_prop (Dictionary ({source = "Security", value = true, type = TYPE_BOOL, attach = PoolStringArray (["Security", "Level", "Pass", "GeneratePassword"]),
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])})
	}));
	"""@Description: Contains the different levels possible security for the creation of file(s) in (.lang) format. The scope of this field is only on the Godot engine."""
	self.bind_prop (Dictionary ({source = "Level", value = SecurityLevel.NORMAL, type = TYPE_INT, dropdown = SecurityLevel.keys (), min = 0, max = 2, showif = "Security",
		attach = PoolStringArray (["Level", "Pass", "GeneratePassword"]), changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])}),
		require = Dictionary ({statement = "Level == 0 && Security", actions = Array ([Dictionary ({slot = "Security", value = false}),
			Dictionary ({slot = "Level", value = Dictionary ({visible = false, value = 1})})])
		})
	}));
	"""@Description: Contains the password to be used to secure language data. You can automatically generate a password via "GeneratePassword" button."""
	self.bind_prop (Dictionary ({source = "Pass", value = "?generate_key ()", type = TYPE_STRING, attach = "Pass", showif = "Security", require = Array ([
			{statement = "AutoCompile && Security && !Pass", actions = {message = "We recommend you to donate a password to get more security.", type = Message.WARNING}},
			{statement = "AutoCompile && _pass_size () > 32", actions = {message = "The password length must not be greater than 32", type = Message.ERROR}}
		]), changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])})
	}));
	"""@Description: Contains the language to be loaded. Note that the values you enter here will have to support the elements that will be
			generated in the "Output". You have the option of targeting a language by giving the name corresponding to its file.
	"""
	self.bind_prop (Dictionary ({source = "ActiveLanguage", value = String (''), type = TYPE_STRING, attach = "ActiveLanguage",
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])}), saveable = true,
		require = Dictionary ({statement = "_game_running ()", actions = Dictionary ({slot = "_load_language ()"})})
	}));
	"""
		@Description: Do you want to automatically generate the matches (.lang) of the file (.csv) ? Note that this option, once enabled, listens to the editing of
			the source file in order to generate real time, the equivalents (.lang). You will therefore no longer be required to press the button "GenerateLangFile(s)"
			each time you progress in editing from your source. The scope of this field is only on the Godot engine. However, deactivate this feature before each
			execution of the game to avoid unnecessary listening.
	"""
	self.bind_prop (Dictionary ({source = "AutoGeneration", value = false, type = TYPE_BOOL, attach = ["AutoGeneration", "Interval"],
		changed = Dictionary ({callback = "_auto_generation ()", actions = Dictionary ({
			slot = "module_values_changed ()", params = Array (["AutoGeneration", Dictionary ({callback = "get_prop ()", params = "AutoGeneration"})])
		})}), require = Array ([
			Dictionary ({statement = "AutoGeneration", actions = Dictionary ({message = "Lang file(s) auto generation started !", type = Message.NORMAL})}),
			Dictionary ({statement = "!AutoGeneration", actions = Dictionary ({message = "Lang file(s) auto generation stoped !", type = Message.NORMAL})})
		])
	}));
	"""
		@Description: What is the dead time before each generation ? Note that the minimum value of this field is "0.1" seconds and not is only enabled when the
			"AutoGeneration" option is enabled. The scope of this field is only on the Godot engine.
	"""
	self.bind_prop (Dictionary ({source = "Interval", value = 3.0, type = TYPE_REAL, min = 0.1, attach = "Interval", showif = "AutoGeneration",
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])}), visible = false,
	}));
	"""
		@Description: Would you like to automatically generate a password ? At this level, the value of the field "Pass" will be updated on each generation.
			The scope of this field is only on the Godot engine.
	"""
	self.bind_prop (Dictionary ({source = "GeneratePassword", attach = "GeneratePassword", button = "generate_password ()", showif = "Security"}));
	"""@Description: Button generating the equivalents (.lang) of the source file (.csv). The scope of activity of this property is only on the Godot engine."""
	self.bind_prop (Dictionary ({source = "GenerateLangFile(s)", attach = "GenerateLangFile(s)", button = "generate_lang_files ()"}));
	# Attaches "Input" and "Pass" properties to "AutoCompile" property.
	self.override_prop (Dictionary ({attach = PoolStringArray (["AutoCompile", "Input", "Pass"])}), "AutoCompile");

#################################################################################### [Signals] ###############################################################################
"""@Description: Called when a lang file is not defined on the computer hard disk."""
signal lang_file_not_found (data);
"""@Description: Called when a lang file was corrupted from the outside."""
signal lang_file_corrupted (data);
"""@Description: Called while a lang file is being loaded."""
signal lang_file_loading (data);
"""@Description: Called when there are some difficulties to open a lang file or that its access has been denied."""
signal lang_file_cant_open (data);
"""@Description: Called when the language data has changed."""
signal language_changed (data);

############################################################################## [Particulars variables] #######################################################################
# Contains the active language data.
var _language_data: Dictionary = Dictionary ({}) setget _unsetable_var_error;
# Checks whether there are some error(s) on lang file(s) generation.
var _has_errors: bool = false setget _unsetable_var_error;
# Contains all generated lang file(s) from the given output.
var _gen_langs: PoolStringArray = PoolStringArray ([]) setget _unsetable_var_error;
# Contains the old csv file checksum.
var _old_csv_checksum: String = String ('') setget _unsetable_var_error;
# Contains all constants about csv file separator.
enum Divider {COMMA = 0, SEMICOLON = 1, TAB = 2};

############################################################################### [Properties manager] #########################################################################
# Returns the game state (Running/Editor).
func _game_running (): return not Engine.editor_hint;

# Returns the password length.
func _pass_size (): return self.get_prop ("Pass").length ();

# Unsetable module variables.
func _unsetable_var_error (_new_value) -> void: self.output ("Can't change value of this variable.", Message.ERROR, self);

############################################################################## [Logic and main tasks] ########################################################################
# This method is called on game initialization and before all nodes instanciation.
func _init (): self._basic_module_properties ();

# Called before ready method run.
func _enter_tree ():
	# Checks the unicity of this module.
	self.check_unique (self.get_class ());
	# The module is now out of reach of scene changes.
	if self.get_parent ().name == "DontDestroyOnLoad":
		# Gets all generated lang file(s).
		self._update_active_lang_file (self._correct_output ());
		# Connects this module reference to "after_load_data" signal.
		if !self.is_connected ("after_load_data", self, "_load_language") && self.connect ("after_load_data", self, "_load_language") != OK: pass;
		# Connects this module reference to "enabled" signal.
		if !self.is_connected ("enabled", self, "_load_language") && self.connect ("enabled", self, "_load_language") != OK: pass;
		# The module is enabled.
		if self.is_unlock () and self._check_game_data_manager (): self._load_language ();

# Checks the target data manager run constraints.
func _check_game_data_manager () -> bool:
	# No data manger specified.
	if self.get_prop ("DataManager") <= GameDataManager.NONE: return true;
	# For any found data mnager.
	elif self._data_manager is SaveLoadFx:
		# The data manager isn't enabled.
		if !self._data_manager.is_unlock (): return true;
		# Auto load game data is disable on the target data mnager.
		elif !self._data_manager.get_prop ("LoadAllData") && !Array (self._data_manager.get_prop ("TargetScenes")).has (self.get_tree ().current_scene.name): return true;
		# The data manager is activate.
		elif not self.get_prop ("LoadData"): return true; else: return false;
	# For other cases.
	else: return true;

# Returns the corresponding separator symbol from the given separator constant.
func _get_separator_symbol (separator: int) -> String:
	# Checks the given separator value.
	if separator <= Divider.COMMA: return ','; elif separator == Divider.SEMICOLON: return ';'; else: return "\t";

# Corrects the passed module output.
func _correct_output () -> String:
	# Contains the user output.
	var output: String = self.get_prop ("Output").replace ('\\', '/').replace (' ', '').lstrip ('/').rstrip ('/');
	# Corrects the passed output.
	output = (("res://" + output + '/') if not output.begins_with ("res://") else (output + '/')).get_base_dir ();
	# Returns the final result with a certain constraints.
	return "res:/" if self.get_prop ("Output").empty () else output;

# Corrects the user path to get better work.
func _correct_input () -> String:
	# Contains the target system path. Returns the corrected form of the given path with input value module property.
	var target_path: String = self.get_prop ("TargetPath", true); var input: String = self.get_prop ("Input").lstrip ('/').rstrip ('/');
	# Returns the corrected path with the given source value.
	return (target_path + input) if target_path.ends_with ('/') else (target_path + '/' + input);

# Follows the lang file serialization progression.
func _lang_file_serializer (path: String, progress: int, error) -> void:
	# An error has been detected.
	if error != null:
		# Error message.
		self.output ((error.message + " ERR_CODE::" + error.code), error.type, self); _has_errors = true;
	# Otherwise.
	elif progress == 100 && !self._has_errors: self.output (('{' + path + "} generation successfully !"), Message.NORMAL, self);

# Follows lang file deserialization and progression.
func _lang_file_deserializer (path: String, is_loading: bool, loaded_data_count: int, _result, error) -> void:
	# An error has been detected.
	if error != null:
		# Contains the error data.
		var error_data: Dictionary = Dictionary ({"message": (self.get_object_prefix (self) + ": " + error.message), "type": error.type, "path": path});
		# The save file to be loaded is corrupted.
		if error.code == ERR_FILE_CORRUPT: self.emit_signal ("lang_file_corrupted", error_data);
		# The save file not found.
		elif error.code == ERR_FILE_NOT_FOUND: self.emit_signal ("lang_file_not_found", error_data);
		# The save file cannot be opened.
		else: self.emit_signal ("lang_file_cant_open", error_data);
	# Otherwise.
	else: self.emit_signal ("lang_file_loading", Dictionary ({"path": path, is_over = is_loading, progress = loaded_data_count}));

# Updates active language dropdown for potentials changes.
func _update_active_lang_file (output: String):
	# Creates a new directory.
	var directory: Directory = Directory.new (); _gen_langs = PoolStringArray ([]);
	# Checks output value.
	if !output.empty () and directory.dir_exists (output) and directory.open (output) == OK and directory.list_dir_begin () == OK:
		# Initializes directory and get the first content.
		var content: String = directory.get_next ();
		# The current content is not null.
		while not content.empty ():
			# The current content is a lang file.
			if !directory.current_is_dir () and content.ends_with (".translation"): _gen_langs.append (output + '/' + content);
			# Go to the next content.
			content = directory.get_next ();
		# Closes directory stream.
		directory.list_dir_end ();

# Generates automatically some lang file(s).
func _auto_generation () -> void:
	# The game isn't running.
	if not self._game_running ():
		# Checks auto generation value.
		if self.get_prop ("AutoGeneration"):
			# Contains the generation interval.
			var interval: float = self.get_prop ("Interval");
			# Waiting for the given interval and re-generates all passed lang file(s).
			if interval > 0.0: yield (self.get_tree ().create_timer (interval), "timeout"); self.generate_lang_files (); self._auto_generation ();
	# Otherwise.
	else:
		# Warning message.
		self.output ("Can't automatically generate some lang file(s) when the game is running.", Message.WARNING, self);
		# Disables "AutoGeneration" option.
		self.set_prop ("AutoGeneration", false);

# Returns the corresponding lang file index from a few name.
func _get_lang_file_index (lang_file_name: String) -> int:
	# Searches the given name into the loaded lang file(s) list cach.
	for x in self._gen_langs.size (): if self._gen_langs [x].find (lang_file_name) != -1: return x; return -1;

# Loads a lang file from the disk to the language maanger.
func _load_language () -> void:
	# The module is it enabled ?
	if self.is_unlock ():
		# Contains the active language value.
		var active_language: String = self.get_prop ("ActiveLanguage"); var loaded_data: Dictionary = Dictionary ({});
		# Generates the lang file index from the active language.
		var index: int = self._get_lang_file_index (active_language) if not self.is_number (active_language) else int (active_language);
		# Checks the current generated index.
		if self.is_range (index, 0, (len (self._gen_langs) - 1)):
			# Checks the security.
			if self.get_prop ("Security"): loaded_data = self.deserialize (self._gen_langs [index], self, self.get_prop ("Pass"),
				SecurityMethod.GODOT, self.get_prop ("Level"), Dictionary ({method = "_lang_file_deserializer ()"})
			);
			# No security found.
			else: loaded_data = self.deserialize (self._gen_langs [index], self, '', SecurityMethod.NONE, -1, Dictionary ({method = "_lang_file_deserializer ()"}));
		# Checks data hashes.
		if loaded_data.hash () != self._language_data.hash ():
			# Updates language data and thrown "language_changed" event.
			_language_data = loaded_data; self.emit_signal ("language_changed", self._language_data);

############################################################################### [Availables features] ########################################################################
"""@Description: Returns the version a module."""
static func get_version () -> String: return "0.4.5";

"""@Description: Returns all origins of a module."""
static func get_origin_name () -> String: return "MegaAssets.Module.Indestructible.Recordable.LanguagesFx";

"""@Description: What is the category of this module ?"""
static func get_category_name () -> String: return "General";

"""@Description: Returns a module class type."""
func get_class (): return "LanguagesFx";

"""@Description: Returns the web link of "Godot Mega Assets" framework."""
static func get_source () -> String: return "https://godot-mega-assets.herokuapp.com/docs/general/languages";

"""
	@Description: Generates at hazard, a password according to the configurations present at its level. The value of the field "Pass" will be updated on
		each generation. Note that you can't generate a password when the game is running.
	@Parameters:
		float delay: What is the dead time before generation ?
"""
func generate_password (delay: float = 0.0) -> void:
	# The game is it running ?
	if not self._game_running ():
		# Waiting for the given delay.
		if delay > 0.0 and self._game_running (): yield (self.get_tree ().create_timer (delay), "timeout");
		# Generates a password that respect the imposed constraints.
		randomize (); self.override_prop (Dictionary ({value = self.generate_key (int (rand_range (16, 33)))}), "Pass");
	# Warning message.
	else: self.output ("Can't generate a password when the game is running.", Message.WARNING, self);

"""
	@Description: Generates the equivalents (.translation) of the source file (.csv) that have been specified. Warning ! This method only works in edit mode.
	@Parameters:
		float delay: What is the dead time before generation(s) ?
"""
func generate_lang_files (delay: float = 0.0) -> void:
	# The game is it running.
	if not self._game_running ():
		# Waiting for the given delay.
		if delay > 0.0 and self._game_running (): yield (self.get_tree ().create_timer (delay), "timeout");
		# Contains some useful data.
		var data: Array = Array ([self._correct_input (), self.get_prop ("Input").get_file (), self._correct_output ()]);
		# Contains the current csv file MD5 checksum.
		var csv_file_md5_checksum: String = File.new ().get_md5 (data [0]);
		# Checks the csv file checksum.
		if csv_file_md5_checksum != self._old_csv_checksum or csv_file_md5_checksum.empty ():
			# Starts verbose.
			self.output ("Starting lang file(s) generation...", Message.NORMAL, self); _has_errors = false;
			# Loads the passed csv file.
			var csv_data: Array = self.load_csv_file (data [0], self._get_separator_symbol (self.get_prop ("Separator")));
			# The loaded data is not empty.
			if not csv_data.empty ():
				# Checks user output.
				if not data [2].empty ():
					# Creating all usefull folder(s) with the given output and get the csv file name.
					self.create_folders_from (data [2], self);
					# Generates all available lang file(s).
					for lang in csv_data:
						# Gets the csv colonne and generate the current lang file name.
						var csv_colonne = lang.keys () [0]; var lang_fname: String = (data [1].split ('.') [0] + '_' + csv_colonne + ".translation");
						# Generates the current lang file path.
						var full_path: String = (data [2] + '/' + lang_fname); self.output (("Generating {" + full_path + "}..."), Message.NORMAL, self);
						# Serializes the current language data into the current lang file with godot security.
						if self.get_prop ("Security"): self.serialize (lang [csv_colonne], full_path, self, self.get_prop ("Pass"), SecurityMethod.GODOT,
							self.get_prop ("Level"), Dictionary ({method = "_lang_file_serializer ()"})
						);
						# No security has been found.
						else: self.serialize (lang [csv_colonne], full_path, self, '', SecurityMethod.NONE, -1, Dictionary ({method = "_lang_file_serializer ()"}));
						# Some errors has been detected on generating lang file(s).
						if self._has_errors: break;
					# No errors thrown on lang file(s) generation. 
					if not self._has_errors:
						# Warns the developper.
						self.output ("Lang file(s) generation successfully !", Message.NORMAL, self);
						# Updates the active language list and the old csv file checksum.
						self._update_active_lang_file (data [2]); _old_csv_checksum = csv_file_md5_checksum;
				# Otherwise.
				else:
					# Error message.
					self.output ("Missing lang file(s) output.", Message.ERROR, self); _has_errors = true;
			# Error message.
			else: _has_errors = true;
			# An error has been detected.
			if self._has_errors:
				# Error message.
				self.output ("Failed to generate lang file(s).", Message.ERROR, self); _gen_langs = PoolStringArray ([]);
	# Warning message.
	else: self.output ("Can't generate lang file(s) when the game is running.", Message.WARNING, self);

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
		_gen_langs = PoolStringArray ([]); _language_data.clear (); _old_csv_checksum = ''; _has_errors = false;
		# Disconnects this module reference from "enabled" signal.
		if self.is_connected ("enabled", self, "_load_language") && self.disconnect ("enabled", self, "_load_language") != OK: pass;
		# Disconnects this module reference from "after_load_data" signal.
		if self.is_connected ("after_load_data", self, "_load_language") && self.disconnect ("after_load_data", self, "_load_language") != OK: pass;
		# Restarts the module.
		self._enter_tree (); self._ready ();

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
			# Waiting for the given delay and loads the active language data.
			if delay > 0.0 and self._game_running (): yield (self.get_tree ().create_timer (delay), "timeout"); self._load_language ();
			# Warns the developer about loading language data.
			self.output ("The active language data has been loaded !", Message.NORMAL, self);
		# On game running.
		else: self.output ("Can't make a module simulation when the game is running.", Message.WARNING, self);

"""
	@Description: Returns the value associated with a given identifier according to the active language.
	@Parameters:
		String key: Contains the identifier of the value to be returned.
		String default: What value should we return in the event of a problem ?
"""
func get_value_at (key: String, default = "Null") -> String:
	# The module is it enabled ?
	if self.is_unlock () and !self._language_data.empty () and self._language_data.has (key):
		# Contains the passed key value from the language data and checks the value of the passed key.
		var value: String = self._language_data [key]; return value if !value.empty () and value != "Null" else default;
	# Returns the default value for other cases.
	return default;

"""
	@Description: Returns all data associated with the active language.
	@Parameters:
		bool json: Do you want to get data as json format ?
"""
func get_language_data (json: bool = true):
	# The module is it enabled ?
	if self.is_unlock ():
		# Returns all existing data from the game data manager.
		if !json: return self._language_data; else: return JSON.print (self._language_data, "\t");
	# Returns a null value.
	else: return null;

"""
	@Description: Determines if one or more identifier(s) are indeed defined in the language manager.
	@Parameters:
		String | PoolStringArray keys: Contains all identifier(s) to seek.
"""
func has_keys (keys) -> bool:
	# Returns the final value whether the module is enabled.
	return self._language_data.has_all (Array (PoolStringArray (Array ([keys]) if !self.is_array (keys) else Array (keys)))) if self.is_unlock () else false;

"""@Description: Returns the names of all languages supported in the module."""
func get_language_list () -> PoolStringArray:
	# The module is it enabled ?
	if self.is_unlock ():
		# Contains the final result and gets the language cach, all lang file(s) name(s) from their path.
		var result: PoolStringArray = PoolStringArray ([]); for path in self._gen_langs: result.append (path.get_file ().split ('.') [0]); return result;
	# Otherwise.
	else: return PoolStringArray ([]);

"""
	@Description: Reloads the active language data into the game languages manager.
	@Parameters:
		float delay: What is the dead time before reloading ?
"""
func reload_language (delay: float = 0.0) -> void:
	# The module is it enabled ?
	if self.is_unlock ():
		# Waiting for the given delay.
		if delay > 0.0 and self._game_running (): yield (self.get_tree ().create_timer (delay), "timeout");
		# Clears the old language data and loads the target language.
		_language_data.clear (); self._load_language ();

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
