extends CanvasLayer

var parallaxes: Array[Parallax2D]

func _ready():
	parallaxes = [$Background, $Stars1, $Stars2, $Stars3, $Stars4, $Stars5, $Stars6, $Stars7]

func start_background():
	var i = -15
	for parallax in parallaxes:
		parallax.autoscroll.x = i
		i -= 5
		
func stop_background():
	for parallax in parallaxes:
		parallax.autoscroll.x = 0

func _on_game_scene_started_game() -> void:
	start_background()

func _on_ufo_died() -> void:
	stop_background()

func _on_game_scene_paused_game() -> void:
	stop_background()

func _on_game_scene_unpaused_game() -> void:
	start_background()
