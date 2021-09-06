"""
	@author: Obrymec
	@company: CodiTheck
	@famework: Godot Mega Assets
	@compatibility: Godot 3.x.x
	@platform: ANDROID || IOS || MACOSX || UWP || HTML5 || WINDOWS || LINUX
	@license: MIT
	@source: https://godot-mega-assets.herokuapp.com/docs/bases/indestructible
	@language: GDscript
	@dimension: 2D || 3D
	@type: Indestructible
	@version: 0.4.3
	@created: 2021-06-16
	@updated: 2021-08-31
"""
################################################################################### [Main class] #############################################################################
"""@Description: A class that represents some basics functionalities common to all indestructibles modules of the Godot Mega Assets framework."""
tool class_name Indestructible, "indestructible.svg" extends Module;

############################################################################## [Particulars variables] #######################################################################
# Contains the old module parent reference.
var _old_module_parent = null setget _unsetable_var_error;

############################################################################### [Properties manager] #########################################################################
# Unsetable module variables.
func _unsetable_var_error (_new_value) -> void: self.output ("Can't change value of this variable.", Message.ERROR, self);

############################################################################## [Logic and main tasks] ########################################################################
# Called before ready method run.
func _enter_tree ():
	# Connects "parent_changed" signal to "_on_module_parent_changed" method to listen parent changements.
	if !self.is_connected ("parent_changed", self, "_on_module_parent_changed") && self.connect ("parent_changed", self, "_on_module_parent_changed") != OK: pass;
	# Makes indestructible this module and get his parent reference.
	if not Engine.editor_hint: self.dont_destroy_on_load ('.', self); _old_module_parent = self.get_parent ();

# Listens module parent changed to notify unicity of indestructibles modules.
func _on_module_parent_changed () -> void:
	# Is the module parent changed ?
	if !Engine.editor_hint and self.get_parent () != self._old_module_parent:
		# Thrown an error message.
		self.output (("Can't change the parent of {" + self.name + "}. Because it's an indestructible module."), Message.ERROR, self);

############################################################################### [Availables features] ########################################################################
"""@Description: Returns the version a module."""
static func get_version () -> String: return "0.4.3";

"""@Description: Returns all origins of a module."""
static func get_origin_name () -> String: return "MegaAssets.Module.Indestructible";

"""@Description: Is the module don't destroy mode ?"""
static func is_dont_destroy_mode () -> bool: return true;

"""@Description: Returns a module class type."""
func get_class (): return "Indestructible";

"""@Description: Returns the web link of "Godot Mega Assets" framework."""
static func get_source () -> String: return "https://godot-mega-assets.herokuapp.com/docs/bases/indestructible";

"""
	@Description: Restarts a module. Made very careful during module reboots. This can be problematic in certain cases.
	@Parameters:
		float delay: What is the timeout before restarting module ?
"""
func restart (delay: float = 0.0) -> void:
	# The module is it enabled ?
	if self.is_unlock ():
		# Waiting for the given delay and resets all module particulars properties.
		if delay > 0.0 and !Engine.editor_hint: yield (self.get_tree ().create_timer (delay), "timeout"); _old_module_parent = null;
		# Disconnects this module reference from "parent_changed" signal.
		if self.is_connected ("parent_changed", self, "_on_module_parent_changed") && self.disconnect ("parent_changed", self, "_on_module_parent_changed") != OK: pass;
		# Restarts the module.
		self._enter_tree (); self._ready ();

"""
	@Description: Does the type of the module of nature indestructible have several instances of itself in the tree of the scene defines ? If so,
		an error will arise to notify the user of the uniqueness indestructible modules. Note that this method is only defined in the class Indestructible.
	@Parameters:
		String mcn: Contains the name of the class of the module whose instance cannot be greater than 1.
		float delay: What is the dead time before checking the uniqueness of the module in question ?
"""
func check_unique (mcn: String, delay: float = 0.0) -> void:
	# Waiting for the given delay.
	if delay > 0.0 and !Engine.editor_hint: yield (self.get_tree ().create_timer (delay), "timeout"); var module_reference = null;
	# The game isn't running.
	if Engine.editor_hint: module_reference = self.search (mcn, self.get_viewport (), NodeProperty.TYPE, 2);
	# The module is now indestructible.
	elif self.get_parent ().name == "DontDestroyOnLoad": module_reference = self.get_indestructible (mcn, self, NodeProperty.TYPE, 2);
	# The game isn't initialised.
	elif not is_game_initialised (): module_reference = self.search (mcn, self.get_tree ().current_scene, NodeProperty.TYPE, 2);
	# Checks the search result.
	if module_reference is Array:
		# Shows error message and destroys immediatly the new created reference.
		self.output (("Can't have severals instance of " + mcn + ". Because it's an indestructible module."), Message.ERROR, self); self.queue_free ();

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
