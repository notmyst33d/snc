class_name BedroomCutsceneController extends CutsceneController

export var sean: NodePath
export var casey_object: NodePath
export var casey_sprite: NodePath

onready var _sean_object: Player = get_node(sean) as Player
onready var _sean_sprite: AnimatedSprite = get_node(sean).get_sprite() as AnimatedSprite
onready var _casey_object: Node2D = get_node(casey_object) as Node2D
onready var _casey_sprite: AnimatedSprite = get_node(casey_sprite) as AnimatedSprite

func run(key: String):
    if key.begins_with("event_anim_"):
        _sean_sprite.animation = key.replace("event_anim_", "")
        _sean_sprite.frame = 0

    if key == "start":
        var player = _level.get_player()
        Global.variables["bedroom_wakeup"] = true
        player.cutscene = true
        player.can_move = false
        player.set_collision(false)
        _sean_sprite.animation = "sleep"
        _sean_sprite.frame = 0
        animation(_casey_sprite, "b", false, 1.0)
        move(_casey_object, Vector2(688, 1097), Vector2(688, 600), 2.0, "bw01_01")
    if key == "bw01_01":
        _casey_sprite.stop()
        dialog("res://sean_and_casey/dialog/main.tres,bw01_01", "glass")
    if key == "glass":
        _sean_sprite.animation = "shock"
        _sean_sprite.frame = 0
        sfx($Glass, "bw02_01")
    if key == "bw02_01":
        dialog("res://sean_and_casey/dialog/main.tres,bw02_01", "walk")
    if key == "walk":
        animation(_casey_sprite, "f", false, 1.0)
        move(_casey_object, Vector2(688, 600), Vector2(688, 1097), 2.0, "")
        animation(_sean_sprite, "s", true, 1.0)
        move_x_from_current(_sean_object, 485, 1.0, "end")
    if key == "end":
        var player = _level.get_player()
        player.cutscene = false
        player.can_move = true
        player.set_collision(true)
