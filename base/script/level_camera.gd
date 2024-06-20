class_name LevelCamera extends Camera2D

var follow_player: bool = true
var follow_position: Vector2

export var level: NodePath
onready var _level = get_node(level) as Level

func _ready():
    if OS.has_feature("mobile"):
        add_child(load("res://base/object/touch_buttons.tscn").instance())

func _process(delta):
    var target_position = _level.get_player().global_position
    if not follow_player:
        target_position = follow_position
    var size = Global.get_size()
    var center = size / 2

    position = Vector2(
        clamp(
            -(center.x - target_position.x),
            0,
            abs(size.x - limit_right)
        ),
        clamp(
            -(center.y - target_position.y),
            0,
            abs(size.y - limit_bottom)
        )
    )

func get_dialog_ui() -> DialogUI:
    return $UI/Control/DialogUI as DialogUI
