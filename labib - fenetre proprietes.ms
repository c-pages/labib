
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
rollout roll_proprietes "Propriétés"  width:800 height:400
(
	
	
	------------ DEBUG	----------------------------------------------------------------------------------
	local	m_debug = true
	local	m_dbgPrefix ="roll_proprietes"
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
	
	local m_id_apercuAAfficher = 0
	
	------------  UI	----------------------------------------------------------------------------------		
	
	label 'ui_lblNom' "Nom : " pos:[282,20] width:36 height:17 align:#left
	edittext 'ui_editNom' "" pos:[388,20] width:200 height:17 bold:true align:#left
	
	label 'ui_lblTags' "Mots clés :" pos:[282,58] width:53 height:17 align:#left
	edittext 'ui_editTags' "" pos:[388,58] width:200 height:17 align:#left
	
	
	label 'ui_lblFichier' "Fichier : " pos:[282,39] width:44 height:17 align:#left
	edittext 'ui_editFichier' "" pos:[388,39] width:181 height:17 align:#left
	button 'ui_btnOuvrirFichierMax' "..." pos:[570,38] width:19 height:19 toolTip:"Choisir le fichier .max de référence de cet asset." align:#left
	
	
	
	label 'ui_lblNotes' "Notes :" pos:[282,169] width:46 height:17 align:#left		
		
		
	
	
	edittext 'ui_editNotes' "" pos:[388,169] width:200 height:56 align:#left
	
	
	label 'ui_lblCreation' "Date de création :" pos:[282,93] width:91 height:17 align:#left
	edittext 'ui_editDateCreation' "" pos:[388,93] width:200 height:17 readOnly:true align:#left
	label 'ui_lblDateDernierImport' "Date dernier import :" pos:[282,112] width:109 height:17 align:#left
	edittext 'ui_editDateDernierImport' "" pos:[388,112] width:200 height:17 readOnly:true align:#left
	
	label 'ui_lblNbreImports' "Nombre d'imports :" pos:[282,131] width:109 height:17 align:#left
	edittext 'ui_editNbreImports' "" pos:[388,131] width:200 height:17 readOnly:true align:#left
	
	label 'ui_lblNbreVertex' "Nombre de points :" pos:[282,150] width:109 height:17 align:#left
	edittext 'ui_editNbreVertex' "" pos:[388,150] width:200 height:17 readOnly:true align:#left
	
	---- le bouton pour fermer la fenetre ----
	ImgTag 'ui_btnFermer' "X" pos:[326,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	
	ImgTag 'ui_titre' "" pos:[17,4] width:66 height:18 align:#left
	
	
	bitmap 'bmp_Affichage' "" pos:[16,24] width:256 height:256 align:#left	
	
	
	checkbutton 'btn_global' "" pos:[16,287] width:50 height:50 align:#left	
	
	checkbutton 'btn_detail_1' "" pos:[116,287] width:50 height:50 align:#left
	checkbutton 'btn_detail_2' "" pos:[169,287] width:50 height:50 align:#left
	checkbutton 'btn_detail_3' "" pos:[222,287] width:50 height:50 align:#left
	/* 
	label 'lbl_' "Globale" pos:[18,336] width:45 height:15 align:#left
	label 'lbl28' "Détail 1" pos:[118,336] width:40 height:15 align:#left
	label 'lbl29' "Détail 2" pos:[171,336] width:40 height:15 align:#left
	label 'lbl30' "Détail 3" pos:[224,336] width:40 height:15 align:#left */
	/* 
	
	------------  UI	----------------------------------------------------------------------------------		
	label 'ui_lblNom' "Nom : " pos:[20,20] width:36 height:17 align:#left
	edittext 'ui_editNom' "" pos:[126,20] width:200 height:17 align:#left bold:true
	
	label 'ui_lblTags' "Mots clés :" pos:[20,38] width:53 height:17 align:#left
	edittext 'ui_editTags' "" pos:[126,38] width:200 height:17 align:#left
	
	
	label 'ui_lblFichier' "Fichier : " pos:[20,56] width:44 height:17 align:#left
	edittext 'ui_editFichier' "" pos:[126,56] width:181 height:17 align:#left
	button 'ui_btnOuvrirFichierMax' "..." pos:[307,56] width:20 height:20 toolTip:"Choisir le fichier .max de référence de cet asset." align:#left
	
	label 'ui_lblApercu' "Aperçu :" pos:[20,75] width:44 height:17 align:#left
	edittext 'ui_editApercu' "" pos:[126,75] width:138 height:17 align:#left
	
	button 'ui_btnOurvirApercu' 		"..." pos:[269,75] width:20 height:20 toolTip:"Choisir l'image servant d'aperçu à cet asset (200px X 200px)." align:#left
	button 'ui_btnCreerApercu' 		"R" pos:[288,75] width:20 height:20 toolTip:"Créer l'aperçu" align:#left
	button 'ui_btnCreerAperculAuto' "O" pos:[307,75] width:20 height:20 toolTip:"Créer l'aperçu" align:#left
		
	label 'ui_lblDetail' "Détail :" pos:[20,94] width:44 height:17 align:#left
	edittext 'ui_editDetail' "" pos:[126,94] width:138 height:17 align:#left
	
	button 'ui_btnOurvirDetail' "..." pos:[269,74] width:20 height:20 toolTip:"Choisir l'image servant d'aperçu détail à cet asset (200px X 200px)." align:#left
	button 'ui_btnCreerDetail' "R" pos:[288,74] width:20 height:20 toolTip:"Création automatique de l'aperçu détail de cet asset." align:#left
	button 'ui_btnCreerApercuDetailAuto' "O" pos:[307,74] width:20 height:20 toolTip:"Création automatique de l'aperçu détail de cet asset." align:#left
	
	
	label 'ui_lblNotes' "Notes :" pos:[20,189] width:46 height:17 align:#left		
		
	edittext 'ui_editNotes' "" pos:[126,189] width:200 height:56 align:#left
	
	
	label 'ui_lblCreation' "Date de création :" pos:[20,113] width:91 height:17 align:#left
	edittext 'ui_editDateCreation' "" pos:[126,113] width:200 height:17 align:#left readOnly:true
	label 'ui_lblDateDernierImport' "Date dernier import :" pos:[20,132] width:109 height:17 align:#left
	edittext 'ui_editDateDernierImport' "" pos:[126,132] width:200 height:17 align:#left readOnly:true
	
	label 'ui_lblNbreImports' "Nombre d'imports :" pos:[20,151] width:109 height:17 align:#left
	edittext 'ui_editNbreImports' "" pos:[126,151] width:200 height:17 align:#left readOnly:true
	
	label 'ui_lblNbreVertex' "Nombre de points :" pos:[20,170] width:109 height:17 align:#left
	edittext 'ui_editNbreVertex' "" pos:[126,170] width:200 height:17 align:#left readOnly:true
	
	---- le bouton pour fermer la fenetre ----
	ImgTag 'ui_btnFermer' "X" pos:[326,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	
	ImgTag 'ui_titre' "" pos:[128,4] width:66 height:18 align:#left
	
 */
	
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
-- 				ui_editApercu.text 					= 	selectionNoeud.getApercu()
-- 				ui_editDetail.text 					= 	selectionNoeud.getDetail()
				ui_editTags.text 						= 	selectionNoeud.getTags ()
				ui_editNotes.text 					=	selectionNoeud.commentaires
				ui_editDateCreation.text 			=  selectionNoeud.getDateCreation ()
				ui_editDateDernierImport.text 	= 	selectionNoeud.getDateDernierImport ()
				ui_editNbreImports.text 			= 	selectionNoeud.getNbrImports () as string
				ui_editNbreVertex.text 				= 	selectionNoeud.getNbrVertex ()   as string
				
				--- les appercus ------------------------
				local ap_global 	= selectionNoeud.getApercu	()
				local ap_detail_1 = selectionNoeud.getdetail_1	()
				local ap_detail_2 = selectionNoeud.getdetail_2	()
				local ap_detail_3 = selectionNoeud.getdetail_3	()
				
				btn_global.enabled 		= true
				btn_detail_1.enabled 	= true
				btn_detail_2.enabled 	= true
				btn_detail_3.enabled 	= true
				
				-- le tooltip avec l'adresse de l'image --
				btn_global.toolTip 	= "" 
				btn_detail_1.toolTip 	= ""
				btn_detail_2.toolTip 	= ""
				btn_detail_3.toolTip 	= ""
				
				-- on affiche les apercus dans les boutons, ou pas ---
				if ap_global == "" then (
					btn_global.images  = undefined -- GetDir #userScripts + "\cp - Labib\data\img\apVide.jpg"	
					btn_global.toolTip 	= "Créer aperçu global"	
				)	else (
					btn_global.toolTip 	= "Aperçu global : " + ap_global
					btn_global.images 	= #(openBitMap ap_global, undefined, 1,1,1,1,1 )
				)
				
				
				if ap_detail_1 == "" then (
					btn_detail_1.images = undefined -- GetDir #userScripts + "\cp - Labib\data\img\apVide.jpg"		
					btn_detail_1.toolTip 	= "Créer aperçu détail 1"
					btn_detail_2.toolTip 	= ""
					
					-- 
					btn_detail_2.enabled = false
					
				)	else (

					btn_detail_1.toolTip 	= "Aperçu détail 1 : " + ap_detail_1
					btn_detail_1.images 	= #(openBitMap ap_detail_1, undefined, 1,1,1,1,1 )
					btn_detail_2.toolTip 	= "Créer aperçu détail 2"
					
				)
				
				if ap_detail_2 == "" then (
					btn_detail_2.images = undefined -- GetDir #userScripts + "\cp - Labib\data\img\apVide.jpg"		
					
					btn_detail_3.toolTip 	= ""
					
					-- 
					btn_detail_3.enabled = false
					
				)	else (
					btn_detail_2.images 	= #(openBitMap ap_detail_2, undefined, 1,1,1,1,1 )
				)
				
				if ap_detail_3 == "" then (
					btn_detail_3.images = undefined -- GetDir #userScripts + "\cp - Labib\data\img\apVide.jpg"
					btn_detail_3.toolTip 	= "Aperçu détail 3"
				)	else (
					btn_detail_3.images 	= #(openBitMap ap_detail_3, undefined, 1,1,1,1,1 )
				)
				
				
				-- l'appercu en grand -----
				case m_id_apercuAAfficher of (
					0: bmp_Affichage.fileName = ap_global
					1: bmp_Affichage.fileName = ap_detail_1
					2: bmp_Affichage.fileName = ap_detail_2
					3: bmp_Affichage.fileName = ap_detail_3
				)
				
				
			) else (
				
				for ui in m_uis do ui.enabled	= false
				ui_editNom.text 			= selectionNoeud.nom
				ui_lblNom.enabled 		= true
				ui_editNom.enabled 		= true
				
				local listeTags 		= for asset in _assets collect selectionNoeud.getTags()
				ui_editTags.text 		= checkUnite 	listeTags
				ui_lblTags.enabled 	= true
				ui_editTags.enabled 	= true
				
				-- on les affoche dans les boutons ---
				btn_global.images 	= undefined 
				btn_detail_1.images 	= undefined 
				btn_detail_2.images 	= undefined 
				btn_detail_3.images 	= undefined 
				
				btn_global.enabled 		= false
				btn_detail_1.enabled 	= false
				btn_detail_2.enabled 	= false
				btn_detail_3.enabled 	= false
				
				bmp_Affichage.fileName = ""
				
			)
			
		) else (
			
			for ui in m_uis do ui.enabled=false
			
			local listeNoms = for asset in _assets collect asset.nom
			ui_editNom.text = checkUnite 	listeNoms
			ui_lblNom.enabled = true
			ui_editNom.enabled = true
			
			local listeTags = for asset in _assets collect asset.getTags()
			ui_editTags.text = checkUnite 	listeTags
			ui_lblTags.enabled = true
			ui_editTags.enabled = true
			
-- 			ui_btnCreerApercu.enabled = true
-- 			ui_btnCreerDetail.enabled = true
		)
		
	)
	
	
	fn reagencer _taille =(
		
		m_prt.m_taille = _taille
		
		local LargeurBordure = 20
		local LargeurBtn = 20
		local	decalXBtn1 = 34
		local	decalXBtn2 = decalXBtn1 + LargeurBtn
		local	decalXBtn3 = decalXBtn1 + 2* LargeurBtn
		
		ui_editNom.width 					= 	_taille.x - ( ui_editNom.pos.x + LargeurBordure )
		ui_editFichier.width 					= 	_taille.x - ( ui_editNom.pos.x + LargeurBordure + LargeurBtn )
-- 		ui_editApercu.width 					= 	_taille.x - ( LargeurEdit + 3 * LargeurBtn )
-- 		ui_editDetail.width 					= 	_taille.x - ( LargeurEdit + 3 * LargeurBtn )
		ui_editTags.width 					= 	_taille.x - ( ui_editTags.pos.x + LargeurBordure )
		ui_editDateCreation.width 			=  _taille.x - ( ui_editDateCreation.pos.x + LargeurBordure )
		ui_editDateDernierImport.width 	= 	_taille.x - ( ui_editDateDernierImport.pos.x + LargeurBordure )
		ui_editNbreImports.width 			= 	_taille.x - ( ui_editNbreImports.pos.x + LargeurBordure )
		ui_editNbreVertex.width 			= 	_taille.x - ( ui_editNbreVertex.pos.x + LargeurBordure )
		ui_editNotes.width 					=	_taille.x - ( ui_editNotes.pos.x + LargeurBordure )
		ui_editNotes.height 					=	_taille.y - ( ui_editNotes.pos.y + LargeurBordure )
		
		
		ui_btnOuvrirFichierMax.pos.x			=	_taille.x - (  LargeurBordure  + ui_btnFermer.width )		
-- 		ui_btnOurvirApercu.pos.x				=	_taille.x - ( decalXBtn3 )
-- 		ui_btnCreerApercu.pos.x				=	_taille.x - ( decalXBtn2 )
-- 		ui_btnCreerAperculAuto.pos.x			=	_taille.x - ( decalXBtn1 )		
-- 		ui_btnOurvirDetail.pos.x					=	_taille.x - ( decalXBtn3 )
-- 		ui_btnCreerDetail.pos.x					=	_taille.x - ( decalXBtn2 )
-- 		ui_btnCreerApercuDetailAuto.pos.x	=	_taille.x - ( decalXBtn1 )
		
		ui_btnFermer.pos.x						=	_taille.x - ( LargeurBordure )
		
	)
	
	---- Initialisation de la fenetre  -----
	fn initialiser labib: prt: = (
		
		if labib != unsupplied and prt != unsupplied do (
			
			m_labib 	= labib
			m_prt 	= prt
			m_drag 	= str_drag 	m_prt:roll_proprietes		
			
			m_titre 	= str_label 	m_ui:ui_titre			m_texte:m_prt.m_titre
			m_titre.setCouleur 	m_prt.col_fenetreTxt
			
			
			-- le bouton fermer --
			ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
			
			-- creation de la liste des uis ---
			m_uis = #(
				ui_lblNom, ui_editNom, ui_lblFichier, ui_editFichier, ui_btnOuvrirFichierMax, /*ui_lblApercu,  ui_editApercu,  ui_btnOurvirApercu , ui_btnCreerDetail, ui_lblDetail, ui_editDetail, 
				ui_btnOurvirDetail, ui_btnCreerApercu, ui_btnCreerApercuDetailAuto,ui_btnCreerAperculAuto, */ ui_lblTags, ui_editTags, ui_lblNotes, ui_editNotes,
				ui_lblCreation, ui_editDateCreation, ui_lblDateDernierImport, ui_editDateDernierImport , ui_lblNbreImports,
				ui_editNbreImports, ui_lblNbreVertex, ui_editNbreVertex )
			
			reagencer [roll_proprietes.width, roll_proprietes.height]
			
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
	on roll_proprietes moved			_pos 		do	m_prt.m_pos	= _pos
	on roll_proprietes resized			_taille 	do	reagencer 	_taille

	---- Drag ----
	on roll_proprietes lbuttondown _pos 	do
		m_drag.demarrer ()
	on roll_proprietes lbuttonup _pos 	do
		m_drag.arreter ()
	on roll_proprietes mouseMove _pos 	do
		m_drag.suivreSouris ()
	on ui_titre mousedown  do 
		m_drag.demarrer ()
	on ui_titre mouseup   do 
		m_drag.arreter ()
	
	
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
-- 	on ui_editApercu 				entered 	_text do ()
-- 	on ui_btnOurvirApercu 			pressed  do ()
-- 	on ui_btnCreerApercu 			pressed  do m_labib.edit.faireApercus 	( m_labib.edit.getSelection () ) 
-- 	on ui_btnCreerAperculAuto 	pressed  do ()
-- 	on ui_editDetail 					entered 	_text do ()
-- 	on ui_btnOurvirDetail 			pressed  do ()
-- 	on ui_btnCreerDetail 			pressed  do ()
-- 	on ui_btnCreerApercuDetailAuto pressed  do ()
	on ui_editTags 					entered _text do m_labib.cmd.setTags 			(m_labib.edit.getSelection ()) 		_text
	on ui_editNotes 					entered _text do ()
	
	on btn_global rightclick 		do m_labib.menus.apercus ()
	on btn_detail_1 rightclick		do m_labib.menus.apercus ()
	on btn_detail_2 rightclick		do m_labib.menus.apercus ()
	on btn_detail_3 	rightclick 	do m_labib.menus.apercus ()
		
	on btn_global rightclick 		do m_labib.menus.apercus ()
	on btn_detail_1 rightclick		do m_labib.menus.apercus ()
	on btn_detail_2 rightclick		do m_labib.menus.apercus ()
	on btn_detail_3 	rightclick 	do m_labib.menus.apercus ()
	
		
)

------------------------------------------------------------------------------
----------	Structure								 -------------------------
------------------------------------------------------------------------------
struct str_proprietes (
	
		------------  Membres	----------------------------------------------------------------------------------
	public
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_proprietes ,		---- le rollout ----
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Propriétés",
		m_pos 				= [100,100],
		m_taille 				= [800, 400],
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


