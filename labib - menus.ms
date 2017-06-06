/* #######################################################################################################################

	2017 Christophe Pages (http://www.c-pages.fr) 

##########################################################################################################################
	
	Bibiotheque d'assets 
	
##########################################################################################################################

	Structs regroupant les differents menus ( clique droit et menu de la fenêtre principale )
	
######################################################################################################################## */ 




------------------------------------------------------------- ------------------------------------------
-------declaration (a voir comment pas la faire en global)  ------------------------------------------
------------------------------------------------------------- ------------------------------------------



--------------------------------------------------------------------------------
------ ajouter un menu quad ctrl+shft+RMB dans le viewport ----
macroScript Labib_mcr_nouvelAsset
category:"#CPages"
buttonText:"Creer nouvel asset de la sélection."
toolTip:""
(
	format "Creer nouvel asset de la sélection.\n"
	labib.cmd.nvlAssetSelec (selection as array)
)




rcMenu rc_fenLabib
(
	---- menu ----
-- 	subMenu "Edit"	(
-- 		menuItem m_nouveauDossier 	"Nouveau dossier" 
-- 		menuItem m_supprimer 				"Supprimer"					
-- 	)
-- 	seperator sep01					
-- 	subMenu "Vues" (
		menuItem m_afficherproprietes 			"proprietes"  		
		menuItem m_afficherApercus		"Création des aperçus" 
		menuItem m_preferences 			"Préferences" 
-- 	)
	
	---- evenements ----
	
)






-------------------------------------------------------------
------- le struct ------------------------------------------
-------------------------------------------------------------
struct str_menus (
	
	------------ DEBUG	----------------------------------------------------------------------------------
	private
		m_debug = true,
		m_dbgPrefix ="menus",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	
		----- le menu quad RMB --------
		fn ajouterMenuRMB =(
			debug "ajouterMenuRMB"
			monQuad = menuMan.createQuadMenu "Labib" "Labib" "quad2Name" "quad3Name" "quad4Name"
			menuMan.setViewportRightClickMenu #shiftAndControlPressed  monQuad
			menu1DuQuad = monQuad.getMenu 1
			testItem = menuMan.createActionItem "Labib_mcr_nouvelAsset" "#CPages"
			menu1DuQuad.addItem testItem -1
		),
		fn retirerMenuRMB =(
			debug "retirerMenuRMB"
			quadVide = menuMan.createQuadMenu "name" "quad1Name" "quad2Name" "quad3Name" "quad4Name"
			menuMan.setViewportRightClickMenu #shiftAndControlPressed  quadVide
		),
	
		
		fn init_quadMenu=(
			debug "init_quadMenu"
-- 			quadmenu = menuMan.findQuadMenu "Labib"
-- 			if quadmenu == undefined do 
-- 			debug "quadmenu" var:(menuMan.getQuadMenuName quadmenu)
			
			ajouterMenuRMB()
		),
		
		
	------------------------------------------------------------------------------------------------------------------
		
	public 	
		fn presets_studio = (		
			
			 rcMenu nvMenu
			(
				menuItem nouveau  					"Nouveau preset" 			
				menuItem sauvegarder  			"Sauvegarder" 		enabled:( labib.studio.aUnPresetSelection () )
				menuItem sauvegarderSous  		"Sauvegarder sous" 	enabled:( labib.studio.aUnPresetSelection () )
				menuItem supprimer		  			"Supprimer" 			enabled:( labib.studio.aUnPresetSelection () )
				
				
				on nouveau 				picked do	labib.studio.presets_nouveau ()
				on sauvegarder 			picked do	labib.studio.presets_sauvegarder ()
				on sauvegarderSous 	picked do	labib.studio.presets_sauvegarderSous ()
				on supprimer 				picked do	labib.studio.presets_supprimer ()
				
			)
			
			popUpMenu 	nvMenu
		),
		
		
		
		
	public 	
		fn apercus = (			
			format "APERCU\n"
			 rcMenu nvMenu
			(
				menuItem changerImage  			"Choisir image sur le disque" 	--filter:siRechercheEnCours
				menuItem rendreApercuAuto  	"Apercu auto" 	
				menuItem modeCreationApercu  	"Mode Apercu" 	
			) 
			
			popUpMenu 	nvMenu
		),
		
		
		
		
		
		fn elements = (			
			rcMenu nvMenu
			(
				------------ DEBUG	----------------------------------------------------------------------------------

				local m_debug = false
				fn debug 	_txt  		var:	 	param:    =(
					if m_debug do ::debuger 	_txt  var:var	 param:param
				)
				fn estRetour =(
					local selec = (labib.edit.getSelection ()) [1]
					selec.estRetour ()
				)
				
				fn aElementsSelectionnees = not labib.edit.selectionEstVide () and  not estRetour() 
				
				fn siRechercheEnCours =  labib.fenetre.m_dialog.m_recherche.estActif()
					
				
				----------------------------------------------------------------------------------------------------------
				menuItem afficherDansDossier  	"Affficher dans le dossier" 	filter:siRechercheEnCours
				
				------- le menu ------------------------------------------
				menuItem importer 					"Importer" 				enabled:( aElementsSelectionnees() )
				subMenu  "Options d'import" (					
					menuItem importerBrut 			"Brut" 			checked:true
					menuItem importerCollapsed 	"Collapsed" 		
					menuItem importerProxy 		"Proxy"					
				)
				
				seperator sep456			
				menuItem couper 				"Couper"  	enabled:( aElementsSelectionnees() )
				menuItem coller 					"Coller" 		enabled:( not labib.edit.pressePapierVide() )
				
-- 				subMenu  "Supprimer" 		(
				menuItem 	supprimer 			"Supprimer" 				enabled:( aElementsSelectionnees() )
-- 					menuItem 	supprimerDD 		"de Labib et du DD"	enabled:( aElementsSelectionnees() )
-- 				)
				
-- 				seperator sep01								
				menuItem Ourvir 						"Ourvir" 								enabled:( aElementsSelectionnees() )
				menuItem OurvirExplo 				"Ourvir dans l'explorateur" 		enabled:( aElementsSelectionnees() )
				
				seperator sep02
				
				menuItem nouveauDossier 		"Nouveau dossier"
				menuItem nouvelAsset 				"Nouvel asset"
				menuItem nouvelAssetDossier 	"Nouveaux assets depuis un dossier"
				/* 
				seperator sep086546
				
-- 				menuItem faireAprecus 				"Apercus"
				menuItem mode_Edition 				"Mode Edition"
				 */
				seperator sep08
				
				menuItem undoMenu 		"Undo"		enabled:( labib.cmd.aDesUndo () )
				menuItem redoMenu			"Redo"		enabled:( labib.cmd.aDesRedo () )
				
				seperator sep0353
				
				subMenu  "Affichage" (
					menuItem	affichage_details 			"Détails"						checked:( labib.prefs.fenetre.affichageLV == #details )
-- 					menuItem	affichage_liste 			"Liste"						checked:( labib.prefs.fenetre.affichageLV == #liste )
					menuItem 	affichage_GrandeIcone	"Icones"			checked:( labib.prefs.fenetre.affichageLV == #grandeIcone )
-- 					menuItem 	affichage_petitIcone		"Petites icones"			checked:( labib.prefs.fenetre.affichageLV == #petitIcone )
-- 					menuItem 	affichage_tuile				"Tuile"						checked:( labib.prefs.fenetre.affichageLV == #tuile )
					
					seperator sep20
					menuItem	afficherDossiers		"Afficher les dossiers"	checked:labib.prefs.fenetre.afficherDossier 
				)
				
				/* subMenu  "Trier par" (
					menuItem	trier_croissant 	"Ordre croissant"			checked:true
					menuItem	trier_decroissant 	"Ordre décroissant"	
					seperator sep10
					menuItem	trier_nom 			"Noms"						checked:true
					menuItem	trier_date 			"Date"	
					menuItem	trier_nbrVertex 	"Nombre de vertex"
					menuItem	trier_nbrImports 	"Nombre d'imports"	
				)
				 */
					seperator sep26548
-- 				subMenu  "Fenêtres" (
					menuItem apercus 		"Aperçus" 				checked:( labib.apercus.estOuvert() )
					menuItem proprietes 	"Propriétés" 		checked:( labib.proprietes.estOuvert() )
				
				subMenu  "studio" (
					menuItem rendre	 		"Rendre" 			
					menuItem ourvirStudio	 	"Ouvrir" 			--	checked:( labib.studio.estOuvert() )
				)
				
				seperator sep5476
				
				menuItem prefs	 	"Préférences" 			checked:(labib.prefs.estOuvert ())
				
				seperator sep54768
						
				subMenu  "Debug" (
					menuItem affichSelec 		"print selection" 	--	checked:labib.prefs.fenetre.fenproprietes_estOuvert
					menuItem debugMode 		"Debug mode" 		checked:DEBUG_MODE		
				)
				
				
				on debugMode 			picked do	DEBUG_MODE = not DEBUG_MODE
				------- les evenements ------------------------------------------				
				on importer 						picked do	labib.cmd.importer ( labib.edit.getSelection () ) 
				on nouveauDossier 				picked do	labib.cmd.nvDossier ()				
				on nouvelAsset 					picked do	labib.cmd.nvlAsset ()				
				on nouvelAssetDossier 			picked do	labib.cmd.nvxAssets()	
				
				on OurvirExplo 					picked do	labib.edit.ouvrirDansExplorer ( labib.edit.getSelection () )[1]
				on Ourvir 							picked do	labib.edit.ouvrirFichier ( labib.edit.getSelection () )[1]
				
				on couper  picked do  labib.cmd.couper 	( labib.edit.getSelection () )
				on coller  	picked do  (
					local selec = labib.edit.getSelection () 
					if selec.count >0 
						then	labib.cmd.coller 	selec[1]			
						else 	labib.cmd.coller 	( labib.edit.getDossier () )
				)
				on supprimer 						picked do 	labib.cmd.supprimer 	( labib.edit.getSelection () ) 
				
				
-- 				on faireAprecus 					picked do 	labib.edit.faireApercus 	( labib.edit.getSelection () ) 
				on mode_Edition 					picked do labib.edit.toggleModeEdition ()
				

				on faireAprecus 					picked do 	labib.cmd.faireApercus 	( labib.edit.getSelection () ) 

				
				on undoMenu 						picked do 		labib.cmd.defaire()
				on redoMenu 						picked do 		labib.cmd.refaire()
				
				
				on affichage_details 			picked do	labib.fenetre.changerAffichage  #details
				on affichage_liste				picked do	labib.fenetre.changerAffichage  #liste
				on affichage_GrandeIcone		picked do	labib.fenetre.changerAffichage  #grandeIcone
				on affichage_petitIcone		picked do	labib.fenetre.changerAffichage  #petitIcone
				on affichage_tuile				picked do	labib.fenetre.changerAffichage  #tuile
				
				
				
				
				on afficherDossiers 				picked do 	(
					labib.prefs.fenetre.afficherDossier = not labib.prefs.fenetre.afficherDossier
					labib.fenetre.actualiser ()
				)
				
				on proprietes						picked do	labib.proprietes.toggleOuverture ()
				on apercus							picked do	labib.apercus.toggleOuverture ()
-- 				on ourvirStudio					picked do	labib.studio.toggleOuverture ()
				on prefs								picked do	labib.prefs.toggleOuverture ()
			
				on affichSelec						picked do		for n in labib.edit.getSelection () do	labib.arbo.afficherNoeud	n
				
			)
			popUpMenu 	nvMenu
			
		),
		
		
		fn arbo = (
			debug "creerMenuTest"
			-------------------------------------------------------------
			------- le menu ------------------------------------------
			-------------------------------------------------------------
			rcMenu nvMenu
			(
				
				------------ DEBUG	----------------------------------------------------------------------------------

				local m_debug = true
				
				local m_dbgPrefix ="menu Arbo"
				fn debug 	_txt  var:	 param:    =(
					if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
				)
				----------------------------------------------------------------------------------------------------------
				
				fn estElemUtilisateur = (
					local dossierCourant = labib.edit.getDossier ()
					dossierCourant.estElemUtilisateur ()
				)
				fn estRecherche =(
					local dossierCourant = labib.edit.getDossier ()
					dossierCourant.estRecherche ()
				)
				
				------- le menu ------------------------------------------
-- 				subMenu  "Nouvel Asset" (
				menuItem nouvelAsset 				"Nouvel Asset"
				menuItem nouvelAssetDossier 	"Nouvel Asset depuis un dossier"
-- 				)
				
				seperator sep01
				menuItem nouveauDossier 	"Nouveau dossier" 
-- 				menuItem renommer 			"Renommer"
				
				seperator sep01563
				menuItem couper 				"Couper"  		enabled:( estElemUtilisateur () )
				menuItem coller 					"Coller" 			enabled:( not labib.edit.pressePapierVide() and not estRecherche () )
				menuItem supprimer 			"Supprimer"		enabled:( estElemUtilisateur () )
				
				seperator sep03
				menuItem undoMenu 		"Undo"		enabled:( labib.cmd.aDesUndo () )
				menuItem redoMenu			"Redo"		enabled:( labib.cmd.aDesRedo () )
				
				seperator sep0353

				
				menuItem expandAll 			"Expand all"
				
				seperator sep04
						
				
				menuItem rechercheAvance 			"Recherche avancée"
				------- les evenements ------------------------------------------
				on nouveauDossier 			picked do	labib.cmd.nvDossier ()
				on nouvelAsset 				picked do	labib.cmd.nvlAsset ()				
				on nouvelAssetDossier 		picked do	labib.cmd.nvxAssets()		
				on renommer 					picked do	labib.renommer ()	
				
				on supprimer 					picked do 	labib.cmd.supprimer 		( labib.edit.getDossier () )
								
				
				on undoMenu 						picked do 		labib.cmd.defaire()
				on redoMenu 						picked do 		labib.cmd.refaire()
				
				on couper  picked do  (
					local source = labib.edit.getDossier () 
					debug "couper" var:source	param:#nomUnique
					labib.edit.ouvrir 	source.parent
					labib.cmd.couper 	source
				)
				on coller  	picked do  (
					local dest = labib.edit.getDossier () 
					labib.cmd.coller 	dest			
				)
				
				on expandAll picked do labib.fenetre.m_dialog.ui_TV.expandAll ()
				
			)
			
			popUpMenu 	nvMenu
		),
		fn recherche = (	
			rcMenu nvMenu
			(	
				------- le menu ------------------------------------------
				
				menuItem rechercheNoms 		"Rechercher dans les noms" 	checked:labib.fenetre.m_dialog.m_recherche.m_rechercheDansNoms
				menuItem rechercheTags 		"Rechercher dans les tags" 	checked:labib.fenetre.m_dialog.m_recherche.m_rechercheDansTags
				
				seperator sep02
				
				menuItem recursif  	"Recursif"  	 checked:labib.fenetre.m_dialog.m_recherche.m_recursif
				
				------- les evenements ------------------------------------------
				on rechercheNoms 	picked do	labib.fenetre.m_dialog.m_recherche.toggle_rechercheDansNoms ()
				on rechercheTags 	picked do	labib.fenetre.m_dialog.m_recherche.toggle_rechercheDansTags ()
				on recursif 	picked do	labib.fenetre.m_dialog.m_recherche.toggle_recursif ()
			)
			popUpMenu nvMenu
		),
		
		fn tags = (	
			rcMenu nvMenu
			(	
				------- le menu ------------------------------------------
				
				menuItem checkAll 		"Check all" 	
				menuItem uncheckAll 	"Uncheck all" 	
				
				seperator sep02
				
				menuItem recursif  	"Recursif" 	 checked:labib.fenetre.m_dialog.m_tags.m_recursif
				
				
				------- les evenements ------------------------------------------
				on checkAll 		picked do	()
				on uncheckAll 	picked do	()
				on recursif 			picked do	labib.fenetre.m_dialog.m_tags.toggleRecursif ()
			)
			popUpMenu nvMenu
		),
		fn fenetre = (	
			rcMenu nvMenu
			(	
				------- le menu ------------------------------------------
				
				menuItem titre 			"Titre" 		checked:labib.prefs.fenetre.afficherTitre
				menuItem menu 			"Menus" 		checked:labib.prefs.fenetre.afficherMenu
				seperator sep02
				
-- 				subMenu "Fenêtres" (
					menuItem afficherproprietes 			"proprietes"  				checked:labib.prefs.fenetre.proprietes
					menuItem afficherApercus			"Aperçus" 
					menuItem afficherPreferences 	"Préferences" 
-- 				)
				seperator sep01
				menuItem fermer 			"Fermer" 
				seperator sep03
				menuItem site 			"www.c-pages.fr" 
				
				------- les evenements ------------------------------------------
				on fermer 		picked do	labib.fenetre.fermer ()
				
				on menu 		picked do	(
					labib.prefs.fenetre.afficherMenu   = not labib.prefs.fenetre.afficherMenu
					labib.fenetre.fermer	()
					labib.fenetre.ouvrir 	()
				)
				
				on titre 		picked do	(
					labib.prefs.fenetre.afficherTitre   = not labib.prefs.fenetre.afficherTitre
					labib.fenetre.fermer	()
					labib.fenetre.ouvrir 	()
				)
				
				
				
				on afficherproprietes				picked do	labib.toggleproprietes ()
				
				on site 			picked do	labib.ouvrirSiteInternet ()
			)
			popUpMenu nvMenu
		),
	---------- evenements ----------------------------
		on create do (
			debug "Structure créée."
			init_quadMenu ()
		)
)

