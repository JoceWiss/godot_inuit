extends Area2D

# On crée la case dans l'inspecteur pour glisser ta Morue Arctique.tres
@export var objet_data : Objet 

func _ready():
	if objet_data:
		# Le sprite prend automatiquement l'image de ta ressource
		$Sprite2D.texture = objet_data.icone
		print("Texture chargée avec succès !")
	else:
		push_warning("Oups ! Tu as oublié de glisser une ressource .tres dans cet objet.")

func _on_body_entered(body):
	# On vérifie si c'est bien l'Inuit qui touche l'objet
	# (En supposant que ton script Joueur.gd a une fonction 'ramasser_objet')
	if body.has_method("ramasser_objet"):
		var succes = body.ramasser_objet(objet_data)
		if succes:
			print(objet_data.nom + " ramassé(e) !")
			queue_free() # L'objet disparaît du sol
