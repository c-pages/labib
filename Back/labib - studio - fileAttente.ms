/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	Fenetre type	( sert de model de base, n'est pas importé dans le script )	
	sans barre de titre, draggable et bouton fermer
	
	Remplacer (ctr + h): 'fileAttente ' par:  'maFenetreAMoi'.
	il y a des parties a decommenter :"--- a décommenter ---"
	Noms des variables 
	-	roll_fileAttente :			le nom de la fenetre
	-	fileAttente_pos :			le parametre des prefs stockant la pos de la fenetre
	-	fileAttente_estOuvert :	le nom du parametre ouvert dans les preferences ( labib.prefs.fenetre. ' fileAttenteOuvert )
	-	str_fileAttente:			le nom de la struicture de controle de la fenetre
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [02/10/2016] -----------------------------------------------------------------------------
	- Mise en place globale ( mise au propre du travail durant l'été)
	- Une interface souple et simple
########################################################################################################################*/

/* 
-- destroydialog roll_fileAttente catch ()
(
	
	
include "$userScripts\cp - labib\cp - GLOBAL\UI.ms"
include "$userScripts\cp - labib\cp - GLOBAL\DragDialog.ms"
	
	 */
	

------------------------------------------------------------------------------
----------	Fenetre								 -------------------------
------------------------------------------------------------------------------
rollout roll_fileAttente  "File de rendus" width:500 height:300
(
	------------ DEBUG	----------------------------------------------------------------------------------
	local m_debug = true
	local m_dbgPrefix ="studio-fileAttente rollout"
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
	
	
	------------  UI	----------------------------------------------------------------------------------		
		ImgTag 'ui_titre' "" pos:[16,4] width:66 height:18 align:#left
	
	---- le bouton pour fermer la fenetre ----
	ImgTag 'ui_btnFermer' "X" pos:[276,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	

	dotNetControl ui_LV 	"system.windows.forms.listView"	pos:		[18,27] \
																				width:261 height:233 \
																				border:	false	\
																				align:#left
	
	
	button 'btn_pause' 		"pause" pos:[16,260] width:52 height:17 align:#left
	button 'btn_annuler' 	"annuler" pos:[67,260] width:52 height:17 align:#left
	
	------------  Fonctions	----------------------------------------------------------------------------------
	
	fn reagencer taille: 	=(
		
		Local largeurBtn = 16
		Local largeurBordure = 20
		
		if taille == unsupplied do taille = [ roll_fileAttente.width, roll_fileAttente.height ]
		ui_btnFermer.pos.x		=	taille.x - ( largeurBordure )
		
		ui_LV.width 			= taille.x - ( 2 * largeurBordure ) + 1 
		ui_LV.height 			= taille.y - ( ui_LV.pos.y +  2 * largeurBordure  ) + 5
		btn_pause.pos.y 		= ui_LV.pos.y + 	ui_LV.height
		btn_annuler.pos.y 	= btn_pause.pos.y
	)
	
	
	
	---- Gere l'état du bouton  fermer -----
	fn etatBtnFermer		_etat =(
		case _etat of (
			#Repos : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]
			#Survol : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[2]
			#Press : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[3]
		)
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
		m_drag 		= str_drag 	m_prt:roll_fileAttente
		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
		
		
		
-- 		local col_fondDossierPrt 		= m_prefs.fenetre.col_fondDossierPrt	
-- 		local col_txt						= m_prefs.fenetre.col_txt
		
		local col_uiFond 		= color 130 136 152
		local col_txt			= color 255	 255	255
		
		-- UI --
		ui_LV.borderstyle 			= (dotnetclass "System.Windows.Forms.BorderStyle").None
		ui_LV.showitemtooltips 		= true
		ui_LV.gridlines 				= false
		ui_LV.checkboxes 			= true
		ui_LV.labeledit 				= false
		ui_LV.MultiSelect				= true
		ui_LV.HideSelection 			= false
		ui_LV.allowdrop 				= false
		ui_LV.AllowColumnReorder	= true
		ui_LV.BackColor 				= toCouleurDotnet	col_uiFond
		ui_LV.ForeColor 				= toCouleurDotnet   col_txt
		
		
		
		ui_LV.view = (dotNetClass "system.windows.forms.view").details
		ui_LV.columns.add "Nom de l'assset" 200
		ui_LV.columns.add "Priorité" 50
		ui_LV.columns.add "Date de l'ajout" 50
		ui_LV.columns.add "Date du rendu" 50
		
		ui_LV.FullRowSelect = true
		
		reagencer ()
		
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	on roll_fileAttente moved			_pos 		do	m_prt.m_pos	= _pos	
	on roll_fileAttente resized			_taille 	do	reagencer ()
	
	---- Drag ----
	on roll_fileAttente lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_fileAttente lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_fileAttente mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
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
struct str_fileAttente (
		
	------------ DEBUG	----------------------------------------------------------------------------------
	m_debug = true,
	m_dbgPrefix ="studio-fileAttente",
	fn debug 	_txt  var:	 param:    =(
		if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
	),
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_fileAttente ,		---- le rollout ----
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Studio | File de rendus",
		m_pos 				= [100,100],
		m_taille 				= [500, 300],
		m_estOuvert 		= false,
		
		--- ui libre de labib -----------	
		col_fenetreFond			= color 68 68 68, 		---- MAX 	----
		col_fenetreTxt				= color 230  230 230, 	----  		----
		
		
		ico_btnFermer_R	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_R.jpg",
		ico_btnFermer_S	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_S.jpg",
		ico_btnFermer_P	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_P.jpg", 
	
		m_icos_fermer= #( 	openBitMap ico_btnFermer_R, 
											openBitMap	ico_btnFermer_S,
											openBitMap	ico_btnFermer_P ),
		
		------------  Fonctions	----------------------------------------------------------------------------------
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
			debug "this ?!?!?" var:this
			
			
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
			
		)
		
		------------  Evenements	----------------------------------------------------------------------------------
	
) -- fin struct ---------

/* 
global fileAttente  	=	str_fileAttente () --	m_labib:Labib

fileAttente.ouvrir ()
-- destroydialog fileAttente.m_dialog
)
 */










