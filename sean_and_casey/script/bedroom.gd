extends Level

func _ready():
    Music.play("res://sean_and_casey/music/one.ogg")
    if not Global.variables.has("bedroom_wakeup"):
        get_cutscene_controller(BedroomCutsceneController).run("start")
