tool extends Indestructible;

func simulate (): print ("Simulation");

## Slot1 method definition.
#func slot1 (value): print ("Property1: ", value);
## Slot2 method definition.
#func slot2 (value): print (value);
## Slot3 method definition.
#func slot3 (param): return param;
## Slot4 method definition.
#func slot4 (): print (get_prop ("test", true));
## Consts definition.
#var CONST1 = false; var CONST2 = "OS dRopDOwn";
## Called on class initialisation.
func _init ():
#	# Change script title.
#	self.bind_prop ({title = "Type", index = 0});
	# Adding a boolean property.
#	self.bind_prop ({source = "Dictionar", type = TYPE_DICTIONARY,
#		value = Dictionary ({
#			a = "b",
#			b = "455",
#			c = {
#				x = 45,
#				y = 0
#			}
#		}),
#		changed = {
#			callback = "module_values_changed ()",
#			params = Array ([null, null])
#		}, attach = "Dictionar"
#	});
	pass

func _enter_tree ():
	#print ("KKKK")
	self.check_unique (self.get_class ());
	
	pass

func _on_start (module):
	print (module.name, " is started !");


func get_class (): return "AI";

#func _ready():
#	self.connect("values_changed", self, "_on_values_changed")

func _on_enabled (module):
	print (module.name, " is enabled !");

func _on_disabled (module):
	print (module.name, " is disabled !");

func _on_values_changed (module):
	print (module, " values has changed !");

func _on_parent_changed (module):
	print (module.name, " parent has changed !");

func _on_children_changed (module):
	print (module.name, " children has changed !");

