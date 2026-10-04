class_name Player

extends CharacterBody2D

signal died;
signal scored;

enum PlayerState{
	WAITING,
	FLYING,
	DEAD
}

const MAX_ROTATION_UP = deg_to_rad(-50.0);
const MAX_ROTATION_DOWN = deg_to_rad(55.0);

@export var jump_speed = 850.0
@export var gravity_mult = 2.0;
@export var death_rotation = 5.0;

var state : PlayerState = PlayerState.WAITING;

func _physics_process(delta: float) -> void:
	if(state == PlayerState.WAITING):
		return;
		
	# Add the gravity.
	velocity += gravity_mult * get_gravity() * delta
	
	if(state == PlayerState.DEAD):
		rotation += death_rotation * delta;
		move_and_slide();
		return;	

	# Handle jump.
	if Input.is_action_just_pressed("jump") and position.y > 50:
		velocity = Vector2.UP * jump_speed
		$JumpAudio.play();

	rotation = lerp_angle(rotation, clamp(velocity.y, MAX_ROTATION_UP, MAX_ROTATION_DOWN), clamp(3*delta, 0, 1))
		
	move_and_slide()
	
func hit():
	state = PlayerState.DEAD;
	died.emit();

func score():
	scored.emit();

func _on_bottom_bound_body_entered(body: Node2D) -> void:
	if(state == PlayerState.FLYING):
		hit();

func _on_game_scene_started_game() -> void:
	state = PlayerState.FLYING
	velocity = Vector2.UP * jump_speed
	$JumpAudio.play();

func _on_game_scene_paused_game() -> void:
	state = PlayerState.WAITING

func _on_game_scene_unpaused_game() -> void:
	state = PlayerState.FLYING
