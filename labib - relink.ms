/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	Fenetre type	( sert de model de base, n'est pas importé dans le script )	
	sans barre de titre, draggable et bouton fermer
	
	Remplacer (ctr + h): 'relink ' par:  'maFenetreAMoi'.
	il y a des parties a decommenter :"--- a décommenter ---"
	Noms des variables 
	-	roll_relink :			le nom de la fenetre
	-	relink_pos :			le parametre des prefs stockant la pos de la fenetre
	-	relink_estOuvert :	le nom du parametre ouvert dans les preferences ( labib.prefs.fenetre. ' relinkOuvert )
	-	str_relink:			le nom de la struicture de controle de la fenetre
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [02/10/2016] -----------------------------------------------------------------------------
	- Mise en place globale ( mise au propre du travail durant l'été)
	- Une interface souple et simple
########################################################################################################################*/
-- destroydialog roll_relink catch ()
(
	
	
include "$userScripts\cp - labib\cp - GLOBAL\UI.ms"
include "$userScripts\cp - labib\cp - GLOBAL\DragDialog.ms"
	
	
	
	local str_Pointeur 
------------------------------------------------------------------------------
----------	Fenetre								 -------------------------
------------------------------------------------------------------------------
rollout roll_relink "relink " width:296 height:296
(
	------------ DEBUG	----------------------------------------------------------------------------------
	local m_debug = true
	local m_dbgPrefix ="studio-relink rollout"
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
	
-- 	button 'btn_chercherManquantes' "Chercher bitmaps manquantes" pos:[27,31] width:254 height:25 align:#left
	
	button 'btn_relink' "Relink" pos:[27,144] width:254 height:25 align:#left
	listBox 'lbx_cheminsRecherche' "" pos:[27,174] width:254 height:6 align:#left
	listBox 'lbx_bitmapsmanquantes' "" pos:[26,57] width:254 height:6 align:#left
	
	------------  Fonctions	----------------------------------------------------------------------------------
	fn actualiser =(
		-- les fichier manquants -------
		local fichiersManquants = m_prt.getMapsManquants ()
		local fichiersManquant_affichage = #()
		for Fichiermanquant in fichiersManquants do
			append fichiersManquant_affichage	Fichiermanquant.filename
		lbx_bitmapsmanquantes.items = fichiersManquant_affichage
		
		---- les chemins de rechreche--------
		lbx_cheminsRecherche.items = m_prt.getCheminsRecherche ()
		
	)
	
	
	fn reagencer taille: 	=(
		
		Local LargeurBtn = 20
		
		if taille == unsupplied do taille = [ roll_relink.width, roll_relink.height ]
		ui_btnFermer.pos.x		=	taille.x - ( LargeurBtn )
		
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
		m_drag 		= str_drag 	m_prt:roll_relink
		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
		b_initialisation = true
		
		m_prt.chercherManquantes ()
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	
	---- Drag ----
	
	---- Bouton fermer -----
	on roll_relink resized _taille 	do
		reagencer ()
	on roll_relink moved _pos 		do
		m_prt.m_pos	= _pos
	on roll_relink lbuttondown _pos 	do
		m_drag.demarrer ()
	on roll_relink lbuttonup _pos 	do
		m_drag.arreter ()
	on roll_relink mouseMove _pos 	do
		m_drag.suivreSouris ()
	on ui_btnFermer mouseover do
		etatBtnFermer #Survol
	on ui_btnFermer mouseout do
		etatBtnFermer #Repos
	on ui_btnFermer mouseDown do
		etatBtnFermer #Press
	on ui_btnFermer mouseUp do
		etatBtnFermer #Repos
	on ui_btnFermer click do
		m_prt.fermer ()
	
	
-- 	on btn_chercherManquantes 	pressed do 		m_prt.chercherManquantes ()
	on btn_relink 	pressed do 		m_prt.relier ()
	
)
	
------------------------------------------------------------------------------
----------	Structure								 -------------------------
------------------------------------------------------------------------------
struct str_relink (
		
	------------ DEBUG	----------------------------------------------------------------------------------
	m_debug = true,
	m_dbgPrefix ="studio-relink",
	fn debug 	_txt  var:	 param:    =(
		if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
	),
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_relink ,		---- le rollout ----
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Relink ",
		m_pos 				= [800,100],
		m_taille 				= [300, 300],
		m_estOuvert 		= false,
		
		--- ui libre de labib -----------	
		col_fenetreFond			= color 68 68 68, 		---- MAX 	----
		col_fenetreTxt				= color 230  230 230, 	----  		----
		
		ico_btnFermer_R	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_R.jpg",
		ico_btnFermer_S	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_S.jpg",
		ico_btnFermer_P	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_P.jpg", 
		
		m_icos_fermer= #( 	openbitmap ico_btnFermer_R, openbitmap ico_btnFermer_S, openbitmap ico_btnFermer_P ),
		
	private
		--------
		m_mapsManquants=#(),
		m_cheminsRecherche = #("D:\00 - images"),
		m_recursif = false,
		
		------------  Fonctions	----------------------------------------------------------------------------------
	private
		fn chercherFile 	_map =(
			local nomFichier = filenameFromPath 	_map.filename
			for chemin in m_cheminsRecherche do (
				local fichier = chemin + "\\" + nomFichier
				if doesFileExist fichier do (
					debug "Image retrouvée" var: fichier
					_map.filename = fichier
				)
			)
			
		),
		
		fn listerTextBitmaps 	_mat =(
			
			local result =#()
			local listeDesProps = getpropnames _mat
			
			if listeDesProps != undefined do 
				for nomProp in listeDesProps do (
					prop = getProperty _mat nomProp
					
	 				if superClassOf prop == textureMap then (
						case ClassOf prop of (
							bitmaptexture:	appendifUnique result prop
							CoronaBitmap:		appendifUnique result prop
							default: (
								local nvItems = ( chercherTextBitmaps prop )
								for nvItem in nvItems do appendifUnique result nvItem 								
							)
						)
					)  	else if ClassOf prop == ArrayParameter then (
						for item in prop where superClassOf item == textureMap do (
								local nvItems = ( chercherTextBitmaps item )
								for nvItem in nvItems do appendifUnique result nvItem 	
						)
					) 
					
				)
			result
		),
		
		fn listerTextBitmapsScene  =(
			
			--- on creer la liste des materiaux -------
			local listeMats 		= #()
			local listeBitmaps 	= #()
			for obj in objects do appendIfUnique listeMats obj.material
			
			--- on traite la question pour les mltimat et des mats de base ----
			for mat in listeMats do if mat != undefined do
				if classOf mat == Multimaterial then
					for subMat in mat do
						listeBitmaps = listerTextBitmaps subMat	
				else
					listeBitmaps = listerTextBitmaps	mat	
					
			listeBitmaps
		),
		
	public
		fn getMapsManquants = m_mapsManquants,
		fn getCheminsRecherche = m_cheminsRecherche,
			
		fn chercherManquantes =(
			
			local texturesBmpScene = listerTextBitmapsScene()
			debug "texturesBmpScene" var:texturesBmpScene
			
			
			m_mapsManquants =#()
			
			for map  in texturesBmpScene do(
-- 				case classof map of (
-- 					bitmaptexture:	appendifUnique result prop
-- 					CoronaBitmap:		appendifUnique result prop
-- 				)
				debug "map" var:map.filename
				debug "doesFileExist" var:(doesFileExist map.filename)
				if not doesFileExist map.filename do append m_mapsManquants	map
			)
			
			debug "m_mapsManquants" var:m_mapsManquants
			
			m_dialog.actualiser ()
			
		),
		
		
		fn relier =(
			for bitmp in m_mapsManquants do
				chercherFile 	bitmp
			
			chercherManquantes ()
		),
		
		
		
		
		
		
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
	
) -- fin struct ------------------


global relink  	=	str_relink () --	m_labib:Labib

relink.ouvrir ()
-- destroydialog relink.m_dialog
)