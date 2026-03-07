extends PanelContainer
var index_dans_sacc: int = -1
@onready var icone_node = $Icone

func actualiser():
	var objet = InventaireManager.slot_sac[index_dans_sac]
	if objet != null:
		icone_node.texture = objet.icone
		icone_node = visible
	else : icone_node.texture = null
	icone_node.visible = false
		
