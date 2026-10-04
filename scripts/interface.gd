extends CanvasLayer

signal restart_requested;

func update_score(score: int):
	$ScoreLabel.text = str(score);

func start_game():
	$StartLabel.hide();

func game_over(score: int, high_score: int):
	$GameOverPanel/FinalScoreLabel.text = \
			"Score: " + str(score) + "\n" + \
			"High Score: "+str(high_score);
	await get_tree().create_timer(1).timeout
	$GameOverPanel.show()
	$ScoreLabel.hide()

func pause_game():
	$PauseLabel.show();
func unpause_game():
	$PauseLabel.hide();

func _on_restart_button_pressed() -> void:
	restart_requested.emit()
