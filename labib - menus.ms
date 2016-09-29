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
			debug "creerMenuTest"
			
			
			rcMenu rcMenuElements
			(
				------- le menu ------------------------------------------
				menuItem importer 				"Importer" 
				
				subMenu  "Options" (
					
					menuItem importerMax 			"brut" 		
					menuItem importerCollapsed 	"collapsé" 		
					menuItem importerProxy 		"proxy" 
					
-- 					seperator sep01
-- 					
-- 					menuItem matconvertCorona 		"Convertir matériaux en Corona" 		--checked:( bibliotheque.prefs.apercus.convertToCoronaMats )
				)
				
				seperator sep02
				
				subMenu  "Edition" (
					
					menuItem couper 		"Couper"
					menuItem coller 			"Coller"
					
					seperator sep03
					
					menuItem supprimer 	"Supprimer" 
					
					seperator sep04
					
					menuItem Ourvir 			"Ourvir" 
					menuItem OurvirExplo 	"Ourvir dans l'explorateur" 
					
				)					
				
				subMenu  "Affichage" (
					
					menuItem	affichage_liste 		"Liste"		checked:( labib.fenetre.affichageLV == #liste )
					menuItem 	affichage_appercus	"Appercus"	checked:( labib.fenetre.affichageLV == #apercus )
-- 					menuItem 	affichage_detail		"detail"		checked:( labib.fenetre.affichageLV == #detail )
					
				)				
				
				seperator sep05
				
				menuItem ouvirFichierMax 		"Ouvir le fichier max" 
				menuItem ouvirFichierExplo 	"Ouvir dans l'explorateur" 
				
				------- les evenements ------------------------------------------
				
				on affichage_liste 		picked do	labib.fenetre.definirAffichage  #liste
				on affichage_appercus 	picked do	labib.fenetre.definirAffichage  #apercus
-- 				on affichage_detail 		picked do	labib.fenetre.definirAffichage  #detail
				
				/* on matNeRienFaire picked do	()
				on matconvertCorona picked do	(	)
				
				on importer picked do	()
				
				on importerCollapsed picked do	()
				on importerProxy picked do	(	)
				
				on ouvirFichier picked do		(	)
				
				on supprimer picked do	() */
				
			
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
				menuItem nouveauDossier 	"Nouveau dossier" 
				menuItem supprimer 			"Supprimer" 
				
				on nouveauDossier picked do()				
				on supprimer picked do ()
				
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

