class_name HorizontalMovementComponent
extends Node

@export var velocity: VelocityComponent
	
func move(info: HorizontalMovementInfo, direction: int, delta: float):
	direction = sign(direction)
	
	if direction == 0:
		velocity.decelerate_x(info.get_deceleration(), delta)
	
	elif velocity.is_inert_x():
		velocity.apply_impulse_x(direction * info.get_initial_speed())
		
	elif turning_around(direction):
		velocity.accelerate_x(direction * info.get_turn_acceleration(), delta)
	
	else:
		velocity.accelerate_x(direction * info.get_acceleration(), delta)
		
	velocity.limit_speed_x(info.get_max_speed())

func turning_around(direction: int) -> bool:
	return velocity.going_right() and direction < 0 or velocity.going_left() and direction > 0
