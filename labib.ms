/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################

	todo:
	-	renommage des assets selectionnés avec possibilité de numerotation auto
	-	probleme de suppression d'elements qui se retire pas de la biblio ?!?!
	-	attention menu Edit/suppression : pas claire, ça supprime le dossier, pas element. rendre plus claire
	-	faire du ménage dans la mise a jour de la listView ( voir si on doit vraiment tout recharger à chaque fois ? )
	-	listeVue : faire une vue détail ( image, détail, liste )
	-	Bouton pour cacher/montrer le panneau de gauche (explorateur + mots clés + status barre)
					-	faire apparaitre les dossiers dans la liseVue pour pouvoir entrer dedans
					-	faire un bouton pour remonter dans l'arborescence
	- remplacer le fetch de max par un fetch perso pour pas ecraser le fetch de l'utilisateur
	
##########################################################################################################################
	changelog:
	*v0.1 - [22/09/2016] -----------------------------------------------------------------------------
	- Mise en place globale ( mise au propre du travail durant l'été)
########################################################################################################################*/





(
	
	-------------------------------------
	------ DEBUG	---------------------
	-------------------------------------
	---- output ----
	global debug, b_DEBUG = true
	fn debug 	_txt  var:"" = 	(
		if b_DEBUG do 
			format "<biblio>	"
			if var == "" then 
				format "%\n" ( _txt  )
			else 
				format "	- % : %\n" _txt   ( var  as string )
	)

	
	
	
	
	
	----  Le dossier du script  ----
	local nomDossierScript = "labib"
	local dossierScript = getdir #userScripts + "\\" + nomDossierScript + "\\"
	
	-------------------------------------
	----- les fichiers à inclure -------
	-------------------------------------
	
	include "$userScripts\labib\labib - preferences.ms"
	include "$userScripts\labib\labib - arborescence.ms"
	include "$userScripts\labib\labib - fenetres.ms"
	include "$userScripts\labib\labib - edition.ms"
	include "$userScripts\labib\labib - menus.ms"

	-----------------------------------------
	----- La structure principale -------
	-----------------------------------------
	struct labib_struct (
		
		------------ Les structures	----------------------------------------------------------------------------------
		prefs		= Preference_struct 		dossierScript:dossierScript,		---- les préferences utilisateurs ----
		fenetre	= Fenetre_struct 			prt:this, 								---- les operations sur la fenetre principale ----
		arbo		= Arborescence_struct 	fichier:prefs.fichierArbo,			---- la gestion de l'arborescenece de la bibliotheque ----	
		apercu,																					---- la gestion des rendus des apercus ----		
		edition	= Edition_struct 				prefs:prefs	arbo:arbo,				---- l'edition proprement dite de la bibliotheque (creation d'un asset, import dans la scene ... ) ----
		menu		= menu_struct (),														---- les menus clique droit ----
		
		------------ Fonctions		----------------------------------------------------------------------------------
		fn renommer =(
			---- Entrer en mode edition du label du noeud selectionné --
			local noeudArboSelec = fenetre.selectionNoeud
			fenetre.dialog.editerNomTV 	noeudArboSelec
		),
		fn nouveauDossier 	=(			
			-- creation de noeud --
			local noeudArboSelec = fenetre.selectionNoeud
			local parent
			if noeudArboSelec.nomUnique == "RECHERCHE" 
				then parent = arbo.root
				else	parent = noeudArboSelec
			local	nouveauNoeud  = arbo.creerNoeud  	parent:parent
			
			--ecriture du fichier ---
			arbo.enregistrer ()
			
			-- actualisation rollout--
			fenetre.actualiser()
			fenetre.dialog.selectionnerTV		nouveauNoeud.parent
			fenetre.dialog.selectionnerLV		#( nouveauNoeud )
			
		),
		fn nouvelAsset =(),		
		fn nouvelAssetDossier =(),
		fn supprimer _noeudsArbo	=(
			local parent = _noeudsArbo[1].parent
			arbo.supprimer _noeudsArbo
			arbo.enregistrer ()
			
			fenetre.actualiser ()
			
			fenetre.dialog.SelectionnerTV 	parent
			
		),
		
		
		fn ouvrirSiteInternet = (
			DOSCommand  "start \"\" http://c-pages.fr"
		),
		
		------------ Evenements 	----------------------------------------------------------------------------------
		on create do 
			debug "<labib>	creation struture"
		
	) -- fin struct labib ----
	
	
	
	
	-----------------------------------------
	----- Création de la structure principale -------
	-----------------------------------------
	global labib = labib_struct ()
	
)

