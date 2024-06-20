extends Level

func _ready():
    Music.play("res://sean_and_casey/music/wind.mp3")
    get_cutscene_controller(ForestCutsceneController).run("start")
