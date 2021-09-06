"""
	@author: Obrymec
	@company: CodiTheck
	@famework: Godot Mega Assets
	@compatibility: Godot 3.x.x
	@platform: ANDROID || IOS || MACOSX || UWP || HTML5 || WINDOWS || LINUX
	@license: MIT
	@source: https://godot-mega-assets.herokuapp.com/docs/bases/module
	@language: GDscript
	@dimension: 2D || 3D
	@type: Module
	@version: 0.2.6
	@created: 2021-06-12
	@updated: 2021-08-31
"""
################################################################################### [Main class] #############################################################################
"""@Description: Module is a class that represents some basics functionalities common to all modules of the Godot Mega Assets framework."""
tool class_name Module, "module.svg" extends MegaAssets;

################################################################################### [Attributes] #############################################################################
# Contains all basics properties of a Godot Mega Assets module.
func _basics_module_properties () -> void:
	# Contains the module title category.
	self.bind_prop (Dictionary ({title = "Module", index = 0}));
	"""@Description: Checks the operating status of a module (ON/OFF)."""
	self.bind_prop (Dictionary ({source = "Enabled", value = true, type = TYPE_BOOL, attach = "Enabled",
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null]), actions = Dictionary ({slot = "_module_activation ()"})})
	}));
	"""@Description: Controls the verification of values ​​of the differents inputs of a module. This option is only available in edit mode."""
	self.bind_prop (Dictionary ({source = "AutoCompile", value = true, type = TYPE_BOOL, attach = "AutoCompile",
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])})
	}));
	"""@Description: Enumeration condition the execution environment of a module. This option restricts the scope of execution of a module."""
	self.bind_prop (Dictionary ({source = "ActivityZone", dropdown = ActivityArea.keys (), value = 2, attach = "ActivityZone", min = 0, max = 2,
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null]), actions = Dictionary ({slot = "_module_activation ()"})})
	}));
	"""
		@Description: Would you like the module in question supports the multiplayer system provided by this framework ? Note that for this works, it will
			defraud that you use the load module to manage a game configured in multiplayer mode.
	"""
	self.bind_prop (Dictionary ({source = "Multiplayer", value = false, type = TYPE_BOOL, attach = "Multiplayer",
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])})
	}));
	"""
		@Description: Boolean which, once activated, gives an overview of the functioning of the module in question. In other words, this option accomplishes
			the task main of a module according to the configurations carried out at its level. This option is not present in all cases. It depends on the nature
			and operation of the module in question. The scope of this field is only on the Godot engine.
	"""
	self.bind_prop (Dictionary ({source = "Simulate", attach = "Simulate", button = Dictionary ({actions = Dictionary ({slot = "simulate ()"})})}));
	"""@Description: Controls the reset of values ​​of the different inputs of a module. The scope of this field is only on the Godot engine."""
	self.bind_prop (Dictionary ({source = "ResetValues", attach = "ResetValues", button = Dictionary ({actions = Dictionary ({slot = "reset_values ()"})})}));

#################################################################################### [Signals] ###############################################################################
"""@Description: Trigger when a module is enabled."""
signal enabled (node);
"""@Description: Trigger when a module is disabled."""
signal disabled (node);
"""@Description: Trigger after a module initialisation."""
signal start (node);
"""@Description: Trigger when a module inputs values changed."""
signal values_changed (node);
"""@Description: Trigger when a child or some children of a module has/have been added or deleted."""
signal children_changed (node);
"""@Description: Trigger when a module parent changed."""
signal parent_changed (node);

############################################################################## [Particulars variables] #######################################################################
# Contains the old module child count.
var _old_child_count: int = 0 setget _unsetable_var_error;
# Contains the old module children.
var _old_children: Array = Array ([]) setget _unsetable_var_error;

############################################################################### [Properties manager] #########################################################################
# Unsetable module variables.
func _unsetable_var_error (_new_value) -> void: self.output ("Can't change value of this variable.", Message.ERROR, self);

############################################################################## [Logic and main tasks] ########################################################################
# This method is called on game initialization and before all nodes instanciation.
func _init (): self._basics_module_properties ();

# Calls on editor notification.
func _notification (what): self.listen_notifications (what);

# Gets all script variables list.
func _get_property_list (): return self.get_properties ();

# Calls to return property value changed.
func _get (property): return self.get_prop (property);

# Calls to set property editor value.
func _set (property, value): self.set_prop (property, value, true, 0.0);

# Called before ready method run.
func _enter_tree ():
	# Enables module "AutoCompile" property wether the game is running and initialize all usefull privates module properties.
	if !Engine.editor_hint: self.set_prop ("AutoCompile", true); self._initialize_sub_properties ();

# This method is called after game ready.
func _ready ():
	# The module is it enabled ?
	if self.is_unlock ():
		# Waiting for the first idle frame before call "start" signal.
		if !Engine.editor_hint: yield (self.get_tree (), "idle_frame");
		# Thrown "start" event.
		if !self.is_dont_destroy_mode (): self.emit_signal ("start", self); else: self.emit_signal ("start");

# This method is called on every game frames.
func _process (_delta): if self.is_unlock (): self._check_children_structure ();

# This method check whether module children or parent has been changed.
func _check_children_structure () -> void:
	# Checking the current module child count at all times.
	if self.get_child_count () != self._old_child_count || hash (self.get_children ()) != hash (self._old_children):
		# Thrown "children_changed" event.
		if !self.is_dont_destroy_mode (): self.emit_signal ("children_changed", self); else: self.emit_signal ("children_changed");
		# Updates the old module child count to the current child count and the old module children to the current children.
		_old_child_count = self.get_child_count (); _old_children = self.get_children ();

# Manages all module privates properties creation.
func _initialize_sub_properties () -> void:
	# Getting the child count of the module and his children.
	_old_child_count = self.get_child_count (); _old_children = self.get_children ();
	# Checking module parent.
	if self.is_game_initialised () and self.is_unlock ():
		# Thrown "parent_changed" event.
		if !self.is_dont_destroy_mode (): self.emit_signal ("parent_changed", self); else: self.emit_signal ("parent_changed");

# This method is called when module is disabled/enabled.
func _module_activation () -> void:
	# Checks module activation.
	if self.is_unlock ():
		# Thrown "enabled" event.
		if !self.is_dont_destroy_mode (): self.emit_signal ("enabled", self); else: self.emit_signal ("enabled");
	else:
		# Thrown "disabled" event.
		if !self.is_dont_destroy_mode (): self.emit_signal ("disabled", self); else: self.emit_signal ("disabled");

############################################################################### [Availables features] ########################################################################
"""@Description: Returns the version a module."""
static func get_version () -> String: return "0.2.6";

"""@Description: Returns all origins of a module."""
static func get_origin_name () -> String: return "MegaAssets.Module";

"""@Description: Returns a module class type."""
func get_class (): return "Module";

"""@Description: Returns the web link of "Godot Mega Assets" framework."""
static func get_source () -> String: return "https://godot-mega-assets.herokuapp.com/docs/bases/module";

"""
	@Description: Resets values ​​of the differents inputs of a module.
	@Parameters:
		float delay: What is the timeout before reseting module properties ?
"""
func reset_values (delay: float = 0.0) -> void: self.reset_props_value ("ResetValues", null, delay);

"""
	@Description: This method is used when any module property value has been changed.
	@Parameters:
		String name: Contains the property name which value has been changed.
		Variant value: Contains the new property value.
"""
func module_values_changed (name: String, value, delay: float = 0.0) -> void:
	# Enabled module "AutoCompile" property wether the game is running.
	if !Engine.editor_hint: self.set_prop ("AutoCompile", true);
	# The module is it enabled ?
	if self.is_unlock ():
		# Waiting for the given delay.
		if delay > 0.0 and !Engine.editor_hint: yield (self.get_tree ().create_timer (delay), "timeout");
		# Thrown "values_changed" event.
		if !self.is_dont_destroy_mode (): self.emit_signal ("values_changed", Dictionary ({"name": name, "value": value, "node": self}));
		# For indestructible modules.
		else: self.emit_signal ("values_changed", Dictionary ({"name": name, "value": value}));

"""@Description: Manages module activity zone and activation to derninates whether module is enabled or not."""
func is_unlock () -> bool:
	# Checks module activation.
	if self.get_prop ("Enabled"):
		# Checks activity zone value.
		if Engine.editor_hint and self.get_prop ("ActivityZone") == ActivityArea.EDITOR_ONLY: return true;
		elif !Engine.editor_hint and self.get_prop ("ActivityZone") == ActivityArea.RUNTIME_ONLY: return true;
		elif self.get_prop ("ActivityZone") == ActivityArea.BOTH: return true; else: return false;
	# Otherwise.
	else: return false;

"""
	@Description: Restarts a module. Made very careful during module reboots. This can be problematic in certain cases.
	@Parameters:
		float delay: What is the timeout before restarting module ?
"""
func restart (delay: float = 0.0) -> void:
	# The module is it enabled ?
	if self.is_unlock ():
		# Waiting for the given delay and resets all module particulars properties.
		if delay > 0.0 and !Engine.editor_hint: yield (self.get_tree ().create_timer (delay), "timeout"); _old_child_count = 0; _old_children.clear ();
		# Restarts the module.
		self._enter_tree (); self._ready ();

"""
	@Description: Performs the three operations (MODIFY, ADD and DELETE) only on arrays and dictionaries.
	@Parameters:
		Dictionary | Array configs: Contains the different configurations on how each container in the module is managed. The dictionary (s) of
			this method supports the following keys:
			-> String name: What is your container name ?
			-> Variant id: Which container identifier do you want reach you ? Note that if the container is a list, the identifier must be an integer.
			-> Variant value: What value attributed to the identifier of the targeted container ? Note that the value assignment is not typed.
			-> float timeout = 0.0: Should us wait for the given delay before executing the given configurations ?
			-> int operation = ContainerOperation.SET: Which is the operation to be performed on the targeted container ? The possible values ​​are:
				-> MegaAssets.ContainerOperation.NONE or 0: Nothing would happen.
				-> MegaAssets.ContainerOperation.SET or 1: Modify the value of an identifier in a container.
				-> MegaAssets.ContainerOperation.ADD or 2: Add a new value to a container. If the container is an array and its identifier is not defined or invalid,
					the element will be appended to the end of the latter. In the case of a dictionary, the targeted key is created when it does not exist
					in the dictionary or update otherwise.
				-> MegaAssets.ContainerOperation.REMOVE or 3: Remove an identifier from a container. If the given identifier is outside the limits of the container
					(table or dictionary), we will see a cleaning full of the latter.
		float delay: What is the idle time before updating the targeted container ?
"""
func set_containers (configs, delay: float = 0.0) -> void:
	# Waiting for the given delay.
	if delay > 0.0 and !Engine.editor_hint: yield (self.get_tree ().create_timer (delay), "timeout");
	# Converting the passed configurations into an array.
	configs = Array ([configs]) if not configs is Array else Array (configs);
	# Runs all availables configurations.
	for cfg in configs:
		# Is it a dictionary and has a valid condition ?
		if cfg is Dictionary and cfg.has ("name") and cfg.name is String and not cfg.name.empty ():
			# Contains the current module property value.
			var prop_value = self.get_prop (cfg.name); var is_array: bool = self.is_array (prop_value);
			# Getting the current id value.
			cfg.id = cfg.id if cfg.has ("id") else null; cfg.operation = int (cfg.operation) if cfg.has ("operation") && is_number (cfg.operation) else 1;
			# Checks id key existance.
			if prop_value != null and cfg.operation > ContainerOperation.NONE:
				# For an array.
				if is_array && self.is_number (cfg.id):
					# Disables "duplicate" key effect on any container.
					self.override_prop (Dictionary ({duplicate = false}), cfg.name);
					# "Set" operation.
					if cfg.operation == ContainerOperation.SET && self.index_validation (cfg.id, prop_value.size ()) && cfg.has ("value"):
						# The current value is a dictionary.
						if cfg.value is Dictionary && prop_value [int (cfg.id)] is Dictionary: for elmt in cfg.value: prop_value [int (cfg.id)] [elmt] = cfg.value [elmt];
						# Otherwise.
						else: prop_value [int (cfg.id)] = cfg.value;
					# "Add" operation.
					elif cfg.operation == ContainerOperation.ADD && cfg.has ("value"):
						# Adding the given value to the target container.
						if self.is_range (int (cfg.id), 0, (len (prop_value) - 1)): prop_value.insert (int (cfg.id), cfg.value); else: prop_value.append (cfg.value);
					# "Remove" operation.
					else:
						# Removing the given value to the target container.
						if self.is_range (int (cfg.id), 0, (len (prop_value) - 1)): prop_value.remove (int (cfg.id)); else: prop_value.clear ();
				# For a dictionary.
				elif prop_value is Dictionary:
					# For "Add" and "Set" operation.
					if cfg.operation == ContainerOperation.ADD || cfg.operation == ContainerOperation.SET: prop_value [cfg.id] = cfg.value;
					# For "Remove" operation.
					elif prop_value.has (cfg.id) && prop_value.erase (cfg.id): pass; else: prop_value.clear ();
				# Updates the target module property.
				self.set_prop (cfg.name, prop_value, false, (float (cfg.timeout) if cfg.has ("timeout") && self.is_number (cfg.timeout) else 0.0));
				# Re-checks the module property value.
				if is_array: self.override_prop (Dictionary ({duplicate = Engine.editor_hint}), cfg.name);

"""
	@Description: Performs the three operations (MODIFY, ADD and DELETE) only on arrays and dictionaries.
	@Parameters:
		String name: What is your container name ?
		Variant id: Which container identifier do you want reach you ? Note that if the container is a list, the identifier must be an integer.
		Variant value: What value attributed to the identifier of the targeted container ? Note that the value assignment is not typed.
		int operation: Which is the operation to be performed on the targeted container ? The possible values ​​are:
			-> MegaAssets.ContainerOperation.NONE or 0: Nothing would happen.
			-> MegaAssets.ContainerOperation.SET or 1: Modify the value of an identifier in a container.
			-> MegaAssets.ContainerOperation.ADD or 2: Add a new value to a container. If the container is an array and its identifier is not defined or invalid,
				the element will be appended to the end of the latter. In the case of a dictionary, the targeted key is created when it does not exist
				in the dictionary or update otherwise.
			-> MegaAssets.ContainerOperation.REMOVE or 3: Remove an identifier from a container. If the given identifier is outside the limits of the container
				(table or dictionary), we will see a cleaning full of the latter.
		float delay: What is the idle time before updating the targeted container ?
"""
func set_container (name: String, id, value, operation: int = ContainerOperation.SET, delay: float = 0.0) -> void:
	# Changes value of the given container.
	self.set_containers (Dictionary ({"name": name, "id": id, "value": value, "operation": operation, timeout = 0.0}), delay);

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
