extends Node

var current_path: String = ""
var player: AudioStreamPlayer

func _ready():
    player = AudioStreamPlayer.new()
    player.bus = "Music"
    add_child(player)

func play(path):
    if path != current_path:
        player.stream = load(path)
        player.play()
        current_path = path

func stop():
    player.stop()
