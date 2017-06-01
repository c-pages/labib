/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	Structs
	
	Regroupe differentes structures (potentielement réutilisables )
	-	gestionnaire de ListView dotnet
	-	gestionnaire de TreeView dotnet
	-	structure permetant de dragger un dialog
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [02/10/2016] -----------------------------------------------------------------------------
	- Mise en place globale 
########################################################################################################################*/



------------------------------------------------------------------------------
----------	recherche						--------------------------
------------------------------------------------------------------------------
struct str_recherche (
	
	
	------------ DEBUG	----------------------------------------------------------------------------------
-- 		m_debug = false,
		m_debug = true,
		m_dbgPrefix ="recherche",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
		
		
		
		
		
		m_prt,				---- le parent, le rollout ---- ( a initialiser ) ----	
		m_ui, 				---- le editTexte  a controler -- ( a initialiser ) ----
		m_arbo, 	
		m_edit,
		
		
		---- les boutons de souris dotNet ----
		m_btnsDotNet = dotNetClass "System.Windows.Forms.MouseButtons",
		
		--- options ----
		m_rechercheDansNoms 	= true,
		m_rechercheDansTags 	= false,
		m_recursif					= true,
		
		---- focus -----
		fn focus =(
			setFocus m_ui
		),
		
		
		fn chercherDansTags 	_aChercher	noeud:m_arbo.root   =(
			
			local result = #()
			local listeTags = noeud.getTagsArray ()
			
			for tag in listeTags do
				if findString tag  _aChercher != undefined do (
					appendIfUnique result  noeud
					continue
				)
				
			if m_recursif do
				for enfant in noeud.enfants do
					result += 	chercherDansTags 	_aChercher	noeud:enfant
			
			result
		),
		
		fn chercherDansNoms 	_aChercher		noeud:m_arbo.root   =(
						
			local result = #()
			
			if findString noeud.nom  _aChercher != undefined then
				append result  noeud
			
			if m_recursif do
				for enfant in noeud.enfants do
					result += 	chercherDansNoms 	_aChercher	noeud:enfant
			
			result
		),
		
		
		
		fn chercher 	_aChercher 	noeuds:#( m_edit.getDossier() )	=(
			
			toArray &noeuds
			
			local resultatsRecherche = #()
			if _aChercher != "" do (
				
				for noeud in noeuds do (
					
					local listeAChercher = filterString  _aChercher 	" "
					
					for motAChercher in listeAChercher where motAChercher != undefined do (
						
						--- chercher dans les NOMS des assets ----
						if m_rechercheDansNoms do
							resultatsRecherche +=		chercherDansNoms 		motAChercher  	noeud:noeud
						
						--- chercher dans les TAGS des assets ----
						if m_rechercheDansTags do
							resultatsRecherche +=		chercherDansTags 		motAChercher  noeud:noeud
						
					)
					
					debug "resultatsRecherche" var:resultatsRecherche param:#nom
					
				)
				
			)
			
			resultatsRecherche
			
		),
		
		
		fn estActif =(
			m_ui.text != ""
		),
		
		
		fn getResultat  noeuds:( m_edit.getDossier() )  =(		
			chercher 	m_ui.text 	noeuds:noeuds
		),
		
		fn actualiserResultats =(
			
			m_edit.actualiserListe ()
			
			-- la couleur passe en mode recherche --
			if estActif() then
				m_ui.BackColor 	= toCouleurDotnet 	m_prt.m_prefs.fenetre.col_uiFondRecherche 
			else
				m_ui.BackColor 	= toCouleurDotnet 	m_prt.m_prefs.fenetre.col_uiFond 
			
		),
		
		
		fn toggle_rechercheDansNoms =(
			m_rechercheDansNoms = not m_rechercheDansNoms
			if not m_rechercheDansNoms do
				m_rechercheDansTags = true
			
			-- actualiser resultats --			
			actualiserResultats ()
		),
		fn toggle_rechercheDansTags =(
			m_rechercheDansTags = not m_rechercheDansTags
			if not m_rechercheDansTags do
				m_rechercheDansNoms = true
			
			-- actualiser resultats --		
			actualiserResultats ()
		),
		fn toggle_recursif =(
			m_recursif = not m_recursif
			
			-- actualiser resultats --		
			actualiserResultats ()
		),
		
		
		--- souris ---
		fn clq_up 			_arg 			= (
			debug "clq_up"
			
				
			
			case _arg.button of (
				(m_btnsDotNet.Left): 		()
				(m_btnsDotNet.Middle): 	()
				(m_btnsDotNet.None): 		()
				(m_btnsDotNet.Right): 		m_prt.m_menus.recherche ()
				(m_btnsDotNet.XButton1): 	()
				(m_btnsDotNet.XButton2):	()
			)
		),
		
		
		---- clavier ----		
		fn key_up				_arg =(
			keyCode = _arg.KeyCode
			local touches = dotnetclass  "System.Windows.Forms.Keys"
			
			
			case keyCode of (
				-- renommer --
				( touches.Tab ): 		(
					debug "TAB"
					if _arg.shift then m_prt.focusPrecedant ()
									else  m_prt.focusSuivant ()
				)
				
				( touches.Enter ): 	actualiserResultats () -- chercher m_ui.text
				( touches.Escape ):  m_prt.focusSuivant ()
				
				
				-- undo --
				( touches.Z ): 		if _arg.Control do	debug "UNDO" 
				-- undo --
				( touches.Y ): 		if _arg.Control do	debug "REDO" 
				
				--defaut--
				default:	actualiserResultats ()
					
				
			)
				
		),
		
		
		fn viderRecherche =(
			m_ui.text = ""
			actualiserResultats ()
			
		)
		
		/* ,
		fn textChange _arg =(
			
			debug "textChange"
		) */
		
)


------------------------------------------------------------------------------
----------	chrono						--------------------------
------------------------------------------------------------------------------
struct str_chrono (
	private
		tempsDebut,
		tempsFin,
		duree,
		fn arreter = (
			tempsFin 	= timeStamp ()
			duree 		= ((tempsFin - tempsDebut) / 1000.0)
		),
	public
		fn demarrer =(
			tempsDebut = timeStamp ()
		),
		fn getDuree =(
			arreter ()
			duree
		)
)


------------------------------------------------------------------------------
----------	Historique						--------------------------
------------------------------------------------------------------------------
struct str_historique (
	
	------------ DEBUG	----------------------------------------------------------------------------------

		m_debug = false,
		m_dbgPrefix ="hist",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	
	
	public
	---- pointeurs ----
		m_dialog,
		m_edit,
	
		m_TV,
		m_LV,
	
	private
		m_pos =1,
		m_pile = #(),
		
	
	
		
	public
		fn enregistrer 	 _noeudAEnregistrer	=(
			
			debug "enregistrer"
			debug "_noeudAEnregistrer" 	var:_noeudAEnregistrer	param:#nomUnique
			
			-- on enregistre si noeud courant est differents --
			if _noeudAEnregistrer != m_pile[1] do ( 
				
				local noeudACourant = _noeudAEnregistrer
				
				--on tronque l'historique a l'emplacement courant
				while m_pos > 1 do (
					if m_pile.count > 0 do
						deleteItem 	m_pile		1
					m_pos -= 1
				)
				
				-- on ajoute le noeud actuel dans l'historique --
				insertItem 		noeudACourant 	m_pile 	1
			)
			debug "" var:m_pile	param:#nomUnique
		),
		-- se deplacer dans l'historque ---
		fn seDeplacer  _sens =(
			debug "seDeplacer"
			debug "pile" var:m_pile	param:#nomUnique
			debug "pos" var:m_pile[m_pos]	param:#nomUnique
			
			-- on gere la position  dans l'historique ---
			local posMax =  m_pile.count 
			local hist_posBack = m_pos
			m_pos += _sens
			
			-- on limite la position --
			if m_pos > posMax	do m_pos = posMax
			if m_pos < 1			do m_pos = 1
			
			-- on ouvre le noeud adequate ---
			local noeudAOuvrir = m_pile[ m_pos   ]
			m_edit.ouvrir   			noeudAOuvrir 	enregistrer_historique:false
-- 			m_TV.selectionner 	noeudAOuvrir
			
-- 			-- on selectionne le dossier precedant si il est dans la LV --
-- 			if m_pile[ m_pos ] == m_pile[ hist_posBack ].parent do
-- 				m_LV.selectionner 	m_pile[ hist_posBack ]
			
		),
		fn  checkSelection =(
			
			-- on selectionne le dossier precedant si il est dans la LV --
			if m_pile.count > 1 do
				if m_pile[ 1 ] == m_pile[ 2 ].parent do
					m_LV.selectionner		m_pile[ 2 ]
			
		)
	
	
)
	




------------------------------------------------------------------------------
----------	dragger une fenetre 					--------------------------
------------------------------------------------------------------------------
struct str_drag (
	
	m_prt, --- le rollout a drager
	
	posOrigineSouris 		= [0,0],
	posOrigineFenetre 	= [0,0],
	enCours 				= false,
	
	fn demarrer 	=(
		enCours 				= true
		posOrigineSouris		= mouse.screenpos 
		posOrigineFenetre 	= GetDialogPos 	m_prt
	),
	fn arreter  	=(
		enCours 				= false
	),
	fn suivreSouris 	 	=(
		if enCours  do (			
			local ecart = ( mouse.screenpos  - posOrigineSouris )
-- 			if not m_prt.inViewport do
			SetDialogPos  m_prt	( posOrigineFenetre + ecart )
		)
	)
	
) -- fin struct drag --

------------------------------------------------------------------------------
----------	Bouton virtuel 						--------------------------
------------------------------------------------------------------------------
struct str_btnVirtuel (
	---- membres ----
	pos 			= [0,0],
	width 		= 0,
	height 		= 0,
	
	pressed 		= false,
	posPress 	= [0,0],
	posOrigine 	= [0,0],
	
	---- fonctions ----
	fn bouge _decallage = (
		pos	= posOrigine + _decallage
	),
	fn survole _pos =(
		local result = false
		if _pos.x > pos.x	and _pos.x < pos.x + width do
			if _pos.y > pos.y	and _pos.y < pos.y + height do
				result = true
		result
	)
	
)



