"""
	@author: Obrymec
	@company: CodiTheck
	@famework: Godot Mega Assets
	@compatibility: Godot 3.x.x
	@platform: ANDROID || IOS || MACOSX || UWP || HTML5 || WINDOWS || LINUX
	@license: MIT
	@source: https://godot-mega-assets.herokuapp.com/docs/bases/destructible
	@language: GDscript
	@dimension: 2D || 3D
	@type: Destructible
	@version: 0.2.2
	@created: 2021-06-15
	@updated: 2021-08-31
"""
################################################################################### [Main class] #############################################################################
"""@Description: A class that represents some basics functionalities common to all destructibles modules of the Godot Mega Assets framework."""
tool class_name Destructible, "destructible.svg" extends Module;

################################################################################### [Attributes] #############################################################################
# Contains all basics properties of a Godot Mega Assets module.
func _basics_destroyable_module_properties () -> void:
	# Contains the module title category.
	self.bind_prop (Dictionary ({title = "Destructible", index = 0}));
	"""@Description: Enumeration controlling the scope of the events of a module."""
	self.bind_prop (Dictionary ({source = "EventsScope", dropdown = WornEvents.keys (), value = 1, min = 0, max = 3,
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])}), attach = "EventsScope"
	}));
	"""
		@Description: Table of dictionaries managing the links internal and external events of a module with one or more given methods and properties.
			To use this option, the developer must follow the key/value concept. Note that any event listened to without going through a connection
			beforehand will fall victim to the reach of events. This option is only available on destructible modules. It is also possible instead of
			a fixed value: that it is at the level of a property or parameters of a method, to refer the value of another property or of a result returned
			by a method recursively. To be able to do this, you must use a character string in which we will have a special character: the "?" placed in front
			of the name of the property or method whose value will be used as the value assigned to said property or parameter of the method in question.
			When you want to act on a method during a trigger, you must put at the end, the characters "()" in order to make the distinction between a property
			and a method.
	"""
	self.bind_prop (Dictionary ({source = "EventsBindings", value = Array ([]), duplicate = Engine.editor_hint, type = TYPE_ARRAY,
		changed = Dictionary ({callback = "module_values_changed ()", params = Array ([null, null])}), attach = "EventsBindings",
		clone = Dictionary ({id = "trigger", statement = "AutoCompile", actions = Dictionary ({message = "Can't have severals values of {trigger} key."})})
	}));
	# Attaches "EventsBindings" property to "AutoCompile" property.
	self.override_prop (Dictionary ({attach = PoolStringArray (["AutoCompile", "EventsBindings"])}), "AutoCompile");

############################################################################## [Logic and main tasks] ########################################################################
# This method is called on game initialization and before all nodes instanciation.
func _init (): self._basics_destroyable_module_properties ();

# Called before ready method run.
func _enter_tree ():
	# If ever on event is not connected to this instance.
	if not self.is_connected ("start", self, "_on_module_start"):
		# Connecting module "start" and "enabled" events to this instance.
		if self.connect ("start", self, "_on_module_start") != OK: pass; if self.connect ("enabled", self, "_on_module_enabled") != OK: pass;
		# Connecting module "disabled" and "values_changed" events to this instance.
		if self.connect ("disabled", self, "_on_module_disabled") != OK: pass; if self.connect ("values_changed", self, "_on_module_values_changed") != OK: pass;
		# Connecting module "children_changed" event to this instance.
		if self.connect ("children_changed", self, "_on_module_children_changed") != OK: pass;
		# Connecting module "parent_changed" event to this instance.
		if self.connect ("parent_changed", self, "_on_module_parent_changed") != OK: pass;

# This method is called when the module started.
func _on_module_start (module): self.thrown_event ("start", module);

# This method is called when the module is enabled.
func _on_module_enabled (module): self.thrown_event ("enabled", module);

# This method is called when the module is disabled.
func _on_module_disabled (module): self.thrown_event ("disabled", module);

# This method is called when any module property value has changed.
func _on_module_values_changed (data): self.thrown_event ("values_changed", data);

# This method is method is called when the module parent has changed.
func _on_module_parent_changed (module): self.thrown_event ("parent_changed", module);

# This method is called when the module children has changed.
func _on_module_children_changed (module): self.thrown_event ("children_changed", module);

############################################################################### [Availables features] ########################################################################
"""@Description: Returns the version a module."""
static func get_version () -> String: return "0.2.2";

"""@Description: Returns all origins of a module."""
static func get_origin_name () -> String: return "MegaAssets.Module.Destructible";

"""@Description: Returns a module class type."""
func get_class (): return "Destructible";

"""@Description: Returns the web link of "Godot Mega Assets" framework."""
static func get_source () -> String: return "https://godot-mega-assets.herokuapp.com/docs/bases/destructible";

"""
	@Description: Manages all events on the module. Note that this method doesn't call "emit_signal" method.
	@Parameters:
		String event: Contains an event name.
		Variant parameters: Contains event parameters when it called.
"""
func thrown_event (event: String, parameters, delay: float = 0.0) -> void:
	# Checks events scope value.
	if self.get_prop ("EventsScope") != WornEvents.NONE:
		# Waiting for the given delay.
		if delay > 0.0 and !Engine.editor_hint: yield (self.get_tree ().create_timer (delay), "timeout");
		# Raises the passed event on all directly listen.
		self.raise_event (Dictionary ({"event": ("_on_" + event), params = parameters}), self, self.get_prop ("EventsScope"));
		# Runs all configurations on "EventsBindings" property.
		for cfg in self.get_prop ("EventsBindings") if self.get_prop ("EventsBindings") is Array else Array ([]):
			# Checks configurations validation.
			if cfg is Dictionary && cfg.has ("trigger") && cfg.trigger is String && cfg.trigger == event && cfg.has ("actions"):
				# Runs the current event configurations.
				self.run_slots (cfg.actions, self, (float (cfg.timeout) if cfg.has ("timeout") && self.is_number (cfg.timeout) else 0.0));

"""@Description: Destroys the given properties from his name from "__props__" dictionary."""
func destroy_props (source, delay: float = 0.0) -> void:
	# Waiting for the given delay and destroys the passed property(ies) and listen this main properties.
	if delay > 0.0 and !Engine.editor_hint: yield (self.get_tree ().create_timer (delay), "timeout"); .destroy_props (source);
	# "AutoCompile" module property exists and "EventsBindings" module property is destroyed.
	if self.get_prop ("AutoCompile") is bool && !self.get_prop ("EventsBindings") is Array: self.override_prop (Dictionary ({attach = "AutoCompile"}), "AutoCompile");

"""
	@Description: Restarts a module. Made very careful during module reboots. This can be problematic in certain cases.
	@Parameters:
		float delay: What is the timeout before restarting module ?
"""
func restart (delay: float = 0.0) -> void:
	# The module is it enabled ?
	if self.is_unlock ():
		# Waiting for the given delay.
		if delay > 0.0 and !Engine.editor_hint: yield (self.get_tree ().create_timer (delay), "timeout");
		# "start" event is it already connected to this module reference ?
		if self.is_connected ("start", self, "_on_module_start"):
			# Disconnects this module reference from "start" and "enabled" signals.
			if self.disconnect ("start", self, "_on_module_start") != OK: pass; if self.disconnect ("enabled", self, "_on_module_enabled") != OK: pass;
			# Disconnects this module reference from "disabled" and "values_changed" signals.
			if self.disconnect ("disabled", self, "_on_module_disabled") != OK: pass; if self.disconnect ("values_changed", self, "_on_module_values_changed") != OK: pass;
			# Disconnects this module reference from "parent_changed" signal.
			if self.disconnect ("parent_changed", self, "_on_module_parent_changed") != OK: pass;
			# Disconnects this module reference from "children_changed" signal.
			if self.disconnect ("children_changed", self, "_on_module_children_changed") != OK: pass;
		# Restarts the module.
		self._enter_tree (); self._ready ();

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
