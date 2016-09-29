/* #######################################################################################################################

	2017 Christophe Pages (http://www.c-pages.fr) 

##########################################################################################################################
	
	Bibiotheque d'assets 
	
##########################################################################################################################

	Organisation des preferences dans des structs
	
######################################################################################################################## */ 
	



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
	moteur								= Corona_1_4__hotfix_1(),	
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
	rotZDetail						=-45 ,
	
	------------ Les fonctions	----------------------------------------------------------------------------------
	fn enregistrer = (
		
		---- APERCUS ----
		setINISetting   fichier		"apercus"   "tailleX"  						( taille.x 						as string )
		setINISetting   fichier		"apercus"   "tailleY"  						( taille.y 						as string )
		setINISetting   fichier		"apercus"   "angleVue"					( angleVue						as string )
		setINISetting   fichier		"apercus"   "angleVueDetail"  			( angleVueDetail 				as string )
		setINISetting   fichier		"apercus"   "moteur"  					( moteur 						as string )
		setINISetting   fichier		"apercus"   "noiseLevel"  				( noiseLevel 					as string )
		setINISetting   fichier		"apercus"   "noiseLevelDetail"			( noiseLevelDetail 			as string )
		setINISetting   fichier		"apercus"   "denoiseAmount"			( denoiseAmount 				as string )
		setINISetting   fichier		"apercus"   "denoiseAmountDetail"	( denoiseAmountDetail		as string )
		setINISetting   fichier		"apercus"   "exposition"  				( exposition 					as string )
		setINISetting   fichier		"apercus"   "highlightCompress"		( highlightCompress			as string )
		setINISetting   fichier		"apercus"   "temperatureRendu"		( temperatureRendu			as string )
		setINISetting   fichier		"apercus"   "contraste"  				( contraste 					as string )
		setINISetting   fichier		"apercus"   "nom"  						( nom 							as string )
		setINISetting   fichier		"apercus"   "nomVide"  					( nomVide 						as string )
		setINISetting   fichier		"apercus"   "nomCalqueImport"		( nomCalqueImport 			as string )
		setINISetting   fichier		"apercus"   "dossier"  					( dossier 						as string )
		setINISetting   fichier		"apercus"   "dossierImport"  			( dossierImport 				as string )
		setINISetting   fichier		"apercus"   "convertToCoronaMats"	( convertToCoronaMats	as string )
		
	),
	
	fn charger = (
		
		---- APERCUS ----
		taille.x 						= ( getINISetting   fichier		"apercus"   "tailleX"  						)	as integer 
		taille.y 						= ( getINISetting   fichier		"apercus"   "tailleY"  						)	as integer 
		angleVue					= ( getINISetting   fichier		"apercus"   "angleVue"					)	as float 
		angleVueDetail 			= ( getINISetting   fichier		"apercus"   "angleVueDetail"  			)	as float
		moteur 						= execute ( ( filterString ( getINISetting   fichier		"apercus"   "moteur"  ) ":")[1] +"()" )
		noiseLevel 					= ( getINISetting   fichier		"apercus"   "noiseLevel"  				)	as float 
		noiseLevelDetail 			= ( getINISetting   fichier		"apercus"   "noiseLevelDetail"			)	as float 
		denoiseAmount 			= ( getINISetting   fichier		"apercus"   "denoiseAmount"			)	as float 
		denoiseAmountDetail		= ( getINISetting   fichier		"apercus"   "denoiseAmountDetail"	)	as float 
		exposition 					= ( getINISetting   fichier		"apercus"   "exposition"  				)	as float 
		highlightCompress 		= ( getINISetting   fichier		"apercus"   "highlightCompress"		)	as float 
		temperatureRendu 		= ( getINISetting   fichier		"apercus"   "temperatureRendu"		)	as float 
		contraste 					= ( getINISetting   fichier		"apercus"   "contraste"  				)	as float 
		nom 							= ( getINISetting   fichier		"apercus"   "nom"  						)	
		nomVide 					= ( getINISetting   fichier		"apercus"   "nomVide"  					)
		nomCalqueImport 		= ( getINISetting   fichier		"apercus"   "nomCalqueImport"		)
		dossier 						= ( getINISetting   fichier		"apercus"   "dossier"  					)
		dossierImport 				= ( getINISetting   fichier		"apercus"   "dossierImport"  			)
		convertToCoronaMats	= if ( getINISetting   fichier	"apercus"   "convertToCoronaMats"	) == "true" then true else false
		
	)

)




------------------------------------------------------------------------------
------ Rollout ---------------------------------------------------------------
------------------------------------------------------------------------------
-- Les preferences pour la fenetre de la bibliotheque				--
------------------------------------------------------------------------------
struct PrefsRollPrincipale_struct (
	
	------------ Les membres	----------------------------------------------------------------------------------
	dossierScript ="",	-- le dossier du script --
	fichier ="",	-- le fichier des preferences
	
	---- les parametres de la fenetre ----	
	taille 			= [1300,900],		---- la taille de la fenetre	---
	pos 				= [50,50],			---- la position de la fenetre ---	
	infos				=	true,				---- si l'onglet "infos" est ouvert ---
	edition			=	false,				---- si la fenetre edition est ouverte ---	
	accroche		=	false,				---- si le mode accroche fenetres est activé --- ( depreciated )
	isOpen 			= false,
	couleurFond 	= (color 56 56 56),
	tailleApercus 	= [255, 255 ],
	
	caseVide		=	"-",
-- 	apercuVide 	= "C:\Users\kris\AppData\Local\Autodesk\3dsMax\2014 - 64bit\ENU\scripts\laBiblio V1.0\img\apVide.jpg",
-- 	apercuDossier 	= "C:\Users\kris\AppData\Local\Autodesk\3dsMax\2014 - 64bit\ENU\scripts\laBiblio V1.0\img\apNoeud.jpg",
	apercuVide 	= dossierScript + "data\img\apVide.jpg",
	apercuDossier = dossierScript + "data\img\apNoeud.jpg",
	
	------------ Les fonctions	----------------------------------------------------------------------------------
	---- les fonctions	----
	fn enregistrer = (	
		setINISetting   fichier		"fenetre"   "tailleX"  				( taille.x 				as string )
		setINISetting   fichier		"fenetre"   "tailleY"  				( taille.y 				as string )
		setINISetting   fichier		"fenetre"   "posX"  				( pos.x 					as string )
		setINISetting   fichier		"fenetre"   "posY"  				( pos.y 					as string )
		setINISetting   fichier		"fenetre"   "infos"  				( infos 					as string )
		setINISetting   fichier		"fenetre"   "edition"  				( edition 				as string )
		setINISetting   fichier		"fenetre"   "accroche"			( accroche				as string )
		setINISetting   fichier		"fenetre"   "tailleApercusX"  	( tailleApercus.x 		as string )
		setINISetting   fichier		"fenetre"   "tailleApercusY"  	( tailleApercus.y 		as string )
	),
	
	fn charger = (
		taille.x		= ( getINISetting   fichier		"fenetre"  	"tailleX"  	)	as integer 
		taille.y		= ( getINISetting   fichier		"fenetre"   "tailleY"  		)	as integer 
		pos.x			= ( getINISetting   fichier 		"fenetre"   "posX"  		)	as integer 
		pos.y			= ( getINISetting   fichier		"fenetre"   "posY"  		)	as integer 
		infos			= if ( getINISetting   fichier	"fenetre"  	"infos"  		)	== "true" then true else false
		edition 		= if ( getINISetting   fichier	"fenetre"   "edition"  		)	== "true" then true else false
		accroche	= if ( getINISetting   fichier	"fenetre"  	"accroche"	)	== "true" then true else false
	)

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
	pos 				= [50,50],			---- la position de la fenetre ---	
	
	------------ Les fonctions	----------------------------------------------------------------------------------
	fn enregistrer =  (
		setINISetting   fichier		"fenetreInfos"   "tailleX"  	( taille.x 	as string )
		setINISetting   fichier		"fenetreInfos"   "tailleY"  	( taille.y 	as string )
		setINISetting   fichier		"fenetreInfos"   "posX"  		( pos.x 		as string )
		setINISetting   fichier		"fenetreInfos"   "posY"  		( pos.y 		as string )
	),
	
	fn charger = (
		taille.x	= ( getINISetting   fichier		"fenetreInfos"  	"tailleX"  	)	as integer 
		taille.y	= ( getINISetting   fichier		"fenetreInfos"   "tailleY"  	)	as integer 
		pos.x		= ( getINISetting   fichier 		"fenetreInfos"   "posX"  		)	as integer 
		pos.y		= ( getINISetting   fichier		"fenetreInfos"   "posY"  		)	as integer 
	)

)

------------------------------------------------------------------------------
-- Les preferences pour la creation de proxies						--
------------------------------------------------------------------------------
struct PrefsProxies_struct (
	
	------------ Les membres	----------------------------------------------------------------------------------
	dossierScript ="",	-- le dossier du script --
	fichier ="",				-- le fichier des preferences
	
	---- les parametres ----
	dossier 							= dossierScript + "data\proxies",
	
	------------ Les fonctions	----------------------------------------------------------------------------------
	fn enregistrer =  (
		setINISetting   fichier		"Proxies"   		"dossier"  	dossier
	),
	
	fn charger = (
		dossier		= 	getINISetting   fichier		"Proxies"   "dossier"  	
	)
	
)


------------------------------------------------------------------------------------------------------------------------------------------------------------
------ LES PRéFéRENCES ----------------------------------------------------------------------------------------------------------------------------------
-- le struct principal qui regroupe les differents structs de préferences					--------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
struct Preference_struct (

	---- le fichier des preferences	----
public
	dossierScript	, 													---- le dossier du script ----
	fichierPrefs 	= dossierScript + "data\prefs.ini",		---- le fichier des preferences ----
	fichierArbo		= dossierScript + "data\arbo.ini",		---- le fichier de l'arborescence ----
	
	---- les structs des diferenetes preferences	----
public	
	fenetre 		=  PrefsRollPrincipale_struct 	fichier:fichierPrefs	dossierScript:dossierScript,
	fenInfos	 	=  PrefsRollInfos_struct 		fichier:fichierPrefs	dossierScript:dossierScript,
	apercus 		= 	PrefsApercus_struct 		fichier:fichierPrefs	dossierScript:dossierScript,
	
	---- les fonctions	----
public	
	fn enregistrer = (
		fenetre.enregistrer	()
		fenInfos.enregistrer	()
		apercus.enregistrer	()
		proxies.enregistrer	()
	),
	fn charger = (
		---- si existe pas on initialise le fichier ----
		if not doesFileExist fichier then enregistrer ()
		---- sinon on charge ----
		else (
			fenetre.charger	()
			fenInfos.charger	()
			apercus.charger	()
			proxies.charger	()
-- 			assets.charger	()
		)
	),
	fn reset = (
		
		fenetre 		=  prefsRollPrincipale	fichier:fichierPrefs	dossierScript:dossierScript
		fenInfos	 	=  prefsRollInfos 			fichier:fichierPrefs	dossierScript:dossierScript
		apercus 		= 	prefsApercus 			fichier:fichierPrefs	dossierScript:dossierScript
		proxies	 	= 	prefsProxies 			fichier:fichierPrefs	dossierScript:dossierScript
		
		enregistrer ()
	), 
	fn resetApercus = (
		apercus 			= 	prefsApercus 		fichier:fichier
		enregistrer ()
	)
	
	
)




