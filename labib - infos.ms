
---------------------------------------------------------------------------------------------------------------------------------------------------------
----------	Le rollout des infos  ---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
rollout m_rollInfos "Infos" width:346 height:262
(
	------------  MEMBRES	----------------------------------------------------------------------------------
	local ui_listBtns_infos	= #()
	local prt
	
	-- drag --
	local drg_enCours 				= false
	local drg_posOrigineSouris 	= [0,0]
	local drg_posOrigineFenetre 	= [0,0]
	
	
	------------  UI	----------------------------------------------------------------------------------
	label ui_lblNom "Nom : " pos:[20,20] width:36 height:17
	edittext ui_editNom "" pos:[126,20] width:200 height:17
	
	label ui_lblFichier "Fichier : " pos:[20,38] width:44 height:17
	edittext ui_editFichier "" pos:[126,38] width:181 height:17
	button ui_btnOuvrirFichierMax "..." pos:[307,37] width:20 height:20 toolTip:"Choisir le fichier .max de référence de cet asset."
	
	label ui_lblApercu "Aperçu :" pos:[20,56] width:44 height:17
	edittext ui_editApercu "" pos:[126,56] width:138 height:17
	button ui_btnOurvirApercu "..." pos:[267,55] width:20 height:20 toolTip:"Choisir l'image servant d'aperçu à cet asset (200px X 200px)."
	button ui_btnCreerDetail "R" pos:[289,74] width:20 height:20 toolTip:"Création automatique de l'aperçu détail de cet asset."
		
	label ui_lblDetail "Détail :" pos:[20,75] width:44 height:17
	edittext ui_editDetail "" pos:[126,75] width:138 height:17
	button ui_btnOurvirDetail "..." pos:[267,74] width:20 height:20 toolTip:"Choisir l'image servant d'aperçu détail à cet asset (200px X 200px)."
	button ui_btnCreerApercu "R" pos:[289,55] width:20 height:20 toolTip:"Créer l'aperçu"
	
	label ui_lblTags "Mots clés :" pos:[20,94] width:53 height:17
	edittext ui_editTags "" pos:[126,94] width:200 height:17
	
	label ui_lblNotes "Notes :" pos:[20,113] width:46 height:17	
	
	edittext ui_editNotes "" pos:[126,113] width:200 height:56
	button btn6 "O" pos:[306,74] width:20 height:20 toolTip:"Création automatique de l'aperçu détail de cet asset."
	button btn7 "O" pos:[306,55] width:20 height:20 toolTip:"Créer l'aperçu"
	label lbl_creation "Date de création :" pos:[20,171] width:91 height:17
	edittext edt9 "" pos:[126,171] width:200 height:17
	label lbl10 "Date dernier import :" pos:[20,190] width:109 height:17
	edittext edt10 "" pos:[126,190] width:200 height:17
	label lbl11 "Nombre d'imports :" pos:[20,209] width:109 height:17
	edittext edt11 "" pos:[126,209] width:200 height:17
	label lbl12 "Nombre de points :" pos:[20,228] width:109 height:17
	edittext edt12 "" pos:[126,228] width:200 height:17
	
	-- le bouton pour fermer la fenetre --
	ImgTag ui_btnFermer "X" pos:[326,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center
	
	------------  FONCTION	----------------------------------------------------------------------------------
	fn sourisClique 		pos 	=(
		debug "clique"
		-- drag --
		drg_enCours 				= true
		drg_posOrigineSouris		= mouse.screenpos 
		drg_posOrigineFenetre 	= GetDialogPos 	m_rollInfos
	)
	fn sourisRelache 		pos  	=(
		drg_enCours 				= false
	)
	fn sourisSeDeplace 	pos  	=(
		if drg_enCours  do (			
			local ecart = ( mouse.screenpos  - drg_posOrigineSouris )
			SetDialogPos  m_rollInfos	( drg_posOrigineFenetre + ecart )
		)
	)
	
	
	
	
	fn initialiser = (
		ui_btnFermer.bitmap = openBitMap prt.prefs.fenetre.ico_btnFermer_R
	)
	
	
	------------  EVENEMENTS	----------------------------------------------------------------------------------
-- 	on m_rollInfos rbuttondown  	pos 	do menu.fenetre ()
	
	on m_rollInfos lbuttondown pos 	do
		sourisClique 		pos
	on m_rollInfos lbuttonup pos 	do
		sourisRelache 		pos
	on m_rollInfos mouseMove pos 	do
		sourisSeDeplace 	pos
	
	
	
	on 	ui_btnFermer 	click 			do prt.fenetre.infos.fermer()
	
	
)


struct infos_struct (
	prt,
	dialog = m_rollInfos,
	
	fn ouvrir =(
		prt.prefs.fenetre.infos = true
		createDialog dialog 	bgcolor:				prt.prefs.fenetre.col_fenetreFond 	 \
									fgcolor:				prt.prefs.fenetre.col_fenetreFore 	\
									style:				#(#style_resizing) \
									lockHeight:			true	\
									lockWidth:			true										
-- 									pos:					pos \
		
		
		dialog.prt = prt
		dialog.initialiser ()
	),
	fn fermer = (
		prt.prefs.fenetre.infos = false
		try destroydialog dialog catch ()
	)
	
)



