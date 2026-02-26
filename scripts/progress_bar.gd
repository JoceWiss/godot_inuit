extends ProgressBar
@onready var joueur = get_tree().get_first_node_in_group("joueur")
func _ready():
	await get_tree().process_frame
	max_value = joueur.faim_max
	joueur.faim_mise_a_jour.connect(_on_faim_changee)
	value = joueur.faim_actuelle
	print("Barre de faim prête ! Valeur : ", value)
	
func _on_faim_changee(nouvelle_valeur):
	value = nouvelle_valeur
	
