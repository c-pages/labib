/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	Le script principale
	
##########################################################################################################################

	todo:
	-	le placement de la fenetre en bandeau est basé sur mon systeme à deux ecrans (je divise par 2 untruc) a voir comment faire plus universel
	
##########################################################################################################################
	changelog:
	*v0.1 - [22/09/2016] -----------------------------------------------------------------------------
	- Mise en place globale ( mise au propre du travail durant l'été)
	- Une interface souple et simple
########################################################################################################################*/

(
	
	------ DEBUG	------------------------------------------------------------------------------------------------------------------------------------
	global 	debug, 	b_DEBUG = true	
	fn debug 	_txt  var:"" = 	(
		if b_DEBUG do 
			format "<Labib>	"
			if var == "" then 
				format "%\n" ( _txt  )
			else 
				format "	- % : %\n" _txt   ( var  as string )
	)		
	------ DEBUG	------------------------------------------------------------------------------------------------------------------------------------
	
	---- la structure principale ----
	global labib
	
	----  Le dossier du script  ----
	local nomDossierScript = "labib"
	local dossierScript 		-- en fonction de monMax --
	
	--------------------------------------
	----- les fichiers à inclure --------
	-- en fonction de monMax		--
	--------------------------------------
	---- pour mon max 2017 ----
	dossierScript = "C:\Users\kris\AppData\Local\Autodesk\3dsMax\2014 - 64bit\ENU\scripts\\" + nomDossierScript + "\\"
	
	include "C:\Users\kris\AppData\Local\Autodesk\3dsMax\2014 - 64bit\ENU\scripts\labib\labib - structs.ms"			
	include "C:\Users\kris\AppData\Local\Autodesk\3dsMax\2014 - 64bit\ENU\scripts\labib\labib - preferences.ms"
	include "C:\Users\kris\AppData\Local\Autodesk\3dsMax\2014 - 64bit\ENU\scripts\labib\labib - arborescence.ms"	
	include "C:\Users\kris\AppData\Local\Autodesk\3dsMax\2014 - 64bit\ENU\scripts\labib\labib - fenetres secondaires.ms"
	include "C:\Users\kris\AppData\Local\Autodesk\3dsMax\2014 - 64bit\ENU\scripts\labib\labib - fenetre.ms"
	include "C:\Users\kris\AppData\Local\Autodesk\3dsMax\2014 - 64bit\ENU\scripts\labib\labib - edition.ms"
	include "C:\Users\kris\AppData\Local\Autodesk\3dsMax\2014 - 64bit\ENU\scripts\labib\labib - menus.ms"
format "PAR LA "
-- 	---- pour mon max 2014 ----
-- 	dossierScript = getdir #userScripts + "\\" + nomDossierScript + "\\"
-- 	
-- 	include "$userScripts\labib\labib - structs.ms"
-- 	include "$userScripts\labib\labib - preferences.ms"
-- 	include "$userScripts\labib\labib - arborescence.ms"	
-- 	include "$userScripts\labib\labib - fenetres secondaires.ms"
-- 	include "$userScripts\labib\labib - fenetre.ms"
-- 	include "$userScripts\labib\labib - edition.ms"
-- 	include "$userScripts\labib\labib - menus.ms"			

	-----------------------------------------
	----- La structure principale -------
	-----------------------------------------
	struct str_labib (
		
		------------ Les structures	----------------------------------------------------------------------------------
		prefs		= str_preferences 			dossierScript:dossierScript,		---- les préferences utilisateurs ----
		fenetre	= str_fenetre 					prt:this, 								---- les operations sur la fenetre principale ----
		arbo		= Arborescence_struct 	fichier:prefs.fichierArbo,			---- la gestion de l'arborescenece de la bibliotheque ----	
		rendu,																					---- la gestion des rendus des apercus ----		
		edition	= Edition_struct 				prefs:prefs		arbo:arbo,			---- l'edition proprement dite de la bibliotheque (creation d'un asset, import dans la scene ... ) ----
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
		fn nouvelAsset =(
			
			debug "nouvelAsset..."
			local	fichierSource = 	getOpenFileName  	caption:				"Fichier source du nouvel asset" \
																		types:				"model (*.max)|*.max|All Files (*.*)|*.*|"	\
																		historyCategory:	"labib"	/* \
																		filename:elemSelect[1].fichier  */
			
			if 	fichierSource != undefined  do (
				debug "Importer " var:fichierSource
				local nouvelElement = arbo.creerElement  	nom:(getFilenameFile	fichierSource) \
																			parent:fenetre.selectionNoeud  			\
																			fichier:fichierSource							\
																			apercu:""	\
																			tags:""	\
																			type:#vide	
				arbo.enregistrer ()
				fenetre.actualiser ()			
				fenetre.dialog.SelectionnerLV 	nouvelElement
				debug "nouvelAsset Créé."
				
			)
			
		),		
		fn nouvelAssetDossier =(),
		fn supprimer _noeudsArbo	=(
			
			local parent = _noeudsArbo[1].parent
			arbo.supprimer _noeudsArbo
			arbo.enregistrer ()
			
			fenetre.actualiser ()			
			fenetre.dialog.actualiserSelections ()			
			fenetre.dialog.SelectionnerTV 	parent
			
		),		
		fn ouvrirSiteInternet = (
			DOSCommand  "start \"\" http://c-pages.fr"
		),
		
		
		
		
		fn toggleInfos =(
			if prefs.fenetre.infos 
				then fenetre.infos.fermer ()
				else	fenetre.infos.ouvrir ()
		),
		fn toggleApercu =(
			if prefs.fenetre.apercu 
				then fenetre.apercu.fermer ()
				else	fenetre.apercu.ouvrir ()
		),
		fn toggleRendu =(
			if prefs.fenetre.rendu 
				then fenetre.rendu.fermer ()
				else	fenetre.rendu.ouvrir ()
		),
		
		
		--- la fenetre ----
		fn ouvrir 	= fenetre.ouvrir(),
		fn fermer 	= fenetre.fermer(),
		
		------------ Evenements 	----------------------------------------------------------------------------------
		on create do 
			debug "<LABIB>		creation struture"
		
	) -- fin struct labib ----
	
	
	
	
	-----------------------------------------
	----- Création de la structure principale -------
	-----------------------------------------
	str_labib ()
	
	
)

