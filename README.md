1)Job Overview : Les fichiers "Job_Overview_MCD" (Modèle Conceptuel de Données) et "Job_Overview_MPD" (Modèle Physique de Données) sont fournis en PDF

	1.1 Créer une nouvelle base de données appelée Job Overview dans Microsoft SQL Server Management Studio
	
	1.2 Exécuter le sript "Création de la base.SQL" dans un New Query de la base précédemment créée
	
	1.3 Exécuter le sript "Jeu de données.SQL" pour remplir la base
	
	1.4 Exécuter le scrip "Logique métier.SQL" pour créer des procédures afin de finir de remplir la base 
		(on peut exécuter la procédure commentée dans la partie "La saisie de temps sur une tâche"
		pour vérifier le fonctionnement des messages d'erreurs lors du dépassement des 8 heures quotidiennes)
	
	1.5 Exécuter le script "Requete 1.2.5 Besoins.SQL" afin de vérifier que les besoins sont remplis
	
2) Grand hotel

	2.1 Dans Microsoft SQL Server Management Studio faire un clic droit sur "Databases"->"Restore database" 
	
	2.2 Donner le nom "Grand hotel" dans "To database", cocher from device, chercher le fichier "Grand hotel.bak" et cocher le case "Restore"
	
	2.3 Dans option selectionner "Overwrite the existing database"
	
	2.4 Dans un New Query de la base précédemment restauré éxécuter le sript "Grand hotel.sql" requête par requête pour constater leur bon résultat
