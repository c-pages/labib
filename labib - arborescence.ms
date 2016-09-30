
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
struct Element_struct (
	
	------------ Les membres	----------------------------------------------------------------------------------
	---- parametres globaux----
		separateursTags 		= ",-/.;",								---- characteres servants de séparateurs dans la liste des tags -----
	
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
		enfants 					= #(),		
		
	------------ Les fonctions	----------------------------------------------------------------------------------
	---- Manipulations Composite ----
	public
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
		
		fn compterElements = (
			i=0
			if classof this == Element_struct do  i+=1
			return i
		),
		fn getNbrEnfants = ( return 0),
		fn getIndexUnique = ( substring nomUnique 2 -1 as integer ),
		
		---- tags ----
		fn possedeTag 	_tagAChercher =(
			
			local listeDesTags = filterString  tags 	separateursTags
			local result = false
			
			for tag in listeDesTags while not result do 
				if tag == _tagAChercher do result = true
			
			result
		)
		
		
)	-- fin Struct Element



--------------------------------------------------------------
-------  LE NOEUD		----------------------------------
--------------------------------------------------------------
-- 	un Noeud est une branche (composite) 				--
-- 	permettant de classer les differents elements 	--
--------------------------------------------------------------
struct Noeud_struct (
	
	------------ Les membres	----------------------------------------------------------------------------------
	-- parametre du noeud --
	public
		nomUnique 	= "",
		nom 				= "nom du noeud",
		
		
	-- le composite --
	public
		parent  			= undefined ,
		enfants 			= #(),
		estExpanded	= false,
	
	------------ Les fonctions	----------------------------------------------------------------------------------	
	---- Manipulations Composite ----	
	public
		fn ajouterEnfant 		_enfant 	= (
			append enfants 	_enfant 
			_enfant.retirer()
			_enfant.definirParent ( this )
		),		
		fn definirParent 	_parent 	= ( parent = _parent ),		
		fn retirer  			 = (
			if parent != undefined then (
				for enfant in enfants do 
					enfant.retirer()
				
				_index  = findItem parent.enfants this
				if _index != 0 do deleteItem   parent.enfants 	_index
				parent = undefined
				return this
			) else return undefined
		),
		
		fn compterElements = (
			local i=0
			for enfant in enfants do 
					i+= enfant.compterElements ()
			return i
		),
		fn getNbrEnfants 	= ( return compterElements () ),
		fn getIndexUnique 	= ( substring nomUnique 2 -1 as integer ) 
	
)	-- fin Struct noeud



--------------------------------------------------------------
-------  L'ARBORESCENCE -------------------------------
--------------------------------------------------------------
-- 	permet de gerer les noeuds et elements. 			--
-- 	de lire ou ecrire l'arbo dans un fichier INI.		--
-- 	faire des recherches (tags, nom, fichier... 			--
--------------------------------------------------------------
struct Arborescence_struct (
	
	------------ 	MEMBRES	----------------------------------------------------------------------------------	
	public
	---- quelques noeuds ----
		root,				---- le noeud racine de toute la bibliotheque -----
		recherche,		---- le noeud contenant les resultat en cas de recherche utlisateur -----	
		retour		=	Noeud_struct	nom:"..." 				\	---- le noeud afficher parmis les élément pour acceder au dossier parent -----	
												parent:undefined 	\
												nomUnique:"RETOUR",			
	
	---- l'emplacement du fichier ----
		fichier  ,			---- l'adresse du fichier ini de l'arborescence -----	
	
	private
	---- noms uniques ----
		indexUnique 					= 0,		---- le compteur d'éléments de la biblio pour gerer les nom uniques-----
		prefixNomUnique_noeud 	= "N",
		prefixNomUnique_element 	= "E",	
		
	----  pour Affichage dans listener -----	
		indent 		= 0,
		tab 			= 	"    ",
		decallage 	=	"",
		
	---- tags ----
		separateursTags	=	(Element_struct()).separateursTags,
	
	------------ 	FONCTIONS		----------------------------------------------------------------------------------	
	-------- GESTION DE L'ARBO --------
	---- les noms uniques -----
	private
		fn creerNomUnique_noeud 	= return prefixNomUnique_noeud 	+ (indexUnique += 1 ) as string,
		fn creerNomUnique_element 	= return prefixNomUnique_element + (indexUnique += 1 ) as string,
	---- Creation des nouveaux élements ou noeuds ----
	public
		fn creerNoeud  	nom:"Nouveau noeud" 		parent:root 		nomUnique:( creerNomUnique_noeud () )	=( 			
			local		nouveauNoeud = Noeud_struct()			
			
			---- Remplissage des parameteres du nouveau noeud 	----
			if parent != undefined do
				parent.ajouterEnfant 	 nouveauNoeud
			nouveauNoeud.nom 			= nom
			nouveauNoeud.nomUnique	= nomUnique
			
			nouveauNoeud			
		),
		fn creerElement 	nom:"Nouvel élément" 		parent:root  		nomUnique:( creerNomUnique_element () )	type:#vide		fichier:""		apercu:""	tags:""	=( 
			local		nouvelElement = Element_struct()
			
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
	---- Supprimer un element de l'arbo ----
		fn supprimer  _noeuds = (
			for noeud in _noeuds do 
				noeud.retirer()
		),
	---- initialiser l'arborescence de tout ses éléments ----
		fn initialiser = (
			root 					= Noeud_struct()
			root.nom 			= "Labib"
			root.nomUnique 	= "ROOT"
			
			recherche					= Noeud_struct()
			recherche.nom 			= "RECHERCHE"
			recherche.nomUnique 	= "RECHERCHE"
			
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
	
	
	-------- GESTION DU FICHIER INI --------
	private
		fn ecrireNoeud  _noeud 					= (
			-- param communs --
			setINISetting   fichier	_noeud.nomUnique   "nom"  _noeud.nom
			setINISetting   fichier	_noeud.nomUnique   "parent"  ( if _noeud.parent ==undefined then "undefined" else _noeud.parent.nom)
			
			case classOf _noeud  of (
				noeud_struct: (
					setINISetting   fichier	_noeud.nomUnique   "composite"  		#branche
					setINISetting   fichier	_noeud.nomUnique   "estExpanded"  	( estExpanded as string )
					
					-- les enfants --
					_enfants = ""
					for enfant in _noeud.enfants do
						_enfants += enfant.nomUnique + ";"
					setINISetting   fichier	_noeud.nomUnique   "enfants"  _enfants
					
					-- recusrcivité --
					for enfant in _noeud.enfants do ecrireNoeud  enfant 
				)
				element_struct: (
					setINISetting   fichier	_noeud.nomUnique   "composite"  #feuille
					
					setINISetting   fichier	_noeud.nomUnique   "type"  				( _noeud.type		as string	)
					setINISetting   fichier	_noeud.nomUnique   "fichier"  			( _noeud.fichier		as string	)
					setINISetting   fichier	_noeud.nomUnique   "apercu"  			( _noeud.apercu	as string	)
					setINISetting   fichier	_noeud.nomUnique   "detail"  				( _noeud.detail		as string	)
					setINISetting   fichier	_noeud.nomUnique   "commentaires"  	( _noeud.commentaires		as string	)
					setINISetting   fichier	_noeud.nomUnique   "tags"  				( _noeud.tags		as string	)
					setINISetting   fichier	_noeud.nomUnique   "proxy"  				( _noeud.proxy		as string	)					
					
					setINISetting   fichier	_noeud.nomUnique   "dateCreation"  			( _noeud.dateCreation as string )
					setINISetting   fichier	_noeud.nomUnique   "dateDernierImport"  	( _noeud.dateDernierImport as string )
					setINISetting   fichier	_noeud.nomUnique   "nbrImports"  			( _noeud.nbrImports as string )
					setINISetting   fichier	_noeud.nomUnique   "nbrVertex"  				( _noeud.nbrVertex as string )
					
				)
			)
			
		),
		fn lireNoeud 	_nomUnique 	_parent 	= (
			
			local _nouveauNoeud
			
			if hasINISetting fichier 	_nomUnique 	then (
				
				_composite = getINISetting   fichier	_nomUnique   "composite"
				case _composite of (
					"feuille":( 
						_type 			= getINISetting   fichier	_nomUnique   "type"  
						_nom 			= getINISetting   fichier	_nomUnique   "nom"  
						_fichier 			= getINISetting   fichier	_nomUnique   "fichier"  
						_apercu 		= getINISetting   fichier	_nomUnique   "apercu"				
						
						_nouveauNoeud = creerElement 	nom:_nom  type:_type	fichier:_fichier  apercu:_apercu	nomUnique:_nomUnique parent:_parent
						
						_nouveauNoeud.commentaires	= getINISetting   fichier	_nomUnique   "commentaires"
						_nouveauNoeud.tags 				= getINISetting   fichier	_nomUnique   "tags"
						_nouveauNoeud.detail 				= getINISetting   fichier	_nomUnique   "detail"
						_nouveauNoeud.proxy 				= getINISetting   fichier	_nomUnique   "proxy"
						
						_nouveauNoeud.dateCreation 		= execute ( getINISetting   fichier	_nomUnique   "dateCreation" )
						_nouveauNoeud.dateDernierImport 	= execute ( getINISetting   fichier	_nomUnique   "dateDernierImport" )
						_nouveauNoeud.nbrImports 			= ( getINISetting   fichier	_nomUnique   "nbrImports" ) as integer
						_nouveauNoeud.nbrVertex 			= ( getINISetting   fichier	_nomUnique   "nbrVertex" ) as integer
					
					)
					"branche":(
						
						_nom 			= getINISetting   fichier	_nomUnique   "nom"  
						
						_enfants 		= filterString 		(getINISetting   fichier	_nomUnique   "enfants" )  ";"	
						
						_nouveauNoeud 	= creerNoeud 	nom:_nom   nomUnique:_nomUnique  parent:_parent
						_nouveauNoeud.estExpanded =  ( if ( getINISetting   fichier	_nomUnique   "estExpanded" )  == "true" then true else false )  
					
						for _enfant in _enfants do (
							lireNoeud   _enfant 		_nouveauNoeud
						)
						
					)
				) -- fin case
				
				return _nouveauNoeud
				
			) else (
				debug "ERREUR:	le noeud n'est pas dans le fichier INI\n" _nom fichier
				debug "noeud" var:_nom 
				debug "fichier" var:fichier 
			)
		),		
	public
		
		fn enregistrer 	= (
			debug "<arbo>	enregistrement"
			setINISetting   fichier	"params"   "indexUnique"  ( indexUnique as string )
			ecrireNoeud Root
		),	
		
		fn charger = (
			debug "<arbo>	chargement"
			
			initialiser()
			
			---- si existe pas on initialise le fichier ----
			if not doesFileExist fichier then enregistrer ()
			---- sinon on charge ----
			else (
				
				indexUnique = ( getINISetting   fichier	"params"   "indexUnique" ) as integer
				root = lireNoeud   "ROOT" 	undefined
			)
			_root
		),
	
	
	-------- ACCEDER AUX NOEUDS --------		
	public
		fn getParFichier 			_fichier  		noeud:root	= (
			
			local result 	= undefined
			
			case classOf noeud of (
				Element_struct:	if noeud.fichier == _fichier	do result =  noeud
				Noeud_struct:		(					
					local trouve 	= false
					for enfant in noeud.enfants while not trouve	do (	
							result =  getParFichier 	_fichier	 	noeud:enfant
							if result != undefined do 	trouve = true
						)						
					) -- fin case Noeud_struct ---					
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
						else	if classOf noeud ==	Noeud_struct do	(		
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
				Element_struct:	if noeud.nom == _nom			do (
											debug "## TROUVE ###"
											append	result 	noeud
										)
				Noeud_struct:		for enfant in noeud.enfants 	do result +=  getParNom 	_nom	 noeud:enfant 
			)
			
			result
		),
	---- Recuperer tout les elements ----
		fn getElements 	noeud:root 	recursif:false	= (
	
			local elements = #()
			
			case classOf noeud of (
				Element_struct:	() --- append 	elements 	noeud
				Noeud_struct:		(
					elements += for enfant in noeud.enfants where classof enfant == Element_struct collect  enfant
					if recursif do for enfant in noeud.enfants do  elements += 	getNoeuds 	noeud:enfant	recursif:true
				)
			)
			
			elements
			
		),	
	---- Recuperer tout les noeuds ----
		fn getNoeuds 	noeud:root 	recursif:false	= (
	
			local elements = #()
			
			case classOf noeud of (
				Element_struct:	() --- append 	elements 	noeud
				Noeud_struct:		(
					elements += for enfant in noeud.enfants where classof enfant == Noeud_struct collect  enfant
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
			local	tagsAChercher 	= filterString	_tagsAChercher 	separateursTags
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
				Element_struct:(
					local listTagsDuNoeud = filterString 	noeud.tags 	separateursTags
					for tag in listTagsDuNoeud do 
						appendifunique 	result 	tag
				)
				Noeud_struct:
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
			/* case of
			(
				(elem1.nom < elem2.nom): -1
				(elem1.nom > elem2.nom): 1
				default: 0
			) */
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
			
			result
		),
	
	
	-------- AFFICHAGE de l'arbo dans le listener --------
	private
		fn afficherNoeud 	_noeud = (
			decallage =""
			for i = 0 to indent do
				decallage += tab
			
			format "%> nom: %\n" 			decallage	_noeud.nom
			format "%  nomUnique: %\n" 	decallage	_noeud.nomUnique		
			format "%  parent: %\n" 			decallage	(_noeud.parent as string)	
			format "%  enfants: %\n" 		decallage	(_noeud.enfants as string)			
			
			for enfant in _noeud.enfants do (
				indent += 1
				afficherNoeud 	enfant
				indent -= 1
			)
		),
	public		
		fn afficher = (
			format "\n----- Arborescence --------------\n"
			afficherNoeud root
			format "----- Arborescence --------------\n\n"
		),
	
	
	------------ EVENEMENTS	----------------------------------------------------------------------------------	
	private
		on create do (
			debug "<arbo>	creation struture"
			initialiser ()
			
			-- on verifie qu'il existe sinon on creer un vierge ------
			if not doesfileexist fichier then (
				debug "fichier absent, création du fichier"		var:fichier
				initialiser()			
				enregistrer()
			) 		
			
			charger()
		)
	
	
)	-- fin Struct Arborescence




















































