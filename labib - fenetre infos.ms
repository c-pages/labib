
----------------------------------------------------------------------------
--------	Fichiers annexes						--------------------------
----------------------------------------------------------------------------
-- include "$userScripts\cp - labib\cp - GLOBAL\UI.ms"
-- include "$userScripts\cp - labib\cp - GLOBAL\DragDialog.ms"
-- include "$userScripts\cp - GLOBAL\UI.ms"
-- include "$userScripts\cp - GLOBAL\DragDialog.ms"



------------------------------------------------------------------------------
----------	Fenetre								 -------------------------
------------------------------------------------------------------------------
rollout roll_infos "infos"  width:346 height:262
(
	
	
	------------ DEBUG	----------------------------------------------------------------------------------
	local	m_debug = true
	local	m_dbgPrefix ="roll_infos"
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
	label ui_lblNom "Nom : " pos:[20,20] width:36 height:17
	edittext ui_editNom "" pos:[126,20] width:200 height:17 bold:true
	
	label ui_lblTags "Mots clés :" pos:[20,59] width:53 height:17
	edittext ui_editTags "" pos:[126,59] width:200 height:17
	
	label ui_lblFichier "Fichier : " pos:[20,39] width:44 height:17
	edittext ui_editFichier "" pos:[126,39] width:177 height:17
	button ui_btnOuvrirFichierMax "..." pos:[309,39] width:17 height:17 toolTip:"Choisir le fichier .max de référence de cet asset."
	
	/* 
	label ui_lblApercu "Aperçu :" pos:[20,74] width:44 height:17
	edittext ui_editApercu "" pos:[126,74] width:139 height:17
	
	button ui_btnOurvirApercu "..." pos:[271,74] width:17 height:17 toolTip:"Choisir l'image servant d'aperçu à cet asset (200px X 200px)."
	button ui_btnCreerApercu "R" pos:[290,74] width:17 height:17 toolTip:"Créer l'aperçu"
	button ui_btnCreerAperculAuto "O" pos:[309,74] width:17 height:17 toolTip:"Créer l'aperçu"
	
	label ui_lblDetail "Détail :" pos:[20,92] width:44 height:17
	edittext ui_editDetail "" pos:[126,92] width:139 height:17
	
	button ui_btnOurvirDetail "..." pos:[271,92] width:17 height:17 toolTip:"Choisir l'image servant d'aperçu détail à cet asset (200px X 200px)."
	button ui_btnCreerDetail "R" pos:[290,92] width:17 height:17 toolTip:"Création automatique de l'aperçu détail de cet asset."
	button ui_btnCreerApercuDetailAuto "O" pos:[309,92] width:17 height:17 toolTip:"Création automatique de l'aperçu détail de cet asset."
	*/
	
	label 		ui_lblNotes 		"Notes :" pos:[20,78] width:46 height:17		
	
	
	
	edittext 	ui_editNotes	"" pos:[126,78] width:200 height:56
	
	
	
	
	
	---- le bouton pour fermer la fenetre ----
	ImgTag ui_btnFermer "X" pos:[326,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center
	
	ImgTag ui_titre "" pos:[128,4] width:66 height:18
	
	label ui_lbl_apercus "Aperçus: " pos:[22,141] width:60 height:17
	
	ImgTag ui_mgr_apercus "" pos:[130,138] width:196 height:151
	
	
	------------  Fonctions	----------------------------------------------------------------------------------
	---- Gere l'état du bouton  -----
	fn etatBtnFermer		_etat =(
		case _etat of (
			#Repos : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
			#Survol : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[2]	
			#Press : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[3]	
		)
	)
	
	
	fn actualiser = (
		
	)
	
	fn afficher 	_assets 	=(
		
		toArray 	&_assets
		debug "afficher"
		debug "_assets" var:_assets param:#nom
		
			
		if _assets.count == 1 then (
			local selectionNoeud = _assets[1]
			
			if classOf selectionNoeud == str_element then  (
				
				for ui in m_uis do ui.enabled=true
				ui_editNom.text = selectionNoeud.nom
				
				ui_editFichier.text 					= 	selectionNoeud.getFichier ()
				ui_editApercu.text 					= 	selectionNoeud.getApercu()
				ui_editDetail.text 					= 	selectionNoeud.getDetail()
				ui_editTags.text 						= 	selectionNoeud.getTags ()
				ui_editNotes.text 					=	selectionNoeud.commentaires
				ui_editDateCreation.text 			=  selectionNoeud.getDateCreation ()
				ui_editDateDernierImport.text 	= 	selectionNoeud.getDateDernierImport ()
				ui_editNbreImports.text 			= 	selectionNoeud.getNbrImports () 
				ui_editNbreVertex.text 				= 	selectionNoeud.getNbrVertex ()
				
			) else (
				
				for ui in m_uis do ui.enabled=false
				ui_editNom.text = selectionNoeud.nom
				ui_lblNom.enabled = true
				ui_editNom.enabled = true
				
				local listeTags = for asset in _assets collect selectionNoeud.getTags()
				ui_editTags.text = checkUnite 	listeTags
				ui_lblTags.enabled = true
				ui_editTags.enabled = true
			)
			
		) else (
			
			for ui in m_uis do ui.enabled=false
				
			if _assets.count == 0 then (
				ui_editFichier.text 					= 	""
-- 				ui_editApercu.text 					= 	""
-- 				ui_editDetail.text 					= 	""
				ui_editTags.text 						= 	""
				ui_editNotes.text 					=	""
				ui_editDateCreation.text 			=  ""
				ui_editDateDernierImport.text 	= 	""
				ui_editNbreImports.text 			= 	""
				ui_editNbreVertex.text 				= 	""
			) else (
			
				local listeNoms = for asset in _assets collect asset.nom
				ui_editNom.text = checkUnite 	listeNoms
				ui_lblNom.enabled = true
				ui_editNom.enabled = true
				
				local listeTags = for asset in _assets collect asset.getTags()
				ui_editTags.text = checkUnite 	listeTags
				ui_lblTags.enabled = true
				ui_editTags.enabled = true
				
-- 				ui_btnCreerApercu.enabled = true
-- 				ui_btnCreerDetail.enabled = true
			)
		)
		
	)
	
	
	fn reagencer _taille =(
		
		m_prt.m_taille = _taille
		
		local LargeurEdit = 148
		local LargeurBtn = 17
		local	decalXBtn1 = 34
		local	decalXBtn2 = decalXBtn1 + LargeurBtn
		local	decalXBtn3 = decalXBtn1 + 2* LargeurBtn
		
		ui_editNom.width 					= 	_taille.x - ( LargeurEdit )
		ui_editFichier.width 					= 	_taille.x - ( LargeurEdit + LargeurBtn )
-- 		ui_editApercu.width 					= 	_taille.x - ( LargeurEdit + 3 * LargeurBtn )
-- 		ui_editDetail.width 					= 	_taille.x - ( LargeurEdit + 3 * LargeurBtn )
		ui_editTags.width 					= 	_taille.x - ( LargeurEdit )
		ui_editDateCreation.width 			=  _taille.x - ( LargeurEdit )
		ui_editDateDernierImport.width 	= 	_taille.x - ( LargeurEdit )
		ui_editNbreImports.width 			= 	_taille.x - ( LargeurEdit )
		ui_editNbreVertex.width 			= 	_taille.x - ( LargeurEdit )
		ui_editNotes.width 					=	_taille.x - ( LargeurEdit )
		ui_editNotes.height 					=	_taille.y - ( 206 )


		ui_btnOuvrirFichierMax.pos.x			=	_taille.x - ( decalXBtn1 )	
/* 		
		ui_btnOurvirApercu.pos.x				=	_taille.x - ( decalXBtn3 )
		ui_btnCreerApercu.pos.x				=	_taille.x - ( decalXBtn2 )
		ui_btnCreerAperculAuto.pos.x			=	_taille.x - ( decalXBtn1 )		
		ui_btnOurvirDetail.pos.x					=	_taille.x - ( decalXBtn3 )
		ui_btnCreerDetail.pos.x					=	_taille.x - ( decalXBtn2 )
		ui_btnCreerApercuDetailAuto.pos.x	=	_taille.x - ( decalXBtn1 )
		 */
		ui_btnFermer.pos.x						=	_taille.x - ( LargeurBtn )
		
	)
	
	---- Initialisation de la fenetre  -----
	fn initialiser labib: prt: = (
		
		if labib != unsupplied and prt != unsupplied do (
			
			m_labib 	= labib
			m_prt 	= prt
			m_drag 	= str_drag 	m_prt:roll_infos		
			
			m_titre 	= str_label 	m_ui:ui_titre			m_texte:m_prt.m_titre
			m_titre.setCouleur 	m_prt.col_fenetreTxt
			
			
			-- le bouton fermer --
			ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
			
			-- creation de la liste des uis ---
			m_uis = #(
				ui_lblNom, ui_editNom, ui_lblFichier, ui_editFichier, ui_btnOuvrirFichierMax, 
-- 				ui_lblApercu, ui_editApercu, ui_btnOurvirApercu , ui_btnCreerDetail, ui_lblDetail, ui_editDetail, 
-- 				ui_btnOurvirDetail, ui_btnCreerApercu, 
				ui_lblTags, ui_editTags, ui_lblNotes, ui_editNotes, 
-- 				ui_btnCreerApercuDetailAuto,
-- 				ui_btnCreerAperculAuto, 
				ui_lblCreation, ui_editDateCreation, ui_lblDateDernierImport, ui_editDateDernierImport , ui_lblNbreImports,
				ui_editNbreImports, ui_lblNbreVertex, ui_editNbreVertex )
			
			reagencer [roll_infos.width, roll_infos.height]
			
			actualiser()
		)
	)
	
	
	
	
	
	------- corps ------
	fn ouvrirFichierMax _noeud =(
		local fichier = getOpenFileName 	caption:"Fichier max de l'asset:" \
														filename:_noeud.fichier
		if fichier != undefined do m_labib.cmd.changerFichier 	_noeud 	fichier
			
	)
	
	
	
	
	------------  Evenements	----------------------------------------------------------------------------------
	
	--- rollout ---
	on roll_infos moved			_pos 		do	m_prt.m_pos	= _pos
	on roll_infos resized			_taille 	do	reagencer 	_taille

	---- Drag ----
	on roll_infos lbuttondown _pos 	do
		m_drag.demarrer ()
	on roll_infos lbuttonup _pos 	do
		m_drag.arreter ()
	on roll_infos mouseMove _pos 	do
		m_drag.suivreSouris ()
	
	---- Fermer ----
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
	
	
	---- corps ----	
	on ui_editNom						entered 	_text do m_labib.cmd.renommer 			(m_labib.edit.getSelection ()) 		_text
	on ui_editFichier 					entered 	_text do m_labib.cmd.changerFichier 	(m_labib.edit.getSelection ())[1] 	_text
	on ui_btnOuvrirFichierMax 		pressed  do ouvrirFichierMax (m_labib.edit.getSelection ())[1]
	on ui_editApercu 				entered 	_text do ()
	on ui_btnOurvirApercu 			pressed  do ()
	on ui_btnCreerApercu 			pressed  do ()
	on ui_btnCreerAperculAuto 	pressed  do ()
	on ui_editDetail 					entered 	_text do ()
	on ui_btnOurvirDetail 			pressed  do ()
	on ui_btnCreerDetail 			pressed  do ()
	on ui_btnCreerApercuDetailAuto pressed  do ()
	on ui_editTags 					entered _text do m_labib.cmd.setTags 			(m_labib.edit.getSelection ()) 		_text
	on ui_editNotes 					entered _text do ()
	
)

------------------------------------------------------------------------------
----------	Structure								 -------------------------
------------------------------------------------------------------------------
struct str_infos (
	
		------------  Membres	----------------------------------------------------------------------------------
	public
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_infos ,		---- le rollout ----
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Infos",
		m_pos 				= [100,100],
		m_taille 				= [300, 300],
		m_estOuvert 		= false,
		
		col_fenetreFond	= m_labib.prefs.fenetre.col_fenetreFond, 	----  ----
		col_fenetreTxt		= m_labib.prefs.fenetre.col_fenetreTxt, 	----  ----
	
		--- images bouton fermer ---
		m_icos_fermer= #( 					---- les images pour les icones du bouton de fermeture ----		
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_R ,		-- Repos ----
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_S ,		-- Survol ----
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_P 		-- Pressé ----
								),
				
		------------  Fonctions	----------------------------------------------------------------------------------
	public
		fn estOuvert = m_estOuvert,
		
		---- fenetre -----
		fn afficher _noeuds =(
			if m_estOuvert do
				m_dialog.afficher _noeuds
		),
		
		fn ouvrir =(
			m_estOuvert = true
			---- creation de la fenetre ----
			createDialog m_dialog 	style:				#(#style_resizing) \
											pos:					m_pos	\
											width:				m_taille.x \
											height:				m_taille.y 
-- 											bgcolor:				col_fenetreFond 	 \
-- 											fgcolor:				col_fenetreTxt 	\
											
			---- initialisation de la fenetre ----
			m_dialog.m_prt	 	= this
			m_dialog.initialiser 	labib:m_labib 	prt:this
			
			afficher  ( m_labib.edit.getSelection() )
			
		),
		
		fn fermer  enregistrer:true =(
			
			if enregistrer do
				m_estOuvert = false
			
			--- Actiualiser position pour reouverture prochaine ----
			try  m_pos = getDialogPos m_dialog  catch ()
			
			---- fermer la fenêtre ----
			try destroydialog m_dialog catch ()
			
		),
		
		fn toggleOuverture =(
			
			if m_estOuvert
				then fermer ()
				else	ouvrir ()
			
		)
		
		
		
		
		------------  Evenements	----------------------------------------------------------------------------------
	
)


