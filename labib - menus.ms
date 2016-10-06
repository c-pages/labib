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
				------- le menu ------------------------------------------
				menuItem importer 					"Importer" 				
				subMenu  "Options d'import" (					
					menuItem importerBrut 			"Brut" 			checked:true
					menuItem importerCollapsed 	"Collapsed" 		
					menuItem importerProxy 		"Proxy"					
				)
				
				seperator sep456			
				
				menuItem nouvelAsset 				"Nouvel Asset"
				menuItem nouvelAssetDossier 	"Nouvel Asset depuis un dossier"
				
				seperator sep03				
				menuItem nouveauDossier 		"Nouveau dossier"
			/* 	subMenu  "Nouvel Asset" (
					menuItem nouvelAsset 				"Fichier"
					menuItem nouvelAssetDossier 	"Dossier"
				) */
				seperator sep01								
				menuItem Ourvir 						"Ourvir" 
				menuItem OurvirExplo 				"Ourvir dans l'explorateur" 
				seperator sep08
				subMenu  "Supprimer" (
					menuItem 	supprimer 			"de Labib" 
					menuItem 	supprimerDD 		"de Labib et du DD"
				)				
				seperator sep02
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
				seperator sep04
-- 				subMenu  "Fenêtres" (
					menuItem infos 		"Infos" 		checked:labib.prefs.fenetre.infos
					menuItem apercu 	"Aperçu" 	checked:labib.prefs.fenetre.apercu
					menuItem rendu	 	"Rendu" 		checked:labib.prefs.fenetre.rendu
				-- 				)
				
				------- les evenements ------------------------------------------				
				on nouveauDossier 				picked do	labib.nouveauDossier ()				
				on nouvelAsset 					picked do	labib.nouvelAsset ()				
				on nouvelAssetDossier 			picked do	labib.nouvelAsset_dossier ()	
				
				on supprimer 						picked do 	labib.supprimer 	( labib.getElementsSelection () ) 
				
				on affichage_details 			picked do	labib.changerAffichage  #details
				on affichage_liste				picked do	labib.changerAffichage  #liste
				on affichage_GrandeIcone		picked do	labib.changerAffichage  #grandeIcone
				on affichage_petitIcone		picked do	labib.changerAffichage  #petitIcone
				on affichage_tuile				picked do	labib.changerAffichage  #tuile
				
				on afficherDossiers 				picked do 	(
					labib.prefs.fenetre.afficherDossier = not labib.prefs.fenetre.afficherDossier
					labib.fenetre.actualiser ()
				)
				
				on infos								picked do	labib.toggleInfos ()
				on apercu							picked do	labib.toggleApercu ()
				on rendu							picked do	labib.toggleRendu ()
			
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
				------- le menu ------------------------------------------
-- 				subMenu  "Nouvel Asset" (
				menuItem nouvelAsset 				"Nouvel Asset"
				menuItem nouvelAssetDossier 	"Nouvel Asset depuis un dossier"
-- 				)
				
				seperator sep01
				menuItem nouveauDossier 	"Nouveau dossier" 
-- 				menuItem renommer 			"Renommer"
				menuItem supprimer 			"Supprimer"
				
				seperator sep03
				
				menuItem expandAll 			"Expand all"
				
				seperator sep04
				
				menuItem rechercheAvance 			"Recherche avancée"
				------- les evenements ------------------------------------------
				on nouveauDossier 			picked do	labib.nouveauDossier ()				
				on nouvelAsset 				picked do	labib.nouvelAsset ()				
				on nouvelAssetDossier 		picked do	labib.nouvelAsset_dossier ()		
				on renommer 					picked do	labib.renommer ()	
				
				on supprimer 					picked do 	labib.supprimer 	( labib.getDossiercourant () )
				
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

