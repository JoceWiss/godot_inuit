extends PanelContainer
var index_dans_sac: int = -1
@onready var icone_node = $Icone

func actualiser():

	var joueur = get_tree().get_first_node_in_group("Joueur")
	if joueur and joueur.has_node("inventaire"):
		var inv_data = joueur.get_node("inventaire")
		if index_dans_sac < inv_data.slots_sac.size():
			var objet = inv_data.slots_sac[index_dans_sac]
			if objet != null:
				icone_node.texture = objet.icone
				icone_node.visible = true
			return # On s'arrête là si on a trouvé
			
	icone_node.texture = null	# Si l'index n'existe pas encore ou si c'est vide
	icone_node.visible = false
