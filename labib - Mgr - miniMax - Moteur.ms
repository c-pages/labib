


--- le painter, pour dessiner sur des bitmaps ----
include "$userScripts\cp - labib\cp - GLOBAL\UI - painter.ms"			

--- les composants ----
include "$userScripts\cp - labib\labib - Mgr - minimax - Vue.ms"		
include "$userScripts\cp - labib\labib - Mgr - minimax - Elements.ms"	













----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- Moteur	------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
		
		--- la fabrique d'éléments ----
		creer 	= str_miniMax_fabElems  m_moteur:this,
		
	private
		
		--- Espace de travail ------
		m_pos	= [20,20],
		m_taille 	= [400,400],					---- La dimension du rectangle dans lequel on manipule les 4 vues ou la grande unique ---
		
		---- Vues et UIs -----
		m_vues 				=	#(),				---- les differentes vues enregistrées dans le moteur ---		
		m_vueActive,							----  ---
		
		---- Elements ( de l'univers du moteur )  -----
		m_elements 		=	#(),				---- les elements de premier plan dans les vues ---
		
		--- Affichage ------
		m_afficherInfos 		= true,
		m_afficherGrille 	= true,
		m_maximiser		= false,				---- Afficher les 4 vues ou 1 seule en grand ---
		
	public		
		---- Vues et UIs --------------------------------------------------------	
		fn ajouterVue 	 _controle  type:#plan  nom: =(
			
			debug "ajouterVue"
			
			--- creation de la nouvelle vue ---
			local nvVue			= str_miniMax_vue m_moteur:this
			nvVue.setControle 		_controle  
			
			
			case type of (
				#plan: (
						if nom == unsupplied do	nom = "Plan"							
						nvVue.setNom 		nom
						nvVue.setNorm 		[0,0,1]
						nvVue.setProjection #ortho
					)
				#face: (
						if nom == unsupplied do	nom = "Face"							
						nvVue.setNom 		nom
						nvVue.setNorm 		[-1,0,0]
						nvVue.setProjection #ortho
					)
				#cote: (
						if nom == unsupplied do	nom = "Coté"							
						nvVue.setNom 		nom
						nvVue.setNorm 		[0,1,0]
						nvVue.setProjection #ortho
					)
				#3D: (
						if nom == unsupplied do	nom = "3D"							
						nvVue.setNom 		nom
						nvVue.setNorm 		[1,0,0]
						nvVue.setProjection #perspective
					)
				#camera: (
						if nom == unsupplied do	nom = "Caméra"							
						nvVue.setNom 		nom
						nvVue.setNorm 		[1,0,0]
						nvVue.setProjection #perspective
					)
			)
			
			--- ajout dans la liste des vues ---
			append 	m_vues 		nvVue
			nvVue
		),
		fn retirerVue _vue =(
			local IDrecherche = findItem m_vues _vue
			if IDrecherche != 0 do
				deleteItem m_vues IDrecherche
		),
		fn activerVue 	_vue =  (
			
			m_vueActive =  _vue 
			
			for vue in m_vues do (
				if _vue == vue then
					vue.activer ()
				else 
					vue.desactiver ()
			)
			
		),
		fn getActiveVue = m_vueActive,
			
		fn setActiveVueType  _type =(
			local controle = m_vueActive.getControle ()
			
			retirerVue 	m_vueActive
			
			nvVue = ajouterVue controle type:_type
			
			activerVue  nvVue
			this.actualiser 	vue:nvVue
			
		),
		
		
		
		---- Elements --------------------------------------------------------	
		fn getElements 		= m_elements,
		fn ajouterElement 	_element =(
			append m_elements 	_element
			_element
		),
		
		
		
		---- Affichage --------------------------------------------------------
		fn getAfficherInfos 	= m_afficherInfos,
		fn getAfficherGrille 	= m_afficherInfos,
		fn getMaximiser 		= m_maximiser,
		
		fn toggleInfos =(
			m_afficherInfos = not m_afficherInfos
			this.dessiner ()
		),
		fn toggleGrille =(
			m_afficherGrille = not m_afficherGrille
			dessiner ()
		),
		fn toggleMaximiserVue 	=(
			
			m_maximiser = not m_maximiser
			
			--- on met a jour tout ca ----
			this.actualiserEspaceDeTravail ()
			
			this.actualiser ()
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
		fn dessiner 	vue:  	fond:true =(		
			
			debug "dessiner"
			
			-- soit seulement l'ui passée en parametre ----
			if vue != unsupplied  then 			
				vue.dessiner  fond:fond	
			
			-- soit toutes les uis ----
			else 	for vue in m_vues do
				vue.dessiner  fond:fond
			
		),	
		fn actualiser vue: =(
			debug "Actualiser"
			dessiner vue:vue
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
							vue.setTailleControle 	m_taille
							vue.setPosControle 		m_pos
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
						
						vue.setTailleControle 	taille
						vue.setPosControle 		pos
						vue.montrer ()
						
						x += 1
						if x > 1 do (	y += 1 ; 	x = 0 )
						
					)
					
				) --- fin du false
			) -- fin du case
-- 			
-- 			--- on redessine tout -----
-- 			dessiner ()
			
		)
		
		
		
)	-- fin str_miniMax_MOTEUR -----
-- popo = str_miniMax_MOTEUR ()
