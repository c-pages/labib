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
struct Menus (
	public 
	
		fn creerMenuElements = (
			debug "creerMenuTest"
			-------------------------------------------------------------
			------- le menu ------------------------------------------
			-------------------------------------------------------------
			rcMenu rcMenuElements
			(
				menuItem importer 				"Importer" 
				menuItem importerCollapsed 	"Importer collapsed" 		
				menuItem importerProxy 		"Importer Proxy Corona" 
				
				seperator sep01
				
				subMenu  "Options d'import" (
					menuItem matNeRienFaire 		"Matériaux d'origine" 								checked:( not bibliotheque.prefs.apercus.convertToCoronaMats )
					menuItem matconvertCorona 		"Convertir matériaux en Corona" 		checked:( bibliotheque.prefs.apercus.convertToCoronaMats )
				)
				
				seperator sep02
				
				menuItem supprimer 			"Supprimer de la bibliothèque" 
				
				seperator sep03
				
				menuItem ouvirFichierMax 		"Ouvir le fichier max" 
				menuItem ouvirFichierExplo 	"Ouvir dans l'explorateur" 
				
				on matNeRienFaire picked do	()
				on matconvertCorona picked do	(	)
				
				on importer picked do	()
				
				on importerCollapsed picked do	()
				on importerProxy picked do	(	)
				
				on ouvirFichier picked do		(	)
				
				on supprimer picked do	()
				
			
			)
			
			
			
			
			popUpMenu 	rcMenuElements
		),
		
		
		fn creerMenuArbo = (
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
		
		fn getMenuPrincipal = (
			
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

