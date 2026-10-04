extends Node2D

@export var speed: float = 480.0;

var pipe_moving: bool;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pipe_moving = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(pipe_moving):
		var velocity = speed * Vector2.LEFT * delta;
		position += velocity;

func handle_pipe_collision(body: Node2D) -> void:
	if body is Player && pipe_moving:
		body.hit();

func stop_pipe_movement():
	pipe_moving = false;

func start_pipe_movement():
	pipe_moving = true;
	
func _on_middle_area_body_entered(body: Node2D) -> void:
	if body is Player && pipe_moving:
		body.score();
	
func _on_bottom_area_2d_body_entered(body: Node2D) -> void:
	handle_pipe_collision(body)
func _on_top_area_2d_body_entered(body: Node2D) -> void:
	handle_pipe_collision(body)
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free();
