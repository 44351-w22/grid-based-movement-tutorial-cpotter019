extends Area2D

const TILE_SIZE = 64
const INPUTS = {
	'ui_right': Vector2.RIGHT,
	'ui_left': Vector2.LEFT,
	'ui_up': Vector2.UP,
	'ui_down': Vector2.DOWN,
}

const SPEED = 3
onready var ray = $RayCast2D
onready var tween = $Tween

func _ready():
	position = Vector2.ONE * 3 * TILE_SIZE / 2

func move_tween(dir):
	tween.interpolate_property(self, "position", position,
		position + INPUTS[dir] * TILE_SIZE, 1.0/SPEED,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func move(dir):
	ray.cast_to = INPUTS[dir] * TILE_SIZE
	ray.force_raycast_update()
	if !ray.is_colliding():
		move_tween(dir)

func _unhandled_input(event):
	if tween.is_active(): # We are currently moving, do nothing
		return
	for dir in INPUTS.keys(): # Check to see if we're firing one of our inputs
		if event.is_action_pressed(dir):
			move(dir)

