class_name VelocityComponent
extends Node

@export var body: CharacterBody2D

var _is_inert_x: bool = true
var _is_inert_y: bool = true

signal started_moving
signal stopped_moving
signal started_moving_x
signal stopped_moving_x
signal started_moving_y
signal stopped_moving_y

func _physics_process(delta):
	body.move_and_slide()

func accelerate(acceleration: Vector2, delta: float):
	body.velocity += acceleration * delta 
	check_started_moving()
	
func accelerate_x(acceleration: float, delta: float):
	accelerate(Vector2.RIGHT * acceleration, delta)
	
func accelerate_y(acceleration: float, delta: float):
	accelerate(Vector2.DOWN * acceleration, delta)
	
func decelerate(deceleration: float, delta: float):
	body.velocity -= body.velocity.normalized() * min(deceleration * delta, body.velocity.length())
	check_stopped_moving()
		
func decelerate_x(deceleration: float, delta: float):
	body.velocity.x -= sign(body.velocity.x) * min(deceleration * delta, abs(body.velocity.x))
	check_stopped_moving()
	
func decelerate_y(deceleration: float, delta: float):
	body.velocity.y -= sign(body.velocity.y) * min(deceleration * delta, abs(body.velocity.y))
	check_stopped_moving()
		
func apply_impulse(impulse: Vector2):
	accelerate(impulse, 1)
	
func apply_impulse_x(impulse: float):
	accelerate_x(impulse, 1)
	
func apply_impulse_y(impulse: float):
	accelerate_y(impulse, 1)
	
func set_velocity(vel: Vector2):
	body.velocity = vel
	check_started_moving()
	check_stopped_moving()
	
func set_velocity_x(vel: float):
	body.velocity.x = vel
	check_started_moving()
	check_stopped_moving()
	
func set_velocity_y(vel: float):
	body.velocity.y = vel
	check_started_moving()
	check_stopped_moving()
		
func limit_speed(speed: float):
	speed = max(speed, 0)
	body.velocity = body.velocity.limit_length(speed)
	check_stopped_moving()
	
func limit_speed_x(speed: float):
	speed = max(speed, 0)
	body.velocity.x = sign(body.velocity.x) * clamp(abs(body.velocity.x), 0, speed)
	check_stopped_moving()
	
func limit_speed_y(speed: float):
	speed = max(speed, 0)
	body.velocity.y = sign(body.velocity.y) * clamp(abs(body.velocity.y), 0, speed)
	check_stopped_moving()
	
func limit_speed_up(speed: float):
	speed = abs(speed)
	body.velocity.y = max(-speed, body.velocity.y)
	check_stopped_moving()
	
func limit_speed_down(speed: float):
	speed = abs(speed)
	body.velocity.y = min(speed, body.velocity.y)
	check_stopped_moving()
	
func limit_speed_left(speed: float):
	speed = abs(speed)
	body.velocity.x = max(-speed, body.velocity.x)
	check_stopped_moving()
	
func limit_speed_right(speed: float):
	speed = abs(speed)
	body.velocity.x = min(speed, body.velocity.x)
	check_stopped_moving()

func is_inert() -> bool:
	return _is_inert_x and _is_inert_y
	
func is_inert_x() -> bool:
	return _is_inert_x
	
func is_inert_y() -> bool:
	return _is_inert_y
	
func get_direction() -> Vector2:
	return body.velocity.sign()
	
func get_velocity_vector() -> Vector2:
	return body.velocity

func check_started_moving():
	if _is_inert_x and _is_inert_y and not body.velocity.is_zero_approx():
		started_moving.emit()
	
	if _is_inert_x and not is_zero_approx(body.velocity.x):
		_is_inert_x = false
		started_moving_x.emit()
		
	if _is_inert_y and not is_zero_approx(body.velocity.y):
		_is_inert_y = false
		started_moving_y.emit()
		
func check_stopped_moving():
	if not _is_inert_x and not _is_inert_y and body.velocity.is_zero_approx():
		body.velocity = Vector2.ZERO
		
		_is_inert_x = true
		_is_inert_y = true
		
		stopped_moving.emit()
		stopped_moving_x.emit()
		stopped_moving_y.emit()
		return
	
	if not _is_inert_x and is_zero_approx(body.velocity.x):
		body.velocity.x = 0
		_is_inert_x = true
		stopped_moving_x.emit()
		return
		
	if not _is_inert_y and is_zero_approx(body.velocity.y):
		body.velocity.y = 0
		_is_inert_y = true
		stopped_moving_y.emit()
		return

func going_up() -> bool:
	return body.velocity.y < 0
	
func going_down() -> bool:
	return body.velocity.y > 0
	
func going_left() -> bool:
	return body.velocity.x < 0
	
func going_right() -> bool:
	return body.velocity.x > 0
