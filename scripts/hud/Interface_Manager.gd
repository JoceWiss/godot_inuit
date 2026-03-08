extends CanvasLayer
@onready var menu_contextuel = %MenuContextuel
@onready var hud = $HUD
@onready var inventaire_visuel = $Inventaire
signal inventaire_modifie(valeur)
const SLOT_SCENE = preload("res://scenes/slot_base.tscn")
var taille_sac: int = 20
var objet_selectionne = null
var index_selectionne : int = -1

func _ready():
	await get_tree().process_frame
	inventaire_visuel.visible=false
	var joueur = get_tree().get_first_node_in_group("joueur")
	var manager = joueur.get_node("inventaire")
	for i in range(taille_sac):
		var nouveau_slot = SLOT_SCENE.instantiate()
		$Inventaire/HBoxContainer/PanelContainer/ScrollContainer/sac.add_child(nouveau_slot)
		nouveau_slot.index_dans_sac = i
		manager.inventaire_modifie.connect(_on_manager_inventaire_modifie)

func _on_manager_inventaire_modifie():
	for slot in $Inventaire/HBoxContainer/PanelContainer/ScrollContainer/sac.get_children():
		slot.actualiser()

func _input(event):
	if event.is_action_pressed("touche_inventaire"):
		inventaire_visuel.visible = !inventaire_visuel.visible

func ouvrir_menu_objet(objet,index):
	objet_selectionne = objet
	index_selectionne = index
	menu_contextuel.position = get_viewport().get_mouse_position()
	menu_contextuel.show()
	
func _on_menu_contextuel_id_pressed(id):
	print("ok menu contextuel")
	var joueur = get_tree().get_first_node_in_group("joueur")
	var inv = joueur.get_node("inventaire")
	
	match id:
		0: 
			print("Utilisation de : ",objet_selectionne.nom)
		1: 
			print(objet_selectionne.nom,"jeté")
			joueur.lacher_objet(objet_selectionne)
		
