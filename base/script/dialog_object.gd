class_name DialogObject extends Area2D

signal finished

const Player = preload("res://base/script/player.gd")

export(String, FILE) var dialog_file = null
export(String) var dialog_key = null
export(bool) var dialog_counter = false
export(Array, Player.Direction) var should_face = []

var counter = 0

export var level: NodePath
onready var _level = get_node(level) as Level

func _ready():
    _level.get_player().connect("interacted", self, "player_interacted")

func player_interacted():
    var player = _level.get_player()
    var dialog_ui = _level.get_camera().get_dialog_ui()
    if dialog_ui.current:
        return

    for body in get_overlapping_bodies():
        if body != player:
            continue

        for direction in should_face:
            if player.direction == direction:
                player.can_move = false
                dialog_ui.connect("finished", self, "dialog_finished")
                if dialog_counter:
                    dialog_ui.connect("counter_changed", self, "counter_changed")
                dialog_ui.load_ddf(dialog_file)
                if dialog_counter:
                    dialog_ui.show_dialog(dialog_key % counter)
                else:
                    dialog_ui.show_dialog(dialog_key)

func dialog_finished():
    _level.get_player().can_move = true
    var dialog_ui = _level.get_camera().get_dialog_ui()
    dialog_ui.disconnect("finished", self, "dialog_finished")
    if dialog_counter:
        dialog_ui.disconnect("counter_changed", self, "counter_changed")
    emit_signal("finished")

func counter_changed(value):
    counter += value
