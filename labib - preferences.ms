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
		dossierNouvelAsset	= getDir #Scene,
	
		fichierArbo				= dossierScript + "data\arbo.bib",		---- le fichier de l'arborescence ----
		dossierApercus		= dossierScript + "data\apercus",		---- le fichier de l'arborescence ----
		dossierProxy			= dossierScript + "data\proxies"		---- le fichier de l'arborescence ----

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
	fenLabib_pos 			= [1200,300],
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
	
	accroche		=	false,				---- si le mode accroche fenetres est activ� --- ( depreciated )
	couleurFond 	= (color 56 56 56),
	tailleApercus 	= [512, 512 ],
	
	afficherMenu 	= false,
	afficherTitre 	= false,
	afficherDossier = true,

	tailleApercusLV = 50,		-- taille affich� des apercus dans le LV --
	
	---- Couleurs ----
	-- des rollouts --
-- 	col_fenetreFond			= color 56  95 120, 	----  bleu ----
	col_fenetreFond			= color 68 68 68, 	---- MAX ----
	col_fenetreTxt				= color 230  230 230, 	----  ----
	
-- 	col_uiFond 					= color 160 166 182, 	----  bleu ----
	col_uiFond 					= color 100 100 100, 	----  MAX ----
	col_uiFondRecherche 	= color 140 140 140, 		----  ----
	
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
	ico_btnFermer_R	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_R.jpg",
	ico_btnFermer_S	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_S.jpg",
	ico_btnFermer_P	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_P.jpg", 
	
	dossierCourant = "ROOT"
	
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
-- Les preferences actives pour les rendus des  aper�us				--
------------------------------------------------------------------------------
struct str_prefsRendus (
	
	------------ Les membres	----------------------------------------------------------------------------------
	public
	
	dossierScript 					= "",	-- le dossier du script --
	
	nomVide 						= "apVide" ,
	nomCalqueImport 			= "ImportTemp",
	dossier 							= 	dossierScript + "data\apercus",
	dossierImport 					= "C:",
	afficherVFB						= false,
	
	convertToCoronaMats 		= true,
	
	-- parametres du moteur de rendu --
-- 	moteur							= "Corona_1_5__hotfix_1()",	-- execute ( ( filterString moteur ":")[1] +"()" )
	taille								= [512,512],	
	coefDistance					= 1.7,
	
	exposition 						= -5,
	highlightCompress			= 1,
	temperatureRendu 			= 5300,
	contraste 						= 3,
	
	-- parametres rendu Apercus --
	nom 								= "apercu_",
	angleVue 						= 40,
	noiseLevel 						= 15,
	denoiseAmount 				= 1,
	transX 							= 0,
	transY 							= 0,
	transZ 							= 0,
	rotX 								= 0,
	rotY 								= -0,
	rotZ 								= -0,
	
	-- parametres rendu Detail --
	nomDetail 						= "apDetail_",
	angleVueDetail 				= 9,	
	noiseLevelDetail				= 5,
	denoiseAmountDetail			= 1,
	transXDetail					= 0,
	transYDetail					= 0,
	transZDetail					= 0,
	rotXDetail						= 0,
	rotYDetail						= -15,
	rotZDetail						=-45 
	
)










------------------------------------------------------------------------------
----------	Fenetre								 -------------------------
------------------------------------------------------------------------------
rollout roll_preferences "preferences" width:346 height:128
(
	
	
	------------ DEBUG	----------------------------------------------------------------------------------
	local	m_debug = true
	local	m_dbgPrefix ="roll_preferences"
	fn debug 	_txt  var:	 param:    =(
		if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
	)
	----------------------------------------------------------------------------------------------------------
	
	
	
	------------  Membres	----------------------------------------------------------------------------------
	---- Pointeurs ----
	local m_prt				---- pointeur vers la structure de controle ----
	local m_labib
	
	---- Structures ----
	local m_drag			---- la structure gerant le drag de la fenetre ----
	
	--- ctro des imgtags ---
	local m_titre
-- 	local m_log
	
	--- liste des uis ----
	local m_uis	=#()
	
	
	------------  UI	----------------------------------------------------------------------------------		
	
	
	
	label 'ui_lblApercus' "Dossier des Aper�us: " pos:[20,56] width:101 height:17 align:#left
	edittext 'ui_editApercus' "" pos:[126,56] width:181 height:17 align:#left
	button 'ui_btnOuvrirApercus' "..." pos:[307,54] width:20 height:20 toolTip:"Choisir le fichier .max de r�f�rence de cet asset." align:#left
	
	label 'ui_lblBiblio' "Biblioth�que : " pos:[20,37] width:101 height:17 align:#left
	edittext 'ui_editBiblio' "" pos:[126,37] width:181 height:17 align:#left
	button 'ui_btnOuvrirBiblio' "..." pos:[307,35] width:20 height:20 toolTip:"Choisir le fichier .max de r�f�rence de cet asset." align:#left
	
	label 'ui_lblProxy' "Dossier des Proxy : " pos:[20,75] width:101 height:17 align:#left
	edittext 'ui_editProxy' "" pos:[126,75] width:181 height:17 align:#left
	button 'ui_btnOuvrirProxy' "..." pos:[307,73] width:20 height:20 toolTip:"Choisir le fichier .max de r�f�rence de cet asset." align:#left
	
	button 'ui_btnReset' "Reset" pos:[19,5] width:42 height:16 align:#left

	
	---- le bouton pour fermer la fenetre ----
	ImgTag 'ui_btnFermer' "X" pos:[326,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	
	ImgTag 'ui_titre' "" pos:[128,4] width:66 height:18 align:#left
	

	
	------------  Fonctions	----------------------------------------------------------------------------------
	---- Gere l'�tat du bouton  -----
	fn etatBtnFermer		_etat =(
		case _etat of (
			#Repos : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
			#Survol : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[2]	
			#Press : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[3]	
		)
	)
	
	fn actualiser = (
		ui_editBiblio.text 		= m_prt.general.fichierArbo
		ui_editApercus.text 	= m_prt.general.dossierApercus
		ui_editProxy.text 		= m_prt.general.dossierProxy
	)
	
	fn reagencer _taille =(
		
		m_prt.m_taille = _taille
		
		local LargeurEdit = 145
		local LargeurBtn = 20
		local	decalXBtn1 = 34
		local	decalXBtn2 = decalXBtn1 + LargeurBtn
		local	decalXBtn3 = decalXBtn1 + 2* LargeurBtn
		
		ui_editProxy.width 					= 	_taille.x - ( LargeurEdit + LargeurBtn )
		ui_editBiblio.width 					= 	_taille.x - ( LargeurEdit + LargeurBtn )
		ui_editApercus.width 				= 	_taille.x - ( LargeurEdit + LargeurBtn )
-- 		ui_btnReset.width 					= 	_taille.x - ( LargeurEdit )


		ui_btnOuvrirProxy.pos.x			=	_taille.x - ( decalXBtn1 )		
		ui_btnOuvrirBiblio.pos.x				=	_taille.x - ( decalXBtn1 )
		ui_btnOuvrirApercus.pos.x				=	_taille.x - ( decalXBtn1 )
		
		ui_btnFermer.pos.x						=	_taille.x - ( LargeurBtn )
		
	)
	
	---- Initialisation de la fenetre  -----
	fn initialiser labib: prt: = (
		
		if labib != unsupplied and prt != unsupplied do (
			
			m_labib 	= labib
			m_prt 	= prt
			m_drag 	= str_drag 	m_prt:roll_preferences		
			
			m_titre 	= str_label 	m_ui:ui_titre			m_texte:m_prt.m_titre
			m_titre.setCouleur 	m_prt.col_fenetreTxt
			
			/* 
			m_log 		= str_label 	m_ui:ui_log				m_texte:"..."
			m_log.setPolice (str_policePetite())
			m_log.setCouleur (color 200	200	200)
			 */
			
			-- le bouton fermer --
			ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
			/* 
			-- creation de la liste des uis ---
			m_uis = #(
				ui_lblNom, ui_editNom, ui_lblFichier, ui_editFichier, ui_btnOuvrirFichierMax, ui_lblApercu, ui_editApercu, ui_btnOurvirApercu , ui_btnCreerDetail, ui_lblDetail, ui_editDetail, 
				ui_btnOurvirDetail, ui_btnCreerApercu, ui_lblTags, ui_editTags, ui_lblNotes, ui_editNotes, ui_btnCreerApercuDetailAuto,
				ui_btnCreerAperculAuto, ui_lblCreation, ui_editDateCreation, ui_lblDateDernierImport, ui_editDateDernierImport , ui_lblNbreImports,
				ui_editNbreImports, ui_lblNbreVertex, ui_editNbreVertex )
			 */
			reagencer [roll_preferences.width, roll_preferences.height]
			
			actualiser()
		)
	)
	
	
	
	
	
	------- corps ------
	fn ouvrirCheminBiblio  chemin:	=(
		local fichier
		
		if chemin == unsupplied 
			then	fichier = getOpenFileName  	caption:"Fichier max de l'asset:" \
															filename:m_prt.general.fichierArbo \
															types:"Labib(*.bib)|*.bib|All|*.*|"
			else fichier = chemin
		
		if fichier != undefined and doesFileExist fichier	then (
			m_prt.general.fichierArbo  = 	fichier
			m_prt.enregistrer ()
			
			m_labib.arbo.fichierArbo = fichier
 			m_labib.arbo.charger ()
			
			m_labib.edit.setDossier m_labib.arbo.root
			m_labib.edit.actualiser ()
		)	
		
		actualiser ()
		
	)
	
	fn ouvrirCheminApercu  chemin:	=(
		local fichier
		
		if chemin == unsupplied 
			then	fichier = getSavePath  	caption:"Fichier max de l'asset:" \
													initialDir:m_prt.general.dossierApercus
			else fichier = chemin
		
		if fichier != undefined and doesFileExist fichier	then (				
			m_prt.general.dossierApercus  = 	fichier
			m_prt.enregistrer ()		
		)	
		actualiser ()
		
	)
	fn ouvrirCheminProxy  chemin:	=(
		local fichier
		
		if chemin == unsupplied 
			then	fichier = getSavePath 	caption:"Fichier max de l'asset:" \
													initialDir:m_prt.general.dossierProxy
			else fichier = chemin
		
		if fichier != undefined and doesFileExist fichier	then (				
			m_prt.general.dossierProxy  = 	fichier
			m_prt.enregistrer ()		
		)	
		actualiser ()
			
	)
	
	
	
	
	------------  Evenements	----------------------------------------------------------------------------------
	
	--- rollout ---

	---- Drag ----
	
	---- Fermer ----
	
	
	---- corps ----
	
	
	
-- 		m_labib.cmd.changerFichier 	(m_labib.edit.getSelection ())[1] 	_text
		
-- 		m_labib.cmd.changerFichier 	(m_labib.edit.getSelection ())[1] 	_text

	on roll_preferences resized _taille 	do
		reagencer 	_taille
	on roll_preferences moved _pos 		do
		m_prt.m_pos	= _pos
	on roll_preferences lbuttondown _pos 	do
		m_drag.demarrer ()
	on roll_preferences lbuttonup _pos 	do
		m_drag.arreter ()
	on roll_preferences mouseMove _pos 	do
		m_drag.suivreSouris ()
	
	
	on ui_editApercus entered _text do ouvrirCheminApercu chemin:_text
	on ui_btnOuvrirApercus pressed do ouvrirCheminApercu ()
	
	
	on ui_editBiblio entered _text do ouvrirCheminBiblio chemin:_text
	on ui_btnOuvrirBiblio pressed do ouvrirCheminBiblio ()
	
		
	on ui_editProxy entered _text do ouvrirCheminProxy chemin:_text
	on ui_btnOuvrirProxy pressed do ouvrirCheminProxy ()
		
		
		
	on ui_btnFermer mouseover do
		etatBtnFermer #Survol
	on ui_btnFermer mouseout do
		etatBtnFermer #Repos
	on ui_btnFermer mouseDown do
		etatBtnFermer #Press
	on ui_btnFermer mouseUp do
		etatBtnFermer #Repos
	on ui_btnFermer click do
		m_prt.fermer ()
)


------------------------------------------------------------------------------------------------------------------------------------------------------------
------ LES PR�F�RENCES -------------------------------------------------------------------------------------------------------------------------------
-- le struct principal qui regroupe les differents structs de pr�ferences					--------------------------------------------------------
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
		---- pointeurs ----
		m_labib,
		
		dossierScript	, 															---- le dossier du script ----
		fichierPrefs 			= dossierScript + "data\prefs.ini",		---- le fichier des preferences ----
-- 		fichierArbo				= dossierScript + "data\arbo.bib",		---- le fichier de l'arborescence ----
	
		
		---- les structs des diferenetes preferences	----
	public	
		fenetre 		=  str_prefsFenPrincipale 	dossierScript:dossierScript,
		infos		 	=  str_prefsFenInfos 		dossierScript:dossierScript,
		rendus 		= 	str_prefsRendus 			dossierScript:dossierScript,
		general 		= 	str_prefsGenerales		dossierScript:dossierScript,
		
		------------  Pour la fenetre	----------------------------------------------------------------------------------
	public
		m_dialog				= roll_preferences ,		---- le rollout ----
		
		---- props de la fenetre -----
		m_titre 				= "Labib | preferences",
		m_pos 				= [100,100],
		m_taille 				= [346, 104],
		m_estOuvert 		= false,
		
		col_fenetreFond	= fenetre.col_fenetreFond, 	----  ----
		col_fenetreTxt		= fenetre.col_fenetreTxt, 	----  ----
	
		--- images bouton fermer ---
		m_icos_fermer= #( 					---- les images pour les icones du bouton de fermeture ----		
									openBitMap fenetre.ico_btnFermer_R ,		-- Repos ----
									openBitMap fenetre.ico_btnFermer_S ,		-- Survol ----
									openBitMap fenetre.ico_btnFermer_P 		-- Press� ----
								),
				
		------------  Fonctions	----------------------------------------------------------------------------------
	public
		fn estOuvert = m_estOuvert,
		
		---- fenetre -----
		
		fn ouvrir =(
			m_estOuvert = true
			---- creation de la fenetre ----
			createDialog m_dialog 	style:				#(#style_resizing) \
											pos:					m_pos	\
											width:				m_taille.x \
											height:				m_taille.y \
											lockHeight:			true
-- 											bgcolor:				col_fenetreFond 	 \
-- 											fgcolor:				col_fenetreTxt 	\
											
			---- initialisation de la fenetre ----
			m_dialog.m_prt	 	= this
			m_dialog.initialiser 	labib:m_labib 	prt:this
			
			
		),
		
		fn fermer  enregistrer:true =(
			
			if enregistrer do
				m_estOuvert = false
			
			--- Actiualiser position pour reouverture prochaine ----
			try  m_pos = getDialogPos m_dialog  catch ()
			
			---- fermer la fen�tre ----
			try destroydialog m_dialog catch ()
			
		),
		
		fn toggleOuverture =(
			
			if m_estOuvert
				then fermer ()
				else	ouvrir ()
			
		),
		
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
					Color:			setProperty _datas 	propNom		( execute propFichier )
					Default:			setProperty _datas 	propNom		propFichier
				) 
			)		
			
		),
		
		
	public	
		fn enregistrer = (
			debug "enregistrement"
			
			enregistrerDatas  fenetre		"fenetre"
			enregistrerDatas  rendus		"rendus"
			enregistrerDatas  infos			"infos"
			
		),
		fn charger = (
			debug "chargement"
			
			---- si existe pas on initialise le fichier ----
			if not doesFileExist fichierPrefs then (
				debug "fichier absent, cr�ation du fichier"		var:fichierPrefs
				enregistrer ()
			---- sinon on charge ----
			) else (
				chargerDatas  fenetre		"fenetre"
				chargerDatas  rendus		"rendus"
				chargerDatas  infos			"infos"
			)
		),
		fn reset = (
			
			fenetre 		=  str_prefsFenPrincipale 	dossierScript:dossierScript
			infos		 	=  str_prefsFenInfos 		dossierScript:dossierScript
			rendus 		= 	str_prefsRendus 			dossierScript:dossierScript
			general 		= 	str_prefsGenerales		dossierScript:dossierScript
			
			enregistrer ()
		), 
		fn resetApercus = (
			rendus 			= 	str_prefsRendus 		dossierScript:dossierScript
			enregistrer ()
		),
		
		
		------------ Les evenements	----------------------------------------------------------------------------------
		on create do (
			charger ()
			
			debug "Structure cr��e."
			
		)
		
	
)













