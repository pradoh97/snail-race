extends AnimatableBody2D
class_name Racer

@export var max_speed: float = 0.25
@export var acceleration: float = 0.025
var timer_factor = 0.1
var current_speed: float = 0
var movement_enabled: bool = true
var movement_over: bool = false
var moving: bool = false
var steps: int = 0
var steps_taken: int = 0
var race_over: bool = false

func _ready():
	$MaxSpeedTimer.timeout.connect(_on_max_speed_timer_timeout)
	$StopTimer.timeout.connect(_on_stop_timer_timeout)

func _physics_process(_delta):
	if not moving:
		new_move()
	move()

func move():
	if movement_enabled:
		current_speed = min(current_speed + acceleration, max_speed)
	if movement_over:
		current_speed = max(0, current_speed - acceleration)

	constant_linear_velocity.x = current_speed
	position.x += constant_linear_velocity.x

	if current_speed >= max_speed and $MaxSpeedTimer.is_stopped():
		$MaxSpeedTimer.start()
	if current_speed == 0 and $StopTimer.is_stopped():
		$StopTimer.start()

func new_move():
	steps = throw_dice()
	moving = true
	$MaxSpeedTimer.wait_time = throw_dice()*timer_factor
	$StopTimer.wait_time = throw_dice()*timer_factor

func throw_dice():
	return [1, 1, 2, 2, 3, 4, 5, 6].pick_random()

func _on_max_speed_timer_timeout():
	$MaxSpeedTimer.wait_time = throw_dice() * timer_factor
	movement_over = true
	movement_enabled = false
	steps_taken += 1

func _on_stop_timer_timeout():
	$StopTimer.wait_time = throw_dice() * timer_factor
	if race_over:
		set_physics_process(false)
	if steps_taken >= steps:
		steps = 0
		steps_taken = 0
		moving = false
	else:
		movement_enabled = true
		movement_over = false
