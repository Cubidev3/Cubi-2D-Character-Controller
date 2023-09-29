class_name JumpComponent
extends Node

@export var velocity: VelocityComponent
@export var info: JumpInfo

var is_in_apex: bool = false
var is_low_jumping: bool = false

signal reached_apex
signal fell_off_apex

var apex_timer: float = 0
	
func apply_gravity(delta: float):
	if is_low_jumping:
		velocity.accelerate_y(info.get_low_jump_gravity(), delta)
		return
	
	if is_in_apex:
		velocity.accelerate_y(info.get_apex_gravity(), delta)
		count_down_apex(delta)
		return
		
	if velocity.going_up():
		velocity.accelerate_y(info.get_up_gravity(), delta)
		
		if not velocity.going_up():
			start_apex()
		
	else:
		velocity.accelerate_y(info.get_down_gravity(), delta)
	
func start_apex():
	is_in_apex = true
	apex_timer = info.get_time_in_apex()
	reached_apex.emit()
	
func count_down_apex(delta: float):
	apex_timer = max(0, apex_timer - delta)
	
	if is_zero_approx(apex_timer):
		end_apex()
		
func end_apex():
	apex_timer = 0
	is_in_apex = false
	fell_off_apex.emit()
		
func start_low_jump():
	if velocity.going_down():
		return
	
	is_low_jumping = true
	
	if is_in_apex:
		end_apex()
	
func jump():
	velocity.set_velocity_y(-info.get_impulse())
	
	is_low_jumping = false
	is_in_apex = false
	apex_timer = 0
	
func ground():
	velocity.set_velocity_y(0)
	is_low_jumping = false
	
	if is_in_apex:
		end_apex()

func in_apex():
	return is_in_apex
