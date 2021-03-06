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
	-	placement de la fenetre en bandeau 
			( bas� sur mon systeme � deux ecrans (je divise par 2 untruc) a voir comment faire plus universel )
	-	surveiller un dossier 
			facon winamp pour mise a jour auto de la base 
			( par exemple: 	- � l'ouverture on scane les dossiers, et on ajoute en auto les nouveaux assets sans faire de preview (comme ca c'est rapide)
							- on a la possibilit� dans un menu de selecctioner les assets sans previews (qui sont afficher de "RECHERCHE") )
	-	version du moteur du fichier a stocker dans 	str_element
	- 	importer-remplacer instances de la scene.
	-	checker materiaux � l'import 
			( si deja dans secene, pour utiliser celle de la scene, ecraser celle de la scene, ou renommer celle de l'import ( comme un merge classique en fait, a voir ...) )
	-	Sauvegarde de arbo.ini 
			( peut etre une sauvegarde / jour � la premiere ouverture du script en gardant 3 sauvegardes max)
	-	Systeme undo-redo
	- � l'ouverture, proposer de retirer de la biblio (et / ou du DD) les �l�ments n'ayant jamais �taient utilis�s depuis un certain temps ?
	
##########################################################################################################################
	changelog:
	*v0.1 - [22/09/2016] -----------------------------------------------------------------------------
	- Mise en place globale ( mise au propre du travail durant l'�t�)
	- Une interface souple et simple
########################################################################################################################*/

-- (
 
-- Global 	labib 

----  Le dossier du script  ----
nomDossierScript = "cp - labib"
dossierScript = getdir #userScripts + "\\" + nomDossierScript + "\\"


----------------------------------------------------------------------------
--------	Fichiers annexes						--------------------------
--------------------------------------------------------------------------
-- include "$userScripts\cp - labib\cp - GLOBAL\global - outils.ms"
-- include "$userScripts\cp - labib\cp - GLOBAL\UI.ms"
-- include "$userScripts\cp - labib\cp - GLOBAL\DragDialog.ms"


-- include "$userScripts\cp - labib\labib - output.ms"
-- include "$userScripts\cp - labib\labib - Outils divers.ms"
-- include "$userScripts\cp - labib\labib - manipNodes.ms"
-- include "$userScripts\cp - labib\labib - presets.ms"


--------------------------------------
----- les fichiers corps --------
--------------------------------------
include "$userScripts\cp - labib\labib - preferences.ms"
include "$userScripts\cp - labib\labib - arborescence.ms"

include "$userScripts\cp - labib\labib - Mgr - Divers.ms"
include "$userScripts\cp - labib\labib - Mgr - TreeView.ms"
include "$userScripts\cp - labib\labib - Mgr - ListView.ms"
include "$userScripts\cp - labib\labib - Mgr - ListView Tags.ms"

include "$userScripts\cp - labib\labib - menus.ms"

include "$userScripts\cp - labib\labib - fenetre proprietes.ms"
include "$userScripts\cp - labib\labib - fenetre apercus.ms"
include "$userScripts\cp - labib\labib - fenetre.ms"

include "$userScripts\cp - labib\labib - edition.ms"
include "$userScripts\cp - labib\labib - Mgr - Commandes.ms"	

-----------------------------------------
----- La structure principale -------
-----------------------------------------
struct str_labib (
	
	
		------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
		m_dbgPrefix ="LABIB",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	
	
	
	
		
	------------ Les structures	----------------------------------------------------------------------------------
	public
	
		---- preferences ----
		prefs		= 	str_preferences 		m_labib:this 	dossierScript:dossierScript,		---- les pr�ferences utilisateurs ----		
		
		---- manager de l'arborescence de la bib ----
		arbo		= 	str_arborescence 	fichierArbo:prefs.general.fichierArbo,		---- la gestion de l'arborescenece de la bibliotheque ----	
		
		---- interfaces ----
		menus	= str_menus (),														---- les menus RCMenu ----
		fenetre	= str_fenLabib				m_labib:this,							---- le manager de la fenetre principale (en post car boucle infernale avec edit sinon ) ----
		
		-- Fenetres secondaires --
		proprietes 	= 	str_proprietes 		m_labib:this,							---- la fenetre de creation des proprietes -----		
		apercus		=	str_apercus 		m_labib:this,							--- la fenetre des appercus
		
		--- le manager des rendus des aper�cus ----
--  		studio		= 	str_studio 			m_labib:this,							---- la fenetre de creation des apercus -----
		
		---- le coeur de la bib : commandes principales et gestion undo/redo  ----
		edit				= 	str_edition					m_labib:this,			---- les commandes utilisateurs,  l'edition proprement dite de la bibliotheque (creation d'un asset, import dans la scene ... ) ----		
		cmd 				= 	str_commandesMgr 		m_edit:edit,
		
			
		
		
		
	------------ Fonctions		----------------------------------------------------------------------------------
	--- Edition ----	
	public
	 	fn nouveauDossier 				=	edit.nouveauDossier	(),
		fn nouvelAsset 					=	edit.nouvelAsset	(),
		fn nouvelAsset_dossier 		=	edit.nouvelAsset_dossier (),
		fn supprimer 	_noeudsArbo	=	edit.supprimer	_noeudsArbo,
		
		fn creerDossier	_nom 	parent:arbo.root	=	edit.creerDossier	nom:_nom 	parent:parent,
		
		
	---- Accessions diverses -----------
	public
		fn getDossierInstal 	= dossierScript ,
		fn getSelection		= edit.getSelection (),
		
	--- Fenetre ----	
	public
		fn ouvrir 		= 	(
			debug "ouvrir fen�tre"
			fenetre.ouvrir()
		),			
		fn fermer 		= (
			fenetre.fermer()
		),
		fn estOuvert  	= prefs.fenetre.fenLabib_estOuvert, 
		
		fn creerArboDeBase = (
			
			if estOuvert() do fermer ()
			arbo.fichier_supprimer ()
			
			tmp_archi = creerDossier  "Archi"
				tmp_lgt = creerDossier  "Logement" 	parent:tmp_archi
					tmp_cuis = creerDossier  "Cuisine" 	parent:tmp_lgt
					tmp_sam = creerDossier  "Salle � manger" 	parent:tmp_lgt
					tmp_sal = creerDossier  "Sallon" 	parent:tmp_lgt
					tmp_chbre = creerDossier  "Chambre" 	parent:tmp_lgt
				tmp_bur = creerDossier  "Bureau" 	parent:tmp_archi
				tmp_comm = creerDossier  "Commerce" 	parent:tmp_archi
			tmp_veget = creerDossier  "V�g�tation"
				tmp_arbres = creerDossier  "Arbres" 	parent:tmp_veget
				tmp_Arbu = creerDossier  "Arbustes" 	parent:tmp_veget
				tmp_Fleu = creerDossier  "Fleurs" 	parent:tmp_veget
				tmp_herb = creerDossier  "Herbes" 	parent:tmp_veget
			tmp_vehi = creerDossier  "V�hicules"
				tmp_voit = creerDossier  "Voitures" 	parent:tmp_vehi
				tmp_voit = creerDossier  "2 roues" 		parent:tmp_vehi
			tmp_perso = creerDossier  "Personnages"
				tmp_hom = creerDossier  "Hommes" 	parent:tmp_perso
				tmp_fem = creerDossier  "Femmes" 	parent:tmp_perso
				tmp_enf = creerDossier  "enfants" 	parent:tmp_perso
				
-- 			ouvrir ()
		),
	------------ Evenements 	----------------------------------------------------------------------------------
	on create do (
		
		---- initialiser les pointeurs qui restent -----
		fenetre.m_edit				= edit		
-- 		gestionRendus.m_edit 	= edit
-- 		vues.m_rendus			= rendus
-- 		studio.initialiser ()
		
		--- initialiser Edition ----	
		edit.initialiser ()
		
		---- output ----
		debug "Structure cr��e."	
		ecrire "Pr�t."	
		
	) 
	
) -- fin struct labib ----



-- labib
-----------------------------------------
----- Cr�ation de la structure principale -------
-----------------------------------------
labib = str_labib ()
	
--  )


