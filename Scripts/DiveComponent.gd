class_name DiveComponent
extends Node

@export var velocity: VelocityComponent

@export var horizontal_speed: float = 100:
	set(value): horizontal_speed = max(value, 0)
	get: return horizontal_speed

@export var distance_in_fall: float = 180:
	set(value):
		distance_in_fall = max(0, value)
		_calculate_all_variables()
		
	get:
		return distance_in_fall
		
@export var distance_in_apex: float = 5:
	set(value):
		distance_in_apex = clamp(value, 0, distance_in_fall)
		_calculate_gravity()
		_calculate_apex_gravity()
		
	get: 
		return distance_in_apex
	
@export var time_to_distance: float = 0.3:
	set(value):
		time_to_distance = max(value, 0.01)
		_calculate_gravity()
		
	get:
		return time_to_distance
	
@export var time_in_apex: float = 0.08:
	set(value):
		time_in_apex = max(value, 0.01)
		
	get:
		return time_in_apex

var impulse: float
var gravity: float
var apex_gravity: float

var is_in_apex: bool = false

signal reached_apex
signal fell_off_apex

var apex_timer: float = 0

func _ready():
	_calculate_all_variables()
	
func apply_gravity(delta: float):
	if is_in_apex:
		velocity.accelerate_y(apex_gravity, delta)
		count_down_apex(delta)
		return
		
	velocity.accelerate_y(gravity, delta)

func _calculate_all_variables():
	_calculate_impulse()
	_calculate_gravity()
	_calculate_apex_gravity()
	
func start_apex():
	is_in_apex = true
	apex_timer = time_in_apex
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
	
	if is_in_apex:
		end_apex()
	
func jump():
	velocity.set_velocity_y(-impulse)
	
	is_in_apex = false
	apex_timer = 0
	
func ground():
	velocity.set_velocity_y(0)
	
	if is_in_apex:
		end_apex()

func _calculate_impulse():
	impulse = 2 * height / time_to_height
	
func _calculate_gravity():
	down_gravity = 2 * (height - heigth_lost_in_apex) / time_to_ground / time_to_ground
	
func _calculate_apex_gravity():
	apex_gravity = 2 * heigth_lost_in_apex / time_in_apex / time_in_apex

func is_on_apex():
	return is_in_apex
