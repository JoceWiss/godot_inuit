extends PanelContainer
@onready var icone_node = $Icone
var index_dans_sac: int = -1
func actualiser():
	print("actualiser inventaire")
	var joueur = get_tree().get_first_node_in_group("joueur")

	if joueur and joueur.has_node("inventaire"):
		
		var inv_data = joueur.get_node("inventaire")
		if index_dans_sac >=0 and index_dans_sac < inv_data.slots_sac.size():
			var objet = inv_data.slots_sac[index_dans_sac]
			if objet != null:
				icone_node.texture = objet.icone
				icone_node.visible = true
			return # On s'arrête là si on a trouvé
			
	icone_node.texture = null	# Si l'index n'existe pas encore ou si c'est vide
	icone_node.visible = false
	
func _on_gui_input(event):
	var joueur = get_tree().get_first_node_in_group("joueur")
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		print("clic droit détecté")
		var inv = joueur.get_node("inventaire")
		var objet = inv.slots_sac[index_dans_sac]
		if objet != null:
			var ui = get_tree().get_first_node_in_group("UI")
			if ui:
				print("demande ouverture")
				ui.ouvrir_menu_objet(objet,index_dans_sac)
			else:push_error("Erreur : aucun noeud dans le groupe interface")


		
		
