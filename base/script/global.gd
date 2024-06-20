extends Node

var variables = {}

func get_size() -> Vector2:
    if ProjectSettings.get("display/window/stretch/mode") == "2d":
        return Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height"))
    else:
        return get_tree().get_root().size
