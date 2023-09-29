@tool
class_name HorizontalMovementInfo
extends Resource

@export var max_speed: float = 264:
	set(value): 
		max_speed = max(value, 0)
		update_acceleration_variables()
		
	get: return max_speed
	
@export var initial_speed: float = 64:
	set(value): 
		initial_speed = clamp(value, 0, max_speed)
		update_acceleration()
		
	get: return initial_speed
	
@export var time_to_max_speed: float = 0.2:
	set(value): 
		time_to_max_speed = max(value, 0.01)
		update_acceleration()
		
	get: return time_to_max_speed
	
@export var time_to_turn_around: float = 0.06:
	set(value): 
		time_to_turn_around = max(value, 0.01)
		update_turn_acceleration()
		
	get: return time_to_turn_around
	
@export var time_to_stop: float = 0.12:
	set(value): 
		time_to_stop = max(value, 0.01)
		update_deceleration()
		
	get: return time_to_stop

var acceleration: float
var turn_acceleration: float
var deceleration: float

func update_acceleration_variables():
	update_acceleration()
	update_turn_acceleration()
	update_deceleration()

func update_acceleration():
	acceleration = (max_speed - initial_speed) / time_to_max_speed
	
func update_turn_acceleration():
	turn_acceleration = max_speed / time_to_turn_around
	
func update_deceleration():
	deceleration = max_speed / time_to_stop
	
func get_max_speed() -> float:
	return max_speed
	
func get_initial_speed() -> float:
	return initial_speed
	
func get_acceleration() -> float:
	return acceleration
	
func get_turn_acceleration() -> float:
	return turn_acceleration
	
func get_deceleration() -> float:
	return deceleration
