extends State
var skill_tree

func _ready():
	skill_tree = get_tree().get_nodes_in_group("skilltree")[0]
	skill_tree.connect("close_skilltree", self, "on_Close_Skilltree")

func enter():
	skill_tree.visible = true
	get_tree().paused = true

func on_Close_Skilltree():
	skill_tree.visible = false
	get_tree().paused = false
	exit("InGame")
		
