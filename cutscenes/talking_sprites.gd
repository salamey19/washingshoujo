extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CutsceneManager.show_sprites.connect(_show_sprites)


func _show_sprites(akira :bool = false, riro : bool = false, kaguya : bool = false, hide_all : bool = false) -> void:

	$Akira.visible = akira
	$Kaguya.visible = kaguya
	$Riro.visible = riro
	if hide_all:
		$Akira.visible = false
		$Kaguya.visible = false
		$Riro.visible = false
