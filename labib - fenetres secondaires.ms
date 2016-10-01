



---------------------------------------------------------------------------------------------------------------------------------------------------------
----------	Le rollout des infos  ---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
rollout m_rollInfos "Infos" width:346 height:262
(
	------------  MEMBRES	----------------------------------------------------------------------------------
	local prt
	local prefs
	
	-- drag --
	local drag
	
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
	fn initialiser = (
		ui_btnFermer.bitmap = openBitMap prt.prefs.fenetre.ico_btnFermer_R
	)
	
	
	------------  EVENEMENTS	----------------------------------------------------------------------------------
	on m_rollInfos moved			pos 	do	prt.prefs.fenetre.posInfos	= pos
	---- le drag ----
	on m_rollInfos lbuttondown	pos 	do	drag.demarrer ()
	on m_rollInfos lbuttonup 		pos 	do	drag.arreter ()
	on m_rollInfos mouseMove 	pos 	do	drag.suivreSouris ()
	
	---- bouton fermer -----
	on 	ui_btnFermer	mouseover 	do ui_btnFermer.bitmap = openBitmap prefs.fenetre.ico_btnFermer_S
	on 	ui_btnFermer	mouseout 	do ui_btnFermer.bitmap = openBitmap prefs.fenetre.ico_btnFermer_R
	on 	ui_btnFermer	mousedown do ui_btnFermer.bitmap = openBitmap prefs.fenetre.ico_btnFermer_P
	on 	ui_btnFermer	mouseup	do ui_btnFermer.bitmap = openBitmap prefs.fenetre.ico_btnFermer_S
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
									lockWidth:			true	\									
									pos:					prt.prefs.fenetre.posInfos	
		
		dialog.drag 	= drag_struct fenetre:dialog
		dialog.prefs = prt.prefs
		dialog.prt 	= prt
		
		dialog.initialiser ()
	),
	fn fermer  silence:false = (
		if not silence do (
			prt.prefs.fenetre.infos = false
			prt.prefs.fenetre.posInfos	= getdialogpos dialog
		)
		try destroydialog dialog catch ()
	)
	
)



---------------------------------------------------------------------------------------------------------------------------------------------------------
----------	Le rollout des infos  ---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
rollout rollApercu  "Aperçu" width:296 height:296
(
	------------  MEMBRES	----------------------------------------------------------------------------------
	local prt
	local prefs
	
	-- drag --
	local drag
	
	------------  UI	----------------------------------------------------------------------------------	
	imgTag 	ui_vue "" pos:[20,20] width:256  height:256 
	
	-- le bouton pour fermer la fenetre --
	ImgTag ui_btnFermer "X" pos:[276,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center
	
	------------  FONCTION	----------------------------------------------------------------------------------
	fn initialiser = (
		ui_btnFermer.bitmap = openBitMap prt.prefs.fenetre.ico_btnFermer_R
		ui_vue.bitmap 			= openBitMap prt.prefs.fenetre.apercuVide
	)
	
	------------  EVENEMENTS	----------------------------------------------------------------------------------
	
	on rollApercu moved			pos 	do	prt.prefs.fenetre.posApercu	= pos
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
	on 	ui_btnFermer 	click 			do prt.fenetre.apercu.fermer()
	
)

struct apercu_struct (
	prt,
	dialog = rollApercu ,
	
	fn ouvrir =(
		prt.prefs.fenetre.apercu = true
		
		createDialog dialog 	bgcolor:				prt.prefs.fenetre.col_fenetreFond 	 \
									fgcolor:				prt.prefs.fenetre.col_fenetreFore 	\
									style:				#(#style_resizing) \
									lockHeight:			true	\
									lockWidth:			true	\									
									pos:					prt.prefs.fenetre.posApercu	
		
		dialog.drag 	= drag_struct fenetre:dialog
		dialog.prefs = prt.prefs
		dialog.prt 	= prt
		
		dialog.initialiser ()
	),
	fn fermer  silence:false = (
		if not silence do (
			prt.prefs.fenetre.apercu = false
			prt.prefs.fenetre.posApercu	= getdialogpos dialog
		)
		try destroydialog dialog catch ()
	)
	
)



---------------------------------------------------------------------------------------------------------------------------------------------------------
----------	Le rollout des rendus  ---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
rollout rollRendu  "Rendu" width:804 height:294
(
	------------  MEMBRES	----------------------------------------------------------------------------------
	local prt
	local prefs
	
	-- drag --
	local drag
	
	------------  UI	----------------------------------------------------------------------------------	
	
	checkbutton ckb_apercus "Aperçu" pos:[18,17] width:55 height:55
	checkbutton ckb_detail "Detail" pos:[76,17] width:55 height:55
	button btn_rendre "Rendre" pos:[302,17] width:206 height:55 toolTip:""
	button btn_ouvrir "Ouvrir" pos:[161,45] width:138 height:25
	button btn_defaut "Defaut" pos:[161,17] width:138 height:25
	
	imgtag	 bmp_ap "" pos:[531,17] width:255 height:255
	
	spinner spn_angleVue "" pos:[141,100] width:100 height:16 range:[0,1000,0]
	label lbl_angleVue "Angle de vue:" pos:[26,100] width:113 height:18
	spinner spn_posX "" pos:[141,128] width:100 height:16 range:[-100000,100000,0]
	label lbl_posX "X:" pos:[111,128] width:25 height:18
	label lbl_pos "Translation : " pos:[26,128] width:79 height:18
	spinner spn_posY "" pos:[141,149] width:100 height:16 range:[-100000,100000,0]
	label lbl_posY "Y:" pos:[111,149] width:25 height:18
	spinner spn_posZ "" pos:[141,170] width:100 height:16 range:[-100000,100000,0]
	label lbl_posZ "Z:" pos:[111,170] width:25 height:18
	label lbl7 "Rotation:" pos:[26,203] width:79 height:18
	spinner spn_rotY "" pos:[141,203] width:50 height:16 range:[-360,360,0]
	label lbl_rotY "Vertic." pos:[95,203] width:35 height:18
	spinner spn_rotZ "" pos:[141,224] width:50 height:16 range:[-360,360,0]
	label lbl_rotZ "Horiz." pos:[95,224] width:35 height:18
	GroupBox grp_cam "Camera" pos:[18,79] width:248 height:193
	spinner spn_expo "" pos:[404,100] width:100 height:16 range:[-1000,1000,0]
	label lbl10_expo "Exposition:" pos:[289,100] width:113 height:18
	spinner spn_highLight "" pos:[404,122] width:100 height:16 range:[-100000,100000,0]
	label lbl_HLComp "Hightlight comp.:" pos:[289,120] width:104 height:18
	spinner spn_whiteBalance "" pos:[404,142] width:100 height:16 range:[-100000,100000,0]
	label lbl13 "White balance:" pos:[289,143] width:100 height:18
	spinner spn_contraste "" pos:[404,164] width:100 height:16 range:[-100000,100000,0]
	label lbl_contrast "Contrast:" pos:[289,163] width:107 height:18
	GroupBox grp_postEffect "Post traitement" pos:[270,79] width:248 height:111
	spinner spn_noiseLevel "" pos:[404,219] width:100 height:16 range:[-1000,1000,0]
	label lbl_noiseLevel "Noise level limit:" pos:[289,220] width:113 height:18
	spinner spn_denoiseAmount "" pos:[404,242] width:100 height:16 range:[-100000,100000,0]
	label lbl_denoiseAmount "Denoise amount" pos:[289,240] width:104 height:18
	GroupBox grp_denoise "Denoise" pos:[270,199] width:248 height:73

	button btn_rotZ_m45 "-45°" pos:[194,224] width:30 height:20
	button btn_rotZ_p45 "+45°" pos:[226,224] width:30 height:20
	
	
	-- le bouton pour fermer la fenetre --
	ImgTag ui_btnFermer "X" pos:[784,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center
	
	------------  FONCTION	----------------------------------------------------------------------------------
	fn initialiser = (
		ui_btnFermer.bitmap = openBitMap prt.prefs.fenetre.ico_btnFermer_R
		
		bmp_ap.bitmap 			= openBitMap prt.prefs.fenetre.apercuVide
	)
	
	
	------------  EVENEMENTS	----------------------------------------------------------------------------------
	
	on rollRendu moved			pos 	do	prt.prefs.fenetre.posRendu	= pos
	-- drag --
	on rollRendu lbuttondown	pos 	do	drag.demarrer ()
	on rollRendu lbuttonup 		pos 	do	drag.arreter ()
	on rollRendu mouseMove 	pos 	do	drag.suivreSouris ()
	
	---- bouton fermer -----
	-- comportement --
	on 	ui_btnFermer	mouseover 		do ui_btnFermer.bitmap = openBitmap prefs.fenetre.ico_btnFermer_S
	on 	ui_btnFermer	mouseout 		do ui_btnFermer.bitmap = openBitmap prefs.fenetre.ico_btnFermer_R
	on 	ui_btnFermer	mousedown 	do ui_btnFermer.bitmap = openBitmap prefs.fenetre.ico_btnFermer_P
	on 	ui_btnFermer	mouseup		do ui_btnFermer.bitmap = openBitmap prefs.fenetre.ico_btnFermer_S
	-- action --
	on 	ui_btnFermer 	click 			do prt.fenetre.rendu.fermer()
	
)

struct rendu_struct (
	prt,
	dialog = rollRendu ,
	
	fn ouvrir =(
		prt.prefs.fenetre.rendu = true
		
		createDialog dialog 	bgcolor:				prt.prefs.fenetre.col_fenetreFond 	 \
									fgcolor:				prt.prefs.fenetre.col_fenetreFore 	\
									style:				#(#style_resizing) \
									lockHeight:			true	\
									lockWidth:			true	\									
									pos:					prt.prefs.fenetre.posRendu 
		
		dialog.drag 	= drag_struct fenetre:dialog
		dialog.prefs = prt.prefs
		dialog.prt 	= prt
		
		dialog.initialiser ()
	),
	fn fermer  silence:false = (
		if not silence do (
			prt.prefs.fenetre.rendu = false
			prt.prefs.fenetre.posRendu	= getdialogpos dialog
		)
		try destroydialog dialog catch ()
	)
	
	
)



