extends CharacterBody2D

@export var horizontal_movement: HorizontalMovementComponent
@export var jump_component: JumpComponent
@export var velocity_component: VelocityComponent

var on_ground: bool = false
var diving: bool = false

@export var ground_movement: HorizontalMovementInfo
@export var aerial_movement: HorizontalMovementInfo
@export var in_apex_movement: HorizontalMovementInfo
@export var jump_info: JumpInfo

@export var dive_move_speed: float = 600
@export var dive_info: JumpInfo

func _physics_process(delta):
	var direction: int = Input.get_axis("left", "right")
	var jump: bool = Input.is_action_just_pressed("jump")
	var low_jump: bool = Input.is_action_just_released("jump")
	
	if not on_ground and is_on_floor():
		on_ground = true
		diving = false
		jump_component.ground()
		
	elif on_ground and not is_on_floor():
		on_ground = false
		
	if not diving:
		if on_ground:
			horizontal_movement.move(ground_movement, direction, delta)
			
		elif jump_component.in_apex():
			horizontal_movement.move(in_apex_movement, direction, delta)
			
		else:
			horizontal_movement.move(aerial_movement, direction, delta)
		
	if diving:
		jump_component.apply_gravity(dive_info, delta)
	
	else:
		jump_component.apply_gravity(jump_info, delta)
	
	if jump:
		if on_ground:
			jump_component.jump(jump_info)
			
		elif not diving:
			dive(direction)
		
	if low_jump and not on_ground:
		jump_component.start_low_jump()

func dive(direction: int):
	diving = true
	jump_component.jump(dive_info)
	velocity_component.set_velocity_x(dive_move_speed * direction)
