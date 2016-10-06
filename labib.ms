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
	-	version du moteur du fichier a stocker dans 	str_element
	- 	importer-remplacer instances
	-	checker si materiaux deja dans secene à l'import, pour utiliser celle de la scene, ecraser celle de la scene, ou renommer celle de l'import ( comme un merge classique en fait, a voir ...)
	
##########################################################################################################################
	changelog:
	*v0.1 - [22/09/2016] -----------------------------------------------------------------------------
	- Mise en place globale ( mise au propre du travail durant l'été)
	- Une interface souple et simple
########################################################################################################################*/




----  Le dossier du script  ----
nomDossierScript = "labib"
dossierScript 		-- en fonction de monMax --

--------------------------------------
----- les fichiers à inclure --------
--------------------------------------
dossierScript = getdir #userScripts + "\\" + nomDossierScript + "\\"

include "$userScripts\labib\labib - output.ms"
include "$userScripts\labib\labib - Outils divers.ms"

include "$userScripts\labib\labib - preferences.ms"

include "$userScripts\labib\labib - Mgr - TreeView.ms"
include "$userScripts\labib\labib - Mgr - ListView.ms"
include "$userScripts\labib\labib - Mgr - Divers.ms"

include "$userScripts\labib\labib - menus.ms"		
include "$userScripts\labib\labib - arborescence.ms"	
-- include "$userScripts\labib\labib - fenetres secondaires.ms"
include "$userScripts\labib\labib - fenetre.ms"
include "$userScripts\labib\labib - edition.ms"	

-----------------------------------------
----- La structure principale -------
-----------------------------------------
struct str_labib (
	
	------------ Les structures	----------------------------------------------------------------------------------
	public
	
		prefs		= str_preferences 	dossierScript:dossierScript,		---- les préferences utilisateurs ----
		arbo		= str_arborescence 	fichierArbo:prefs.fichierArbo,		---- la gestion de l'arborescenece de la bibliotheque ----	
		menus	= str_menus (),													---- les menus RCMenu ----
		fenetre	= str_fenLabib			m_labib:this, 						---- le manager de la fenetre principale (en post car boucle infernale avec edit sinon ) ----
		edit 		= str_edition 			m_labib:this,							---- les commandes utilisateurs,  l'edition proprement dite de la bibliotheque (creation d'un asset, import dans la scene ... ) ----

 		rendu,																			---- la gestion des rendus des apercus ----		
	
	------------ Fonctions		----------------------------------------------------------------------------------
	--- Edition ----	
	public
		fn nouveauDossier 				=	edit.nouveauDossier	(),
		fn nouvelAsset 					=	edit.nouvelAsset	(),
		fn nouvelAsset_dossier 		=	edit.nouvelAsset_dossier (),
		fn supprimer 	_noeudsArbo	=	edit.supprimer	_noeudsArbo,
		
	--- Fenetre ----	
	public
		fn ouvrir 		= (			
			fenetre.ouvrir()
		),
			
		fn fermer 		= fenetre.fermer(),
		fn estOuvert  	= prefs.fenetre.fenLabib_estOuvert, 
	
	------------ Evenements 	----------------------------------------------------------------------------------
	on create do (
		--- initialiser le manager de fenetre ----	
			edit.initialiser ()		
		ecrire "Structure Labib crée."		
	)
	
) -- fin struct labib ----




-----------------------------------------
----- Création de la structure principale -------
-----------------------------------------
labib = str_labib ()
	
	


