/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	studio -- gestion des appercu
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [09/05/2017] -----------------------------------------------------------------------------
	- Mise en place globale 
########################################################################################################################*/


include "$userScripts\cp - labib\labib - studio - fenetres.ms"
include "$userScripts\cp - labib\labib - studio - presets.ms"
include "$userScripts\cp - labib\labib - studio - Vues.ms"
	

------------------------------------------------------------------------------
----------	Structure								 -------------------------
------------------------------------------------------------------------------
struct str_studio (
	
	------------ DEBUG	----------------------------------------------------------------------------------
	m_debug = true,
	m_dbgPrefix ="studio",
	fn debug 	_txt  var:	 param:    =(
		if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
	),
	
	------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		
		
		m_dialog_complet	= roll_studioComplet ,		---- le rollout ----
		m_dialog_simple		= roll_studioSimple ,		---- le rollout ----
		
		m_dialog					= m_dialog_complet,
		m_modeComplet 	= true,	
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Studio",
		
		m_pos 				= [600,370],
		
		m_tailleComplet 	= [281, 173],
		m_tailleSimple		= [265, 153],
		m_taille 				= m_tailleComplet,
		
		m_estOuvert 		= false,
		
		--- ui libre de labib -----------	
		col_fenetreFond			= color 68 68 68, 		---- MAX 	----
		col_fenetreTxt				= color 230  230 230, 	----  		----
		
		
		ico_btnFermer_R	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_R.jpg",
		ico_btnFermer_S	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_S.jpg",
		ico_btnFermer_P	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_P.jpg", 
	
		m_icos_fermer= #( 	openBitMap ico_btnFermer_R, 
											openBitMap	ico_btnFermer_S,
											openBitMap	ico_btnFermer_P ),
		
		
		
	public
		--- le manager  ---------
		m_presets				=	str_studio_presets (),
-- 		m_mgrRendus 			=	labib_rendus,
		m_vues					=	str_vues 	(),
		
		--- les rollouts secondaires -------------
		m_fen_choisirVue		= 	roll_choisirVue,
		m_fen_queryNom		= 	roll_queryNom,

-- 		m_mgrRendus			= 	str_gestionRendus 	() /* m_labib:m_labib */,			---- la creation des apercus -----
		
		
	-------------------------------------------------------------------------------------------------------------------------------------
								

		
		------ accessions --------------------------
		
		
		fn estEnModeComplet =  m_modeComplet,
		
		fn getPreset_actif =(			
			local indexSelec = m_dialog.ddl_presets.selection
			local result = m_presets.get		indexSelec	type:#studio
			result
		),
		fn getPresets_Noms =(
-- 			m_presets.get_noms ()
			local presets = m_presets.get_items	()
			local result = 	#()
			for preset in presets do ( 
				local nomTmp = preset.nom
				nomTmp += " (" + preset.vues.count as string + ")" 
				if preset.locked do nomTmp +=  " *" 
				append result nomTmp
			)
			result
		),	
		  
		
		
		fn getQualite_actif =(			
			
			local indexSelec 	= m_dialog.ddl_qualite.selection
			
			local result 		= m_presets.get		indexSelec	type:#qualite
			
			result
		),
		fn getQualites_Noms =(
-- 			local noms = m_presets.get_noms type:#qualite
			
			local listPresetQualite = m_presets.get_items	type:#qualite
			local result = 	#()
			for preset in listPresetQualite do  ( 
				local nomTmp = preset.nom
				if preset.locked do nomTmp +=  " *" 
				append result nomTmp
			)
			result
		),	
		
		
		
		fn getPreset_vues 	=(
			local std_actif = getPreset_actif ()
			local result =#()
			for idVue in std_actif.vues do (
				append result ( m_presets.get 	idVue	 par:#id		type:#vue ).nom
			)
			result
		),  
		
		fn getVue_actif =(
			
			local preset_actif 		= getPreset_actif ()
			local result = #() 
			for IDvue in preset_actif.vues do(
				local vue = m_presets.get		IDvue	type:#vue  par:#id
				append result   vue
			)
			
			result
			
		),
		
		fn getVues_noms =(
			
			local result 			= m_presets.get_noms	type:#vue 
			
			result
			
		),
		
		
		
		fn renommer_presetActif		_nvNom =(
			local presetActif = (getPreset_actif () )
			presetActif.nom = _nvNom
			
			m_presets.sauvegarder		item:presetActif
		),
		
		
		--------
		fn retirer_vue 	_id_vueAVirer  =(
			local studio 			= getPreset_actif ()
			m_presets.studio_retirerVue 		studio		_id_vueAVirer
			
			m_dialog.actualiser ()
			m_dialog.subrollout.rollouts[1].actualiser ()
		),
		fn ajouter_vue 	_indexVue	=(
			debug "ajouter_vue"
			
			local std_actif 		= getPreset_actif ()
			local vueAAjouter 	= m_presets.get 	_indexVue	type:#vue
			m_presets.studio_ajouter_vue	std_actif	vueAAjouter
			
			m_dialog.actualiser ()
			m_dialog.subrollout.rollouts[1].actualiser ()
		),
		fn creer_vue =(
			debug "creer_vue"
		),
		
		 
		
		fn editer_vue  = (				
			local pos = (GetDialogPos  m_dialog + [m_taille.x+ 3, 0  ] )
			
-- 			m_labib.vues.ouvrir 	pos:pos
		), 
		
		fn fermer_vue  = (		
-- 			m_labib.vues.fermer ()
		), 
		
		
		
		--------- rendus -------------
		fn ajouterAlaPile	critique:false	=(
			local assetsARendre = labib.getSelection ()
			local vues				= getVue_actif ()
			local qualite 			= getQualite_actif ()
			for asset in assetsARendre where classof asset != str_branche do (
				for vue in vues do (
					labib_rendus.ajouter 	pause:false				\
													critique:critique		\
													asset:asset 			\
													fichier:""					\
													vue:vue					\
													qualite:qualite			\
													dateEnvoi:localTime
				)
			)
		),
		
		
		---- GESTION DE LA FENETRE ------------------
		
		
		fn fermerParam =(
			removeSubRollout m_dialog.SubRollout		roll_param_studio
			removeSubRollout m_dialog.SubRollout		roll_param_qualite
			removeSubRollout m_dialog.SubRollout		roll_param_application
		),
		
		fn ouvrirParam 	_param =(
			fermerParam ()
			case _param of (				
				#studio:				(
					addSubRollout 	m_dialog.SubRollout		roll_param_studio
					roll_param_studio.initialiser  	this
				)
				#qualite:			(
					addSubRollout		m_dialog.SubRollout		roll_param_qualite
					roll_param_qualite.initialiser  	this					
				)
				#application:		addSubRollout		m_dialog.SubRollout		roll_param_application
			) 
		),
		
		
		fn ouvrir_fileAttente =(
			debug "toggle file d'attente "
			labib_rendus.toggleOuverture ()			
		),
		
		fn ouvrir_choixVue =(
			createdialog 	m_fen_choisirVue 	style:				#(#style_resizing) 	\		
															lockheight:			true	 \	 
															lockwidth:			true	
			m_fen_choisirVue.initialiser this
		), 		
		
		
		fn ouvrir_editerVue =(
			local pos = GetDialogPos  m_dialog + [m_dialog.width + 2, 0]
			m_vues.ouvrir pos:pos
			
		/* 	createdialog 	m_fen_vue 				style:				#(#style_resizing) 	\		
															lockheight:			true	 \	 
															lockwidth:			true	
			m_fen_vue.initialiser 	this */
		),
		
		fn fermer_editerVue =(
		/* 
			destroydialog 	m_fen_vue 	 */
		),
		
		
		
		
		
		
		fn estOuvert = m_estOuvert,
		fn ouvrir =(			
			debug "ouvrir"
			m_estOuvert 		= true
			
			if m_modeComplet then (
				m_dialog =	m_dialog_complet		
				m_taille	=	m_tailleComplet
			) else (
				m_dialog = m_dialog_simple
				m_taille	=	m_tailleSimple	
			)
			---- creation de la fenetre ----
			createDialog m_dialog 	style:				#(#style_resizing) 	\		
											width:				m_taille.x 				\
											height:				m_taille.y 				\		
											pos:					m_pos	 				 \	 
											lockheight:			true	 \	 
											lockwidth:			true	
			
			
			
			-- m_preset_id_select = m_presets_studio.count
			
			---- initialisation de la fenetre ----
			m_dialog.initialiser 	this
			
			
		),
		fn fermer  enregistrerPresets:true =(
			
			debug "fermer"
			
			if enregistrerPresets do
				m_estOuvert = false
			
			m_vues.fermer ()
-- 			labib_rendus.fermer ()
-- 			m_vues.fermer ()
			
			---- fermer la fenêtre ----
			try destroydialog m_dialog catch ()
		),
		fn toggleOuverture =(
			
			if m_estOuvert
				then fermer ()
				else	ouvrir ()
			
		),
		fn  basculer_mode =(
			m_modeComplet = not m_modeComplet
			try destroydialog m_dialog catch ()
			ouvrir()
		),
		
		
		-------
		
		fn initialiser =(			
			debug "initialiser"	
			
			--- chargemnt des presets enregistreés ----
			m_presets.charger ()
		),
		
		------------  Evenements	----------------------------------------------------------------------------------
		on create do (		
			---- output ----
			debug "Structure créée."	
			ecrire "|Studio| Prêt."
			initialiser()
		) 
		
) -- fin su struct -------------------------





 labib_studio		= 	str_studio ()		--	m_labib:labib
-- studio.ouvrir ()

-- )












