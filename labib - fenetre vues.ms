/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	Fenetre type	( sert de model de base, n'est pas importé dans le script )	
	sans barre de titre, draggable et bouton fermer
	
	Remplacer (ctr + h): 'vues' par:  'maFenetreAMoi'.
	il y a des parties a decommenter :"--- a décommenter ---"
	Noms des variables 
	-	roll_vues :			le nom de la fenetre
	-	vues_pos :			le parametre des prefs stockant la pos de la fenetre
	-	vues_estOuvert :	le nom du parametre ouvert dans les preferences ( labib.prefs.fenetre. ' vuesOuvert )
	-	str_vues:			le nom de la struicture de controle de la fenetre
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [02/10/2016] -----------------------------------------------------------------------------
	- Mise en place globale ( mise au propre du travail durant l'été)
	- Une interface souple et simple
########################################################################################################################*/
-- destroydialog roll_vues catch ()

------------------------------------------------------------------------------
----------	Fenetre								 -------------------------
------------------------------------------------------------------------------
rollout roll_vues  "vues" width:308 height:259
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
	
	ImgTag 'ui_titre' "" pos:[16,4] width:66 height:18 align:#left
	
	---- le bouton pour fermer la fenetre ----
	ImgTag ui_btnFermer "X" pos:[276,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center
	
	
	
	
	label 'lbl45' "Nom :" pos:[28,68] width:44 height:16 align:#left
	edittext 'edt9' "" pos:[117,68] width:163 height:17 align:#left
	
	GroupBox 'grp1' "Vue" pos:[17,47] width:272 height:192 align:#left
	dropdownList 'ddl1' "" pos:[122,123] width:120 height:21 items:#("Face") align:#left
	label 'lbl14' "Camera :" pos:[27,126] width:44 height:16 align:#left
	listbox 'lbx2' "" pos:[122,173] width:120 height:4 items:#("Spot contre jour", "Soleil") align:#left
	button 'btn9' "+" pos:[245,173] width:17 height:17 align:#left
	button 'btn10' "-" pos:[263,173] width:17 height:17 align:#left
	label 'lbl16' "Lumières :" pos:[27,176] width:73 height:16 align:#left
	dropdownList 'ddl3' "" pos:[122,148] width:120 height:21 align:#left
	label 'lbl17' "Fond :" pos:[27,149] width:34 height:16 align:#left
	colorPicker 'cp1' "" pos:[244,148] width:25 height:21 align:#left
	button 'btn11' "Editer" pos:[246,123] width:35 height:17 toolTip:"Modifier" align:#left
	button 'btn12' "Editer" pos:[245,190] width:35 height:17 toolTip:"Modifier" align:#left
	
	dropdownList 'ddl4' "" pos:[122,98] width:120 height:21 items:#("Rapide", "Super beau") align:#left
	label 'lbl_corona' "Param. de rendu :" pos:[27,101] width:88 height:16 align:#left
	button 'btn_coronaEdit' "Editer" pos:[246,98] width:35 height:17 toolTip:"Modifier" align:#left
	
	dropdownList 'ddl29' "" pos:[19,25] width:123 height:21 items:#("Face", "Coté", "Dessus", "   ---", "Charger", "Sauvegarder") align:#left
	
	
	
	
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
		m_drag 		= str_drag 	m_prt:roll_vues
		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
		
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	on roll_vues moved			_pos 	do	m_prt.m_pos	= _pos	
		
	---- Drag ----
	on roll_vues lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_vues lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_vues mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
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
struct str_vues (
	
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_vues ,		---- le rollout ----
		
	
		---- props de la fenetre -----
		m_titre 				= "Labib | vues",
		m_pos 				= [100,100],
		m_taille 				= [308, 259],
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
		fn ouvrir =(			
			m_estOuvert 		= true
			---- creation de la fenetre ----
			createDialog m_dialog 	fgcolor:				col_fenetreTxt 	\
											style:				#(#style_resizing) \
											lockHeight:			true	\
											lockWidth:			true	 \									
											pos:					m_pos	
-- 			bgcolor:				col_fenetreFond	 \
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

