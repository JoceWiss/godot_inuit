extends PanelContainer

@export var slot_scene : PackedScene 

@onready var grille = $MarginContainer/VBoxContainer/Slots_Inventaire
@onready var barre_poids = $MarginContainer/VBoxContainer/Poids
@onready var bouton_retour = $MarginContainer/VBoxContainer/BoutonRetour
@onready var titre_label = $MarginContainer/VBoxContainer/TitreInventaire

var mise_a_jour = false
var joueur_ref = null

func _ready():
	await get_tree().process_frame
	joueur_ref = get_tree().current_scene.find_child("Joueur", true, false)
	if joueur_ref and joueur_ref.inventaire:
		# On masque le bouton retour au début (on est à la racine)
		bouton_retour.visible = false
		bouton_retour.pressed.connect(ouvrir_racine)
		
		# Connexions
		joueur_ref.inventaire.donner_poids_total.connect(_on_poids_mis_a_jour)
		joueur_ref.inventaire.inventaire_modifie.connect(ouvrir_racine)
		
		ouvrir_racine()
		
	self.visible=false
# Affiche l'inventaire principal du joueur (ses poches/mains)
func _input(event):
	if event.is_action_pressed("Inventaire"):
		print("touche inventaire")
		self.visible = !self.visible
		if self.visible:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			ouvrir_racine()
		
func ouvrir_racine():
	bouton_retour.visible = false
	titre_label.text = "Inventaire Principal"
	afficher_contenu(joueur_ref.inventaire.slots_equipement)

# Fonction universelle pour remplir la grille avec un dictionnaire de slots
func afficher_contenu(slots_a_afficher: Dictionary):
	if mise_a_jour : return
	mise_a_jour = true
	# On vide la grille
	for enfant in grille.get_children():
		enfant.queue_free()
		
	for nom_slot in slots_a_afficher:
		var objet = slots_a_afficher[nom_slot]
		if objet != null:
			var case = slot_scene.instantiate()
			grille.add_child(case)
			case.afficher_objet(objet)
			
			# SI C'EST UN SAC : on connecte son clic pour ouvrir l'intérieur
			if objet.est_un_conteneur:
				case.pressed.connect(func(): ouvrir_sac(objet))

func ouvrir_sac(sac_objet):
	bouton_retour.visible = true
	titre_label.text = sac_objet.nom
	afficher_contenu(sac_objet.slots_contenu)

func _on_poids_mis_a_jour(nouveau_poids: float):
	barre_poids.value = nouveau_poids
