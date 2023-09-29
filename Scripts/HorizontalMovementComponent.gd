class_name HorizontalMovementComponent
extends Node

@export var velocity: VelocityComponent
@export var info: HorizontalMovementInfo
	
func move(direction: int, delta: float):
	direction = sign(direction)
	
	if direction == 0:
		velocity.decelerate_x(info.get_deceleration(), delta)
	
	elif velocity.is_inert_x():
		velocity.apply_impulse_x(direction * info.get_initial_speed())
		
	elif velocity.going_right() and direction < 0 or velocity.going_left() and direction > 0:
		velocity.accelerate_x(direction * info.get_turn_acceleration(), delta)
	
	else:
		velocity.accelerate_x(direction * info.get_acceleration(), delta)
		
	velocity.limit_speed_x(info.get_max_speed())
