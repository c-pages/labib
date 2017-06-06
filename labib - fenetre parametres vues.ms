/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	

##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [02/10/2016] -----------------------------------------------------------------------------
	- Mise en place globale ( mise au propre du travail durant l'été)
	- Une interface souple et simple
########################################################################################################################*/
-- destroydialog roll_paramRendu catch ()

rollout roll_param_qualite  "Qualité"	width:156 height:152
(
	label 'lbl_nom' "Nom :" pos:[11,1] width:44 height:16 align:#left
	edittext 'edt_nom' "" pos:[38,1] width:131 height:17 align:#left
	button 'btn_sauvegarderSous' "+" pos:[171,1] width:17 height:17 toolTip:"Sauvegarder sous" align:#left
	
	spinner 'ddl1' "" pos:[125,34] width:60 height:16 items:#("Face") align:#left
	label 'lbl14' "Denoise Amount :" pos:[10,37] width:89 height:16 align:#left
	spinner 'ddl3' "" pos:[125,49] width:60 height:16 align:#left
	label 'lbl17' "Pass limit :" pos:[10,52] width:53 height:16 align:#left
	
	spinner 'ddl4' "" pos:[125,19] width:60 height:16 items:#("Rapide", "Super beau") align:#left
	label 'lbl_corona' "Noise level limit :" pos:[10,22] width:81 height:16 align:#left
	
	spinner 'spn4' "" pos:[131,81] width:45 height:16 range:[0,100,0] align:#left
	label 'lbl5' "Time limit :" pos:[10,67] width:50 height:16 align:#left
	label 'lbl11' "h" pos:[66,81] width:10 height:16 align:#left
	spinner 'spn9' "" pos:[74,81] width:45 height:16 range:[0,100,0] align:#left
	label 'lbl12' "m" pos:[120,81] width:10 height:16 align:#left
	spinner 'spn10' "" pos:[20,81] width:45 height:16 range:[0,100,0] align:#left
	label 'lbl13' "s" pos:[178,81] width:10 height:16 align:#left


)

rollout roll_param_studio "Prises de vues" width:487 height:300
(
	
	---- le bouton pour fermer la fenetre ----
	
	label 'lbl45' "Nom du studio :" pos:[10,0] width:84 height:16 align:#left
	edittext 'edt_nom' "" pos:[86,0] width:100 height:17 align:#left
	
	checkbutton 'btn_edit_effects' "-" pos:[187,32] width:17 height:17 toolTip:"Editer paramètre de rendu" align:#left
	
	
	listbox 'lbx1' "" pos:[10,17] width:176 height:5 align:#left
 
 
 
	checkbutton 'ckb6' "+" pos:[187,16] width:17 height:17 toolTip:"Editer paramètre de rendu" align:#left
	
	
	
)



------------------------------------------------------------------------------
----------	RENDU								 -------------------------
------------------------------------------------------------------------------
rollout roll_paramRendu "Rendu" width:209 height:136
(
	------------  Membres	----------------------------------------------------------------------------------
		
		
											
	---- Pointeurs ----
	local m_prt				---- pointeur vers la structure de controle ----
	local m_prefs			---- pointeur vers les preferences "Fenetre"de labib ----
	------------  UI	----------------------------------------------------------------------------------		
	label 'lbl_nom' "Nom :" pos:[11,1] width:44 height:16 align:#left
	edittext 'edt_nom' "" pos:[38,1] width:131 height:17 align:#left
	button 'btn_sauvegarderSous' "+" pos:[171,1] width:17 height:17 toolTip:"Sauvegarder sous" align:#left
	
	spinner 'ddl1' "" pos:[125,45] width:60 height:16 items:#("Face") align:#left
	label 'lbl14' "Denoise Amount :" pos:[10,48] width:89 height:16 align:#left
	spinner 'ddl3' "" pos:[125,60] width:60 height:16 align:#left
	label 'lbl17' "Pass limit :" pos:[10,63] width:53 height:16 align:#left
	
	spinner 'ddl4' "" pos:[125,30] width:60 height:16 items:#("Rapide", "Super beau") align:#left
	label 'lbl_corona' "Noise level limit :" pos:[10,33] width:81 height:16 align:#left
	
	spinner 'spn4' "" pos:[131,92] width:45 height:16 range:[0,100,0] align:#left
	label 'lbl5' "Time limit :" pos:[10,78] width:50 height:16 align:#left
	label 'lbl11' "h" pos:[66,92] width:10 height:16 align:#left
	spinner 'spn9' "" pos:[74,92] width:45 height:16 range:[0,100,0] align:#left
	label 'lbl12' "m" pos:[120,92] width:10 height:16 align:#left
	spinner 'spn10' "" pos:[20,92] width:45 height:16 range:[0,100,0] align:#left
	label 'lbl13' "s" pos:[178,92] width:10 height:16 align:#left
 
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
		
		
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	on roll_paramRendu moved			_pos 	do	m_prt.m_pos	= _pos	
		
	---- Drag ----
	on roll_paramRendu lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_paramRendu lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_paramRendu mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
	---- Bouton fermer -----
	on 	ui_btnFermer	mouseover 				do 	etatBtnFermer #Survol
	on 	ui_btnFermer	mouseout 				do 	etatBtnFermer #Repos
	on 	ui_btnFermer	mousedown 			do 	etatBtnFermer #Press
	on 	ui_btnFermer	mouseup				do 	etatBtnFermer #Repos
	on 	ui_btnFermer 	click 						do 	m_prt.fermer ()
	
)


-- createdialog roll_paramRendu
------------------------------------------------------------------------------
struct str_paramRendu (
	
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_paramRendu ,		---- le rollout ----
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Paramètres de rendu" ,
		m_pos 				= [100,100],
		m_taille 				= [209,172],
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
		fn ouvrir pos: =(			
			
			if pos != unsupplied do m_pos = pos			
			m_estOuvert 		= true
			
			---- creation de la fenetre ----
			createDialog m_dialog 	fgcolor:				col_fenetreTxt 	\
											style:				#(#style_resizing) \
											lockHeight:			true	\
											lockWidth:			true	 \			
											width:m_taille.x \
											height:m_taille.y \
											pos:					m_pos	
			
			---- initialisation de la fenetre ----
			m_dialog.initialiser this
	
		),
		
		fn fermer  silence:false =(		---- silence : fermer sans modifier l'état des preferences ---
			
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
			
		)
		
		------------  Evenements	----------------------------------------------------------------------------------
	
)


------------------------------------------------------------------------------
----------	paramCamera								 -------------------------
------------------------------------------------------------------------------
rollout roll_paramCamera "Camera" width:217 height:172
(
	------------  Membres	----------------------------------------------------------------------------------
		
		
											
	---- Pointeurs ----
	local m_prt				---- pointeur vers la structure de controle ----
	local m_prefs			---- pointeur vers les preferences "Fenetre"de labib ----
	
	
		label 'lbl_nom' "Nom :" pos:[11,1] width:44 height:16 align:#left
	edittext 'edt_nom' "" pos:[38,1] width:131 height:17 align:#left
	button 'btn_sauvegarderSous' "+" pos:[171,1] width:17 height:17 toolTip:"Sauvegarder sous" align:#left
	
	spinner 'ddl1' "" pos:[82,45] width:60 height:16 range:[-360,360,0] type:#float items:#("Face") align:#left
	label 'lbl14' "y:" pos:[62,45] width:17 height:16 align:#left
	spinner 'ddl3' "" pos:[82,60] width:60 height:16 range:[0.1,100,1] align:#left
	label 'lbl17' "Distance:" pos:[10,61] width:52 height:16 align:#left
	
	spinner 'ddl4' "" pos:[82,30] width:60 height:16 range:[-360,360,0] items:#("Rapide", "Super beau") align:#left
	label 'lbl_corona' "Rotation:" pos:[10,33] width:52 height:16 align:#left
	
	
	label 'lbl95' "x:" pos:[62,33] width:17 height:16 align:#left
	spinner 'spn41' "" pos:[82,75] width:60 height:16 range:[10,170,90] align:#left
	label 'lbl96' "FOV:" pos:[10,76] width:36 height:16 align:#left
	button 'btn75' "-45" pos:[142,30] width:23 height:16 toolTip:"Sauvegarder sous" align:#left
	button 'btn76' "+45" pos:[164,30] width:23 height:16 toolTip:"Sauvegarder sous" align:#left
	button 'btn77' "-45" pos:[142,45] width:23 height:16 toolTip:"Sauvegarder sous" align:#left
	button 'btn78' "+45" pos:[164,45] width:23 height:16 toolTip:"Sauvegarder sous" align:#left
 
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
		

	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	on roll_paramCamera moved			_pos 	do	m_prt.m_pos	= _pos	
		
	---- Drag ----
	on roll_paramCamera lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_paramCamera lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_paramCamera mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
	---- Bouton fermer -----
	on 	ui_btnFermer	mouseover 				do 	etatBtnFermer #Survol
	on 	ui_btnFermer	mouseout 				do 	etatBtnFermer #Repos
	on 	ui_btnFermer	mousedown 			do 	etatBtnFermer #Press
	on 	ui_btnFermer	mouseup				do 	etatBtnFermer #Repos
	on 	ui_btnFermer 	click 						do 	m_prt.fermer ()
	
)
------------------------------------------------------------------------------
struct str_paramCamera (
	
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_paramCamera ,		---- le rollout ----
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Camera" ,
		m_pos 				= [100,100],
		m_taille 				= [209,172],
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
		fn ouvrir pos: =(			
			
			if pos != unsupplied do m_pos = pos			
			m_estOuvert 		= true
			
			---- creation de la fenetre ----
			createDialog m_dialog 	fgcolor:				col_fenetreTxt 	\
											style:				#(#style_resizing) \
											lockHeight:			true	\
											lockWidth:			true	 \			
											width:m_taille.x \
											height:m_taille.y \
											pos:					m_pos	
			
			---- initialisation de la fenetre ----
			m_dialog.initialiser this
	
		),
		
		fn fermer  silence:false =(		---- silence : fermer sans modifier l'état des preferences ---
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
			
		)
		
		------------  Evenements	----------------------------------------------------------------------------------
	
)


------------------------------------------------------------------------------
----------	FOND								 -------------------------
------------------------------------------------------------------------------
rollout roll_paramFond "Fond" width:217 height:172
(
	------------  Membres	----------------------------------------------------------------------------------
		
		
											
	---- Pointeurs ----
	local m_prt				---- pointeur vers la structure de controle ----
	local m_prefs			---- pointeur vers les preferences "Fenetre"de labib ----
	

	
	------------  UI	----------------------------------------------------------------------------------		
	label 'lbl_nom' "Nom :" pos:[11,1] width:44 height:16 align:#left
	edittext 'edt_nom' "" pos:[38,1] width:131 height:17 align:#left
	button 'btn_sauvegarderSous' "+" pos:[171,1] width:17 height:17 toolTip:"Sauvegarder sous" align:#left
	
	dropdownList 'ddl34' "" pos:[66,29] width:120 height:21 items:#("Aucun", "Pli", "Bowl") align:#left
	label 'lbl103' "Sol :" pos:[11,31] width:32 height:16 align:#left
	colorPicker 'cp1' "" pos:[44,31] width:21 height:17 align:#left
	dropdownList 'ddl35' "" pos:[66,48] width:120 height:21 items:#("Aucun", "Bitmap", "Color") align:#left
	label 'lbl105' "Fond :" pos:[11,50] width:32 height:16 align:#left
	colorPicker 'cp3' "" pos:[43,50] width:21 height:17 color:(color 0 0 155) align:#left
	
 
	
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
	
		
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	on roll_paramFond moved			_pos 	do	m_prt.m_pos	= _pos	
		
	---- Drag ----
	on roll_paramFond lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_paramFond lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_paramFond mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
	---- Bouton fermer -----
	on 	ui_btnFermer	mouseover 				do 	etatBtnFermer #Survol
	on 	ui_btnFermer	mouseout 				do 	etatBtnFermer #Repos
	on 	ui_btnFermer	mousedown 			do 	etatBtnFermer #Press
	on 	ui_btnFermer	mouseup				do 	etatBtnFermer #Repos
	on 	ui_btnFermer 	click 						do 	m_prt.fermer ()
	
)
------------------------------------------------------------------------------
struct str_paramFond (
	
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_paramFond ,		---- le rollout ----
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Fond" ,
		m_pos 				= [100,100],
		m_taille 				= [209,172],
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
		fn ouvrir pos: =(			
			
			if pos != unsupplied do m_pos = pos			
			m_estOuvert 		= true
			
			---- creation de la fenetre ----
			createDialog m_dialog 	fgcolor:				col_fenetreTxt 	\
											style:				#(#style_resizing) \
											lockHeight:			true	\
											lockWidth:			true	 \			
											width:m_taille.x \
											height:m_taille.y \
											pos:					m_pos	
			
			---- initialisation de la fenetre ----
			m_dialog.initialiser this
	
		),
		
		fn fermer  silence:false =(		---- silence : fermer sans modifier l'état des preferences ---
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
			
		)
		
		------------  Evenements	----------------------------------------------------------------------------------
	
)




------------------------------------------------------------------------------
----------	FOND								 -------------------------
------------------------------------------------------------------------------
rollout roll_paramLumieres "Lumières" width:217 height:172
(
	------------  Membres	----------------------------------------------------------------------------------
	
	
	
	---- Pointeurs ----
	local m_prt				---- pointeur vers la structure de controle ----
	local m_prefs			---- pointeur vers les preferences "Fenetre"de labib ----

	
	------------  UI	----------------------------------------------------------------------------------		
	label 'lbl_nom' "Nom :" pos:[11,1] width:44 height:16 align:#left
	edittext 'edt_nom' "" pos:[38,1] width:131 height:17 align:#left
	button 'btn_sauvegarderSous' "+" pos:[171,1] width:17 height:17 toolTip:"Sauvegarder sous" align:#left
	listbox 'lbx2' "" pos:[10,33] width:175 height:4 align:#left
	button 'btn102' "+" pos:[150,90] width:17 height:17 align:#left
	button 'btn103' "-" pos:[168,90] width:17 height:17 align:#left
 
	
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
		
				
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	on roll_paramLumieres moved			_pos 	do	m_prt.m_pos	= _pos	
		
	---- Drag ----
	on roll_paramLumieres lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_paramLumieres lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_paramLumieres mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
	---- Bouton fermer -----
	on 	ui_btnFermer	mouseover 				do 	etatBtnFermer #Survol
	on 	ui_btnFermer	mouseout 				do 	etatBtnFermer #Repos
	on 	ui_btnFermer	mousedown 			do 	etatBtnFermer #Press
	on 	ui_btnFermer	mouseup				do 	etatBtnFermer #Repos
	on 	ui_btnFermer 	click 						do 	m_prt.fermer ()
	
)

------------------------------------------------------------------------------
----------	Structure								 -------------------------
------------------------------------------------------------------------------
struct str_paramLumieres (
	
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_paramLumieres ,		---- le rollout ----
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Lumières" ,
		m_pos 				= [100,100],
		m_taille 				= [209,172],
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
		fn ouvrir pos: =(			
			
			if pos != unsupplied do m_pos = pos			
			m_estOuvert 		= true
			
			---- creation de la fenetre ----
			createDialog m_dialog 	fgcolor:				col_fenetreTxt 	\
											style:				#(#style_resizing) \
											lockHeight:			true	\
											lockWidth:			true	 \			
											width:m_taille.x \
											height:m_taille.y \
											pos:					m_pos	
			
			---- initialisation de la fenetre ----
			m_dialog.initialiser this
			
		),
		
		fn fermer  silence:false =(		---- silence : fermer sans modifier l'état des preferences ---
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
			
		)
		
		------------  Evenements	----------------------------------------------------------------------------------
	
)







