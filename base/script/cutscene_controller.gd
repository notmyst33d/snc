class_name CutsceneController extends Node

export var level: NodePath
onready var _level = get_node(level) as Level

func move_x_from_current(object: Node2D, to: float, time: float, next_key: String):
    var tween = get_tree().create_tween()
    tween.tween_property(object, "position:x", to, time)
    tween.connect("finished", self, "run", [next_key], CONNECT_ONESHOT)

func move(object: Node2D, from: Vector2, to: Vector2, time: float, next_key: String):
    var tween = get_tree().create_tween()
    tween.tween_property(object, "position", to, time).from(from)
    tween.connect("finished", self, "run", [next_key], CONNECT_ONESHOT)

func dialog(key: String, next_key: String):
    var dialog_ui: DialogUI = _level.get_camera().get_dialog_ui()
    var data = key.split(",")
    if dialog_ui.loaded_file != data[0]:
        dialog_ui.load_ddf(data[0])
    dialog_ui.show_dialog(data[1])
    dialog_ui.connect("finished", self, "dialog_finished", [next_key], CONNECT_ONESHOT)
    dialog_ui.connect("event", self, "run")

func wait(time: float, next_key: String):
    get_tree().create_timer(time).connect("timeout", self, "run", [next_key], CONNECT_ONESHOT)

func dialog_finished(next_key: String):
    var dialog_ui: DialogUI = _level.get_camera().get_dialog_ui()
    dialog_ui.disconnect("event", self, "run")
    run(next_key)

func sfx(audio: AudioStreamPlayer, next_key: String):
    audio.play()
    audio.connect("finished", self, "run", [next_key], CONNECT_ONESHOT)

func animation(sprite: AnimatedSprite, name: String, flip: bool, speed: float):
    sprite.play(name)
    sprite.flip_h = flip
    sprite.speed_scale = speed

func run(key: String):
    pass
