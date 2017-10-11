/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	Fenetre type	( sert de model de base, n'est pas importé dans le script )	
	sans barre de titre, draggable et bouton fermer
	
	Remplacer (ctr + h): 'mgrRendus ' par:  'maFenetreAMoi'.
	il y a des parties a decommenter :"--- a décommenter ---"
	Noms des variables 
	-	roll_mgrRendus :			le nom de la fenetre
	-	mgrRendus_pos :			le parametre des prefs stockant la pos de la fenetre
	-	mgrRendus_estOuvert :	le nom du parametre ouvert dans les preferences ( labib.prefs.fenetre. ' mgrRendusOuvert )
	-	str_mgrRendus:			le nom de la struicture de controle de la fenetre
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [02/10/2016] -----------------------------------------------------------------------------
	- Mise en place globale ( mise au propre du travail durant l'été)
	- Une interface souple et simple
########################################################################################################################*/

/* 	
 */
-- destroydialog roll_mgrRendus catch ()
-- (
	
---- a ne pas doubler ----
-- include "$userScripts\cp - labib\cp - GLOBAL\UI.ms"
-- include "$userScripts\cp - labib\cp - GLOBAL\DragDialog.ms"

	
	
-- 	global labib_rendus
	

--- pour fonctionnement mgr rendus -----
include "$userScripts\cp - labib\labib - studio - mgrRendus - mgrLV.ms"
	
/* 	
---- les trhead pour fonction en paralleles -----
global labib_thread_1

fn dialogThread =(
	format " THREAD § § § § § THREAD § § § § § THREAD § § § § § THREAD § § § § §\n"
	rollout unnamedRollout "Untitled" width:162 height:98
	(
		progressBar 'pb1' "ProgressBar" pos:[8,35] width:145 height:23 align:#left
		button 'btn1' "Button" pos:[12,64] width:143 height:26 align:#left
		
		on btn1 pressed  do	(
			::labib_rendus.annulerRendus ()
		)
	)
   createdialog unnamedRollout
)




 */




	
struct str_node_rendu (
	
	id 				="",				---- 	id unique  	------
	pause 		= false,			----	si le noeud est  en attente ou a rendre 	------
	critique 		= false,			---- 	si le noeud est a rendre en priorité ----
	renduFait 	= false,			---- 	si le noeud est a rendre en priorité ----
	
	asset 		="",				----	l'id unique de l'asset de Labib a rendre, si vide on utilise le fichier ci dessous 	------
	fichier 		="",				----	fichier a rendre si l'asset ci dessus reste vide, pour rendre des fichier hors Labib 	------
	
	vue 			="",				----	la vue à utiliser pour le rendu ----
	qualite 		= "",				----	la qualité à utiliser pour le rendu ----
	
	dateEnvoi 	="",				----	la date d'envois du rendu ----
	dateRendu 	=""				----	la date de rélisation du rendu, vide si pas encore rendu ----
	
)

struct str_mgr_pileRendus (
	
			------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
		m_dbgPrefix ="str_mgr_pileRendus",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	
	private
		m_items =#(),
		m_pause = true,
		m_indexID = 0,
		
	public
		
		fn marquerFait  _item 	=(
			_item.dateRendu = localTime
			_item.renduFait = true
		),
		
		fn supprimerPremier  =(
			debug "supprimerPremier"
			if m_items.count > 0 do
				deleteItem m_items 1
		),
		
		fn supprimer	_rendu  =(
			debug "supprimer"
			local id = findItem m_items	_rendu
			deleteItem m_items id
			
		),
		
		fn ajouter 	 =(
			debug "ajouter" 
			
			local nvRendu = str_node_rendu ()
			nvRendu.id = m_indexID as string
			m_indexID += 1
			
			append 	m_items 	nvRendu
			nvRendu
		),
		
		fn get _index =(
			m_items[_index]
		),
		fn getItems = m_items,
		fn aItems = m_items.count > 0,
			
		fn getItemsARendre =(
			local result =for item in m_items where not item.renduFait collect item
			result
		),
		fn aItemsARendre =(
			( getItemsARendre() ).count > 0
		)
)


------------------------------------------------------------------------------
----------	Fenetre								 -------------------------
------------------------------------------------------------------------------
rollout roll_mgrRendus  "File de rendus" width:500 height:300
(
	------------ DEBUG	----------------------------------------------------------------------------------
	local m_debug = true
	local m_dbgPrefix ="studio-mgrRendus rollout"
	fn debug 	_txt  var:	 param:    =(
		if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
	)

	
	------------  Membres	----------------------------------------------------------------------------------
	---- Pointeurs ----
	local m_prt				---- pointeur vers la structure de controle ----
	local m_prefs			---- pointeur vers les preferences "Fenetre"de labib ----
	
	---- Structures ----
	local m_drag			---- la structure gerant le drag de la fenetre ----
	
	--- ctro des imgtags ---
	local m_titre
	
	---- manager du listview ----
	local m_LV
	
	------------  UI	----------------------------------------------------------------------------------		
	ImgTag 'ui_titre' "" pos:[16,4] width:66 height:18 align:#left
	
	---- le bouton pour fermer la fenetre ----
	ImgTag 'ui_btnFermer' "X" pos:[276,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	

	dotNetControl ui_LV 	"system.windows.forms.listView"	pos:		[18,27] \
																				width:261 height:233 \
																				border:	false	\
																				align:#left
	
	
	checkButton	'chk_pause' 		"Pauser" pos:[16,260] width:52 height:17 align:#left
	button 'btn_annuler' 	"Annuler" pos:[67,260] width:52 height:17 align:#left
	
	------------  Fonctions	----------------------------------------------------------------------------------
	
	fn reagencer taille: 	=(
		
		Local largeurBtn = 16
		Local largeurBordure = 20
		
		if taille == unsupplied do taille = [ roll_mgrRendus.width, roll_mgrRendus.height ]
		ui_btnFermer.pos.x		=	taille.x - ( largeurBordure )
		
		ui_LV.width 			= taille.x - ( 2 * largeurBordure ) + 1 
		ui_LV.height 			= taille.y - ( ui_LV.pos.y +  2 * largeurBordure  ) + 5
		chk_pause.pos.y 		= ui_LV.pos.y + 	ui_LV.height
		btn_annuler.pos.y 	= chk_pause.pos.y
	)
	
	
	
	---- Gere l'état du bouton  fermer -----
	fn etatBtnFermer		_etat =(
		case _etat of (
			#Repos : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]
			#Survol : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[2]
			#Press : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[3]
		)
	)
	
	fn actualiser = (
		
		m_LV.actualiser ()
		
		
		if m_prt.m_pile.aItemsARendre ()  then (
			chk_pause.checked 	= m_prt.estEnPause ()
			
		) else (
			chk_pause.checked = false
		)
		chk_pause.enabled 	= m_prt.m_pile.aItemsARendre () 
		btn_annuler.enabled = m_prt.m_pile.aItemsARendre () 
		
	)
	
	
	
	---- Initialisation de la fenetre  -----
	fn initialiser  ptr_parent= (
		
		debug "initialiser"
		
		-- se raccrocher à labib --
		m_prt = ptr_parent
		
		-- le titre --
		m_titre 	= str_label 	m_ui:ui_titre			m_texte:m_prt.m_titre
		m_titre.setCouleur 	m_prt.col_fenetreTxt
		
		-- le drag --
		m_drag 		= str_drag 	m_prt:roll_mgrRendus
		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
		
		---- listView -----
		m_LV 			= str_studio_LVmgr		m_prt:roll_mgrRendus	m_ui:ui_LV
		
-- 		local col_fondDossierPrt 		= m_prefs.fenetre.col_fondDossierPrt	
-- 		local col_txt						= m_prefs.fenetre.col_txt
		
		
		reagencer ()
		actualiser ()
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	on roll_mgrRendus moved			_pos 		do	m_prt.m_pos	= _pos	
	on roll_mgrRendus resized			_taille 	do	reagencer ()
	
	---- Drag ----
	on roll_mgrRendus lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_mgrRendus lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_mgrRendus mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
	---- Bouton fermer -----
	on 	ui_btnFermer	mouseover 				do 	etatBtnFermer #Survol
	on 	ui_btnFermer	mouseout 				do 	etatBtnFermer #Repos
	on 	ui_btnFermer	mousedown 			do 	etatBtnFermer #Press
	on 	ui_btnFermer	mouseup				do 	etatBtnFermer #Repos
	on 	ui_btnFermer 	click 						do 	m_prt.fermer ()
	
	---- liste view -----
	on ui_LV	mouseDown 				_arg 	do  	m_LV.clq_down  	_arg
	on ui_LV 	mouseUp 	_sender 		_arg 	do 	m_LV.clq_up 		_arg
	
	on chk_pause changed state 				do	(
		if state 
			then (
				m_prt.pauser ()
				chk_pause.text = "Rendre"
			)	else ( 
				m_prt.lancerExecution () 
				chk_pause.text = "Pauser"
			)
		actualiser ()
	)
	
	on btn_annuler pressed do annulerRendus ()
	
)
	
------------------------------------------------------------------------------
----------	Structure								 -------------------------
------------------------------------------------------------------------------
struct str_mgrRendus (
		
	------------ DEBUG	----------------------------------------------------------------------------------
	m_debug = true,
	m_dbgPrefix ="studio-str_mgrRendus",
	fn debug 	_txt  var:	 param:    =(
		if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
	),
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_mgrRendus ,		---- le rollout ----
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Studio | File de rendus",
		m_pos 				= [100,100],
		m_taille 				= [500, 300],
	
		
		--- ui libre de labib -----------	
		col_fenetreFond			= color 68 68 68, 		---- MAX 	----
		col_fenetreTxt				= color 230  230 230, 	----  		----
		
		m_pile		= str_mgr_pileRendus (),
		
		ico_btnFermer_R	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_R.jpg",
		ico_btnFermer_S	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_S.jpg",
		ico_btnFermer_P	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_P.jpg", 
	
		m_icos_fermer= #( 	openBitMap ico_btnFermer_R, 
									openBitMap	ico_btnFermer_S,
									openBitMap	ico_btnFermer_P ),
		
		
		
		

	private
		m_estOuvert 	= false,	
		m_pause 		= true,
		m_canceled	= false ,
		
		--- fichier MAX servant de studio ----------
		m_fichierStudio			=	getDir #userscripts + "\cp - labib\data\labib_modeEdition.max",
		m_fichierStudio_ouvert 	= false,
		
		m_manips   			= str_manipNodes (),
		
-- 		m_thread_1 		 = dotnetobject "CSharpUtilities.SynchronizingBackgroundWorker",
		
		m_coroConverter,
		m_coroProxyConverter,
		------------  Fonctions	----------------------------------------------------------------------------------
		
		
		fn ouvrir_fichierStudio =(
			debug "ouvrir_fichierStudio"
			
				
				resetMaxFile 	#noPrompt
				
			
				--- les elements du studio ---------------
				mergeMaxFile	m_fichierStudio 
				
				m_fichierStudio_ouvert = true
				
-- 			)
		),
		
		
		fn quitter_fichierStudio =(
			debug "quitter_fichierStudio"
			resetMaxFile 	#noPrompt
			m_fichierStudio_ouvert = false
		),
		
		
	private
		fn annulerRendus =(
			ecrire "annulerRendus"
			m_canceled = true
-- 			progressEnd() 
		),
		fn estAnnule =(
-- 			if getProgressCancel()  then annulerRendus () else
			 if  keyboard.escPressed  do annulerRendus ()
			m_canceled
		),
			
		
		
		---- divers ---------
		fn placer_CamDefaut  		_objets  =(
			
			local cam 					= $Camera
			local camTarget 			= $'Camera.Target'
			local ptRotation 			= $ptCam_rot
			local ptDeplacement 	= $ptCam_pos
			local ptRoot 				= $PtCam_root
			
			local ratioDistance 		= .5
			
			local BB 					= m_manips.calculerBB  		_objets
			local tailleBB 				= m_manips.calculerTaillesBB  _objets
			
			ptRoot.pos 					= m_manips.calculerCentre	_objets
			
			
			in coordsys parent 		camTarget.pos.y = BB[1].y
			local cam_fov 			= cam.fov *.65
			local grdeLongueurBB 	= if tailleBB.x > tailleBB.z then tailleBB.x else tailleBB.z
			
			local d = ( grdeLongueurBB / 2 ) / tan (cam_fov/2 ) * ratioDistance
			
			in coordsys parent cam.pos.y =  in coordsys parent camTarget.pos.y  - d
			
			
		),
		
		
	public
		
		--------- RENDU ------------
		
		fn convertMateriauxScene =(
			
			debug "convertMateriauxScene - debut" 
			
			if m_coroConverter == undefined do (
				m_coroConverter 		= CoronaConverter
				m_coroProxyConverter 	= CoronaProxyConverter
			)
			m_coroConverter.convertScene ()
			
			debug "convertMateriauxScene - fin" 
		),
		
		fn relinkBitmap =(
			
						---- collecter les bitmaps --------
			fn chercher_fichier  _bitmap_map 	_dossier	=(
				
				local recurant = true
				local chemin_fichier = _bitmap_map.fileName
				local fichier = filenameFromPath chemin_fichier
-- 							format"fichier a chercher :%\n" (  fichier)
				
				local i = 1
				local trouve= false
		
				if doesFileExist ( _dossier + "\\" + fichier) then (
					format"	---->	fichier trouvé:%	<----\n" ( _dossier + "\\" + fichier)
					_bitmap_map.fileName = ( _dossier + "\\" + fichier)
					trouve	= true
				) else if recurant do (
					local sousDossiers = getDirectories 	(_dossier + "*")
					for sousDossier in sousDossiers where not trouve	do (
						
						format"	sous dossiers:%\n"  sousDossier
						trouve = chercher_fichier  _bitmap_map 	sousDossier
					)
				)
					
				trouve
			)
			
			
			local dossiers_recherche = #(	"D:\01 - modeles 3D\00 - collections\ARCHMODELS\MAPS Evermotion" )
			local allTxtMaps = getClassInstances BitmapTexture

			for bitmap_map in allTxtMaps do
			(
				
				bitmap_map.fileName
				if not (doesFileExist ( bitmap_map.fileName ) ) do (
					format"fichier manquant:%\n" ( bitmap_map.fileName)
					local trouve = false
					for dossier in dossiers_recherche where not trouve	do (
						trouve = chercher_fichier	bitmap_map  dossier
					)
				)
				
			)

			
		),
		--- lancé par le thread, ----------------
		fn preparerVue 	nodes:  vue:	qualite: 		 =  /* with redraw off  */ (
			
			local mtr_rendu 	= 	renderers.current		
			local lum 			=	labib_studio.m_presets.get	vue.lumiere			type:#lumiere 		par:#id
			local cam 			=	labib_studio.m_presets.get	vue.camera			type:#camera 	par:#id
			local ptCamRotation 	= $ptCam_rot
			
			m_studio_camera = $Camera
			viewport.setLayout #layout_1
			viewport.setType #view_camera
			
			--- VUE ---------------------------------------
			-- camera --
			placer_CamDefaut	nodes
			local posBak = ptCamRotation.pos
			in coordsys parent rotate ptCamRotation (angleaxis cam.rot.x  [0,0,1])
			in coordsys parent rotate ptCamRotation (angleaxis cam.rot.y  [1,0,0])
			ptCamRotation.pos = posBak
			
			-- fond --
			-- lumieres --			
			mtr_rendu.bg_source = 1
			mtr_rendu.bg_texmap = CoronaSky ()
			mtr_rendu.colorMap_simpleExposure = lum.EV
			-- effets --
			
			
			--- QUALITE ----------------------------	
			mtr_rendu.progressive_passLimit			=	qualite.nbrPass
			mtr_rendu.adaptivity_targetError		=	qualite.noiseLvl
			mtr_rendu.denoise_blendAmount			=	qualite.denoise
			mtr_rendu.progressive_timeLimit			=	qualite.timeLimit
			
			--- conversion materiaux coro et relink ---
			convertMateriauxScene ()
			relinkBitmap ()
		),
		
		
		fn rendre 	_renduAFaire	=(
			
			debug "rendre"
			
			local prefix = _renduAFaire.vue.nom
			local suffix = _renduAFaire.asset.nomUnique			
			local nomRendu  = ::labib.prefs.general.dossierApercus + "\\" + prefix + "_" + suffix + ".jpg"
			
			debug "nomRendu" var:nomRendu
			
			CoronaRenderer.CoronaFp.showVfB false
			
			local imageRendu = 	render m_studio_camera 		outputSize:::labib.prefs.rendus.taille   	\
											outputfile:nomRendu 			vfb:false 			quiet:true				\
											cancelled:&m_canceled	 		missingExtFilesAction:#logmsg
			
			_renduAFaire.asset.apercu = nomRendu
			_renduAFaire.asset.enregistrer ()
			
-- 			display imageRendu
			gc ()
			
			imageRendu
			
		),
		
		
		fn executer =  (
			
			debug "executer"
			
			local fen_labib_ouverte 	= labib.estOuvert ()
			local fen_studio_ouverte 	= labib_studio.estOuvert ()
			local fen_rendus_ouverte 	= labib_rendus.estOuvert ()

			
			local nodesImport
			local dumPrt 
			local assetBack

			local nbrRendus_init 	= (m_pile.getItemsARendre ()).count as float
			local nbreRendus_fait 	= 0.
				
				
			if not checkForSave()  do return #canceled
			
			-- on regarde si on est dans le studio ----
			if not m_fichierStudio_ouvert 
				do 	ouvrir_fichierStudio ()
			
			
			progressStart "| Labib | Rendus en cours" 
			progressUpdate ( nbreRendus_fait / nbrRendus_init * 100. )
			
			
			while m_pile.aItemsARendre () do with redraw off  (
				
				
				progressUpdate ( nbreRendus_fait / nbrRendus_init * 100. )
				
				local listeRendus = m_pile.getItemsARendre ()
				local renduAFaire = listeRendus[1]
				
				
				if estAnnule () do return #canceled	-------------------------------- CHECK ANNULATION ---

				
				if renduAFaire.asset  != assetBack 	then 	(
					
					-- on vide la scene de l'ancien asset --
					if nodesImport != undefined 	do delete nodesImport
					if dumPrt != undefined 			do delete dumPrt
					
					--- on importe le nouveau ---
					mergeMAXFile   renduAFaire.asset.fichier   #autoRenameDups  #renameMtlDups mergedNodes:&nodesImport   quiet:true  
					dumPrt = m_manips.creerDummyParent	nodesImport
					dumPrt.pos.x = 0
					dumPrt.pos.y = 0
					
				) 
				
				-- on applique les parametres de la vue a rendre -------				  	
				preparerVue 	nodes:nodesImport  vue:renduAFaire.vue		qualite:renduAFaire.qualite		
				
				
				--- rendre la vue -------------
				rendre 	renduAFaire
				
				--- conclusions ------
				assetBack = renduAFaire.asset
				nbreRendus_fait += 1.
				progressUpdate ( nbreRendus_fait / nbrRendus_init * 100. )
				m_pile.marquerFait 	renduAFaire
				
				--m_dialog.actualiser ()
				
			)
			
			if m_fichierStudio_ouvert do quitter_fichierStudio ()
			progressEnd() 
			
-- 			debug "2- fen_labib_ouverte"		var:fen_labib_ouverte
-- 			debug "2- fen_studio_ouverte"	var:fen_studio_ouverte
-- 			debug "2- fen_rendus_ouverte"	var:fen_rendus_ouverte
			
-- 			if fen_labib_ouverte 			do labib.ouvrir ()
-- 			if fen_studio_ouverte 		do labib_studio.ouvrir ()
-- 			if fen_rendus_ouverte 		do labib_rendus.ouvrir ()
			
			
		),
		
		
		
		
		
		
		
		
		
		
		
		---- accesssions ----
		fn get_rendus =(
			m_pile.getItems ()
		),
		fn estEnPause = m_pause,
		
		
		
		---- manipuler l'execution de la pile de rendus  ----
		fn lancerExecution = (
			m_pause = false
			m_dialog.actualiser ()
			
			if executer() == #canceled do (
				debug "A été annulé, on pourrait faire un truc là ......................................................................................."
				
				if m_fichierStudio_ouvert do quitter_fichierStudio ()
				progressEnd() 
			)
			
		),
		
		
		
		fn pauser = (
			m_pause = true
			m_dialog.actualiser ()
		),
		
		
		---- manipuler la pile de rendus  ----
		fn ajouter  pause:true	critique:false		asset:""	fichier:""		vue:""	qualite:""	dateEnvoi:localTime		= (
			
			local rendu 		=	m_pile.ajouter 	()
			
			rendu.pause		=	pause
			rendu.critique		=	critique
			rendu.asset		=	asset
			rendu.fichier		=	fichier
			rendu.vue			=	vue
			rendu.qualite		=	qualite
			rendu.dateEnvoi	=	dateEnvoi
			
			m_dialog.actualiser ()
			
		),		
		
		
		
		
		
	
		
		
		
		
	public
		
		---- la fenetre generale des rendus-------------------
		fn estOuvert = m_estOuvert,
		fn ouvrir =(			
			debug "ouvrir"
			m_estOuvert 		= true
			
			---- creation de la fenetre ----
			createDialog m_dialog 	fgcolor:				col_fenetreTxt 	\
											style:				#(#style_resizing) \
											pos:					m_pos	
-- 											lockHeight:			true	\
-- 											lockWidth:			true	 \	
			
			---- initialisation de la fenetre ----
			
			
			m_dialog.initialiser 	this
	
		),
		
		fn fermer  silence:false =(		---- silence : fermer sans modifier l'état des preferences ---	
			debug "fermer"
			m_estOuvert 		= false
			---- maj des preferences ----	
			if not silence do (
			)
			
			---- fermer la fenêtre ----
			try destroydialog m_dialog catch ()
		),
		
		fn toggleOuverture =(
			
			if m_estOuvert
				then fermer ()
				else	ouvrir ()
			
		),
		
		------------  Evenements	----------------------------------------------------------------------------------
		on create do (
			
			--	MainThread.WorkerReportsProgress = true
			/* 
			labib_thread_1 = dotnetobject "CSharpUtilities.SynchronizingBackgroundWorker"
			labib_thread_1.WorkerSupportsCancellation = true	
			dotNet.addEventHandler labib_thread_1 "DoWork" dialogThread
			 */
			
			-- au cas ou on retire l'ecouteur , pour pas cumuler ---			
			ecrire "|Rendus| Prêt."
		)
		
		
) -- fin struct ---------

 labib_rendus  	=	str_mgrRendus () --	m_labib:Labib



/* 
 */

-- destroydialog labib_rendus.m_dialog
-- )


/* 
labib_rendus.ouvrir ()
labib_rendus.ajouter "tutu"
labib_rendus.ajouter "popo"
labib_rendus.ajouter "tyty"


labib_rendus.m_pile.getItems()


 */


