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
	-	roll_paramRendu :			le nom de la fenetre
	-	paramRendu_pos :			le parametre des prefs stockant la pos de la fenetre
	-	paramRendu_estOuvert :	le nom du parametre ouvert dans les preferences ( labib.prefs.fenetre. ' paramRenduOuvert )
	-	str_paramRendu:			le nom de la struicture de controle de la fenetre
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [02/10/2016] -----------------------------------------------------------------------------
	- Mise en place globale ( mise au propre du travail durant l'été)
	- Une interface souple et simple
########################################################################################################################*/
-- destroydialog roll_paramRendu catch ()
(
------------------------------------------------------------------------------
----------	Fenetre								 -------------------------
------------------------------------------------------------------------------
rollout roll_paramRendu "Paramètres de rendu" width:258 height:192
(
	------------  Membres	----------------------------------------------------------------------------------
		local LastSubRollout = 1
		
		rollout rollout_1 "Rendu"
		(
				ImgTag 'ui_titre' "" pos:[16,4] width:66 height:18 align:#left
			
			---- le bouton pour fermer la fenetre ----
			ImgTag 'ui_btnFermer' "X" pos:[235,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
			
			label 'lbl45' "Nom :" pos:[19,22] width:44 height:16 align:#left
			edittext 'edt9' "" pos:[108,22] width:126 height:17 align:#left
			
			spinner 'ddl1' "" pos:[174,73] width:60 height:16 items:#("Face") align:#left
			label 'lbl14' "Denoise Amount :" pos:[18,76] width:93 height:16 align:#left
			spinner 'ddl3' "" pos:[174,94] width:60 height:16 align:#left
			label 'lbl17' "Time limit :" pos:[18,97] width:82 height:16 align:#left
			
			spinner 'ddl4' "" pos:[174,52] width:60 height:16 items:#("Rapide", "Super beau") align:#left
			label 'lbl_corona' "Denoise level limit :" pos:[18,55] width:94 height:16 align:#left
		)
		rollout rollout_2 "Rollout 02"
		(
			button btn_button "Button"
		)
		rollout rollout_3 "Rollout 03"
		(
			label lbl_label "This is some text"
		)
		rollout rollout_4 "Rollout 04"
		(
			colorpicker clr_picker "Color Picker"
		)
		
	
		local roll_paramRendu_Rollouts = #(	#("Rendu",#(rollout_1)),
												#("Caméra",#(rollout_2)),
												#("Fond",#(rollout_3)),
												#("Lumières",#(rollout_4))
											)
											
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
	ImgTag 'ui_btnFermer' "X" pos:[302,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	
	dotNetControl 'dn_tabs' "System.Windows.Forms.TabControl" pos:[13,27] width:288 height:20 align:#left
	subRollout 'theSubRollout' "" pos:[11,53] width:291 height:190 align:#left
		on dn_tabs Selected itm do
		(
			if LastSubRollout != (itm.TabPageIndex+1) do --do not update if the same tab clicked twice
			(
				for subroll in roll_paramRendu_Rollouts[LastSubRollout][2] do
					removeSubRollout theSubRollout subroll
				for subroll in roll_paramRendu_Rollouts[LastSubRollout = itm.TabPageIndex+1][2] do	
					addSubRollout theSubRollout subroll
			) 
		)--end tabs clicked	

		on roll_paramRendu open do
		(
			for aTab in roll_paramRendu_Rollouts do			(
				dn_tabs.TabPages.add aTab[1]
			)
			for subroll in roll_paramRendu_Rollouts[1][2] do 
				addSubRollout theSubRollout subroll	
		)
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
		m_drag 		= str_drag 	m_prt:roll_paramRendu
		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
		
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

------------------------------------------------------------------------------
----------	Structure								 -------------------------
------------------------------------------------------------------------------
struct str_paramRendu (
	
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_paramRendu ,		---- le rollout ----
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Edition vue" ,
		m_pos 				= [100,100],
		m_taille 				= [326,268],
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
			createDialog m_dialog 	bgcolor:				col_fenetreFond	 \
											fgcolor:				col_fenetreTxt 	\
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


global paramRendu 	=	str_paramRendu 	m_labib:Labib
paramRendu.ouvrir ()
/* 
paramRendu.fermer ()
 */
)