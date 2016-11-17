/* #######################################################################################################################

	2017 Christophe Pages (http://www.c-pages.fr) 

##########################################################################################################################
	
	Bibiotheque d'assets 
	
##########################################################################################################################

	Organisation des preferences dans des structs
	
######################################################################################################################## */ 
	

------------------------------------------------------------------------------
-- Les preferences pour la fenetre des infos							--
------------------------------------------------------------------------------
struct str_prefsGenerales (
	
		dossierScript	, 						
		dossierNouvelAsset	= getDir #Scene

)
------------------------------------------------------------------------------
------ Rollout ---------------------------------------------------------------
------------------------------------------------------------------------------
-- Les preferences pour la fenetre de la bibliotheque				--
------------------------------------------------------------------------------
struct str_prefsFenPrincipale (
	
	------------ Les membres	----------------------------------------------------------------------------------
	dossierScript,											-- le dossier du script --
	
	---- les parametres de la fenetre ----	
	fenLabib_estOuvert	= false,
	fenLabib_pos 			= [50,50],
	fenLabib_taille 		= [578,366],
	
	-- les sliders --
	sliderH_pos				= 173.0,
	sliderH_estRabattu 	= false,
	sliderV_pos				= 315.0,
	sliderV_estRabattu 	= false,	
	
	-- les modes de la fenetre --
	pleinEcran    	= false,
	bandeau    		= false,
	bandeau_pos 	= [0,0],	
	bandeau_taille	= [0,0],		
	
	accrochage		= true,
	
	--- mode affichage LV ---
	affichageLV		=	#grandeIcone,
	
	-- pour les fenetres seondaires --
	fenInfos_estOuvert				=	false,				---- si l'onglet "infos" est ouvert ---
	fenInfos_pos	= [0,0],
	
	apercu			=	false,				----
	rendu				=	false,				----
	posApercu		= [0,0],
	posRendu		= [0,0],
	
	accroche		=	false,				---- si le mode accroche fenetres est activé --- ( depreciated )
	couleurFond 	= (color 56 56 56),
	tailleApercus 	= [512, 512 ],
	
	afficherMenu 	= false,
	afficherTitre 	= false,
	afficherDossier = true,

	tailleApercusLV = 100,		-- taille affiché des apercus dans le LV --
	
	---- Couleurs ----
	-- des rollouts --
-- 	col_fenetreFond			= color 56  95 120, 	----  bleu ----
	col_fenetreFond			= color 68 68 68, 	---- MAX ----
	col_fenetreTxt				= color 230  230 230, 	----  ----
	
-- 	col_uiFond 					= color 160 166 182, 	----  bleu ----
	col_uiFond 					= color 100 100 100, 	----  MAX ----
	col_uiFondRecherche 	= color 190 196 212, 		----  ----
	
	col_fondDossier 			= color 167 173 189, 	----  ----
	col_fondDossierPrt 		= color 130 136 152, 	----  ----
	col_txtDossier 			= color 50 50 50, 	----  ----
	col_txt 						= color 255	 255	255, 		----  ----
	
	col_TVLVfore 				= color 45	42	35, 		----  ----
	

	
	caseVide		=	"-",
	
	---- images ----
	-- apercus --
	apercuVide 				= dossierScript + "data\img\apVide.jpg",
	apercuDossier 				= dossierScript + "data\img\apNoeud.jpg",
	apercuDossierParent 	= dossierScript + "data\img\apNoeudParent.jpg",
-- 	-- Fond TV --
-- 	fd_TV 						= dossierScript + "data\img\fd_TV.jpg"
	
	
	---- icones ----
	-- facon dossier commun --
	ico_btnFermer_R	=	"$userScripts\cp - GLOBAL\ico\ico_fermer_grisFoncee_R.jpg",
	ico_btnFermer_S	=	"$userScripts\cp - GLOBAL\ico\ico_fermer_grisFoncee_S.jpg",
	ico_btnFermer_P	=	"$userScripts\cp - GLOBAL\ico\ico_fermer_grisFoncee_P.jpg"--,
	
-- 	ico_btnFermer_R	=	"$userScripts\cp - GLOBAL\ico\ico_fermer_grisClaire_R.jpg",
-- 	ico_btnFermer_S	=	"$userScripts\cp - GLOBAL\ico\ico_fermer_grisClaire_S.jpg",
-- 	ico_btnFermer_P	=	"$userScripts\cp - GLOBAL\ico\ico_fermer_grisClaire_P.jpg"--,
	
	-- facon dossier labib --
-- 	ico_btnFermer_R				= dossierScript + "data\ico\ico_fermer_R.jpg", 	-- repos 	--
-- 	ico_btnFermer_S				= dossierScript + "data\ico\ico_fermer_S.jpg", 	-- survol 	--
-- 	ico_btnFermer_P				= dossierScript + "data\ico\ico_fermer_P.jpg" 	-- press 	--

)

------------------------------------------------------------------------------
-- Les preferences pour la fenetre des infos							--
------------------------------------------------------------------------------
struct str_prefsFenInfos (
	
	------------ Les membres	----------------------------------------------------------------------------------
	dossierScript ="",	-- le dossier du script --
	
	---- les parametres ----
	taille 			= [1300,900],		---- la taille de la fenetre	---
	pos 				= [50,50]			---- la position de la fenetre ---	

)


------------------------------------------------------------------------------
------ Rendus  --------------------------------------------------------------
------------------------------------------------------------------------------
-- Les preferences actives pour les rendus des  aperçus				--
------------------------------------------------------------------------------
struct str_prefsRendu (
	
	------------ Les membres	----------------------------------------------------------------------------------
	public
	
	dossierScript 					="",	-- le dossier du script --
	
	nomVide 						= "apVide" ,
	nomCalqueImport 			= "ImportTemp",
	dossier 							= 	dossierScript + "data\apercus",
	dossierImport 					= "C:",
	afficherVFB						= false,
	
	convertToCoronaMats 		= true,
	
	-- parametres du moteur de rendu --
	moteur							= "Corona_1_5__hotfix_1()",	-- execute ( ( filterString moteur ":")[1] +"()" )
	taille								= [256,256],	
	coefDistance					= 1.7,
	
	exposition 						= -5,
	highlightCompress			= 1,
	temperatureRendu 			= 5300,
	contraste 						= 3,
	
	-- parametres rendu Apercus --
	nom 								= "apercu_",
	angleVue 						= 40,
	noiseLevel 						= 1,
	denoiseAmount 				= 1,
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












------------------------------------------------------------------------------------------------------------------------------------------------------------
------ LES PRéFéRENCES -------------------------------------------------------------------------------------------------------------------------------
-- le struct principal qui regroupe les differents structs de préferences					--------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
struct str_preferences (

	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = false,
-- 		m_debug = true,
		m_dbgPrefix ="prefs",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	
	
		------------ Les membres	----------------------------------------------------------------------------------
	public
		dossierScript	, 													---- le dossier du script ----
		fichierPrefs 			= dossierScript + "data\prefs.ini",		---- le fichier des preferences ----
		fichierArbo				= dossierScript + "data\arbo.ini",		---- le fichier de l'arborescence ----
	
		
		---- les structs des diferenetes preferences	----
	public	
		fenetre 		=  str_prefsFenPrincipale 	dossierScript:dossierScript,
		infos		 	=  str_prefsFenInfos 		dossierScript:dossierScript,
		apercus 		= 	str_prefsRendu 			dossierScript:dossierScript,
		general 		= 	str_prefsGenerales		dossierScript:dossierScript,
		
		------------ Les fonctions	----------------------------------------------------------------------------------
	
	private
		fn enregistrerDatas  _datas  _nomDatas	=(
			
			local propsNoms 	= getPropNames  _datas
			
			for propNom in propsNoms do 
				if propNom != "dossierScript"
					do setINISetting   fichierPrefs		_nomDatas   propNom  	( ( getProperty _datas	 propNom	)	as string )
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
			debug "enregistrement"
			
			enregistrerDatas  fenetre		"fenetre"
			enregistrerDatas  apercus		"apercus"
			enregistrerDatas  infos			"infos"
			
		),
		fn charger = (
			debug "chargement"
			
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
			charger()
			debug "Structure crée."
			
		)
		
	
)













