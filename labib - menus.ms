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

rcMenu rc_fenLabib
(
	---- menu ----
	subMenu "Edit"	(
		menuItem m_nouveauDossier 	"Nouveau dossier" 
		menuItem m_supprimer 				"Supprimer"					
	)
	subMenu "Vues" (
		menuItem m_afficherInfos 			"Infos"  		
		menuItem m_afficherApercus		"Création des aperçus" 
	)
	subMenu "Préferences"	(
		menuItem m_preferences 			"Préferences" 
		menuItem m_resetPreferences 	"Reinitialiser" 
	)
	
	---- evenements ----
	
)




-------------------------------------------------------------
------- le struct ------------------------------------------
-------------------------------------------------------------
struct str_menus (
	
	------------ DEBUG	----------------------------------------------------------------------------------
	private
		m_debug = false,
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  var:var	 param:param
		),
	----------------------------------------------------------------------------------------------------------
	
	
	public 	
		fn elements = (			
			rcMenu rcMenuElements
			(
				------------ DEBUG	----------------------------------------------------------------------------------

				local m_debug = false
				fn debug 	_txt  var:	 param:    =(
					if m_debug do ::debuger 	_txt  var:var	 param:param
				)
				fn estRetour =(
					local selec = (labib.edit.getSelection ()) [1]
					selec.estRetour ()
				)
				
				fn aElementsSelectionnees = not labib.edit.selectionEstVide () and  not estRetour() 
				
				
				----------------------------------------------------------------------------------------------------------
				
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
				
				seperator sep086546
				
				menuItem faireAprecus 				"Apercus"
				
				seperator sep08
				
				menuItem undoMenu 		"Undo"		enabled:( labib.cmd.aDesUndo () )
				menuItem redoMenu			"Redo"		enabled:( labib.cmd.aDesRedo () )
				
				seperator sep0353
				
				subMenu  "Affichage" (
					menuItem	affichage_details 			"Détails"						checked:( labib.prefs.fenetre.affichageLV == #details )
					menuItem	affichage_liste 			"Liste"						checked:( labib.prefs.fenetre.affichageLV == #liste )
					menuItem 	affichage_GrandeIcone	"Grandes icones"			checked:( labib.prefs.fenetre.affichageLV == #grandeIcone )
					menuItem 	affichage_petitIcone		"Petites icones"			checked:( labib.prefs.fenetre.affichageLV == #petitIcone )
					menuItem 	affichage_tuile				"Tuile"						checked:( labib.prefs.fenetre.affichageLV == #tuile )
					
					seperator sep20
					menuItem	afficherDossiers		"Afficher les dossiers"	checked:labib.prefs.fenetre.afficherDossier 
				)
				subMenu  "Trier par" (
					menuItem	trier_croissant 	"Ordre croissant"			checked:true
					menuItem	trier_decroissant 	"Ordre décroissant"	
					seperator sep10
					menuItem	trier_nom 			"Noms"					checked:true
					menuItem	trier_date 			"Date"	
					menuItem	trier_nbrVertex 	"Nombre de vertex"
					menuItem	trier_nbrImports 	"Nombre d'imports"	
				)
				
				subMenu  "Fenêtres" (
					menuItem infos 		"Infos" 		checked:labib.prefs.fenetre.infos
					menuItem apercu 	"Aperçu" 	checked:labib.prefs.fenetre.apercu
					menuItem rendu	 	"Rendu" 		checked:labib.prefs.fenetre.rendu
				)
				
				seperator sep5476
				
				subMenu  "Debug" (
					menuItem affichSelec 		"print selection" 		checked:labib.prefs.fenetre.infos
				)
				
				
				
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
				
				on faireAprecus 					picked do 	labib.edit.faireApercus 	( labib.edit.getSelection () ) 
				
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
				
				on infos								picked do	labib.fenetre.toggleInfos ()
				on apercu							picked do	labib.fenetre.toggleApercu ()
				on rendu							picked do	labib.fenetre.toggleRendu ()
			
				on affichSelec						picked do		for n in labib.edit.getSelection () do	labib.arbo.afficherNoeud	n
				
			)
			
			popUpMenu 	rcMenuElements
			
		),
		
		
		fn arbo = (
			debug "creerMenuTest"
			-------------------------------------------------------------
			------- le menu ------------------------------------------
			-------------------------------------------------------------
			rcMenu rcMenuDossiers
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
			
			popUpMenu 	rcMenuDossiers
		),
		
		fn fenetre = (	
			rcMenu rcFenetre
			(	
				------- le menu ------------------------------------------
				
				menuItem titre 			"Titre" 		checked:labib.prefs.fenetre.afficherTitre
				menuItem menu 			"Menus" 		checked:labib.prefs.fenetre.afficherMenu
				seperator sep02
				
-- 				subMenu "Fenêtres" (
					menuItem afficherInfos 			"Infos"  				checked:labib.prefs.fenetre.infos
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
				
				
				
				on afficherInfos				picked do	labib.toggleInfos ()
				
				on site 			picked do	labib.ouvrirSiteInternet ()
			)
			popUpMenu rcFenetre
		),
	---------- evenements ----------------------------
		on create do 
			debug "<menu>		Structure crée."
)

