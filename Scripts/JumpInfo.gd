@tool
class_name JumpInfo
extends Resource

@export var height: float = 180:
	set(value):
		height = max(0, value)
		_calculate_all_variables()
		
	get:
		return height
		
@export var min_height: float = 100:
	set(value):
		min_height = clamp(value, 0, height)
		_calculate_low_jump_gravity()
		
	get:
		return min_height
		
@export var heigth_lost_in_apex: float = 5:
	set(value):
		heigth_lost_in_apex = clamp(value, 0, height)
		_calculate_down_gravity()
		_calculate_apex_gravity()
		
	get: 
		return heigth_lost_in_apex
		
@export var time_to_height: float = 0.4:
	set(value):
		time_to_height = max(value, 0.01)
		_calculate_all_variables()
		
	get:
		return time_to_height
	
@export var time_to_ground: float = 0.3:
	set(value):
		time_to_ground = max(value, 0.01)
		_calculate_down_gravity()
		
	get:
		return time_to_ground
	
@export var time_in_apex: float = 0.08:
	set(value):
		time_in_apex = max(value, 0.01)
		
	get:
		return time_in_apex

var impulse: float
var up_gravity: float
var down_gravity: float
var low_jump_gravity: float
var apex_gravity: float

func get_impulse() -> float:
	return impulse
	
func get_up_gravity() -> float:
	return up_gravity
	
func get_down_gravity() -> float:
	return down_gravity
	
func get_low_jump_gravity() -> float:
	return low_jump_gravity
	
func get_apex_gravity() -> float:
	return apex_gravity
	
func get_time_in_apex() -> float:
	return time_in_apex

func _calculate_all_variables():
	_calculate_impulse()
	_calculate_up_gravity()
	_calculate_down_gravity()
	_calculate_low_jump_gravity()
	_calculate_apex_gravity()

func _calculate_impulse():
	impulse = 2 * height / time_to_height
	
func _calculate_up_gravity():
	up_gravity = 2 * height / time_to_height / time_to_height
	
func _calculate_down_gravity():
	down_gravity = 2 * (height - heigth_lost_in_apex) / time_to_ground / time_to_ground
	
func _calculate_low_jump_gravity():
	low_jump_gravity = impulse * impulse / (2 * min_height)
	
func _calculate_apex_gravity():
	apex_gravity = 2 * heigth_lost_in_apex / time_in_apex / time_in_apex
