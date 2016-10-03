
/*#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	la gestion de l'arborescence de la bibliotheque.	
##########################################################################################################################*/



-------------------------------------------------------------------------------------------------------------------
------- Les composites de l'arborescence ----------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
-------  L'ELEMENT		----------------------------------
--------------------------------------------------------------
-- 	un élément  est une feuille (composite) 				--
-- 	peut representer une image, un fichier max ...		--
--------------------------------------------------------------
struct str_element (
	
	------------ Les membres	----------------------------------------------------------------------------------
	---- parametres globaux----
		m_prt, ---- pointeur vers arbo ---
	
	
	
	---- parametres de l'element ----
	public
		nomUnique 				= "",										---- NomUnique de l'élément, ne doit jamais y avoir 2 element avec le mm nomUnique !!! ---
		nom 						= "nom",								---- le nom affiché de l'élément ---
		type						= "",										---- le type d'asset ( #vide, #model, #material, #map ) ----
		fichier					= "",										---- l'adresse du fichier vers l'asset original ----
		proxy						= "",										---- l'adresse du fichier max contenant le proxy ----
		apercu					= "",										----  ----
		detail						= "",										----  ----
		tags						= "",										----  ----
		commentaires			= "",										----  ----
		dateCreation 			= getLocalTime(),					---- Date de création de l'asset ----
		dateDernierImport 	= #(0, 0, 0, 0, 0, 0, 0, 0),		----  ----
		nbrImports				= 0,										----  ----
		nbrVertex				= 0,										----  ----
		
	
	---- le composite ----
	public
		parent 					= undefined,
		enfants 					= #(),		-- toujours vide --
		
	------------ Les fonctions	----------------------------------------------------------------------------------
	---- Manipulations Composite ----
	public
	
		
		----fichier ---
		fn enregistrer =	m_prt.ecrireNoeud this,
		fn retirerDuFichier =	m_prt.supprimerNoeud this,
		
		fn ajouterEnfant 	_enfant 	= (),
		fn definirParent 	_parent 	= ( parent = _parent ),
		fn retirer  			 = (
			if parent != undefined then (
				
				deleteFile apercu
				deleteFile detail
				deleteFile proxy
				deleteFile ( getFilenamePath  proxy + getFilenameFile  proxy + ".cgeo" )
				
				_index  = findItem parent.enfants this
				if _index != 0 do deleteItem   parent.enfants 	_index
				parent = undefined
				
				
				return this
			) else return undefined
		),
		
		fn supprimer  			 = (
			
			-- on le supprime dans le parent --
			if parent != undefined do (
					debug "on le supprime dans le parent" var:parent.nom
				local index  = findItem parent.enfants 	this
				if index != 0 do deleteItem   parent.enfants 	index
			)
			
			--- on le retire du fichier --
			retirerDuFichier ()
			
			--- on suprrime les enfants du chichier ----
			for enfant in enfants 
				do enfant.supprimer  ()
			
		),
		
		fn compterElements = (
			i=0
			if classof this == str_element do  i+=1
			return i
		),
		fn getNbrEnfants 	= ( return 0),	--- n'as pas d'enfants ---
		fn getIndexUnique 	= ( substring nomUnique 2 -1 as integer ),
		
		fn getElements 		=	return #(),	--- n'as pas d'enfants ---
		fn getNoeuds 			= return #(),		--- n'as pas d'enfants ---
		
		
		---- tags ----
		fn possedeTag 	_tagAChercher  =(
			
			local listeDesTags = filterString  tags 	m_prt.m_tagsSeparateurs
			local result = false
			
			for tag in listeDesTags while not result do 
				if tag == _tagAChercher do result = true
			
			result
		),
		
		----- accesseurs -----
		fn getNbrVertex 				= nbrVertex as string,
		fn getNbrImports 			= nbrImports as string,
		fn getDateDernierImport 	= m_prt.dateToString 	dateDernierImport,
		fn getDateCreation 			= m_prt.dateToString 	dateCreation,
		fn getAProxy 					= if proxy != undefined then "oui" else "non",
		fn getAVueDetail 				= if detail != undefined then "oui" else "non"
		
		
		
)	-- fin Struct Element



--------------------------------------------------------------
-------  LE NOEUD		----------------------------------
--------------------------------------------------------------
-- 	un Noeud est une branche (composite) 				--
-- 	permettant de classer les differents elements 	--
--------------------------------------------------------------
struct str_branche (
	
	------------ Les membres	----------------------------------------------------------------------------------
	-- parametre du branche --
	public
		m_prt, ---- pointeur vers arbo ---
	
		nomUnique 	= "",
		nom 				= "nom du branche",
		
		
	-- le composite --
	public
		parent  			= undefined ,
		enfants 			= #(),
		estExpanded	= false,
	
	------------ Les fonctions	----------------------------------------------------------------------------------	
	---- Manipulations Composite ----	
	public
	
		----fichier ---
		fn enregistrer =	m_prt.ecrireNoeud this,
		fn retirerDuFichier =	m_prt.supprimerNoeud this,
	
	
		fn ajouterEnfant 		_enfant 	= (
			append enfants 	_enfant 
			_enfant.retirer()
			_enfant.definirParent ( this )
		),		
		fn definirParent 	_parent 	= ( parent = _parent ),		
		fn retirer  			 = (
			
			if nomUnique != "ROOT" and nomUnique != "RECHERCHE" then (
				for enfant in enfants do 
					enfant.retirer()
				
				-- on le supprime dans le parent --
				if parent != undefined do (
					_index  = findItem parent.enfants this
					if _index != 0 do deleteItem   parent.enfants 	_index
					parent = undefined
				)
				
				
				return this
			) else return undefined
			
			
		),
		fn supprimer  			 = (
			
			if nomUnique != "ROOT" and nomUnique != "RECHERCHE" then (
				
				-- on le supprime dans le parent --
				if parent != undefined do (
					debug "on le supprime dans le parent" var:parent.nom
					local index  = findItem parent.enfants this
					if index != 0 do deleteItem   parent.enfants 	index
				)
				
				--- on le retire du fichier --
				retirerDuFichier ()
				
				--- on suprrime les enfants du chichier ----
				for enfant in enfants 
					do enfant.supprimer  ()
				
				
			) 
			
		),
		
		fn compterElements = (
			local i=0
			for enfant in enfants do 
					i+= enfant.compterElements ()
			return i
		),
		fn getNbrEnfants 	= ( return compterElements () ),
		fn getIndexUnique 	= ( substring nomUnique 2 -1 as integer ) ,
	
		fn getElements 		= for enfant in enfants where classof enfant == str_element 	collect enfant,
		fn getNoeuds 			= for enfant in enfants where classof enfant == str_branche 		collect enfant,
		
		
		----- accesseurs -----
		fn getNbrVertex 				= "",
		fn getNbrImports 			= "",
		fn getDateDernierImport 	= "",
		fn getDateCreation 			= "",
		fn getAProxy 					= "",
		fn getAVueDetail 				= ""
		
)	-- fin Struct branche



--------------------------------------------------------------
-------  L'ARBORESCENCE -------------------------------
--------------------------------------------------------------
-- 	permet de gerer les branches et elements. 			--
-- 	de lire ou ecrire l'arbo dans un fichier INI.		--
-- 	faire des recherches (tags, nom, fichier... 			--
--------------------------------------------------------------
struct str_arborescence (

	------------ 	MEMBRES	----------------------------------------------------------------------------------	
	public
	---- quelques noeuds ----
		root,				---- le noeud racine de toute la bibliotheque -----
		recherche,		---- le noeud contenant les resultat en cas de recherche utlisateur -----	
		retour		=	str_branche	m_prt:			this 		\	---- le noeud afficher parmis les élément pour acceder au dossier parent -----	
												nom:			"..." 			\
												parent:		undefined 	\
												nomUnique:	"RETOUR",			
	
	---- l'emplacement du fichier ----
		fichierArbo  ,			---- l'adresse du fichier ini de l'arborescence -----	
	
	private
	---- noms uniques ----
		indexUnique 					= 0,		---- le compteur d'éléments de la biblio pour gerer les nom uniques-----
		prefixNomUnique_branche 	= "N",
		prefixNomUnique_element 	= "E",	
		
	----  pour Affichage dans listener -----	
		indent 		= 0,
		tab 			= 	"    ",
		decallage 	=	"",
		
	---- tags ----
		m_tagsSeparateurs	=	", -/.;",
		
	------------ 	FONCTIONS		----------------------------------------------------------------------------------	
			
	---- les noms uniques -----
	private
		fn creerNomUnique_branche 	= return prefixNomUnique_branche 	+ (indexUnique += 1 ) as string,
		fn creerNomUnique_element 	= return prefixNomUnique_element + (indexUnique += 1 ) as string,
			-------- GESTION DU FICHIER INI --------
	public
		fn ecrireNoeud  _noeud 					= (
			-- param communs --
			setINISetting   fichierArbo	_noeud.nomUnique   "nom"  _noeud.nom
			setINISetting   fichierArbo	_noeud.nomUnique   "parent"  ( if _noeud.parent ==undefined then "undefined" else _noeud.parent.nom)
			
			case classOf _noeud  of (
				str_branche: (
					setINISetting   fichierArbo	_noeud.nomUnique   "composite"  		#branche
					setINISetting   fichierArbo	_noeud.nomUnique   "estExpanded"  	( estExpanded as string )
					
					-- les enfants --
					_enfants = ""
					for enfant in _noeud.enfants do
						_enfants += enfant.nomUnique + ";"
					setINISetting   fichierArbo	_noeud.nomUnique   "enfants"  _enfants
					
					-- recusrcivité --
					for enfant in _noeud.enfants do ecrireNoeud  enfant 
				)
				str_element: (
					setINISetting   fichierArbo	_noeud.nomUnique   "composite"  #feuille
					
					setINISetting   fichierArbo	_noeud.nomUnique   "type"  				( _noeud.type		as string	)
					setINISetting   fichierArbo	_noeud.nomUnique   "fichier"  			( _noeud.fichier		as string	)
					setINISetting   fichierArbo	_noeud.nomUnique   "apercu"  			( _noeud.apercu	as string	)
					setINISetting   fichierArbo	_noeud.nomUnique   "detail"  				( _noeud.detail		as string	)
					setINISetting   fichierArbo	_noeud.nomUnique   "commentaires"  	( _noeud.commentaires		as string	)
					setINISetting   fichierArbo	_noeud.nomUnique   "tags"  				( _noeud.tags		as string	)
					setINISetting   fichierArbo	_noeud.nomUnique   "proxy"  				( _noeud.proxy		as string	)					
					
					setINISetting   fichierArbo	_noeud.nomUnique   "dateCreation"  			( _noeud.dateCreation as string )
					setINISetting   fichierArbo	_noeud.nomUnique   "dateDernierImport"  	( _noeud.dateDernierImport as string )
					setINISetting   fichierArbo	_noeud.nomUnique   "nbrImports"  			( _noeud.nbrImports as string )
					setINISetting   fichierArbo	_noeud.nomUnique   "nbrVertex"  				( _noeud.nbrVertex as string )
					
				)
			)
			
		),
		
		fn supprimerNoeud _noeud =(
			-- on supprime du fichierArbo --
			delINISetting   fichierArbo	_noeud.nomUnique
		),
		
		
	-------- GESTION DE L'ARBO --------
	---- Creation des nouveaux élements ou branches ----
	public
		fn creerNoeud  	nom:"Nouvel branche" 	parent:root 	nomUnique:( creerNomUnique_branche () )	=( 			
			local		nouveauNoeud = str_branche m_prt:this		
			
			---- Remplissage des parameteres du nouveau branche 	----
			if parent != undefined do
				parent.ajouterEnfant 	 nouveauNoeud
			
			nouveauNoeud.nom 			= nom
			nouveauNoeud.nomUnique	= nomUnique
			
			nouveauNoeud			
		),
		fn creerElement 	nom:"Nouvel élément" 	parent:root  	nomUnique:( creerNomUnique_element () )	type:#vide		fichier:""		apercu:""	tags:""	=( 
			local		nouvelElement = str_element	m_prt:this	
			
			---- Remplissage des parameteres du nouvel element----
			if parent != undefined do 
				parent.ajouterEnfant 	nouvelElement
			
			nouvelElement.nom 			= nom
			nouvelElement.nomUnique	= nomUnique
			nouvelElement.type 			= type
			nouvelElement.fichier		= fichier
			nouvelElement.apercu		= apercu
			nouvelElement.tags			= tags
			
			nouvelElement
		),	
		
		
	private
		fn lireNoeud 	_nomUnique 	_parent 	= (
			debug "lireNoeud"
			debug "noeud" var:_nomUnique
			local nouveauNoeud
			
			if hasINISetting fichierArbo 	_nomUnique 	then (
				
				_composite = getINISetting   fichierArbo	_nomUnique   "composite"
				case _composite of (
					"feuille":( 
						local type 			= getINISetting   fichierArbo	_nomUnique   "type"  
						local nom 			= getINISetting   fichierArbo	_nomUnique   "nom"  
						local fichier 		= getINISetting   fichierArbo	_nomUnique   "fichier"  
						local apercu 		= getINISetting   fichierArbo	_nomUnique   "apercu"				
						
						nouveauNoeud = creerElement 	nom:nom  type:type	fichier:fichier  apercu:apercu	nomUnique:_nomUnique parent:_parent
						
						nouveauNoeud.commentaires	= getINISetting   fichierArbo	_nomUnique   "commentaires"
						nouveauNoeud.tags 				= getINISetting   fichierArbo	_nomUnique   "tags"
						nouveauNoeud.detail 			= getINISetting   fichierArbo	_nomUnique   "detail"
						nouveauNoeud.proxy 			= getINISetting   fichierArbo	_nomUnique   "proxy"
						
						nouveauNoeud.dateCreation 			= execute ( getINISetting   fichierArbo	_nomUnique   "dateCreation" )
						nouveauNoeud.dateDernierImport 	= execute ( getINISetting   fichierArbo	_nomUnique   "dateDernierImport" )
						
						dateTmp = getINISetting   fichierArbo	_nomUnique   "dateDernierImport"
						
						debug ""
						debug ""
						debug "_nomUnique"  var:_nomUnique
						debug "fichierArbo"  var:fichierArbo
						debug "dateDernierImport" var:nouveauNoeud.dateDernierImport
						debug "dateTmp"  var:dateTmp
						debug ""
						debug ""
						nouveauNoeud.nbrImports 			= ( getINISetting   fichierArbo	_nomUnique   "nbrImports" ) as integer
						nouveauNoeud.nbrVertex 				= ( getINISetting   fichierArbo	_nomUnique   "nbrVertex" ) as integer
					
					)
					"branche":(
						
						local nom 							= getINISetting   fichierArbo	_nomUnique   "nom"  
						local enfantsNomsUniques 	= filterString 		(getINISetting   fichierArbo	_nomUnique   "enfants" )  ";"	
						local enfants =#()
						
						nouveauNoeud 					= creerNoeud 	nom:nom   nomUnique:_nomUnique  parent:_parent
						nouveauNoeud.estExpanded 	=  ( if ( getINISetting   fichierArbo	_nomUnique   "estExpanded" )  == "true" then true else false )  
					
						for enfantNomUnique in enfantsNomsUniques do 
							append enfants ( lireNoeud   enfantNomUnique 		nouveauNoeud )
						
						nouveauNoeud.enfants = enfants
						
					)
				) -- fin case
				
				return nouveauNoeud
				
			) else (
				ecrire "ERREUR:	le noeud n'est pas dans le fichier INI\n"
				ecrire "noeud" var:_nom 
				ecrire "fichier" var:fichierArbo 
			)
			debug "nouveauNoeud" var:nouveauNoeud
			
			nouveauNoeud
		),	
		
	public
		
		
		---- Supprimer un element de l'arbo ----
		fn supprimer  _noeuds 	= (
			
			if classof _noeuds != Array 	do _noeuds =#(_noeuds)
			
			for noeud in _noeuds do 	noeud.supprimer()
			
		),
		
	---- initialiser l'arborescence de tout ses éléments ----
		fn initialiser = (
			root 			= str_branche 	m_prt:this	nom:"Labib"	nomUnique:"ROOT"			
			recherche	= str_branche  	m_prt:this	nom:"RECHERCHE"	nomUnique:"RECHERCHE"
			
			nbrElements 		= 0
			nbrNoeuds 			= 0
			indexUnique 		= 0
		),
	---- deplacer un noeud dans l'arbo ----
		fn deplacer 	_elements	_noeudDest = (
			for element in _elements do(
				_noeudDest.ajouterEnfant 	element
			)
			enregistrer()
		),
	
	
		
	private
		fn enregistrer 	= (
			debug "<arbo>		enregistrement"
			setINISetting   fichierArbo	"params"   "indexUnique"  ( indexUnique as string )
			ecrireNoeud Root
		),	
		
		fn charger = (
			debug "<arbo>		chargement"
			
			initialiser()
			
			---- si existe pas on initialise le fichierArbo ----
			if not doesFileExist fichierArbo then enregistrer ()
			---- sinon on charge ----
			else (
				
				indexUnique = ( getINISetting   fichierArbo	"params"   "indexUnique" ) as integer
				root = lireNoeud   "ROOT" 	undefined
			)
			_root
		),
	
	
	-------- ACCEDER AUX NOEUDS --------		
	public
		fn getParFichier 			_fichier  		noeud:root	= (
			
			local result 	= undefined
			
			case classOf noeud of (
				str_element:	if noeud.fichier == _fichier	do result =  noeud
				str_branche:		(					
					local trouve 	= false
					for enfant in noeud.enfants while not trouve	do (	
							result =  getParFichier 	_fichier	 	noeud:enfant
							if result != undefined do 	trouve = true
						)						
					) -- fin case str_branche ---					
			) -- fin case of --
			
			result
		),
		fn getParNomUnique 	_nomUnique  	noeud:root	= (
			
			local result 	= undefined
			
			case 	_nomUnique of (
				
				"RECHERCHE" : 	result = recherche
				
				"RETOUR" : 			result = retour
				
				default: (
					if noeud.nomUnique == _nomUnique	
						then result =  noeud
						else	if classOf noeud ==	str_branche do	(		
							local trouve 	= false
							for enfant in noeud.enfants while not trouve	do (
									result =  getParNomUnique 	_nomUnique	 	noeud:enfant
									if result != undefined do 	trouve = true
								)						
							) -- fin if classof --
				)
			)
			
			
			result
			
		),
		fn getParNom 				_nom 			noeud:root 	= (
			
			debug "getParnom" var:_nom
			debug "noeud" var:noeud.nom
			
			local result = #()
			
			case classOf noeud of (
				str_element:	if noeud.nom == _nom			do (
											debug "## TROUVE ###"
											append	result 	noeud
										)
				str_branche:		for enfant in noeud.enfants 	do result +=  getParNom 	_nom	 noeud:enfant 
			)
			
			result
		),
	---- Recuperer tout les elements ----
		fn getElements 	noeud:root 	recursif:false	= (
	
			local elements = #()
			
			case classOf noeud of (
				str_element:	() --- append 	elements 	noeud
				str_branche:		(
					elements += for enfant in noeud.enfants where classof enfant == str_element collect  enfant
					if recursif do for enfant in noeud.enfants do  elements += 	getNoeuds 	noeud:enfant	recursif:true
				)
			)
			
			elements
			
		),	
	---- Recuperer tout les noeuds ----
		fn getNoeuds 	noeud:root 	recursif:false	= (
	
			local elements = #()
			
			case classOf noeud of (
				str_element:	() --- append 	elements 	noeud
				str_branche:		(
					elements += for enfant in noeud.enfants where classof enfant == str_branche collect  enfant
					if recursif do for enfant in noeud.enfants do  elements += 	getNoeuds 	noeud:enfant	recursif:true
				)
			)
			
			elements
			
		),	
	---- Savoir si un fichier est deja present dans l'arbo	----
		fn dejaPresent  		_fichier 	= (
			if  getParFichier 	_fichier != undefined 	then 	true 
																	else 		false
		),
	

	-------- ACCEDER AUX TAGS --------
	---- recherche de tags ----
	public
		fn chercherTags 	_tagsAChercher	noeud:root  =	(
			
			local	elemsResult 		= #()			
			local	tagsAChercher 	= filterString	_tagsAChercher 	m_tagsSeparateurs
			local	elementsTotal 	= getElements 	recursif:true
			
			for tagAChercher in tagsAChercher do
				for elem in elementsTotal do 
					if elem.possedeTag  tagAChercher 
						do appendifunique elemsResult 	elem
			
			elemsResult
		),
	---- acceder aux tags ----
	public
		fn getTags  noeud:root = (
			
			local result 	= #()
			case classOf noeud of (
				str_element:(
					local listTagsDuNoeud = filterString 	noeud.tags 	m_tagsSeparateurs
					for tag in listTagsDuNoeud do 
						appendifunique 	result 	tag
				)
				str_branche:
					for enfant in noeud.enfants do (
						tags 	= getTags		noeud:enfant			
						for tag in tags do
							appendifunique 	result 	tag
					)
			) -- fin case of --
			
			result
		),
	
	
	-------- CLASSEMENT DIVERS --------
	private
		fn sortParNbrImports 		elem1  elem2 = (
			case of
			(
				(elem1.nbrImports < elem2.nbrImports): -1
				(elem1.nbrImports > elem2.nbrImports): 1
				default: 0
			)
		),
		fn sortParNbrImportsInv 	elem1  elem2 = (
			case of
			(
				(elem1.nbrImports < elem2.nbrImports): 1
				(elem1.nbrImports > elem2.nbrImports): -1
				default: 0
			)
		),
		fn sortParVertex 				elem1  elem2  = (
			case of
			(
				(elem1.nbrVertex < elem2.nbrVertex): -1
				(elem1.nbrVertex > elem2.nbrVertex): 1
				default: 0
			)
		),
		fn sortParVertexInv 		elem1  elem2  = (
			case of
			(
				(elem1.nbrVertex < elem2.nbrVertex): 1
				(elem1.nbrVertex > elem2.nbrVertex): -1
				default: 0
			)
		),
		fn sortParNom 				elem1  elem2 = (
			case of
			(
				(elem1.nom < elem2.nom): -1
				(elem1.nom > elem2.nom): 1
				default: 0
			)
		),		
		fn sortParNomInv 			elem1  elem2 = (
			case of
			(
				(elem1.nom < elem2.nom): 1
				(elem1.nom > elem2.nom): -1
				default: 0
			)
		),
		fn compareDate 				elem1  elem2 = (
			
			for i= 1 to elem1.dateCreation.count	 do 
			(
				
				case of
				(
					(elem1.dateCreation[i] < elem2.dateCreation[i]): return -1
					(elem1.dateCreation[i] > elem2.dateCreation[i]): return 1
-- 					default: if  i != elem1.dateCreation.count  then continue else 0
				)
			)
			0
		),
		fn sortParCreation 			elem1  elem2 = (
-- 			case of
-- 			(
-- 				(elem1.nom < elem2.nom): -1
-- 				(elem1.nom > elem2.nom): 1
-- 				default: 0
-- 			) 
			return compareDate elem1  elem2
		),
		fn sortParCreationInv 		elem1  elem2 = (
			
			return compareDate elem1  elem2
		),
	public
		fn classerCreation 		_elements 	ordreInverse:false	 = (
			case ordreInverse of (
				false:	qsort 	_elements 	sortParCreation
				true:		qsort 	__elements 	sortParCreationInv
			)
-- 			enregistrer()
-- 			afficher()
		),
		fn classerNbrImports 	_elements 	ordreInverse:false	 = (
			case ordreInverse of (
				false:	qsort 	_elements 	sortParNbrImports
				true:		qsort 	_elements 	sortParNbrImportsInv
			)
-- 			enregistrer()
-- 			afficher()
		),
		fn classerVertex 			_elements 	ordreInverse:false	 = (
			case ordreInverse of (
				false:	qsort 	_elements 	sortParVertex
				true:		qsort 	_elements 	sortParVertexInv
			)
-- 			enregistrer()
-- 			afficher()
		),
		fn classerNoms 			_elements 	ordreInverse:false	 = (
			case ordreInverse of (
				false:	qsort 	_elements 	sortParNom
				true:		qsort 	_elements 	sortParNomInv
			)
-- 			enregistrer()
-- 			afficher()
		),
	
	
	-------- manipulations diverses --------
	public
		fn dateToString 	_date = (
			if _date != undefined then (
				local result 
				
				zeroJour 	= if _date[4] <10 then  "0"  else ""
				zeroMois 	= if _date[2] <10 then  "0"  else ""
				zeroH 		= if _date[5] <10 then  "0"  else ""
				zeroM 		= if _date[6] <10 then  "0"  else ""
				zeroS 		= if _date[7] <10 then  "0"  else ""
				if _date[4] != 0 then 
					result = zeroJour + _date[4] as string + "/"  + zeroMois + _date[2] as string+ "/"  + _date[1] as string + "  "  + zeroH + _date[5] as string + ":"  + zeroM  + _date[6] as string + ":"  +zeroS + _date[7] as string 
				else 
					result = ""
				
			) else result = ""
			result
		),
	
	
	-------- AFFICHAGE de l'arbo dans le listener --------
	public
		fn afficherNoeud 	_noeud = (
			decallage =""
			for i = 0 to indent do
				decallage += tab
			
			format "%> nom: %\n" 			decallage	_noeud.nom
			format "%  nomUnique: %\n" 	decallage	_noeud.nomUnique		
			format "%  parent: %\n" 		decallage	(_noeud.parent as string)	
			format "%  enfants: %\n" 		decallage	(_noeud.enfants as string)			
			
			for enfant in _noeud.enfants do (
				indent += 1
				afficherNoeud 	enfant
				indent -= 1
			)
		),
			
		fn afficher = (
			format "\n----- Arborescence --------------\n"
			afficherNoeud root
			format "----- Arborescence --------------\n\n"
		),
	
	
	------------ EVENEMENTS	----------------------------------------------------------------------------------	
	private
		on create do (
			initialiser ()
			
			-- on verifie qu'il existe sinon on creer un vierge ------
			if not doesfileexist fichierArbo then (
				debug "fichier absent, création du fichier"		var:fichierArbo
				initialiser()			
				enregistrer()
			) 		
			
			charger()
			debug "<arbo>		Structure crée."
		)
	 
	
)	-- fin Struct Arborescence




















































