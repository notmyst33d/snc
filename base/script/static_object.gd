extends StaticBody2D

export var level: NodePath
onready var _level = get_node(level) as Level

func _process(delta):
    var distance = _level.get_player().global_position - global_position
    if distance.y > 0.001:
        print("e")
        $Sprite.z_index = -1
    else:
        print("n")
        $Sprite.z_index = 0
