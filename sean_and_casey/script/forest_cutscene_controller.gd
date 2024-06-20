class_name ForestCutsceneController extends CutsceneController

export var sean: NodePath
export var casey_object: NodePath
export var casey_sprite: NodePath

onready var _sean_object: Player = get_node(sean) as Player
onready var _sean_sprite: AnimatedSprite = get_node(sean).get_sprite() as AnimatedSprite
onready var _casey_object: Node2D = get_node(casey_object) as Node2D
onready var _casey_sprite: AnimatedSprite = get_node(casey_sprite) as AnimatedSprite

var tween = null

func byebye(body):
    run("oops")

func run(key: String):
    if key == "event_interrupt":
        var dialog_ui = _level.get_camera().get_dialog_ui()
        tween.kill()
        tween.disconnect("finished", self, "run")
        _sean_sprite.stop()
        _sean_sprite.flip_h = true
        _sean_sprite.frame = 0
        dialog_ui.call_deferred("_finish")

    if key == "start":
        _sean_sprite.play("s")
        _casey_sprite.play("s")
        run("infinite_walk")
        run("quiet")

    if key == "infinite_walk":
        var size = Global.get_size()
        tween = get_tree().create_tween()
        _sean_object.global_position.x = 1138
        _casey_object.global_position.x = 1025
        tween.tween_property(_sean_object, "global_position:x", 1280 + 512 + 256, 7.0).as_relative()
        tween.parallel().tween_property(_casey_object, "global_position:x", 1280 + 512 + 256, 7.0).as_relative()
        tween.connect("finished", self, "run", ["infinite_walk"], CONNECT_ONESHOT)

    if key == "quiet":
        dialog("res://sean_and_casey/dialog/main.tres,fr01", "whoosh")

    if key == "whoosh":
        $ByeBye.connect("body_entered", self, "byebye", [], CONNECT_ONESHOT)

    if key == "oops":
        _casey_sprite.visible = false
        wait(2.0, "selfdialog")

    if key == "selfdialog":
        dialog("res://sean_and_casey/dialog/main.tres,ms01", "notice_wait")

    if key == "notice_wait":
        wait(2.0, "notice")

    if key == "notice":
        dialog("res://sean_and_casey/dialog/main.tres,in01", "after_notice")

    if key == "after_notice":
        wait(2.0, "angry")

    if key == "angry":
        dialog("res://sean_and_casey/dialog/main.tres,uh01", "angry_wait")

    if key == "angry_wait":
        wait(2.0, "creepy")

    if key == "creepy":
        dialog("res://sean_and_casey/dialog/main.tres,cr01", "creepy_wait")

    if key == "creepy_wait":
        wait(2.0, "ohno")

    if key == "ohno":
        dialog("res://sean_and_casey/dialog/main.tres,oops01", "poof")

    if key == "poof":
        _level.change_level("res://sean_and_casey/level/credits.tscn", false)
