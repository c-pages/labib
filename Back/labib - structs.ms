/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	Structs
	
	Regroupe differentes structures (potentielement r�utilisables )
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
		ecrire ( "Dur�e de l'op�ration : " + duree as string  + "s." )   
	)

)


------------------------------------------------------------------------------
----------	Historique						--------------------------
------------------------------------------------------------------------------
struct str_historique (
	
		m_prt,
		m_pos =1,
		m_pile = #(),
	
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
		),
		-- se deplacer dans l'historque ---
		fn seDeplacer  _sens =(
			
			-- on gere la position  dans l'historique ---
			local posMax =  m_pile.count 
			local hist_posBack = m_pos
			m_pos += _sens
			
			-- on limite la position --
			if m_pos > posMax	do m_pos = posMax
			if m_pos < 1			do m_pos = 1
			
			-- on ouvre le noeud adequate ---
			local noeudAOuvrir = m_pile[ m_pos   ]
			m_prt.ouvrirBranche   noeudAOuvrir	enregistrer:false
			m_prt.m_TV.selectionner 	noeudAOuvrir
			
			-- on selectionne le dossier precedant si il est dans la LV --
			if m_pile[ m_pos ] == m_pile[ hist_posBack ].parent do
				m_prt.m_LV.selectionner 	m_pile[ hist_posBack ] 
			
		)
	
	
)
	




------------------------------------------------------------------------------
----------	dragger une fenetre 					--------------------------
------------------------------------------------------------------------------
struct str_drag (
	
	fenetre, 
	
	posOrigineSouris 		= [0,0],
	posOrigineFenetre 	= [0,0],
	enCours 				= false,
	
	fn demarrer 	=(
		enCours 				= true
		posOrigineSouris		= mouse.screenpos 
		posOrigineFenetre 	= GetDialogPos 	fenetre
	),
	fn arreter  	=(
		enCours 				= false
	),
	fn suivreSouris 	 	=(
		if enCours  do (			
			local ecart = ( mouse.screenpos  - posOrigineSouris )
			SetDialogPos  fenetre	( posOrigineFenetre + ecart )
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



