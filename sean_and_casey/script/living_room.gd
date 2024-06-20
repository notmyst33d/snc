extends Level

func _ready():
    Music.play("res://sean_and_casey/music/one.ogg")
    if not Global.variables.has("living_room_hint"):
        get_cutscene_controller(LivingRoomCutsceneController).run("hint")
    $DialogObject.connect("finished", self, "run_cutscene_go", [], CONNECT_ONESHOT)

func run_cutscene_go():
    get_cutscene_controller(LivingRoomCutsceneController).run("go")
