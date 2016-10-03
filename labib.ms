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
	-	surveiller un dossier facon winamp pou mise a jour auto de la base 
		( par exemple: 	- à l'ouverture on scane les dossiers, et on ajoute en auto les nouveaux assets sans faire de preview (comme ca c'est rapide)
							- on a la possibilité dans un menu de selecctioner les assets sans previews (qui sont afficher de "RECHERCHE") )
	
##########################################################################################################################
	changelog:
	*v0.1 - [22/09/2016] -----------------------------------------------------------------------------
	- Mise en place globale ( mise au propre du travail durant l'été)
	- Une interface souple et simple
########################################################################################################################*/



------ DEBUG	------------------------------------------------------------------------------------------------------------------------------------
global 	debug
DEBUG_MODE = false
fn debug 	_txt  var:"" = 	(
	if DEBUG_MODE   do (
		format "<DEBUG>	"
		if var == "" then 
			format "%\n" ( _txt  )
		else 
			format "	- % : %\n" _txt   ( var  as string )
	)
)		
------ DEBUG	------------------------------------------------------------------------------------------------------------------------------------

----- output ------------------------------
fn ecrire 	_txt  var:"" = 	(
	
	format "<Labib>	"
	if var == "" then 
		format "%\n" ( _txt  )
	else 
		format "	- % : %\n" _txt   ( var  as string )
)		
----- output ------------------------------


----  Le dossier du script  ----
nomDossierScript = "labib"
dossierScript 		-- en fonction de monMax --

--------------------------------------
----- les fichiers à inclure --------
--------------------------------------
dossierScript = getdir #userScripts + "\\" + nomDossierScript + "\\"

include "$userScripts\labib\labib - structs.ms"
include "$userScripts\labib\labib - preferences.ms"
include "$userScripts\labib\labib - menus.ms"		
include "$userScripts\labib\labib - arborescence.ms"	
-- 	 	include "$userScripts\labib\labib - fenetres secondaires.ms"
include "$userScripts\labib\labib - fenetre.ms"
-- 	 	include "$userScripts\labib\labib - edition.ms"	

-----------------------------------------
----- La structure principale -------
-----------------------------------------
struct str_labib (
	
	------------ Les structures	----------------------------------------------------------------------------------
	prefs		= str_preferences 	dossierScript:dossierScript,		---- les préferences utilisateurs ----
	arbo		= str_arborescence 	fichierArbo:prefs.fichierArbo,			---- la gestion de l'arborescenece de la bibliotheque ----	
	menus	= str_menus (),													---- les menus clique droit ----
	fenetre	= str_fenLabib			m_labib:this, 							---- les operations sur la fenetre principale ----
-- 		rendu,																					---- la gestion des rendus des apercus ----		
-- 		edition	= Edition_struct 				prefs:prefs		arbo:arbo,			---- l'edition proprement dite de la bibliotheque (creation d'un asset, import dans la scene ... ) ----
	
	
	chrono = str_chrono (),
	
	------------ Fonctions		----------------------------------------------------------------------------------

	public
	
	fn getDossierCourant = (
		fenetre.m_dialog.m_TV.m_selection
	),
	fn getElementsSelection = (
		fenetre.m_dialog.m_LV.m_selection
	),
	
	--- actions generales ---
	fn nouveauDossier 	=(
		
		-- creation de noeud --
		local noeudArboSelec = getDossierCourant ()
		local parent
		if noeudArboSelec.nomUnique == "RECHERCHE" 
			then	parent = arbo.root
			else	parent = noeudArboSelec
		local	nouveauNoeud  = arbo.creerNoeud  	parent:parent
		
		-- actualisation rollout--
		fenetre.actualiser()		
		fenetre.selectionnerTV		nouveauNoeud.parent
		fenetre.selectionnerLV		nouveauNoeud
		fenetre.editerNom			nouveauNoeud
		
		--- ecrire sur le fichier ---
		nouveauNoeud.enregistrer ()
		parent.enregistrer ()
		
		--- sortie Listener --
		ecrire "Noeud renommé."
		
	),
	fn nouvelAsset =(
		
		--- sortie Listener --
		chrono.demarrer ()
		
		---- fenetre de pointage de fichier ----
		local	fichierSource = 	getOpenFileName  	caption:				"Fichier source du nouvel asset" \
																	types:				"model (*.max)|*.max|All Files (*.*)|*.*|"	\
																	historyCategory:	"labib"	\
																	filename:			( prefs.general.dossierNouvelAsset +"\\" )
		
		if 	fichierSource != undefined  do (
			
			debug "Importer " var:fichierSource
			
			---- creation du nouveau noeud ----
			local nouvelElement = arbo.creerElement  	nom:(getFilenameFile	fichierSource) \
																		parent:(  getDossierCourant () )   		\
																		fichier:fichierSource							\
																		apercu:""	\
																		tags:""	\
																		type:#vide	
			
			--- ecrire sur le fichier ---
			nouvelElement.enregistrer ()
			nouvelElement.parent.enregistrer ()
			
			---- actualise l4UI ----
			fenetre.actualiser ()			
			fenetre.selectionnerLV 	nouvelElement 
			
			debug "nouvelAsset Créé."
			
			--- sortie Listener --
			ecrire ( "Asset créé: " + nouvelElement.nom )
			chrono.ecrireDuree ()
			
		)
	),		
	fn nouvelAssetDossier =(
		
		local	dossierSource = 	getSavePath	caption:	"Fichier source du nouvel asset" \
															initialDir:	prefs.general.dossierNouvelAsset
		
		if dossierSource != undefined do (
			
			ecrire "Créer asset depuis dossier ..."
			
			chrono.demarrer ()
			
			debug "Creer asset"
			
			local fichiersMax = getFiles ( dossierSource + "\\*.max" )
			local nouveauxElements = #()
			
			for fichierSource in fichiersMax do (
				
				local nouvelElement = arbo.creerElement  	nom:(getFilenameFile	fichierSource) \
																			parent:(  getDossierCourant () )   		\
																			fichier:fichierSource							\
																			apercu:""	\
																			tags:""		\
																			type:#vide
				debug "nom" var:nouvelElement.nom
				
				nouvelElement.enregistrer ()
				append nouveauxElements nouvelElement
			)
			
			(  getDossierCourant () ).enregistrer ()
			
			fenetre.actualiser ()			
			fenetre.selectionnerLV 	nouveauxElements
			
			debug "nouvelAsset Créé."
			
			--- maj des prefs ---
			prefs.general.dossierNouvelAsset = dossierSource
		)
		ecrire ( "Dossier importer : " +  nouveauxElements.count as string + " assets crées." )
		chrono.ecrireDuree ()
		
	),
	fn supprimer _noeudsArbo	=(
		
		if classof _noeudsArbo != Array 
			do _noeudsArbo = #(_noeudsArbo)
		
		local parent = _noeudsArbo[1].parent
		arbo.supprimer 	_noeudsArbo
-- 		arbo.enregistrer ()
		
		fenetre.actualiser()		
		fenetre.selectionnerTV		parent
		
	),		
	fn ouvrirSiteInternet = (
		DOSCommand  "start \"\" http://c-pages.fr"
	),
	
	
	fn  changerAffichage  _nouvelAffichage =(
		fenetre.m_dialog.m_LV.changerAffichage		 _nouvelAffichage
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
	fn ouvrir 		= fenetre.ouvrir(),
	fn fermer 		= fenetre.fermer(),
	fn estOuvert  	= prefs.fenetre.fenLabib_estOuvert, 
	
	------------ Evenements 	----------------------------------------------------------------------------------
	on create do 
		ecrire "Structure Labib crée."
	
) -- fin struct labib ----




-----------------------------------------
----- Création de la structure principale -------
-----------------------------------------
labib = str_labib ()
	
	


