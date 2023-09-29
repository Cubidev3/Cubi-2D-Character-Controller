extends CharacterBody2D

@export var horizontal_movement: HorizontalMovementComponent
@export var jump_component: JumpComponent
@export var velocity_component: VelocityComponent

var on_ground: bool = false

@export var ground_movement: HorizontalMovementInfo
@export var aerial_movement: HorizontalMovementInfo
@export var in_apex_movement: HorizontalMovementInfo
@export var jump_info: JumpInfo

func _ready():
	jump_component.info = jump_info
	horizontal_movement.info = aerial_movement

func _physics_process(delta):
	var direction: int = Input.get_axis("left", "right")
	var jump: bool = Input.is_action_just_pressed("jump")
	var low_jump: bool = Input.is_action_just_released("jump")
	
	horizontal_movement.move(direction, delta)
	jump_component.apply_gravity(delta)
	
	on_ground = is_on_floor()
	
	if jump && on_ground:
		jump_component.jump()
	
	if on_ground:
		horizontal_movement.info = ground_movement
		
	elif jump_component.in_apex():
		horizontal_movement.info = in_apex_movement
		
	else:
		horizontal_movement.info = aerial_movement
		
	if low_jump:
		jump_component.start_low_jump()
