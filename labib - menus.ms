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





-------------------------------------------------------------
------- le struct ------------------------------------------
-------------------------------------------------------------
struct menu_struct (
	
	public 
	
		fn elements = (
			
			rcMenu rcMenuElements
			(
				------- le menu ------------------------------------------
				menuItem importer 				"Importer" 
				
				subMenu  "Options d'import" (
					
					menuItem importerCollapsed 	"Collapsed" 		
					menuItem importerProxy 			"Proxy"
					
				)
			
				seperator sep03
				
				menuItem nouveauDossier 	"Nouveau dossier" 
				
				seperator sep01				
				
				menuItem Ourvir 			"Ourvir" 
				menuItem OurvirExplo 		"Ourvir dans l'explorateur" 
				
				
				seperator sep08
				subMenu  "Supprimer" (
					menuItem 	supprimer 			"de Labib" 
					menuItem 	supprimerDD 		"de Labib et du DD"
				)
				
				seperator sep02
				
				subMenu  "Affichage" (
					
					menuItem	affichage_liste 		"Liste"		checked:( labib.fenetre.affichageLV == #liste )
					menuItem 	affichage_appercus	"Appercus"	checked:( labib.fenetre.affichageLV == #apercus )
					
				)
				seperator sep04
				subMenu  "Fenêtres" (
					menuItem infos 		"Infos" 
					menuItem apercus 	"Aperçus" 
					
				)
				------- les evenements ------------------------------------------
				
				on nouveauDossier 		picked do	labib.nouveauDossier ()		
				
				on affichage_liste 		picked do	labib.fenetre.definirAffichage  #liste
				on affichage_appercus 	picked do	labib.fenetre.definirAffichage  #apercus
			
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
				subMenu  "Nouvel Asset" (
					menuItem nouvelAsset 				"Fichier"
					menuItem nouvelAssetDossier 	"Dossier"
				)
				
				seperator sep01
				menuItem nouveauDossier 	"Nouveau dossier" 
				menuItem renommer 			"Renommer" 
				
				seperator sep02
				
				menuItem supprimer 			"Supprimer"
				
				------- les evenements ------------------------------------------
				on nouveauDossier 			picked do	labib.nouveauDossier ()				
				on nouvelAsset 				picked do	labib.nouvelAsset ()				
				on nouvelAssetDossier 	picked do	labib.nouvelAssetDossier ()		
				on renommer 					picked do	labib.renommer ()	
				
				on supprimer 					picked do 	labib.supprimer ()		
				
			)
			
			
			
			
			popUpMenu 	rcMenuDossiers
		),
		
		fn principal = (
			
			rcMenu rcPrincipal
			(
				---- menu ----
				subMenu "Edit"	(
					menuItem m_nouveauDossier 	"Nouveau dossier" 
					menuItem m_supprimer 			"Supprimer"					
				)
				subMenu "Vues" (
					menuItem m_afficherInfos 	"Infos"  	--	checked:( bibliotheque.getInfosOuvert() )
					menuItem m_afficherApercus	"Création des aperçus" 
				)
				subMenu "Préferences"	(
					menuItem m_preferences 			"Préferences" 
					menuItem m_resetPreferences 	"Reinitialiser" 
				)
				
				
				
				
				---- evenements ----
				on m_nouveauDossier picked do ()
				on m_supprimer picked do  ()
				
				on m_afficherInfos picked do ()
				on m_afficherApercus picked do ()
				
				on m_resetPreferences picked do 
					if queryBox "Etes-vous sûr de vouloir réinitialiser les préférences de la bibliotheque ?" do
						 ()				
				on m_preferences picked do  ()
				
			)
			return rcPrincipal
		)
		
)

