/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
		
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	Fenetre type	( sert de model de base, n'est pas importé dans le script )	
	sans barre de titre, draggable et bouton fermer
	
	Remplacer (ctr + h): 'fenetreType' par:  'maFenetreAMoi'.
	il y a des parties a decommenter :"--- a décommenter ---"
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
	- Mise en place globale ( mise au propre du travail durant l'été)
	- Une interface souple et simple
########################################################################################################################*/

------------------------------------------------------------------------------
----------	Fenetre								 -------------------------
------------------------------------------------------------------------------
rollout roll_fenetreType  "fenetreType" width:296 height:296
(
	------------  Membres	----------------------------------------------------------------------------------
	---- Pointeurs ----
	local m_prt				---- pointeur vers la structure de controle ----
	local m_prefs			---- pointeur vers les preferences "Fenetre"de labib ----
	
	---- Structures ----
	local m_drag			---- la structure gerant le drag de la fenetre ----
	
	------------  UI	----------------------------------------------------------------------------------		
	---- le bouton pour fermer la fenetre ----
	ImgTag ui_btnFermer "X" pos:[276,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center
	
	------------  Fonctions	----------------------------------------------------------------------------------
	---- Gere l'état du bouton  -----
	fn etatBtnFermer		_etat =(
		case _etat of (
			#Repos : 	ui_btnFermer.bitmap = openBitmap 	m_prefs.fenetre.ico_btnFermer_S
			#Survol : 	ui_btnFermer.bitmap = openBitmap 	m_prefs.fenetre.ico_btnFermer_R
			#Press : 	ui_btnFermer.bitmap = openBitmap 	m_prefs.fenetre.ico_btnFermer_P
		)
	)
	---- Initialisation de la fenetre  -----
	fn initialiser = (		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	/* 	--- a décommenter ---		
	on roll_fenetreType moved			_pos 	do	m_prefs.fenetre.fenetreType_pos	= _pos	
	*/
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
	
		------------  Membres	----------------------------------------------------------------------------------
	public
		---- pointeurs ----
		m_labib	,		-- ( a remplir a la creation )		---- pointeur vers la structure principale ----
		m_prefs			= m_labib.prefs			,		---- pointeur vers les preferences ----
		m_dialog			= roll_fenetreType ,		---- le rollout ----
		m_icos_fermer = #( 					---- les images pour les icones du bouton de fermeture ----
									openBitMap m_prefs.fenetre.ico_btnFermer_R ,		-- Repos ----
									openBitMap m_prefs.fenetre.ico_btnFermer_S ,		-- Survol ----
									openBitMap m_prefs.fenetre.ico_btnFermer_P 		-- Pressé ----
								),
		
		------------  Fonctions	----------------------------------------------------------------------------------
	public
		fn ouvrir =(			
			---- creation de la fenetre ----
			createDialog m_dialog 	bgcolor:				m_prefs.fenetre.col_fenetreFond 	 \
											fgcolor:				m_prefs.fenetre.col_fenetreTxt 	\
											style:				#(#style_resizing) \
											lockHeight:			true	\
											lockWidth:			true	/* \	--- a décommenter ---								
											pos:					m_prefs.fenetre.fenetreType_pos	  */
			
			---- initialisation de la fenetre ----
			m_dialog.m_drag 		= str_drag fenetre:m_dialog
			m_dialog.m_prefs 	= m_prefs
			m_dialog.m_prt	 	= this
			m_dialog.initialiser ()
			
			---- maj des preferences ----	
			/* 	--- a décommenter ---		
			m_prefs.fenetre.fenetreType_estOuvert = true
			*/
		),
		
		fn fermer  silence:false =(		---- silence : fermer sans modifier l'état des preferences ---
			---- maj des preferences ----	
			if not silence do (
				/* 	--- a décommenter ---		
				m_prefs.fenetre.fenetreType_estOuvert 	= false
				m_prefs.fenetre.fenetreType_pos			= getdialogpos m_dialog
				*/
			)
			
			---- fermer la fenêtre ----
			try destroydialog m_dialog catch ()
		)
		
		------------  Evenements	----------------------------------------------------------------------------------
	
)


fenetreType 	=	str_fenetreType m_labib:Labib
fenetreType.ouvrir ()