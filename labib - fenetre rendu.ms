/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	Fenetre rendu pour gerer la cam, luz..; des rendus des appercus auto
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [09/05/2017] -----------------------------------------------------------------------------
	- Mise en place globale 
########################################################################################################################*/


------------------------------------------------------------------------------
----------	Fenetre								 -------------------------
------------------------------------------------------------------------------
rollout roll_rendu  "rendu" width:143 height:108
(
	------------  Membres	----------------------------------------------------------------------------------
	---- Pointeurs ----
	local m_prt				---- pointeur vers la structure de controle ----
	local m_prefs			---- pointeur vers les preferences "Fenetre"de labib ----
	
	---- Structures ----
	local m_drag			---- la structure gerant le drag de la fenetre ----
	
	--- ctro des imgtags ---
	local m_titre
	
	------------  UI	----------------------------------------------------------------------------------		
	ImgTag 'ui_titre' "" pos:[5,4] width:66 height:18 align:#left
	
	---- le bouton pour fermer la fenetre ----
	ImgTag 'ui_btnFermer' "X" pos:[107,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	spinner 'btn_spn_angleX' "Rotation X" pos:[8,34] width:71 height:16 range:[-180,180,0] align:#left
	
	spinner 'btn_spn_angleY' "Rotation Y" pos:[8,54] width:71 height:16 range:[-1000,1000,0] align:#left
	spinner 'btn_spn_distanceZ' "Distance Z" pos:[8,74] width:69 height:16 range:[-180,180,0] align:#left
	
	------------  Fonctions	----------------------------------------------------------------------------------
	---- Gere l'état du bouton  -----
	fn etatBtnFermer		_etat =(
		case _etat of (
			#Repos : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]
			#Survol : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[2]
			#Press : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[3]
		)
	)
	
	---- Initialisation de la fenetre  -----
	fn initialiser  ptr_Labib= (
		
		-- se raccrocher à labib --
		m_prt = ptr_Labib
		
		-- le titre --
		m_titre 	= str_label 	m_ui:ui_titre			m_texte:m_prt.m_titre
		m_titre.setCouleur 	m_prt.col_fenetreTxt
		
		-- le drag --
		m_drag 		= str_drag 	m_prt:roll_rendu
		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
		
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	on roll_rendu moved			_pos 	do	m_prt.m_pos	= _pos	
	
	---- Drag ----
	on roll_rendu lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_rendu lbuttonup 	_pos 	do	m_drag.arreter ()
	on roll_rendu mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
	---- Bouton fermer -----
	on 	ui_btnFermer	mouseover 				do 	etatBtnFermer #Survol
	on 	ui_btnFermer	mouseout 				do 	etatBtnFermer #Repos
	on 	ui_btnFermer	mousedown 			do 	etatBtnFermer #Press
	on 	ui_btnFermer	mouseup				do 	etatBtnFermer #Repos
	on 	ui_btnFermer 	click 						do 	m_prt.fermer ()
	
	
	on btn_spn_angleX changed val do	m_prt.changeRotationX val
	on btn_spn_angleY changed val do m_prt.changeRotationY val	
	on btn_spn_distanceZ changed val do	 m_prt.changeDistanceZ val
	
)

------------------------------------------------------------------------------
----------	Structure								 -------------------------
------------------------------------------------------------------------------
struct str_rendu (
	
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_rendu ,		---- le rollout ----
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Rendu",
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
								
								
								
								
								
								
		fn changeRotationX val =(
			m_labib.apercus.m_rotateCam_X = val
		),
		fn changeRotationY val =(
			m_labib.apercus.m_rotateCam_Y = val
		),
		fn changeDictanceZ val =(
			m_labib.apercus.m_distanceDecallage = val
		),
		
		
		
		fn estOuvert = m_estOuvert,
		fn ouvrir =(			
			
			m_estOuvert 		= true
			
			---- creation de la fenetre ----
			createDialog m_dialog 	bgcolor:				col_fenetreFond	 	\
											fgcolor:				col_fenetreTxt 		\
											style:				#(#style_resizing) 	\
											lockHeight:			true	\
											lockWidth:			true	 \							
											pos:					m_pos	  
			
			---- initialisation de la fenetre ----
			m_dialog.initialiser this
	
		),
		

		fn fermer  enregistrer:true =(
			
			if enregistrer do
				m_estOuvert = false
			
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




/* 
---------------------------------------------------------------------------------------------------------------------------------------------------------
----------	Le rollout des rendus  ---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
rollout roll_rendu "Rendu" width:377 height:206
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
	
	on roll_rendu moved pos 	do
		m_labib.prefs.fenetre.posRendu	= pos
	on roll_rendu lbuttondown pos 	do
		drag.demarrer ()
	on roll_rendu lbuttonup pos 	do
		drag.arreter ()
	on roll_rendu mouseMove pos 	do
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



struct str_rendu (
	m_labib,
	m_dialog = roll_rendu ,
	
	---- props de la fenetre -----
	m_titre 				= "Labib | Rendu",
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
	
	fn ouvrir =(
		
		m_estOuvert = true
		
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
		
		m_estOuvert = false
		
		if not silence do (
			m_labib.prefs.fenetre.rendu = false
			m_labib.prefs.fenetre.posRendu	= getDialogPos m_dialog
		)
		try destroyDialog m_dialog catch ()
	),	
	fn toggleOuverture =(
		
		if m_estOuvert
			then fermer ()
			else	ouvrir ()
		
	)
)
 */