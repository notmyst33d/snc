class_name LivingRoomCutsceneController extends CutsceneController

export var sean: NodePath
export var casey_object: NodePath
export var casey_sprite: NodePath

onready var _sean_object: Player = get_node(sean) as Player
onready var _sean_sprite: AnimatedSprite = get_node(sean).get_sprite() as AnimatedSprite
onready var _casey_object: Node2D = get_node(casey_object) as Node2D
onready var _casey_sprite: AnimatedSprite = get_node(casey_sprite) as AnimatedSprite

func run(key: String):
    if key == "hint":
        Global.variables["living_room_hint"] = true
        _level.get_camera().follow_player = false
        _level.get_camera().follow_position = Global.get_size() / 2
        _level.get_player().can_move = false
        wait(0.5, "hint_pan")
    if key == "hint_pan":
        var tween = get_tree().create_tween()
        tween.tween_property(_level.get_camera(), "follow_position:x", 500, 1.5).as_relative()
        tween.connect("finished", self, "run", ["hint_dialog"], CONNECT_ONESHOT)
    if key == "hint_dialog":
        dialog("res://sean_and_casey/dialog/main.tres,lh01", "hint_pan_back")
    if key == "hint_pan_back":
        var tween = get_tree().create_tween()
        tween.tween_property(_level.get_camera(), "follow_position:x", -500, 1.5).as_relative()
        tween.connect("finished", self, "run", ["end"], CONNECT_ONESHOT)

    if key == "go":
        _level.fade_out()
        _level.get_player().can_move = false
        wait(2.0, "fade")
    if key == "fade":
        _level.change_level("res://sean_and_casey/level/forest.tscn", false)

    if key == "end":
        _level.get_camera().follow_player = true
        _level.get_player().can_move = true
