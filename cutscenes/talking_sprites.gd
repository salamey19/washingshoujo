extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CutsceneManager.show_sprites.connect(_show_sprites)
	CutsceneManager.show_black_screen.connect(_show_black_screen)
func _show_black_screen(show) -> void:
	$Background.visible = show

func _show_sprites(akira :bool = false, riro : bool = false, kaguya : bool = false, hide_all : bool = false) -> void:

	$Akira.visible = akira
	$Kaguya.visible = kaguya
	$Riro.visible = riro
	if hide_all:
		$Akira.visible = false
		$Kaguya.visible = false
		$Riro.visible = false
