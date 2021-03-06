/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	Fenetre type	( sert de model de base, n'est pas import� dans le script )	
	sans barre de titre, draggable et bouton fermer
	
	Remplacer (ctr + h): 'fenetreType ' par:  'maFenetreAMoi'.
	il y a des parties a decommenter :"--- a d�commenter ---"
	Noms des variables 
	-	roll_fenetreType :			le nom de la fenetre
	-	fenetreType_pos :			le parametre des prefs stockant la pos de la fenetre
	-	fenetreType_estOuvert :	le nom du parametre ouvert dans les preferences ( labib.prefs.fenetre. ' fenetreTypeOuvert )
	-	str_fenetreType:			le nom de la struicture de controle de la fenetre
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [02/10/2016] -----------------------------------------------------------------------------
	- Mise en place globale ( mise au propre du travail durant l'�t�)
	- Une interface souple et simple
########################################################################################################################*/
-- destroydialog roll_fenetreType catch ()
(
	
	
include "$userScripts\cp - labib\cp - GLOBAL\UI.ms"
include "$userScripts\cp - labib\cp - GLOBAL\DragDialog.ms"
	
	
	
	local str_Pointeur 
------------------------------------------------------------------------------
----------	Fenetre								 -------------------------
------------------------------------------------------------------------------
rollout roll_fenetreType  "fenetreType " width:296 height:296
(
	------------ DEBUG	----------------------------------------------------------------------------------
	local m_debug = true
	local m_dbgPrefix ="studio-fenetreType rollout"
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
	ImgTag ui_btnFermer "X" pos:[276,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center
	
	------------  Fonctions	----------------------------------------------------------------------------------
	
	fn reagencer taille: 	=(
		
		Local LargeurBtn = 20
		
		if taille == unsupplied do taille = [ roll_fenetreType.width, roll_fenetreType.height ]
		ui_btnFermer.pos.x		=	taille.x - ( LargeurBtn )
		
	)
	
	
	
	---- Gere l'�tat du bouton  fermer -----
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
		-- se raccrocher � labib --
		m_prt = ptr_parent
		
		-- le titre --
		m_titre 	= str_label 	m_ui:ui_titre			m_texte:m_prt.m_titre
		m_titre.setCouleur 	m_prt.col_fenetreTxt
		
		-- le drag --
		m_drag 		= str_drag 	m_prt:roll_fenetreType
		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
		b_initialisation = true
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	on roll_fenetreType moved			_pos 		do	m_prt.m_pos	= _pos	
	on roll_fenetreType resized			_taille 	do	reagencer ()
	
	---- Drag ----
	on roll_fenetreType lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_fenetreType lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_fenetreType mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
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
struct str_fenetreType (
		
	------------ DEBUG	----------------------------------------------------------------------------------
	m_debug = true,
	m_dbgPrefix ="studio-fenetreType",
	fn debug 	_txt  var:	 param:    =(
		if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
	),
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_fenetreType ,		---- le rollout ----
		
		---- props de la fenetre -----
		m_titre 				= "Labib | fenetreType ",
		m_pos 				= [100,100],
		m_taille 				= [300, 300],
		m_estOuvert 		= false,
		
		--- ui libre de labib -----------	
		col_fenetreFond			= color 68 68 68, 		---- MAX 	----
		col_fenetreTxt				= color 230  230 230, 	----  		----
		
		ico_btnFermer_R	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_R.jpg",
		ico_btnFermer_S	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_S.jpg",
		ico_btnFermer_P	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_P.jpg", 
	
		m_icos_fermer= #( 	openbitmap ico_btnFermer_R, openbitmap ico_btnFermer_S, openbitmap ico_btnFermer_P ),
		
		
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
		
		fn fermer  silence:false =(		---- silence : fermer sans modifier l'�tat des preferences ---	
			debug "fermer"
			m_estOuvert 		= false
			---- maj des preferences ----	
			if not silence do (
			)
			
			---- fermer la fen�tre ----
			try destroydialog m_dialog catch ()
		),
		
		fn toggleOuverture =(
			
			if m_estOuvert
				then fermer ()
				else	ouvrir ()
			
		)
		
		------------  Evenements	----------------------------------------------------------------------------------
	
)


global fenetreType  	=	str_fenetreType () --	m_labib:Labib

fenetreType.ouvrir ()
-- destroydialog fenetreType.m_dialog
)