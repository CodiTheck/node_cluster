# Dependences
tool class_name Tester extends MegaAssets;

# Slot1 method definition.
func slot1 (value): print ("Property1: ", value);
# Slot2 method definition.
func slot2 (value): print (value);
# Slot3 method definition.
func slot3 (param): return param;
# Slot4 method definition.
func slot4 (): print (get_prop ("test", true));
# Consts definition.
var CONST1 = false; var CONST2 = "OS dRopDOwn";
# Called on class initialisation.
func _init ():
	# Change script title.
	self.bind_prop ({title = "ModuleType", index = 0});
	# Adding a boolean property.
	self.bind_prop ({source = "Features/Range", type = TYPE_REAL, value = 1, range = Vector2 (0, 5), attach = "range"});
	# Adding a boolean property.
	self.bind_prop ({
		source = "Features/Boolean", type = TYPE_BOOL, value = "?CONST1",
		changed = {callback = "slot1", params = null}, attach = "integer"
	});
	# Adding an integer property.
	self.bind_prop ({
		source = "Features/Integer", type = TYPE_INT, value = 0, attach = "integer", visible = false,
		min = {value = 0, actions = {slot = "slot2 ()", params = "Min value of integer"}},
		max = {value = 10, actions = {slot = "slot2 ()", params = "Max value of integer"}},
		showif = {statement = "boolean"},
		notification = [{
			what = NOTIFICATION_ENTER_TREE,
			actions = {slot = "slot2 ()", params = "Start Game", message = "Enter tree", type = Message.NORMAL}
		}, {
			what = NOTIFICATION_EXIT_TREE,
			actions = {slot = "slot2 ()", params = "Stop Game", message = "Exit tree", type = Message.NORMAL}
		}]
	});
	# Adding an OS dropdown property.
	self.bind_prop ({
		source = "Features/OS Dropdown", dropdown = ["Desktop", "Ipad", "Iphone", "Android"],
		value = 0, disableif = "not nodepath is Camera", attach = ["selecTED Os", "Resolutions dropdown"]
	});
	# Adding a screen resolutions dropdown.
	self.bind_prop ({
		source = "Resolutions Dropdown", dropdown = {behavior = NaughtyAttributes.DESKTOP_RESOLUTIONS},
		value = 0, disableif = "not nodepath is Camera", attach = "resolutions dropdown",
		require = [{
			statement = "os dropdown == 0",
			actions = {
				slot = "resolutions dropdown", value = {dropdown = {behavior = NaughtyAttributes.DESKTOP_RESOLUTIONS}}
			}
		}, {
			statement = "OS dropdown == 1",
			actions = {slot = "resolutions dropdown", value = {dropdown = {behavior = NaughtyAttributes.IPAD_RESOLUTIONS}}}
		}, {
			statement = "oS DROPdown == 2",
			actions = {
				slot = "resolutions dropdown", value = {dropdown = {behavior = NaughtyAttributes.IPHONE_RESOLUTIONS}}
			}
		}, {
			statement = "OS DROPDOWN == 3",
			actions = {
				slot = "resolutions dropdown", value = {dropdown = {behavior = NaughtyAttributes.ANDROID_RESOLUTIONS}}
			}
		}]
	});
	# Adding a node path.
	self.bind_prop ({
		source = "NodePath", index = 1, type = TYPE_NODE_PATH, value = NodePath (''),
		attach = ["NODEPATH", "OS DropDOWN", "RESOlutiONS drOPDown"],
		require = [{
			statement = "!nodepath is Camera",
			actions = {message = "You should donate an instance of camera.", type = Message.ERROR}
		}, {
			statement = "Nodepath is Camera",
			actions = {message = "NodePath property value is [OK].", type = Message.NORMAL}
		}]
	});
	# Adding an array.
	self.bind_prop ({source = "Array", type = TYPE_ARRAY, value = Array ([]), duplicate = true, attach = "array"});
	# Adding a reset value button.
	self.bind_prop ({source = "ResetValues", button = {actions = {slot = "reset_props_value ()", params = ["ResetVALUES", null]}}});
	# Adding a selected os name listener.
	self.bind_prop ({
		source = "Selected OS", type = TYPE_STRING, value = String ("No OS seclected"), attach = "selected os",
		require = {
			statement = "os dropdown >= 0",
			actions = {
				slot = "sEleCtED Os",
				value = {value = {callback = "get_prop", params = [{callback = "slot3", params = "?CONST2"}, true]}}
			}
		}
	});
	# Adding a screen resolutions dropdown.
	self.bind_prop ({
		source = "Test",
		dropdown = {
			behavior = NaughtyAttributes.SYSTEM_DIR, paths = false
		}, value = 0, changed = "slot4"
	});

# Calls on editor notification.
func _notification (what): self.listen_notifications (what);
# Gets all script variables list.
func _get_property_list (): return self.get_properties ();
# Calls to return property value changed.
func _get (property): return self.get_prop (property);
# Calls to set property editor value.
func _set (property, value): self.set_prop (property, value);

func _ready ():
	#print (self.search ("AI", self, NodeProperty.TYPE))
	yield (self.get_tree ().create_timer (5.0), "timeout");
	#MegaAssets.re_parent (MegaAssets.get_indestructible ("AI", self).get_path (), '.', self);
	#MegaAssets.re_parent (MegaAssets.get_indestructible ("Module", self).get_path (), '.', self);
	pass;


#var keys: Array = Array ([]);
#func _input(event):
#	if event is InputEventMouseMotion:
#		print (MegaAssets.get_keycode_string (event))
#	var string: String = '';
#	if not event is InputEventMouseMotion:
#		var keystr = MegaAssets.get_keycode_string (event);
#		if MegaAssets.is_key_or_axis_pressed (event):
#			if not keys.has (keystr): keys.append (MegaAssets.get_keycode_string (event));
#		else:
#			print (keys.has ('-' + MegaAssets.get_keycode_string (event)))
#			if keys.has (MegaAssets.get_keycode_string (event)): keys.erase (MegaAssets.get_keycode_string (event));
#			if keys.has ('-' + MegaAssets.get_keycode_string (event)): keys.erase ('-' + MegaAssets.get_keycode_string (event));
#			if keys.has ('+' + MegaAssets.get_keycode_string (event)): keys.erase ('+' + MegaAssets.get_keycode_string (event));
#		for k in len (keys):
#			if k == 0: string = keys [k];
#			else: string += ('+' + keys [k]);
#	else: string = MegaAssets.get_keycode_string (event);
#	print (string);
