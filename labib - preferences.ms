/* #######################################################################################################################

	2017 Christophe Pages (http://www.c-pages.fr) 

##########################################################################################################################
	
	Bibiotheque d'assets 
	
##########################################################################################################################

	Organisation des preferences dans des structs
	
######################################################################################################################## */ 
	


------------------------------------------------------------------------------
------ Rollout ---------------------------------------------------------------
------------------------------------------------------------------------------
-- Les preferences pour la fenetre de la bibliotheque				--
------------------------------------------------------------------------------
struct prefsFenetre_struct (
	
	------------ Les membres	----------------------------------------------------------------------------------
	dossierScript,										-- le dossier du script --
	fichier = dossierScript + "\data\prefs.ini",	-- le fichier des preferences
	
	---- les parametres de la fenetre ----	
	taille 				= [578,366],		---- la taille de la fenetre	---
	pos 				= [50,50],			---- la position de la fenetre ---	
	
	-- les sliders --
	posSlider_H		= 173.0,
	posSlider_V		= 315.0,
	sliderFermer_V = false,	
	sliderFermer_H = false,
	
	-- les modes de la fenetre --
	pleinEcran    	= false,
	bandeau    		= false,
	posBandeau 	= [0,0],	
	tailleBandeau	= [0,0],		
	
	
	infos				=	true,				---- si l'onglet "infos" est ouvert ---
	edition			=	false,				---- si la fenetre edition est ouverte ---	
	accroche		=	false,				---- si le mode accroche fenetres est activé --- ( depreciated )
	isOpen 			= false,
	couleurFond 	= (color 56 56 56),
	tailleApercus 	= [255, 255 ],
	
	afficherMenu 	= false,
	afficherTitre 	= false,
	afficherDossier = true,

	tailleApercusLV = 40,		-- taille affiché des apercus dans le LV --
	
	---- Couleurs ----
	-- des rollouts --
	col_fenetreFond				= color 104  112 131, 	----  ----
	col_fenetreFore				= color 230  230 230, 	----  ----
	-- trucs dotnet (LV, TV ) --
	col_TVLVfond 					= color 160 166 182, 	----  ----
	col_TVLVfondDossier 		= color 145 151 167, 	----  ----
	col_TVLVforeDossier 		= color 237 237 237, 	----  ----
	col_TVLVfondDossierPrt 	= color 130 136 152, 	----  ----
-- 	col_TVLVfondDossierPrt 	= col_TVLVfondDossier, 	----  ----
-- 	col_TVLVfondDossierPrt 	= col_TVLVfondDossier, 	----  ----
	col_TVLVfore 					= color 45	42	35, 		----  ----
	
	col_TVfore 						= color 255	 255	255, 		----  ----

	col_fondRech 					= col_TVLVfondDossierPrt, 		----  ----
	
	caseVide		=	"-",
	
	---- images ----
	-- apercus --
	apercuVide 				= dossierScript + "data\img\apVide.jpg",
	apercuDossier 				= dossierScript + "data\img\apNoeud.jpg",
	apercuDossierParent 	= dossierScript + "data\img\apNoeudParent.jpg",
-- 	-- Fond TV --
-- 	fd_TV 						= dossierScript + "data\img\fd_TV.jpg"
	
	
	---- icones ----
	ico_btnFermer_R				= dossierScript + "data\ico\ico_fermer_R.jpg", 	-- repos 	--
	ico_btnFermer_S				= dossierScript + "data\ico\ico_fermer_S.jpg", 	-- survol 	--
	ico_btnFermer_P				= dossierScript + "data\ico\ico_fermer_P.jpg" 	-- press 	--

)




------------------------------------------------------------------------------
------ Rendus  --------------------------------------------------------------
------------------------------------------------------------------------------
-- Les preferences actives pour les rendus des  aperçus				--
------------------------------------------------------------------------------
struct PrefsApercus_struct (
	
	------------ Les membres	----------------------------------------------------------------------------------
	public
	
	dossierScript ="",	-- le dossier du script --
	fichier ="",	-- le fichier des preferences
	
	nomVide 						= "apVide" ,
	nomCalqueImport 			= "ImportTemp",
	dossier 							= 	dossierScript + "data\apercus",
	dossierImport 					= "C:",
	afficherVFB						= false,
	
	convertToCoronaMats 		= true,
	
	-- parametres du moteur de rendu --
	moteur							= "Corona_1_4__hotfix_1()",	-- execute ( ( filterString moteur ":")[1] +"()" )
	taille								= [256,256],	
	coefDistance					= 1.7,
	exposition 						= -5,
	highlightCompress			= 1.4,
	temperatureRendu 			= 5300,
	contraste 						= 3,
	
	-- parametres rendu Apercus --
	nom 								= "apercu_",
	angleVue 						= 40,
	noiseLevel 						= 7,
	denoiseAmount 				= .4,
	transX 							= 0,
	transY 							= 0,
	transZ 							= 0,
	rotX 								= 0,
	rotY 								= -15,
	rotZ 								= -135,
	
	-- parametres rendu Detail --
	nomDetail 						= "apDetail_",
	angleVueDetail 				= 9,	
	noiseLevelDetail				= 11,
	denoiseAmountDetail		= .3,
	transXDetail					= 0,
	transYDetail					= 0,
	transZDetail					= 0,
	rotXDetail						= 0,
	rotYDetail						= -15,
	rotZDetail						=-45 
	
)





------------------------------------------------------------------------------
-- Les preferences pour la fenetre des infos							--
------------------------------------------------------------------------------
struct PrefsRollInfos_struct (
	
	------------ Les membres	----------------------------------------------------------------------------------
	dossierScript ="",	-- le dossier du script --
	fichier ="",	-- le fichier des preferences
	
	---- les parametres ----
	taille 			= [1300,900],		---- la taille de la fenetre	---
	pos 				= [50,50]			---- la position de la fenetre ---	

)








------------------------------------------------------------------------------------------------------------------------------------------------------------
------ LES PRéFéRENCES -------------------------------------------------------------------------------------------------------------------------------
-- le struct principal qui regroupe les differents structs de préferences					--------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
struct Preference_struct (

		------------ Les membres	----------------------------------------------------------------------------------
	public
		dossierScript	, 													---- le dossier du script ----
		fichierPrefs 	= dossierScript + "data\prefs.ini",		---- le fichier des preferences ----
		fichierArbo		= dossierScript + "data\arbo.ini",		---- le fichier de l'arborescence ----
		
		---- les structs des diferenetes preferences	----
	public	
		fenetre 		=  prefsFenetre_struct 	fichier:fichierPrefs	dossierScript:dossierScript,
		infos		 	=  PrefsRollInfos_struct 	fichier:fichierPrefs	dossierScript:dossierScript,
		apercus 		= 	PrefsApercus_struct 	fichier:fichierPrefs	dossierScript:dossierScript,
		
		------------ Les fonctions	----------------------------------------------------------------------------------
	
	private
		fn enregistrerDatas  _datas  _nomDatas	=(
			
			local propsNoms 	= getPropNames  _datas
			
			for propNom in propsNoms do
				setINISetting   fichierPrefs		_nomDatas   propNom  	( ( getProperty _datas	 propNom	)	as string )
		),
		fn chargerDatas  _datas  _nomDatas	=(
			
			local propsNoms 	= getPropNames  _datas
			
			for propNom in propsNoms do (
				local propType 	= classof ( getProperty _datas propNom )
				local propFichier 	= getINISetting   	fichierPrefs		_nomDatas   propNom 
				
				case propType of (
					Integer:			setProperty _datas 	propNom		( propFichier	as integer )
					Float:			setProperty _datas 	propNom		( propFichier	as float )
					BooleanClass:	setProperty _datas 	propNom		( if propFichier == "true" then true else false )
					Point2:			setProperty _datas 	propNom		( execute propFichier )
					Defaut:			setProperty _datas 	propNom		propFichier
				) 
			)		
			
		),
		
		
	public	
		fn enregistrer = (
			debug "<prefs>	enregistrement"
			
			enregistrerDatas  fenetre		"fenetre"
			enregistrerDatas  apercus		"apercus"
			enregistrerDatas  infos			"infos"
			
		),
		fn charger = (
			debug "<prefs>	chargement"
			
			---- si existe pas on initialise le fichier ----
			if not doesFileExist fichierPrefs then (
				debug "fichier absent, création du fichier"		var:fichierPrefs
				enregistrer ()
			---- sinon on charge ----
			) else (
				chargerDatas  fenetre		"fenetre"
				chargerDatas  apercus		"apercus"
				chargerDatas  infos			"infos"
			)
		),
		fn reset = (
			
			fenetre 		=  prefsRollPrincipale	fichier:fichierPrefs	dossierScript:dossierScript
			fenInfos	 	=  prefsRollInfos 			fichier:fichierPrefs	dossierScript:dossierScript
			apercus 		= 	prefsApercus 			fichier:fichierPrefs	dossierScript:dossierScript
	-- 		proxies	 	= 	prefsProxies 			fichier:fichierPrefs	dossierScript:dossierScript
			
			enregistrer ()
		), 
		fn resetApercus = (
			apercus 			= 	prefsApercus 		fichier:fichier
			enregistrer ()
		),
		
		
		------------ Les evenements	----------------------------------------------------------------------------------
		on create do (
			debug "<prefs>	creation structure"
			charger()
			
		)
		
	
)














