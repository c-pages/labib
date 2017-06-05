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
	-	roll_queryNom :			le nom de la fenetre
	-	queryNom_pos :			le parametre des prefs stockant la pos de la fenetre
	-	queryNom_estOuvert :	le nom du parametre ouvert dans les preferences ( labib.prefs.fenetre. ' queryNomOuvert )
	-	str_queryNom:			le nom de la struicture de controle de la fenetre
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [02/10/2016] -----------------------------------------------------------------------------
	- Mise en place globale ( mise au propre du travail durant l'été)
	- Une interface souple et simple
########################################################################################################################*/
-- destroydialog roll_queryNom catch ()
-- (
------------------------------------------------------------------------------
----------	Fenetre								 -------------------------
------------------------------------------------------------------------------
rollout roll_queryNom  "vues" width:296 height:73
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
	ImgTag 'ui_btnFermer' "X" pos:[276,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	edittext 'edt_txt' "" pos:[10,23] width:265 height:17 align:#left
	button 'bt_ok' "ok" pos:[185,41] width:45 height:17 align:#left
	button 'btn_cancel' "Cancel" pos:[230,41] width:45 height:17 align:#left
	
	
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
		m_titre 	= str_label 	m_ui:ui_titre			m_texte:( m_prt.m_titre + m_prt.m_text )
		m_titre.setCouleur 	m_prt.col_fenetreTxt
		
		-- le drag --
		m_drag 		= str_drag 	m_prt:roll_queryNom
		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
		
		setfocus	edt_txt
		
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	
	on edt_txt entered text do	(
		m_prt.fermer ()
		m_prt.m_fnOk 	text  
	)
	on bt_ok pressed  do(
		m_prt.fermer ()
		m_prt.m_fnOk text 
	)
	on btn_cancel pressed  do
		m_prt.fermer ()
	
	
	
	---- Fenetre -----
	on roll_queryNom moved			_pos 	do	m_prt.m_pos	= _pos	
	
	---- Drag ----
	on roll_queryNom lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_queryNom lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_queryNom mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
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
struct str_queryNom (
	
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_queryNom ,		---- le rollout ----

		m_rollParent,
	
		---- props de la fenetre -----
		m_titre 				= "Labib | ",
		m_text				=	"",
		
		m_fnOk,
		
		m_pos 				= [100,100],
		m_taille 				= [300, 73],
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
		fn ouvrir 	texte:"" 		fnOk:   parent:	=(		
			
			m_text 			= texte	
			m_fnOk 			= fnOk	
			m_rollParent = parent
			m_estOuvert 		= true
			
			m_pos = mouse.screenpos + [ - m_taille.x / 2 , 10 ]
			
			---- creation de la fenetre ----
			createDialog m_dialog 	fgcolor:				col_fenetreTxt 	\
											style:				#(#style_resizing) \
											lockHeight:			true		\
											lockWidth:			true	 	\									
											pos:					m_pos	 \
											parent:				m_rollParent.hwnd
-- 											modal:				true					\
-- 											escapeEnable:		true 			\
			
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
/* 
-- destroydialog queryNom.m_dialog
queryNom 	=	str_queryNom 	m_labib:Labib	m_text:"ceci est le texte"
queryNom.ouvrir ()

) */