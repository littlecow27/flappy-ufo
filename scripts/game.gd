extends Node2D

signal started_game;
signal paused_game;
signal unpaused_game;

enum GameState{
	READY,
	PLAYING,
	PAUSED,
	GAME_OVER
}

const SAVE_FILE = "user://savefile.save"
const GAME_WIDTH = 1920;
const GAME_HEIGHT = 1080

@export var pipe_scene: PackedScene;

var score = 0;
var high_score = 0;

var state: GameState;

func _ready() -> void:
	state = GameState.READY
	load_score()
	score = 0;
	$InterfaceLayer.update_score(score);
	$PipeTimer.stop();

func _process(delta: float) -> void:
	if state == GameState.READY and Input.is_action_just_pressed("jump"):
		start_game();
	if state != GameState.GAME_OVER and state != GameState.READY and Input.is_action_just_pressed("pause"):
		if(state == GameState.PAUSED):
			unpause_game();
		else:
			pause_game();

func start_game():
	$PipeTimer.start();
	$InterfaceLayer.start_game();
	state = GameState.PLAYING
	started_game.emit()

func pause_game():
	$PipeTimer.paused = true;
	state = GameState.PAUSED
	get_tree().call_group("pipes", "stop_pipe_movement")
	paused_game.emit()
	$InterfaceLayer.pause_game();

func unpause_game():
	$PipeTimer.paused = false;
	state = GameState.PLAYING
	get_tree().call_group("pipes", "start_pipe_movement")
	unpaused_game.emit()
	$InterfaceLayer.unpause_game();

func _on_pipe_timer_timeout() -> void:
	var new_pipe = pipe_scene.instantiate();
	new_pipe.position = Vector2(GAME_WIDTH + 250, randf_range(250, GAME_HEIGHT - 250));
	add_child(new_pipe);

func _on_ufo_died() -> void:
	$Audio/DeathAudio.play();
	$PipeTimer.stop();
	
	get_tree().call_group("pipes", "stop_pipe_movement")
	state = GameState.GAME_OVER
	
	if(score > high_score):
		high_score = score;
		save_score()
	$InterfaceLayer.game_over(score, high_score);

func _on_ufo_scored() -> void:
	$Audio/ScoreAudio.play();
	score += 1;
	$InterfaceLayer.update_score(score);

func save_score():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE_READ)
	if(file != null):
		file.store_16(high_score)
		file = null
	
func load_score():
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file != null:
		high_score = file.get_16()

func _on_interface_layer_restart_requested() -> void:
	get_tree().reload_current_scene()
