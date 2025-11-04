extends AnimatableBody2D
class_name Racer

@export var max_speed: float = 0.25
@export var acceleration: float = 0.025
var original_position: Vector2
var vertical_boundaries: = {
	"bottom": 0,
	"top": 0
}
var racer_number: int = 0
var timer_factor = 0.1
var current_speed: Vector2 = Vector2.ZERO
var movement_enabled: bool = true
var movement_over: bool = false
var moving: bool = false
var steps: int = 0
var steps_taken: int = 0
var race_over: bool = false
var trapped: bool = false
var consuming_trap: bool = false
var trap_in_sight: Trap = null
var vertical_direction = 0

func _ready():
	original_position = global_position
	set_physics_process(false)
	$MaxSpeedTimer.timeout.connect(_on_max_speed_timer_timeout)
	$StopTimer.timeout.connect(_on_stop_timer_timeout)

func _physics_process(_delta):
	if not moving:
		new_move()

	if not trapped:
		move()
	elif not consuming_trap:
		consuming_trap = true
		go_to_trap()

func move():
	if movement_enabled:
		var vector_component = min(current_speed.x + acceleration, max_speed)
		current_speed = Vector2(vector_component, vector_component * randf_range(0.1, 1))
	if movement_over:
		vertical_direction = randi_range(-1, 1)
		var vector_component = max(0, current_speed.x - acceleration)
		current_speed = Vector2(vector_component, vector_component * randf_range(0.1, 1))

	constant_linear_velocity = current_speed
	if vertical_direction == 1 and global_position.y >= vertical_boundaries.bottom:
		constant_linear_velocity.y = 0
	if vertical_direction == -1 and global_position.y <= vertical_boundaries.top:
		constant_linear_velocity.y = 0
	position += Vector2(constant_linear_velocity.x, constant_linear_velocity.y * vertical_direction)


	if current_speed.x >= max_speed and $MaxSpeedTimer.is_stopped():
		$MaxSpeedTimer.start()
	if current_speed.x == 0 and $StopTimer.is_stopped():
		$StopTimer.start()

func go_to_trap():
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", trap_in_sight.get_consume_area(), 1)
	tween.finished.connect($AnimationPlayer.play.bind("eating"))

func fall_for_trap():
	return trap_in_sight and throw_dice() >= 5

func new_move():
	steps = throw_dice()
	moving = true
	$MaxSpeedTimer.wait_time = throw_dice()*timer_factor
	$StopTimer.wait_time = throw_dice()*timer_factor
	vertical_direction = randi_range(-1, 1)

func throw_dice():
	return [1, 1, 2, 2, 3, 4, 5, 6].pick_random()

func _on_max_speed_timer_timeout():
	$MaxSpeedTimer.wait_time = throw_dice() * timer_factor
	movement_over = true
	movement_enabled = false
	steps_taken += 1

func _on_stop_timer_timeout():
	if not trapped and trap_in_sight:
		trapped = fall_for_trap()
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


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "eating":
		if trap_in_sight:
			trap_in_sight.queue_free()
		trapped = false
		consuming_trap = false
		trap_in_sight = null
		$AnimationPlayer.play("moving")
