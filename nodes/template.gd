"""
	@author: Obrymec
	@company: CodiTheck
	@famework: Godot Mega Assets
	@compatibility: Godot 3.x.x
	@platform: ANDROID || IOS || MACOSX || UWP || HTML5 || WINDOWS || LINUX
	@license: MIT
	@source: https://www.godot-mega-assets.herokuapp.com
	@language: GDscript
	@dimension: 2D || 3D
	@level: Fx
	@category: General
	@saveable: False
	@type: ModuleType
	@version: 0.0.1
	@created: 2020-11-26
	@updated: 2021-07-20
"""
################################################################################### [Main class] #############################################################################
"""
	@Description: ....
"""
tool extends Module;

################################################################################### [Attributes] #############################################################################
# Contains all basics properties of a Godot Mega Assets module.
func _basic_module_properties () -> void: pass;

#################################################################################### [Signals] ###############################################################################
############################################################################## [Particulars variables] #######################################################################
############################################################################### [Properties manager] #########################################################################
############################################################################## [Logic and main tasks] ########################################################################
# This method is called on game initialization and before all nodes instanciation.
func _init (): self._basic_module_properties ();

# Called before ready method run.
func _enter_tree ():
	# Initialize all usefull privates module properties.
	self._initialize_sub_properties ();

# This method is called after game ready.
func _ready (): pass;

# This method is called on every game frames.
func _process (_delta): pass;

# Manages all module privates properties creation.
func _initialize_sub_properties () -> void: pass;

############################################################################### [Availables features] ########################################################################
"""@Description: Returns the version a module."""
static func get_version () -> String: return "0.0.1";

"""@Description: Returns all origins of a module."""
static func get_origin_name () -> String: return "MegaAssets.CategoryName.ModuleType";

"""@Description: What is the supported dimensions of this module ?"""
static func get_supported_dimensions () -> String: return "2D || 3D";

"""@Description: What is the category of this module ?"""
static func get_category_name () -> String: return "CategoryName";

"""@Description: Returns a module class type."""
func get_class (): return "ModuleType";

"""@Description: Returns the web link of "Godot Mega Assets" framework."""
static func get_source () -> String: return "https://www.godot-mega-assets.herokuapp.com";

"""@Description: What is the supported platforms of this module ?"""
static func get_supported_platforms () -> String: return "ANDROID || IOS || MACOSX || UWP || HTML5 || WINDOWS || LINUX";

"""
	@Description: Restarts a module. Made very careful during module reboots. This can be problematic in certain cases.
	@Parameters:
		float delay: What is the timeout before restarting module ?
"""
func restart (_delay: float = 0.0) -> void: if self.is_unlock (): pass;

"""
	@Description: Gives an overview of operation of a module. In other words, it performs the main task of a module by depending on the configurations
		carried out at its level. This function is not present in all cases. It depends on the nature and operation of the module in question.
	@Parameters:
		float delay: What is the timeout before module simulation ?
"""
func simulate (_delay: float = 0.0) -> void: if self.is_unlock (): pass;

#"""@Description: Determines whether the data within of a module have been saved into the game data manager. It is only available on saveable modules."""
#func is_saved () -> bool:
#	# The module is it enabled ?
#	if self.is_unlock (): return false; else: return false;
#
#"""
#	@Description: Updates the game data manager. This function is only available on saveable modules.
#	@Parameters:
#		float delay: What is the timeout before updating module data ?
#"""
#func update_data (_delay: float = 0.0) -> void: if self.is_unlock (): pass;
#
#"""
#	@Description: Back up data of a module using the game's data management system. Note that it is not recommended to use this method when you want to make
#		several backups at the same time. This function is only available on saveable modules.
#	@Parameters:
#		float delay: What is the timeout before saving module data ?
#"""
#func save_data (_delay: float = 0.0) -> void: if self.is_unlock (): pass;
#
#"""
#	@Description: Loads data from a module using the game's data management system. This function is only available on saveable modules.
#	@Parameters:
#		float delay: What is the timeout before updating module data ?
#"""
#func load_data (_delay: float = 0.0) -> void: if self.is_unlock (): pass;
#
#"""
#	@Description: Destroys all data linked to a data manager module. Warning ! there will be no going back after the destruction of the latter.
#		This function is only available on modules saveable.
#	@Parameters:
#		float delay: What is the timeout before updating module data ?
#"""
#func remove_data (_delay: float = 0.0) -> void: if self.is_unlock (): pass;

#"""@Description: Destroys the given properties from his name from "__props__" dictionary."""
#func destroy_props (_source, _delay: float = 0.0) -> void: self.output ("Can't changed module properties structure.", Message.ERROR, self);
#
#"""@Description: Overrides a module property."""
#func override_prop (_data: Dictionary, _prop_name: String, _delay: float = 0.0) -> void: self.output ("Can't changed module properties structure.", Message.ERROR, self);
#
#"""@Description: Adds one or severals property(ies) to a script."""
#func bind_prop (_data, _delay: float = 0.0) -> void: self.output ("Can't changed module properties structure.", Message.ERROR, self);
#
#"""@Description: Resets values ​​of the differents inputs of a module."""
#func reset_props_value (_trigger: String, _prop = null, _delay: float = 0.0) -> void: self.output ("Can't changed module properties structure.", Message.ERROR, self);
#
#"""@Description: This method is used when any module property value has been changed."""
#func module_values_changed (_name: String, _value, _delay: float = 0.0) -> void: self.output ("{module_values_changed} method call is denied.", Message.ERROR, self);
#
#"""@Description: Manages all events on the module. Note that this method doesn't call "emit_signal" method."""
#func thrown_event (_event: String, _parameters, _delay: float = 0.0) -> void: self.output ("{thrown_event} method call is denied.", Message.ERROR, self);
#
#"""
#	@Description: Does the type of the module of nature indestructible have several instances of itself in the tree of the scene defines ? If so,
#		an error will arise to notify the user of the uniqueness indestructible modules. Note that this method is only defined in the class Indestructible.
#"""
#func check_unique (_module_class_name: String, _delay: float = 0.0) -> void: self.output ("{check_unique} method call is denied.", Message.ERROR, self);
