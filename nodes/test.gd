extends KinematicBody;

var gravity = 9.8;
export (NodePath) var anim_tree_path;
onready var anim_tree: AnimationTree = self.get_node_or_null (anim_tree_path);
onready var target: MeshInstance = self.get_node_or_null ("../Target");
onready var nav: Navigation = self.get_node_or_null ("../Navigation");
onready var geo = self.get_node_or_null ("../ImmediateGeometry");
onready var tween: Tween = $Tween;
var is_running: bool = false;
var index: int = 0;
var path: PoolVector3Array = PoolVector3Array ([]);
var psize: int = 0;
#var target_location: Vector3
var target_rotation: Basis
var rotation_lerp: = 0.0
var rotation_speed: = 0.3
export (Array, PackedScene) var array


func _on_loot ():
	print ("Single player")

func _ready ():
	if tween.connect ("tween_completed", self, "finished"): pass;
	set_physics_process(false);
	self.path = nav.get_simple_path (self.translation, target.translation);
	self.psize = self.path.size ();
	#print (psize)
	if psize > 0: self.set_translation (self.path [index]);
	
#	self.get_parent ().draw_line_3d (Dictionary ({
#		points = path,
##		points = [
##			$"../Navigation/NavigationMeshInstance/Walls/StaticBody2", $"../Navigation/NavigationMeshInstance/Walls/StaticBody3",
##			$"../Navigation/NavigationMeshInstance/Walls/StaticBody4", $"../Navigation/NavigationMeshInstance/Walls/StaticBody5",
##			$"../Navigation/NavigationMeshInstance/Walls/StaticBody6", $"../Navigation/NavigationMeshInstance/Walls/StaticBody7",
##			$"../Navigation/NavigationMeshInstance/Walls/StaticBody8",
##		],
##		points = [
##			$"../Navigation/NavigationMeshInstance/Walls/StaticBody7",
##			$"../Navigation/NavigationMeshInstance/Walls/StaticBody2",
##			$"../Navigation/NavigationMeshInstance/Walls/StaticBody3"
##		],
#		#parent = self,
#		mesh = Mesh.PRIMITIVE_TRIANGLES,
#		freeze = self.get_parent ().Axis.NONE,
#		skin = geo.material_override,
#		id = "NavigationPath",
#		visible = true,
#		width = Vector2 (0.001, 0.5),
#		smooth = "(10.0, 10.0)", 
#		skinscale = false
#	}));
	
	

func finished (_obj, _key): self.is_running = false;

func rotate_player (delta):
	if rotation_lerp < 1:
		rotation_lerp += delta * rotation_speed * 0.1
	elif rotation_lerp > 1:
		rotation_lerp = 1
	transform.basis = transform.basis.slerp (target_rotation, rotation_lerp) .get_rotation_quat ()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process (_delta):
	#print ("Running: ", is_running)
	#self.update ();
	MegaAssets.debug_line_3d (true, "NavigationPath", nav.get_simple_path (self.translation, target.translation), self.get_parent (), Color.cyan, 2);
	#self.get_parent ().apply_root_motion (anim_tree, self, delta, gravity);
	MegaAssets.debug_ray_3d (true, "LinearPath", Vector3.ZERO, get_node ("RayCast").cast_to, self, Color.green, 0);
	
	
	MegaAssets.draw_line_3d (Dictionary ({
		points = "./RayCast",
		parent = '.',
		mesh = Mesh.PRIMITIVE_TRIANGLES,
		freeze = MegaAssets.Axis.NONE,
		skin = Color.green,
		id = "RayPath",
		visible = true,
		# If you detect any body.
		oncolliding = {
			smooth = "10.0",
			skin = self.get_node ("../ImmediateGeometry").material_override,
			actions = {
				source = '.',
				action = "is_running",
				value = true
			},
			impact = "res://prefabs/cube.tscn",
			#impact = "../Navigation/NavigationMeshInstance/Walls/StaticBody6/impact",
			destroy = true,
			width = 0.05,
			# If you found a body named "StaticBody6".
			StaticBody6 = {
				width = 0.004,
				#impact = "../Navigation/NavigationMeshInstance/Walls/StaticBody6/impact",
				impact = "res://prefabs/cube.tscn",
			}
		},
		actions = {
			source = '.',
			action = "is_running",
			value = false
		}
	}), self);

	if self.psize > 0 and index < self.psize:
		var distance: int = int (translation.distance_to (self.path [self.index]));
		#print ("Distance: ", distance);

		if distance == 0:
			#print ("Next path");
#			while int (translation.distance_to (self.path [self.index])) < 1:
#				if self.index < self.psize - 1: index += 1;
#				else: break;
			if self.index < self.psize - 1:
				self.index += 1;
				set_physics_process(true);
			else: set_physics_process(false);
			#if self.index < self.psize - 3: self.look_at (self.path [index + 3], Vector3.UP);
#			var trans: Transform = self.global_transform.looking_at (self.path [index], Vector3.UP);
#			tween.interpolate_property (self, "global_transform", self.global_transform, trans, 0.2, Tween.TRANS_LINEAR);
#			tween.start ();
#			self.is_running = true;
			#rotation_degrees.x = 0.0;
			#rotation.x = 0.0;


func _physics_process (delta):
	#print (index)
	path [index].y = transform.origin.y
	if path [index] != transform.origin:
		target_rotation = transform.looking_at(path [index], Vector3.UP).basis
		rotate_player(delta);
	
	pass
