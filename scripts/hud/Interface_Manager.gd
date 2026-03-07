extends CanvasLayer

@onready var hud = $HUD
@onready var inventaire = $Inventaire
signal inventaire_modifie
const SLOT_SCENE = preload("res://scenes/slot_base.tscn")
var taille_sac: int = 20
func _ready():
	inventaire.invisible=false


func _input(event):
	if event.is_action_pressed("Inventaire"):
		inventaire.visible = !inventaire.visible
