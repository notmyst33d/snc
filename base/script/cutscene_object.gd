class_name CutsceneObject extends Node

export var object: NodePath
export var sprite: NodePath

onready var _object = get_node(object)
var _sprite = null

func init():
    if _object is Player:
        _sprite = _object.get_sprite()
    else:
        _sprite = get_node(sprite)
