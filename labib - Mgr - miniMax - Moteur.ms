


--- le painter, pour dessiner sur des bitmaps ----
include "$userScripts\cp - labib\cp - GLOBAL\UI - painter.ms"			

--- les composants ----
include "$userScripts\cp - labib\labib - Mgr - minimax - Vue.ms"		
include "$userScripts\cp - labib\labib - Mgr - minimax - Elements.ms"	

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- Moteur	------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- UI : Structre associant un controleur Bitmap avec sa Vue   ------------------------------------------------------------------------
struct str_miniMax_controle (
	
	m_controle,
	m_vue,
	m_visible = true,
	
	m_pos = [0,0]
	m_taille =[0,0]
	
	
)


--- Moteur   ------------------------------------------------------------------------
struct str_miniMax_MOTEUR (
	
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="str_miniMax_MOTEUR",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
		
		--- Membres  ------------------------------------------------------------------------
		
		m_dialog,			---- le rollout parent ---
		
	private
		--- la fabrique d'éléments ----
		creer 	= str_miniMax_fabElems  m_moteur:this,
		
		---- Vues et UIs -----
		m_vues 				=	#(),				---- les differentes vues enregistrées dans le moteur ---
		m_UIs				=	#(),				---- liste de "str_miniMax_controle" , structre associant un controleur Bitmap et une Vue ---
		
		m_idVueActive,								----  ---
		
		---- Elements ( de l'univers du moteur )  -----
		m_elements 		=	#(),				---- les elements de premier plan dans les vues ---
		
		--- Affichage ------
		m_afficherUI 		= true,
		m_afficherGrille 	= true,
		m_maximiser		= false,				---- Afficher les 4 vues ou 1 seule en grand ---
		
		
		--- Espace de travail ------
		m_pos	= [20,20],
		m_taille 	= [400,400],					---- La dimension du rectangle dans lequel on manipule les 4 vues ou la grande unique ---
		
		
		
		
	private 
		fn idUI_estValid  _id = _id > 0 and _id <= m_UIs.count,
		
	public
		
		---- Vues et UIs --------------------------------------------------------	
		fn creerVue 	controle:  	type: =(
			
			debug "creerVue"			
			
			local nvVue = str_miniMax_vue 		m_moteur:this
			
			nvVue.setID 		m_vues.count
			
			if controle 	!= unsupplied 		do	nvVue.setControle 	controle  
			if type 		!= unsupplied 		do	nvVue.setType 		type
			
			append m_vues 	nvVue
			
			nvVue
			
		),
		fn ajouterControle 			_controle  type: =(
			
			debug "ajouterControle"
			
			local nvUI 			= str_miniMax_controle ()
			nvUI.controle 		= _controle
			nvUI.vue 			= creerVue 	controle:_controle 	type:type
			
			this.activerControle	1
			appendIfUnique 	m_UIs 		nvUI
			debug "m_UIs" var:m_UIs
			
		),
		fn getActiveVue = m_UIs[ m_idVueActive ].vue,
		
		---- Elements --------------------------------------------------------	
		fn getElements 		= m_elements,
		fn ajouterElement 	_element =(
			append m_elements 	_element
			_element
		),
		
		
		
		---- Affichage --------------------------------------------------------
		fn getAfficherUI 		= m_afficherUI,
		fn getAfficherGrille 	= m_afficherUI,
		fn getMaximiser 		= m_maximiser,
		
		fn toggleUI =(
			m_afficherUI = not m_afficherUI
			dessiner ()
		),
		fn toggleGrille =(
			m_afficherGrille = not m_afficherGrille
			dessiner ()
		),
		fn toggleMaximiserVue 	=(
			
			m_maximiser = not m_maximiser
			
			--- on met a jour tout ca ----
			actualiserEspaceDeTravail ()
			
			actualiser ()
		),
		
		
		
		------ Espace de travail  --------------------------------------------------------
		fn setTaille  _taille =(
			m_taille = _taille
			this.actualiserEspaceDeTravail ()
		),
		fn setPos  _pos =(
			m_pos = _pos
			this.actualiserEspaceDeTravail ()
		),
		
		
		fn activerControle 	_idUI = if idUI_estValid _idUI do  (
			
			m_idVueActive =  _idUI 
			
			for UI in m_UIs do (
				if UI.vue.getID () == m_idVueActive then
					UI.vue.activer ()
				else 
					UI.vue.desactiver ()
			)
			
		),
		
		
		------ Tests --------------------------------------------------------
		fn getVueSurvol _pos =(
			local result
			for vue in m_vues do
				if vue.estSurvolee 	_pos do result = vue
			result
		),
		fn estSurvolee 	_pos =(
			local result = ( getVueSurvol _pos ) != undefined

			result
		),
		
		
		------  Evenements Souris	--------------------------------------------------------
		--- Deplacement --------------
		fn mouseMove  	_pos =	for vue in m_vues do	if vue.estSurvolee _pos do vue.mouseMove 		_pos,
		
		--- Bouton gauche --------------
		fn mouseLDble 	_pos =	for vue in m_vues do	if vue.estSurvolee _pos do vue.mouseLDble 		_pos,
		fn mouseLUp 		_pos =	for vue in m_vues do	if vue.estSurvolee _pos do vue.mouseLUp 		_pos,
		fn mouseLDown 	_pos =	for vue in m_vues do	if vue.estSurvolee _pos do vue.mouseLDown 	_pos,
		
		--- Bouton droit --------------
		fn mouseRDble 	_pos =	for vue in m_vues do	if vue.estSurvolee _pos do vue.mouseRDble 		_pos,
		fn mouseRUp 		_pos =	for vue in m_vues do	if vue.estSurvolee _pos do vue.mouseRUp 		_pos,
		fn mouseRDown 	_pos =	for vue in m_vues do	if vue.estSurvolee _pos do vue.mouseRDown 	_pos,
		
		--- Bouton millieu --------------
		fn mouseMDble 	_pos =	for vue in m_vues do	if vue.estSurvolee _pos do vue.mouseMDble 	_pos,
		fn mouseMUp 		_pos =	for vue in m_vues do	if vue.estSurvolee _pos do vue.mouseMUp 		_pos,
		fn mouseMDown 	_pos =	for vue in m_vues do	if vue.estSurvolee _pos do vue.mouseMDown 	_pos,
		
		
		
		
		
		------  Dessins et actualisations	--------------------------------------------------------
		fn dessiner 	id_UI:  	fond:true =(		
			
			debug "dessiner"
			debug "m_UIs" var:m_UIs
			
			-- soit seulement l'ui passée en parametre ----
			if id_UI != unsupplied  and idUI_estValid 		id_UI 	then 			
				m_UIs[ id_UI ].vue.dessiner  fond:fond	
			
			-- soit toutes les uis ----
			else for UI in m_UIs do	(
				
				debug "dessiner UI" var:( UI.vue.getType () )
				UI.vue.dessiner  fond:fond
			)
		),	
		fn actualiser =(
			debug "Actualiser"
			dessiner ()
		),
		fn actualiserEspaceDeTravail =(
			
			debug "actualiserEspaceDeTravail"
			case m_maximiser of (
				
				----- Une seule vue affichée en grand ----
				true:(
					---- on actualise l'activité des vues ------
					for vue in m_vues do 
						if vue.estActive () then (							
							--- la vue maximisée -----
							vue.setTailleUI 	m_taille
							vue.setPosUI 		m_pos
							vue.montrer ()							
						) else	--- les autres vues  -----
							vue.cacher ()
					
				) --- fin du true
				
				----- les quatres vues en meme temps ----
				false:		(				
					local x = y = 0
					
					for vue in m_vues do (
						
						local taille 	= m_taille / 2
						local pos 	= [ m_pos.x + x * taille.x , m_pos.y + y * taille.y ]
						
						vue.setTailleUI 	taille
						vue.setPosUI 		pos
						vue.montrer ()
						
						x += 1
						if x > 1 do (	y += 1 ; 	x = 0 )
						
					)
					
				) --- fin du false
			) -- fin du case
-- 			
-- 			--- on redessine tout -----
-- 			dessiner ()
			
		),
		
		
		---------- Inititalisation  -------------------------------------------
		fn initialiser =(
			/* 
			--- les UIs utilisables ----
			m_UIs = #( 	m_dialog.ui_painter_1,	\
								m_dialog.ui_painter_2,	\
								m_dialog.ui_painter_3,	\
								m_dialog.ui_painter_4 )
			
			--- création des quatres vues ----
			this.creerVue 	ui:m_UIs[1]  	type:#Plan
			this.creerVue 	ui:m_UIs[2]  	type:#Cote
			this.creerVue 	ui:m_UIs[3]  	type:#Face
			this.creerVue 	ui:m_UIs[4]  	type:#3D
			
			-- on active la premiere --
			activerUI 	1
			
			--- creation des element des base ----
			creer.box  		pos:[0,0,0] 	taille:[50,40,80] 	centre:[0 ,0 ,0 ] 	coulLignes:[30,30,30]  	coulPts:white	
			creer.camera  	pos:[0,0,0] 	cible:[0,0,40] 		FOV:75			 	coulLignes:blue  		coulPts:blue	
			
			 */
		),
		
		
		
		---------- Evenements -------------------------------------------
		on create do initialiser ()
		
)	-- fin str_miniMax_MOTEUR -----
-- popo = str_miniMax_MOTEUR ()
