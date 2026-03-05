extends Node

func lancer_des(formule: String) -> int:
	var total = 0
	var parties = formule.replace(" ","").split("+")
	
	for partie in parties:
		if "d" in parties:
			var des = parties.split("d")
			var nb_des = int(des[0])
			var faces_des = int(des[1])
			
			for i in range(nb_des):
				total += randi_range(1,faces_des)
		else:
			total += int(partie)
	return total
