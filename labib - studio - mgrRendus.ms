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
include "$userScripts\cp - labib\cp - GLOBAL\UI.ms"
include "$userScripts\cp - labib\cp - GLOBAL\DragDialog.ms"

	
	
-- 	global labib_rendus
	

--- pour fonctionnement mgr rendus -----
include "$userScripts\cp - labib\labib - studio - mgrRendus - mgrLV.ms"
	
	
	
	
fn executer_THREAD  sender e  =(
-- 			debug "sender" var:sender
		local pileRendus = labib_rendus.m_pile.getItems ()
		
		for renduAFaire in pileRendus do (
			if keyboard.escPressed do
					If thread_1.IsBusy Then thread_1.CancelAsync()
			If thread_1.CancellationPending 
				then 	(
					e.cancel = true	
					labib_rendus.pauser ()
				)
				else 		(
					labib_rendus.rendre 	renduAFaire
					
				)
		)
	)
thread_1 = dotnetobject "CSharpUtilities.SynchronizingBackgroundWorker"
thread_1.WorkerSupportsCancellation = true		
dotNet.addEventHandler thread_1 "DoWork" 	executer_THREAD

	
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
		fn supprimerPremier  =(
			debug "supprimerPremier"
			if m_items.count > 0 do
				deleteItem m_items 1
		),
		fn supprimer	_rendu  =(
			debug "supprimerPremier"
			local id = findItem m_items	_rendu
			deleteItem m_items id
			
-- 			if m_items.count > 0 do
-- 				deleteItem m_items 1
		),
		fn ajouter 	_rendu =(
			debug "ajouter" 
			
			local nvRendu = str_node_rendu ()
			nvRendu.id = m_indexID as string
			m_indexID += 1
			nvRendu.asset = _rendu
			
			append 	m_items 	nvRendu
			nvRendu
		),
		fn getItems = m_items
		
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
	
	
	checkButton	'chk_pause' 		"pause" pos:[16,260] width:52 height:17 align:#left
	button 'btn_annuler' 	"annuler" pos:[67,260] width:52 height:17 align:#left
	
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
		chk_pause.checked = m_prt.estEnPause ()
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
			then m_prt.pauser ()
			else m_prt.retirerPause () 
		actualiser ()
	)
	
	on btn_annuler pressed do 
					If thread_1.IsBusy Then thread_1.CancelAsync()
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
		
		
		------ multi threading ------------------
		m_thread_1 = dotnetobject "CSharpUtilities.SynchronizingBackgroundWorker",

		
		------------  Fonctions	----------------------------------------------------------------------------------
	public
		---- accesssions ----
		fn get_rendus =(
			m_pile.getItems ()
		),
		fn estEnPause = m_pause,
		
		
		---- divers ---------
		fn rendre 	_rendu =(
			debug "RENDRE" 
			debug "rendu"  var:_rendu
			m_pile.supprimer 	_rendu
			m_dialog.actualiser ()
		),
		
	/* 	fn executer_THREAD  sender e  =(
-- 			debug "sender" var:sender
			local pileRendus = labib_rendus.m_pile.getItems ()
			
			for renduAFaire in pileRendus do (
				If m_thread_1.CancellationPending 
					then 	(e.cancel = true	)
					else 		(labib_rendus.rendre 	renduAFaire)
			)
			
-- 			if not m_pause do (
-- 				debug "executer" 
-- 				-- annulation -----
-- 				if if not thread_1.IsBusy do thread_1.RunWorkerAsync()do  ( m_pause = true; 	return #annuler )
-- 					
-- 				local pile = m_pile.getItems ()
-- 				
-- 				-- annulation -----
-- 				if keyboard.escPressed do ( m_pause = true; 	return #annuler  )
-- 					
-- 				if pile.count > 0 then (
-- 					local renduAFaire = pile[1]
-- 				-- annulation -----
-- 				if keyboard.escPressed do ( m_pause = true; 	return #annuler  )
-- 					rendre 	renduAFaire
-- 				-- annulation -----
-- 				if keyboard.escPressed do ( m_pause = true; 	return #annuler  )
-- 					m_pile.supprimerPremier ()
-- 				-- annulation -----
-- 				if keyboard.escPressed do ( m_pause = true; 	return #annuler  )
-- 					executer ()
-- 				) else 	debug "Plus rien a rendre" 
-- 			) 
		), */
		
		fn executer =(
			-- on execute par le thread ---
			if not thread_1.IsBusy do thread_1.RunWorkerAsync()
		),
		fn retirerPause = (
			m_pause = false
			m_dialog.actualiser ()
			executer()
		),
		fn pauser = (
			m_pause = true
			m_dialog.actualiser ()
		),
		
		
		
		fn ajouter  pause:true	critique:false		asset:""	fichier:""		vue:""	qualite:""	dateEnvoi:localTime		= (
			
			local rendu 		=	m_pile.ajouter 	_rendu
			
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
			m_thread_1.WorkerSupportsCancellation = true		
			dotNet.addEventHandler m_thread_1 "DoWork" 	executer_THREAD
			
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


