extends CanvasLayer

@onready var hud = $HUD
@onready var inventaire_visuel = $Inventaire
signal inventaire_modifie
const SLOT_SCENE = preload("res://scenes/slot_base.tscn")
var taille_sac: int = 20
func _ready():
	inventaire_visuel.visible=false
	for i in range(taille_sac):
		var nouveau_slot = SLOT_SCENE.instantiate()
		$Inventaire/HBoxContainer/PanelContainer/ScrollContainer/sac.add_child(nouveau_slot)
		nouveau_slot.index_dans_sac = i
		inventaire_modifie.connect(nouveau_slot.actualiser)


func _input(event):
	if event.is_action_pressed("Inventaire"):
		inventaire_visuel.visible = !inventaire_visuel.visible
