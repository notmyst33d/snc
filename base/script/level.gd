class_name Level extends Node2D

const Player = preload("res://base/script/player.gd")

var init = false
var cutscene_controllers: Array = []

func _ready():
    for marker in get_markers():
        marker.connect("body_entered", self, "_level_changed", [marker], CONNECT_ONESHOT)
        if marker.marker_name == "default":
            teleport_player_to_marker("default")
    var fade = get_camera().get_node("Fade")
    var tween = get_tree().create_tween()
    tween.tween_property(fade, "modulate", Color("00ffffff"), 0.5).from(Color("ffffffff"))

func fade_out():
    var fade = get_camera().get_node("Fade")
    var tween = get_tree().create_tween()
    tween.tween_property(fade, "modulate", Color("ffffffff"), 0.5).from(Color("00ffffff"))
    return tween

func change_level(path, should_fade_out = true):
    var player = get_player()
    var player_sprite = player.get_sprite()
    player.can_move = false
    player_sprite.stop()
    player_sprite.frame = 0
    if should_fade_out:
        fade_out().tween_callback(self, "_fade_finished", [path])
    else:
        _fade_finished(path)

func _fade_finished(path):
    var level = load(path).instance()
    get_tree().get_root().add_child(level)
    queue_free()

func _level_changed(body, marker):
    print("Triggered by: %s" % marker.marker_name)
    var player = get_player()
    var player_sprite = player.get_sprite()
    player.can_move = false
    player_sprite.stop()
    player_sprite.frame = 0
    var fade = get_camera().get_node("Fade")
    var tween = get_tree().create_tween()
    tween.tween_property(fade, "modulate", Color("ffffffff"), 0.5).from(Color("00ffffff"))
    tween.tween_callback(self, "_level_changed_finished", [marker])

func _level_changed_finished(marker):
    var level = load(marker.next_level).instance()
    level.call_deferred("teleport_player_to_marker", marker.next_level_marker_name)
    get_tree().get_root().add_child(level)
    queue_free()

func teleport_player_to_marker(marker_name):
    var player = get_player()
    for marker in get_markers():
        if marker.marker_name == marker_name:
            print("Teleporting to: %s" % marker_name)
            player.global_position = marker.global_position + marker.player_spawn_offset
            player.direction = marker.player_direction
            if player.direction == Player.Direction.UP:
                player.sprite.animation = "b"
                player.sprite.flip_h = false
            elif player.direction == Player.Direction.DOWN:
                player.sprite.animation = "f"
                player.sprite.flip_h = false
            elif player.direction == Player.Direction.LEFT:
                player.sprite.animation = "s"
                player.sprite.flip_h = true
            elif player.direction == Player.Direction.RIGHT:
                player.sprite.animation = "s"
                player.sprite.flip_h = false

func get_cutscene_controller(type):
    for controller in get_cutscene_controllers():
        if controller is type:
            return controller
    return null

func get_markers() -> Array:
    return get_nodes_in_group(self, "marker")

func get_cutscene_controllers() -> Array:
    return get_nodes_in_group(self, "cutscene_controller")

func get_level():
    return get_nodes_in_group(self, "level")[0]

func get_camera():
    return get_nodes_in_group(self, "camera")[0]

func get_player():
    return get_nodes_in_group(self, "player")[0]

func get_nodes_in_group(node: Node, group_name: String) -> Array:
    var nodes = []
    for child in node.get_children():
        if child.is_in_group(group_name):
            nodes.append(child)
        nodes += get_nodes_in_group(child, group_name)
    return nodes
