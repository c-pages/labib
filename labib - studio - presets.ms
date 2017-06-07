/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	----les presets----
	gestionnaires des presets des studio 
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [05/06/2017] -----------------------------------------------------------------------------

########################################################################################################################*/



--- structre d'un apercu ---
struct str_preset_apercu  (
	fichier 			= "",   	---- le fichier de l'image
	
	vue					   	---- le preset de la vue utilisée -----------
)

------------------------------------------------------------------------------------------------------------------------------
----------------- LES DIFFERENTS PRESETS ---------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
struct str_preset_qualite (
	id 					= "",		
	nom 				= "qualite", 		---- 	le nom du preset 
	locked			= false,
	
	nbrPass		=0,				----	progressive_nbrPass
	noiseLvl		=0.0,				----	adaptivity_targetError
	denoise		=0.0,				---- 	denoise_blendAmount
	timeLimit	=0				----	progressive_timeLimit (en ms)
)
struct str_preset_camera (
	id 					= "",	
	nom 				= "Camera",  		---- le nom du preset	
	locked			= false,
	
	rot			= [0,0,0],				---- rotation de la camera par rapport à la position par defaut ( face au petit coté de la BB ? a définir)	
	pos			= [0,0,0],				---- decallage effectué apres la rotation
	fov			= 50.0,
	dist_ratio	= 1.0 						---- un ratio, 		( 1 : la position de la camera par algorithme,  0->1 : on avance  1>100 : on s'éloigne )
)
struct str_preset_fond (
	id 				= "",	
	nom 			= "",   					---- le nom du preset
	locked			= false
	
)
struct str_preset_lumiere (
	id 				= "",	
	nom 			= "Lumiere",  			---- le nom du preset
	locked			= false,
	
	rot			= [0,0,0],				----	sur 2 ou 3 axes ?!? 	----	rotation de la camera par rapport à la position par defaut ( face au petit coté de la BB ? a définir)	
	pos			= [0,0,0],				----	sur 2 ou 3 axes ?!? 	----	decallage effectué apres la rotation
	taille			= [1,1,1],				----	sur 2 ou 3 axes ?!? 	----	
	intensite		= 50.0,
	map			= 50.0					---- un pourcentage ?
)
struct str_preset_effect (
	id 				= "",	
	nom 			= "",   					---- le nom du preset
	locked			= false,
	
	vignetting,
	
	flou,
	nettete,
	
	bloom,
	glare
)

----------------- LES PRESETS generales du studio ---------------------------------------------------------------------------
-----  preset d'une vue ------
struct str_preset_vue (
	id 					= "",		
	nom 				= "Vue",   			---- le nom du preset ("Face", "mobilier" ou "détail végétation" .... par ex.)
	locked			= false,
	
	camera			= "",
	fond				= "",
	lumieres 		= #()
)
---- preset de studio , un groupement de vues pour faire des studio en serie ------------------
struct str_preset_studio (
	id 				= "",	
	nom 			= "Studio", 
	locked			= false,
	
	vues 			=#()		--- la liste des differentes ID des vues à rendre -------
)



------------------------------------------------------------------------------------------------------------------------------
----------------- MANAGER DES LISTES --------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
struct str_liste_mgr (
	
			------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
		m_dbgPrefix ="studio|liste mgr",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	public
		---- a definir à la création ---------
		type					="",
		fichier 				="",
		
	private
		m_items 			=	#(),
		m_indiceUnique 	= 	0,
		m_preset_class, 					--- la classe des preset qu'il gere ----------
		
		------------------------- Fonctions internes diverses --------------------------
		fn generer_idUnique  &_node = (
			m_indiceUnique += 1
			_node.id = type + m_indiceUnique as string
		),
		fn enregistrerDatas  _datas  =(
			local propsNoms 	= getPropNames  _datas
			for propNom in propsNoms do (
				setINISetting   	fichier	_datas.id   propNom  	( ( getProperty _datas	 propNom	)	as string )
			)
		),
		fn chargerDatas	&_preset =(
			
			local propsNoms 	= getPropNames  _preset
		
			for propNom in propsNoms do (
				local propType 	= classof ( getProperty 	_preset  propNom )
				local propFichier 	= getINISetting   	fichier		_preset.id   	propNom 
				
				case propType of (
					Integer:			setProperty 	_preset 	propNom		( propFichier	as integer )
					Float:			setProperty 	_preset 	propNom		( propFichier	as float )
					BooleanClass:	setProperty 	_preset 	propNom		( if propFichier == "true" then true else false )
					Point2:			setProperty 	_preset 	propNom		( execute propFichier )
					Array:			setProperty 	_preset 	propNom		( execute propFichier )
					Default:			setProperty 	_preset 	propNom		propFichier
				)  
			)
		),
		fn sortParNom 				elem1  elem2 = (
			case of
			(
				(elem1.m_nom < elem2.m_nom): -1
				(elem1.m_nom > elem2.m_nom): 1
				default: 0
			)
		),
		
	public
		---- accessions ---------------------
		fn get 	_aChercher		par:#index	=(
			
			local result
			
			--- on cherche --------
			case par of (
				#index: 			if _aChercher <= m_items.count 	do	
										result = m_items[ _aChercher ]
				#nom: 			for preset in m_items do
										if preset.nom  == _aChercher 	do	
											result = preset
				#id: 				for preset in m_items do
										if preset.id  == _aChercher 		do	
											result = preset
			)
			
			result
			
		),
		fn get_items 			= m_items,
		
		--- classements --------------------
		fn classer	=(
			qsort 	m_items 	sortParNom
		),
		
		
		--- Manipulations  courantes -------------------		
		fn vider = 			m_items = #(),
		fn sauvegarder 		itemCible:  =(
			
			if itemCible == unsupplied then (
				--- la liste des presets -----
				local liste_idsUniques	=	for item in m_items 	collect 	item.id
				setINISetting   	fichier	"datas"   type  					( liste_idsUniques as string )
				
				--- l' id unique -----
				setINISetting   	fichier	"datas"   ("idUni_" + type)  	( m_indiceUnique as string )
				
				--- les items ----
				for item in m_items do	enregistrerDatas	item 
					
			) else (
				enregistrerDatas	itemCible 
			)
		),
		fn charger			=(
			
			--- on vide la liste -----
			vider ()
			
			-- on charge les dopnnes annexes ---------
			local liste_idsUniques	=	execute ( getINISetting   	fichier	"datas"   type )
			m_indiceUnique			= 	execute ( getINISetting   	fichier	"datas"   ("idUni_" + type) ) --as string
			
			-- on charge les presets ----
			if liste_idsUniques != ok do
				for id in liste_idsUniques do (
					local nvPreset= m_preset_class 	id:id
					chargerDatas  &nvPreset
					append 	m_items 	nvPreset
				)
		),
		fn ajouter 		nom:	=(
			
			local nvPreset	 = m_preset_class ()
			if nom != unsupplied do
				nvPreset.nom = nom
			
			append m_items 		nvPreset
			generer_idUnique 	&nvPreset
			
			sauvegarder ()
			
			nvPreset
			
		),
		fn supprimer 	_id	=(
			
			local presetASupprimer = get 	_id  par:#id
			if presetASupprimer != undefined do (
				
				--- on supprime de la liste des items ----------
				local index_presetASupprimer = findItem m_items presetASupprimer
				deleteItem index_presetASupprimer
				
				--- on supprime des fichiers ------
				delIniSetting 	fichier	presetASupprimer.id
			)
			
		),
		
		
		------- evnements --------
		on create do (
			
			-- on initialse les calss associés a chaque type -------------
			case type of (
				"S":	m_preset_class = str_preset_studio
				"V":	m_preset_class = str_preset_vue
				"Q":	m_preset_class = str_preset_qualite
				"C":	m_preset_class = str_preset_camera
				"F":	m_preset_class = str_preset_fond
				"L":	m_preset_class = str_preset_lumiere
				"E":	m_preset_class = str_preset_effect
			)
		)
)




------------------------------------------------------------------------------------------------------------------------------
----------------- MANAGER GENERAL 		------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
struct str_studio_presets (
	
	private
		------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
		m_dbgPrefix ="studio|presets",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	public
		fn print =(
			debug"---------------------- PRESETS --------------------------------------"
			debug"m_studios"
			for item in this.m_studios.get_items () 	do	debug  "item"	var:item 
			debug"m_vues"
			for item in this.m_vues.get_items () 		do	debug  "item"	var:item 
			debug"m_qualites"
			for item in this.m_qualites.get_items () 	do	debug  "item"	var:item 
			debug"m_cameras"
			for item in this.m_cameras.get_items () 	do	debug  "item"	var:item 
			debug"m_fonds"
			for item in this.m_fonds.get_items () 		do	debug  "item"	var:item 
			debug"m_lumieres"
			for item in this.m_lumieres.get_items () 	do	debug  "item"	var:item 
		),
		------------ DEBUG	----------------------------------------------------------------------------------
		
		
		
	private
		----------------------------------------------------------------		
		m_fichier 		= getDir #userscripts + "\cp - labib\studio\labib_presets.ini",
		
		--- les managers de presets ---------------
		m_studios 		= str_liste_mgr 	type:"S"		fichier:m_fichier,  --- liste des differents studio enregistrés
		m_vues 			= str_liste_mgr 	type:"V"		fichier:m_fichier,  --- liste des differents presets de vues enregistrés
		
		m_qualites 		= str_liste_mgr 	type:"Q"		fichier:m_fichier,  --- liste des differents presets de vues enregistrés
	
		m_cameras 	= str_liste_mgr 	type:"C"		fichier:m_fichier,  --- liste des differents presets de vues enregistrés
		m_fonds 		= str_liste_mgr 	type:"F"		fichier:m_fichier,  --- liste des differents presets de vues enregistrés
		m_lumieres		= str_liste_mgr 	type:"L"		fichier:m_fichier,  --- liste des differents presets de vues enregistrés
		m_effets		= str_liste_mgr 	type:"E"		fichier:m_fichier,  --- liste des differents presets de vues enregistrés
		
		
		
		--- regroupe tout les managers ------
		m_presetsTotal = #( m_studios, m_vues, m_qualites, m_cameras, m_fonds, m_lumieres, m_effets ),
		
		
		
	public
		--- stockage --------
		fn sauvegarder  item: =(
			debug "sauvegarder"
			if item == unsupplied then (
				--- ecriture des presets ----
				for presets in m_presetsTotal do
						presets.sauvegarder ()
			) else (
				local mgr_temp
				case classOf item of (
					str_preset_studio:	mgr_temp = m_studios
					str_preset_vue:		mgr_temp = m_vues
					
					str_preset_qualite:	mgr_temp = m_qualites
					
					str_preset_camera:	mgr_temp = m_cameras
					str_preset_fond:		mgr_temp = m_fonds
					str_preset_lumiere:	mgr_temp = m_lumieres
					str_preset_effect:	mgr_temp = m_effets
					
				)
				mgr_temp.sauvegarder	itemCible:item
			)
		),
		fn charger =(
			debug "charger"
			if doesfileExist m_fichier do
				for presets in m_presetsTotal do
					presets.charger ()
		),
		
		
		
		----------------- Fonctions principales --------------------------
		--- creation --------
		fn creer 	type:#studio 	nom:	=(
			
			debug "Ajouter preset"
			debug "type" var:type
			
			local nvPreset
			
			case type of (
				#studio: 	nvPreset =	m_studios.ajouter 	nom:nom
				#vue: 		nvPreset =	m_vues.ajouter 		nom:nom
				#qualite: 	nvPreset =	m_qualites.ajouter 	nom:nom
				#camera:	nvPreset =	m_cameras.ajouter 	nom:nom
				#fond: 		nvPreset =	m_fonds.ajouter 		nom:nom
				#lumiere:	nvPreset =	m_lumieres.ajouter 	nom:nom
				#effet:		nvPreset =	m_effets.ajouter 		nom:nom
			)
			nvPreset
		),
		
		fn studio_ajouter_vue		_studio		_vueAAjouter =(
			append _studio.vues		_vueAAjouter.id
			m_studios.sauvegarder 		itemCible:_studio
		),
		
		fn studio_retirerVue 		_studio		_index	=(
			deleteItem 	_studio.vues	_index
			sauvegarder ()
-- 			_studio.supprimer 	_index
			
		),
		
		
		---- accession ------------------
		
		fn get_items  	type:#studio 	=(
			
			local result 
			case type  of (
				#studio: 	result =	m_studios.get_items		()
				
				#vue: 		result =	m_vues.get_items		()				
				#qualite: 	result =	m_qualites.get_items		()
				
				#camera:	result =	m_cameras.get_items	()
				#fond: 		result =	m_fonds.get_items		()
				#lumiere:	result =	m_lumieres.get_items	()
				#effet:		result =	m_effets.get_items		()
				
			)
			result
		),  
		
		fn get_noms 	type:#studio =(
			
			local items = get_items 		type:type
			local result  =	for item in items	collect item.nom
			
			result
		),
		
		fn get  _param	type:#studio  par:#index	=(
			
			local result  
			case type  of (
				#studio: 	result =	m_studios.get		_param	par:par
				#vue: 		result =	m_vues.get			_param	par:par
				#qualite: 	result =	m_qualites.get		_param	par:par
				#camera:	result =	m_cameras.get	_param	par:par
				#fond: 		result =	m_fonds.get		_param	par:par
				#lumiere:	result =	m_lumieres.get	_param	par:par
				#effet:		result =	m_effets.get		_param	par:par
			)
			
			result
		),
		
		----------------------------------------------------------------------------------------------------------------------------------------------------------------
		---- initialiser les VALEURS PAR DEFAUTS ------------------------------------------------------------------------------------------------
		----------------------------------------------------------------------------------------------------------------------------------------------------------------
		fn defaut 	=(
			
			local nvPreset
			
			-- on vide tout ---
			for presets in  m_presetsTotal do	presets.vider ()
			
			
			---- studios -------------------------------------------------------------------------------------
			nvPreset = creer nom:"Défaut"	
			nvPreset.locked	=  true
			nvPreset.vues 	=#( "V1" )
			
			nvPreset = creer nom:"Végétation - Exterieur"	
			nvPreset.vues 	=#( "V1" , "V2", "V3")
			
			nvPreset = creer nom:"Végétation - Interieur"
			nvPreset.vues 	=#( "V1" )
			
			nvPreset = creer nom:"Mobilier"
			nvPreset.vues 	=#( "V1" )
			
			---- vues -------------------------------------------------------------------------------------
			nvPreset = creer type:#vue		nom:"Face"
			nvPreset.locked	=  true
			nvPreset = creer type:#vue		nom:"Profil D"
			nvPreset.locked	=  true
			nvPreset = creer type:#vue		nom:"Profil G"
			nvPreset.locked	=  true
			nvPreset = creer type:#vue		nom:"Dessus"
			nvPreset.locked	=  true
			nvPreset = creer type:#vue		nom:"Custom"
			
			---- qualité -------------------------------------------------------------------------------------
			nvPreset = creer type:#qualite	nom:"Trés rapide"
			nvPreset.locked				=  true
			nvPreset.nbrPass 			= 5
			nvPreset.noiseLvl 			= 0
			nvPreset.denoise 			= 1
			nvPreset.timelimit 			= 0
			
			nvPreset = creer type:#qualite	nom:"Rapide"
			nvPreset.locked				=  true
			nvPreset.nbrPass 			= 15
			nvPreset.noiseLvl 			= 0
			nvPreset.denoise 			= 0.75
			nvPreset.timelimit 			= 0
			
			nvPreset = creer type:#qualite	nom:"Normal"
			nvPreset.locked				=  true
			nvPreset.nbrPass 			= 0
			nvPreset.noiseLvl 			= 5
			nvPreset.denoise 			= 0.7
			nvPreset.timelimit 			= 0
			
			nvPreset = creer type:#qualite	nom:"Qualité"
			nvPreset.locked				=  true
			nvPreset.nbrPass 			= 0
			nvPreset.noiseLvl 			= 2
			nvPreset.denoise 			= 0
			nvPreset.timelimit 			= 0
			
			nvPreset = creer type:#qualite	nom:"1 minute"
			nvPreset.nbrPass 			= 0
			nvPreset.noiseLvl 			= 0
			nvPreset.denoise 			= 0
			nvPreset.timelimit 			= 1000 * 60
			
			
			---- cameras  -------------------------------------------------------------------------------------
			nvPreset = creer type:#camera	nom:"Face"
			nvPreset.locked	=  true
			nvPreset.rot			= [0,0,0]
			nvPreset.pos			= [0,0,0]
			nvPreset.fov			= 90
			nvPreset.dist_ratio	= 1
			
			nvPreset = creer type:#camera	nom:"Arrière"
			nvPreset.rot			= [0,0,180]
			nvPreset.pos			= [0,0,0]
			nvPreset.fov			= 90
			nvPreset.dist_ratio	= 1
			
			nvPreset = creer type:#camera	nom:"Profil D"
			nvPreset.rot			= [0,0,90]
			nvPreset.pos			= [0,0,0]
			nvPreset.fov			= 90
			nvPreset.dist_ratio	= 1
			
			nvPreset = creer type:#camera	nom:"Profil G"
			nvPreset.rot			= [0,0,-90]
			nvPreset.pos			= [0,0,0]
			nvPreset.fov			= 90
			nvPreset.dist_ratio	= 1			
			
			nvPreset = creer type:#camera	nom:"Détail 1"
			nvPreset.rot			= [0,15,15]
			nvPreset.pos			= [0,0,0]
			nvPreset.fov			= 50
			nvPreset.dist_ratio	= .333	
			
			---- fond -------------------------------------------------------------------------------------
			nvPreset = creer type:#fond		nom:"Présentation objets"
			
			---- lumieres -------------------------------------------------------------------------------------
			nvPreset = creer type:#lumiere	nom:"Exterieur 1"
			nvPreset = creer type:#lumiere	nom:"Interieur 1"
			
			
			---- effets -------------------------------------------------------------------------------------
			nvPreset = creer type:#effet		nom:"Neutre"
			nvPreset = creer type:#effet		nom:"Vignetting + bloom leger"
			
			sauvegarder ()
			
		)
		
		
		
		
		
)





/* 
clearlistener ()
str_tmp = str_presets ()
str_tmp.valeursParDefaut ()
str_tmp.print ()
str_tmp.get 2 type:#camera
str_tmp.get_items  	type:#camera
str_tmp.get_noms 	type:#vue

 */


/* 
str_tmp.get_items 	type:#camera
str_tmp.creer #studio		nom:"Végétation - Exterieur"
str_tmp.creer #studio		nom:"Végétation - Interieur"
str_tmp.creer #vue			nom:"Face"
str_tmp.creer #vue			nom:"Profil D"
str_tmp.creer #vue			nom:"Profil G"
str_tmp.creer #qualite		nom:"trés rapide"
str_tmp.creer #qualite		nom:"Rapide"
str_tmp.creer #qualite		nom:"Normal"
str_tmp.creer #qualite		nom:"Qualité"
str_tmp.creer #fond			nom:"Présentation objets"
str_tmp.creer #lumiere		nom:"Exterieur 1"
str_tmp.creer #lumiere		nom:"Interieur 1"


 str_tmp.charger ()
str_tmp.print ()
str_tmp.get 
 */

--