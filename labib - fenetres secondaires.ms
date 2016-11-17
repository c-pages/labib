




---------------------------------------------------------------------------------------------------------------------------------------------------------
----------	Le rollout des infos  ---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
rollout m_rollInfos "Infos" width:346 height:262
(
	------------  MEMBRES	----------------------------------------------------------------------------------
	local m_labib
	local m_prefs
	
	-- drag --
	local m_drag
	
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
	fn initialiser labib:		= (
		if labib != unsupplied do (
			m_labib 	= labib
			m_prefs 	= m_labib.prefs.fenetre
			m_drag 	= str_drag 	m_prt:m_rollInfos
		
			ui_btnFermer.bitmap = openBitMap m_labib.prefs.fenetre.ico_btnFermer_R
			
		)
	)
	
	
	------------  EVENEMENTS	----------------------------------------------------------------------------------
	on m_rollInfos moved			pos 	do	m_prefs.fenInfos_pos	= pos
	---- le drag ----
	on m_rollInfos lbuttondown	pos 	do	m_drag.demarrer ()
	on m_rollInfos lbuttonup 		pos 	do	m_drag.arreter ()
	on m_rollInfos mouseMove 	pos 	do	m_drag.suivreSouris ()
	
	---- bouton fermer -----
	on 	ui_btnFermer	mouseover 	do ui_btnFermer.bitmap = openBitmap m_prefs.ico_btnFermer_S
	on 	ui_btnFermer	mouseout 	do ui_btnFermer.bitmap = openBitmap m_prefs.ico_btnFermer_R
	on 	ui_btnFermer	mousedown do ui_btnFermer.bitmap = openBitmap m_prefs.ico_btnFermer_P
	on 	ui_btnFermer	mouseup	do ui_btnFermer.bitmap = openBitmap m_prefs.ico_btnFermer_S
	on 	ui_btnFermer 	click 			do m_labib.fenetre.infos.fermer()
	
)

struct infos_struct (
	m_labib,
	m_dialog = m_rollInfos,
	
	fn ouvrir =(
		m_labib.prefs.fenetre.fenInfos_estOuvert = true
		
		createDialog m_dialog 		bgcolor:				m_labib.prefs.fenetre.col_fenetreFond 	 \
											fgcolor:				m_labib.prefs.fenetre.col_fenetreTxt 	\
											style:				#(#style_resizing) \
											lockHeight:			true	\
											lockWidth:			true	\									
											pos:					m_labib.prefs.fenetre.fenInfos_pos	
		

		m_dialog.initialiser labib:m_labib
	),
	fn fermer  silence:false = (
		if not silence do (
			m_labib.prefs.fenetre.fenInfos_estOuvert = false
			m_labib.prefs.fenetre.fenInfos_pos	= getDialogPos m_dialog
		)
		try destroyDialog m_dialog catch ()
	)
	
)
 
 
/* 
---------------------------------------------------------------------------------------------------------------------------------------------------------
----------	Le rollout des infos  ---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
rollout rollApercu  "Aperçu" width:296 height:296
(
	------------  MEMBRES	----------------------------------------------------------------------------------
	local m_labib
	local prefs
	
	-- drag --
	local drag
	
	------------  UI	----------------------------------------------------------------------------------	
	imgTag 	ui_vue "" pos:[20,20] width:256  height:256 
	
	-- le bouton pour fermer la fenetre --
	ImgTag ui_btnFermer "X" pos:[276,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center
	
	------------  FONCTION	----------------------------------------------------------------------------------
	fn initialiser = (
		ui_btnFermer.bitmap = openBitMap m_labib.prefs.fenetre.ico_btnFermer_R
		ui_vue.bitmap 			= openBitMap m_labib.prefs.fenetre.apercuVide
	)
	
	------------  EVENEMENTS	----------------------------------------------------------------------------------
	
	on rollApercu moved			pos 	do	m_labib.prefs.fenetre.posApercu	= pos
	-- drag --
	on rollApercu lbuttondown	pos 	do	drag.demarrer ()
	on rollApercu lbuttonup 	pos 	do	drag.arreter ()
	on rollApercu mouseMove 	pos 	do	drag.suivreSouris ()
	
	---- bouton fermer -----
	-- comportement --
	on 	ui_btnFermer	mouseover 		do ui_btnFermer.bitmap = openBitmap prefs.fenetre.ico_btnFermer_S
	on 	ui_btnFermer	mouseout 		do ui_btnFermer.bitmap = openBitmap prefs.fenetre.ico_btnFermer_R
	on 	ui_btnFermer	mousedown 	do ui_btnFermer.bitmap = openBitmap prefs.fenetre.ico_btnFermer_P
	on 	ui_btnFermer	mouseup		do ui_btnFermer.bitmap = openBitmap prefs.fenetre.ico_btnFermer_S
	-- action --
	on 	ui_btnFermer 	click 			do m_labib.fenetre.apercu.fermer()
	
)

struct apercu_struct (
	m_labib,
	m_dialog = rollApercu ,
	
	fn ouvrir =(
		m_labib.prefs.fenetre.apercu = true
		
		createDialog m_dialog 	bgcolor:				m_labib.prefs.fenetre.col_fenetreFond 	 \
									fgcolor:				m_labib.prefs.fenetre.col_fenetreFore 	\
									style:				#(#style_resizing) \
									lockHeight:			true	\
									lockWidth:			true	\									
									pos:					m_labib.prefs.fenetre.posApercu	
		
		m_dialog.drag 	= drag_struct fenetre:m_dialog
		m_dialog.prefs = m_labib.prefs
		m_dialog.m_labib 	= m_labib
		
		m_dialog.initialiser ()
	),
	fn fermer  silence:false = (
		if not silence do (
			m_labib.prefs.fenetre.apercu = false
			m_labib.prefs.fenetre.posApercu	= getDialogPos m_dialog
		)
		try destroyDialog m_dialog catch ()
	)
	
)



---------------------------------------------------------------------------------------------------------------------------------------------------------
----------	Le rollout des rendus  ---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
rollout rollRendu "Rendu" width:377 height:206
(
	------------  MEMBRES	----------------------------------------------------------------------------------
	local m_labib
	local prefs
	
	-- drag --
	local drag
	
	------------  UI	----------------------------------------------------------------------------------	
	
	checkbutton ckb_apercus "Aperçu" pos:[191,164] width:40 height:22
	checkbutton ckb_detail "Detail" pos:[234,164] width:40 height:22
	button btn_rendre "Rendre" pos:[276,164] width:79 height:22 toolTip:""
	
	
	spinner spn_angleVue "" pos:[120,35] width:50 height:16 range:[0,1000,0]
	label lbl_angleVue "Angle de vue:" pos:[28,35] width:71 height:18
	spinner spn_posX "" pos:[120,55] width:50 height:16 range:[-100000,100000,0]
	label lbl_posX "X:" pos:[102,55] width:14 height:18
	label lbl_pos "Translation : " pos:[28,55] width:65 height:18
	spinner spn_posY "" pos:[120,75] width:50 height:16 range:[-100000,100000,0]
	label lbl_posY "Y:" pos:[102,75] width:14 height:18
	spinner spn_posZ "" pos:[120,95] width:50 height:16 range:[-100000,100000,0]
	label lbl_posZ "Z:" pos:[102,95] width:11 height:18
	label lbl7 "Rotation:" pos:[28,113] width:51 height:18
	spinner spn_rotY "" pos:[120,114] width:50 height:16 range:[-360,360,0]
	label lbl_rotY "Vertic." pos:[86,113] width:34 height:18
	spinner spn_rotZ "" pos:[120,134] width:50 height:16 range:[-360,360,0]
	label lbl_rotZ "Horiz." pos:[86,134] width:30 height:18
	GroupBox grp_cam "Camera" pos:[19,14] width:166 height:172
	spinner spn_expo "" pos:[292,35] width:50 height:16 range:[-1000,1000,0]
	label lbl10_expo "Exposition:" pos:[200,35] width:59 height:18
	spinner spn_highLight "" pos:[292,54] width:50 height:16 range:[-100000,100000,0]
	label lbl_HLComp "Hightlight comp.:" pos:[200,54] width:83 height:18
	spinner spn_whiteBalance "" pos:[292,73] width:50 height:16 range:[-100000,100000,0]
	label lbl13 "White balance:" pos:[200,73] width:74 height:18
	spinner spn_contraste "" pos:[292,92] width:50 height:16 range:[-100000,100000,0]
	label lbl_contrast "Contrast:" pos:[200,92] width:54 height:18
	GroupBox grp_postEffect "Post traitement" pos:[191,14] width:166 height:144
	spinner spn_noiseLevel "" pos:[292,111] width:50 height:16 range:[-1000,1000,0]
	label lbl_noiseLevel "Noise level limit:" pos:[200,111] width:77 height:18
	spinner spn_denoiseAmount "" pos:[292,130] width:50 height:16 range:[-100000,100000,0]
	label lbl_denoiseAmount "Denoise amount" pos:[200,130] width:79 height:18

	button btn_rotZ_m45 "-45°" pos:[113,156] width:27 height:17
	button btn_rotZ_p45 "+45°" pos:[141,156] width:27 height:17
	
	
	-- le bouton pour fermer la fenetre --
	ImgTag ui_btnFermer "X" pos:[357,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center
	
	------------  FONCTION	----------------------------------------------------------------------------------
	fn initialiser = (
		ui_btnFermer.bitmap = openBitMap m_labib.prefs.fenetre.ico_btnFermer_R
		
	)
	
	
	------------  EVENEMENTS	----------------------------------------------------------------------------------
	
	-- drag --
	
	---- bouton fermer -----
	-- comportement --
	-- action --
	
	on rollRendu moved pos 	do
		m_labib.prefs.fenetre.posRendu	= pos
	on rollRendu lbuttondown pos 	do
		drag.demarrer ()
	on rollRendu lbuttonup pos 	do
		drag.arreter ()
	on rollRendu mouseMove pos 	do
		drag.suivreSouris ()
	on ui_btnFermer mouseover do
		ui_btnFermer.bitmap = openBitmap prefs.fenetre.ico_btnFermer_S
	on ui_btnFermer mouseout do
		ui_btnFermer.bitmap = openBitmap prefs.fenetre.ico_btnFermer_R
	on ui_btnFermer mouseDown do
		ui_btnFermer.bitmap = openBitmap prefs.fenetre.ico_btnFermer_P
	on ui_btnFermer mouseUp do
		ui_btnFermer.bitmap = openBitmap prefs.fenetre.ico_btnFermer_S
	on ui_btnFermer click do
		m_labib.fenetre.rendu.fermer()
)



struct rendu_struct (
	m_labib,
	m_dialog = rollRendu ,
	
	fn ouvrir =(
		m_labib.prefs.fenetre.rendu = true
		
		createDialog m_dialog 	bgcolor:			m_labib.prefs.fenetre.col_fenetreFond 	 \
									fgcolor:				m_labib.prefs.fenetre.col_fenetreFore 	\
									style:				#(#style_resizing) \
									lockHeight:			true	\
									lockWidth:			true	\									
									pos:					m_labib.prefs.fenetre.posRendu 
		
		m_dialog.drag 		= drag_struct 	fenetre:m_dialog
		m_dialog.prefs 	= m_labib.prefs
		m_dialog.m_labib 	= m_labib
		
		m_dialog.initialiser ()
	),
	fn fermer  silence:false = (
		if not silence do (
			m_labib.prefs.fenetre.rendu = false
			m_labib.prefs.fenetre.posRendu	= getDialogPos m_dialog
		)
		try destroyDialog m_dialog catch ()
	)
	
	
)


 */
