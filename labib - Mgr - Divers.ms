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
----------	chrono						--------------------------
------------------------------------------------------------------------------
struct str_chrono (
	tempsDebut,
	fn demarrer =(
		tempsDebut = timeStamp ()
	),
	fn ecrireDuree = (
		local tempsFin 	= timeStamp ()
		local duree 		= ((tempsFin - tempsDebut) / 1000.0)
		ecrire ( "Durée de l'opération : " + duree as string  + "s." )   
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
	
	m_prt, 
	
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



