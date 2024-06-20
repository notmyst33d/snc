tool
class_name Player extends KinematicBody2D

signal interacted

enum Direction {
    UP,
    DOWN,
    LEFT,
    RIGHT,
}

const ANIMATION_FRONT = "f"
const ANIMATION_SIDE = "s"
const ANIMATION_BACK = "b"

onready var sprite = $Sprite

var velocity = Vector2.ZERO
var speed = 60
var speed_multiplier = 1
export var can_move = true
export var cutscene = false
export(Direction) var direction = Direction.DOWN

var touch_position = null
var touch_pressed = false

func _input(event):
    if event is InputEventScreenTouch:
        touch_pressed = event.pressed
        touch_position = event.position

    if event is InputEventScreenDrag:
        touch_position = event.position

    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT:
            touch_pressed = event.pressed
            touch_position = event.position

    if event is InputEventMouseMotion:
        if touch_pressed:
            touch_position = event.position

func _physics_process(delta):
    if not can_move and not cutscene and sprite.playing:
        sprite.stop()
        sprite.frame = 0

    if Engine.editor_hint or not can_move:
        return

    if Input.is_action_just_pressed("primary"):
        emit_signal("interacted")

    if Input.is_action_pressed("quadiary"):
        sprite.speed_scale = 1.5
        speed_multiplier = 2
    else:
        sprite.speed_scale = 1
        speed_multiplier = 1

    if check_inputs():
        move_and_slide(velocity * speed * speed_multiplier * scale)
        velocity = Vector2.ZERO

func play_animation_wtf(target_direction, animation, flip, check_flip = false):
    if (
        direction == target_direction and
        (
            sprite.animation != animation or
            (sprite.animation == animation and not sprite.playing) or
            (sprite.animation == animation and sprite.flip_h != flip and check_flip)
        )
    ):
        sprite.play(animation)
        sprite.frame = 1
        sprite.flip_h = flip

func check_inputs():
    var check = false
    if Input.is_action_pressed("up"):
        check = true
        velocity.y -= 1
        direction = Direction.UP
    elif Input.is_action_pressed("down"):
        check = true
        velocity.y += 1
        direction = Direction.DOWN

    if Input.is_action_pressed("left"):
        check = true
        velocity.x -= 1
        direction = Direction.LEFT
    elif Input.is_action_pressed("right"):
        check = true
        velocity.x += 1
        direction = Direction.RIGHT

    play_animation_wtf(Direction.UP, ANIMATION_BACK, false)
    play_animation_wtf(Direction.DOWN, ANIMATION_FRONT, false)
    play_animation_wtf(Direction.LEFT, ANIMATION_SIDE, true, true)
    play_animation_wtf(Direction.RIGHT, ANIMATION_SIDE, false, true)

    if check:
        return true

    if sprite.playing:
        sprite.frame = 0
        sprite.stop()

    return false

func get_sprite() -> AnimatedSprite:
    return $Sprite as AnimatedSprite

func set_collision(value):
    $Shape.disabled = not value
