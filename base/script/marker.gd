tool
class_name Marker extends Area2D

const Player = preload("res://base/script/player.gd")

export var marker_name: String = "default"
export(String, FILE) var next_level = null
export var next_level_marker_name: String = "default"
export var player_spawn_offset: Vector2 = Vector2.ZERO
export(Player.Direction) var player_direction = Player.Direction.DOWN

var editor_player = null

func _ready():
    if Engine.editor_hint:
        if not marker_name:
            return

        editor_player = load("res://sean_and_casey/object/player.tscn").instance()
        add_child(editor_player)

func _process(delta):
    if Engine.editor_hint:
        if not editor_player or not marker_name:
            return

        if player_direction == Player.Direction.UP:
            editor_player.get_sprite().animation = "b"
            editor_player.get_sprite().flip_h = false
        elif player_direction == Player.Direction.DOWN:
            editor_player.get_sprite().animation = "f"
            editor_player.get_sprite().flip_h = false
        elif player_direction == Player.Direction.LEFT:
            editor_player.get_sprite().animation = "s"
            editor_player.get_sprite().flip_h = true
        elif player_direction == Player.Direction.RIGHT:
            editor_player.get_sprite().animation = "s"
            editor_player.get_sprite().flip_h = false

        editor_player.position = player_spawn_offset
