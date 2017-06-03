/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA m_labib
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	le manager des rendus
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [30/10/2016] -----------------------------------------------------------------------------
########################################################################################################################*/



----------------------------------------
------ La structure Apercu --------
-- gère la creation des apercu  ---
----------------------------------------
struct str_rendus (
	
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="rendus",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
		
		
	public
		m_labib,
		m_edit,
		
		-- la CAMERA --
		cameraApercu,
		soleilCorona,
		
		sol,
		
		-- pour IMPORT dans scene --
		a_objetsImport 		= #(),

		-- stockage de l'ancien moteur de rendu et ses parametres -
		m_moteurRenduPrecedant,
		
		-- les axes de rotation de la camera--
		m_rotateCam_X = 0,
		m_rotateCam_Y = 0,
		m_distanceDecallage = 0,
		
	public
		BB_import,
		m_centre_import,
		m_longueurMax_import,
		
		m_annuler = false,
		
-- 	private
	public
		
		fn creerNomRendu	_prefix	= (
			
			local nouveauNom =""
			listerendus = getFiles ( m_labib.prefs.rendus.dossier + "\\*.jpg" )
			
			trouveNouveauNom = false
			i = 0
			while not trouveNouveauNom do (
				present = false
				nouveauNom = _prefix + i as string 
				for app in listerendus do (
					if getFilenameFile app == nouveauNom
						do present = true
				)
				if present == false then trouveNouveauNom = true
				else		i += 1
			)
			
			nouveauNom  
		),
		
		---- INFOS sur l'assets ------------
		fn calculerNbreVertex 	_asset	=	(
			debug "calculerNbreVertex - debut"
			
			local nbrVertex = 0
			for obj in objects where superClassOf obj == GeometryClass do (
				local nodeSnapShot = snapshotAsMesh  obj
-- 				debug "nodeSnapShot" var:(getNumVerts  nodeSnapShot)
				
				try nbrVertex += getNumVerts  nodeSnapShot catch ()
				delete nodeSnapShot
			)
			debug "nbrVertex" var:nbrVertex
			_asset.nbrVertex = nbrVertex
			
			debug "calculerNbreVertex - fin"
			
		),
		
		
		
		fn calculerBB 	_objets	=	(
			
			debug "calculerBB"
			
			-- on calcul le bounding box de l'ensemble des objets --
			BB_import = nodeLocalBoundingBox  _objets[1]
			
			for obj in _objets where ( superclassof obj != light  	and	superclassof obj != camera 	and 	superclassof obj != helper	and 	superclassof obj != shape and classOf obj != Targetobject and not obj.ishidden )	do (
				
				BoundingTemp = nodeLocalBoundingBox  obj
				
				if BoundingTemp[1].x < BB_import[1].x 	do 	BB_import[1].x = BoundingTemp[1].x 
				if BoundingTemp[1].y < BB_import[1].y 	do 	BB_import[1].y = BoundingTemp[1].y 
				if BoundingTemp[1].z < BB_import[1].z 	do 	BB_import[1].z = BoundingTemp[1].z 
					
				if BoundingTemp[2].x > BB_import[2].x 	do 	BB_import[2].x = BoundingTemp[2].x 
				if BoundingTemp[2].y > BB_import[2].y 	do 	BB_import[2].y = BoundingTemp[2].y
				if BoundingTemp[2].z > BB_import[2].z 	do 	BB_import[2].z = BoundingTemp[2].z 					
				
			)
			
			-- on calcul quelques données utils pour la mise en place de la scene de rendu --
			m_centre_import = [ ( BB_import[2].x - BB_import[1].x )/2 + BB_import[1].x, ( BB_import[2].y - BB_import[1].y )/2 +BB_import[1].y, ( BB_import[2].z - BB_import[1].z  )/2 + BB_import[1].z ]
			
			--- la longueur max ---
			BBLargeur	=	BB_import[2].x - BB_import[1].x
			BBLongeur	=	BB_import[2].y - BB_import[1].y
			BBHauteur	=	BB_import[2].z - BB_import[1].z
			hypot_1  = sqrt   ( BBLargeur*BBLargeur   + BBLongeur*BBLongeur)   
			m_longueurMax_import = sqrt ( hypot_1*hypot_1 + BBHauteur*BBHauteur)
			
			return BB_result
			
		),
		
		
		
		
		
		
		
		fn annuler =(
			debug "ANNULER"
			m_annuler = true
		),
		
		
		
		fn importer		_fichier = (
			
			debug "importer - debut"
			
			-- on vide les tableau --
			a_objetsImport = #()
			
			-- on merge le fichier --
			mergeMaxFile _fichier #select #autoRenameDups #renameMtlDups #neverReparent
			
			-- on supprime cameras et lumières
			delete cameras
			delete lights
			
			-- on liste les objets importés --
			a_objetsImport = for i in selection collect i
			
			-- calcul du BB et du centre de l'import --
			calculerBB  	a_objetsImport
			
			debug "importer - fin"
			
		),	--FIN Importer_Fichier_Pour_Edition
		
		fn poserCamera 	detail:false	 = (
			
			debug "poserCamera"
			
			local CameraPosX, distCam, ptCam
			
-- 			m_centre_import = [0,0,0]
			ptCam	= point name:"pt_camApercu"	pos:m_centre_import
			
			marge 	= m_longueurMax_import * 0			
			distCam 	= m_longueurMax_import * m_labib.prefs.rendus.coefDistance + m_distanceDecallage
			
			CameraPosX = m_centre_import.x  + distCam 
			CameraPosY = m_centre_import.y 
			CameraPosZ = m_centre_import.z
			
			TargetX =  m_centre_import.x
			TargetY =  m_centre_import.y
			TargetZ =  m_centre_import.z		
			
			if ( not detail ) then
				Capture_FOV = m_labib.prefs.rendus.angleVue
			else 
				Capture_FOV = m_labib.prefs.rendus.angleVueDetail
			
			cameraApercu =  Targetcamera fov:Capture_FOV pos:[CameraPosX,CameraPosY,CameraPosZ] name:"Camera_apercu" orthoProjection:false target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [TargetX,TargetY, TargetZ] ) name:"TargetCapture") 
			
			--- on parent la cam et la lumiere au point ---
			cameraApercu.parent = ptCam
			cameraApercu.target.parent = ptCam
			soleilCorona.parent = ptCam
			
			-- on tourne le point parent pour orienter comme il faut ---
			local posBack = ptCam.pos
			in coordsys local rotate ptCam (angleaxis m_rotateCam_Y [0,1,0])
			in coordsys world rotate ptCam (angleaxis m_rotateCam_X [0,0,1])
			
			
			
			viewport.setCamera cameraApercu
			cameraApercu.type = #free			
			
			-- on l'ajoute à la liste import pour le suppr à la fin --
			append a_objetsImport cameraApercu
			
			cameraApercu
			
		),
		fn poserSol 		 = (
			
			debug "poserSol"
			
			TailleSol 	= m_longueurMax_import * 100
			Extrusion 	= m_longueurMax_import * 50
			
			sol = Plane 	length:TailleSol 		width:TailleSol 		pos:[m_centre_import.x,m_centre_import.y,BB_import[1].z + Extrusion ] 		isSelected:off   lengthsegs:2 widthsegs:2
			
			converttopoly Sol
			sol.EditablePoly.SetSelection #Face #{1..16}
			sol.extrudeFaces -Extrusion
			addModifier sol (TurboSmooth ())
			sol.modifiers[1].iterations = 3
			sol.castShadows  = false
			matSol = CoronaMtl ()
			sol.material = matSol
			
			-- on l'ajoute à la liste import pour le suppr à la fin --
			append a_objetsImport 	sol
			sol
		),		
		fn preparerLumieres		 =	(
			
			debug "preparerLumieres"
			
			posLum = 500 --m_longueurMax_import * 2
						
			-- creation de la lumiere pour l'apercu --
			soleilCorona = CoronaSun targeted:on name:"Soleil_apercu" pos:[m_centre_import.x + 5*posLum ,m_centre_import.y + 5*posLum, m_centre_import.z + 10*posLum] isSelected:off  target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [m_centre_import.x,m_centre_import.y, m_centre_import.z] ) name:"TargetLumiereCapture") 
			soleilCorona.targeted = off
			),
		fn poserOrigine 		detail = (
			
			debug "poserOrigine"
			
			ptCam = point name:"point camera" 	pos:m_centre_import
			cameraApercu.parent  = ptCam
			soleilCorona.parent = ptCam
			
			if not detail then (
				
				in coordsys world rotate ptCam ( eulerAngles m_labib.prefs.rendus.rotX 		 m_labib.prefs.rendus.rotY  	m_labib.prefs.rendus.rotZ )
				ptCam.pos = m_centre_import
				in coordsys local 	move cameraApercu  [  m_labib.prefs.rendus.transX  ,  m_labib.prefs.rendus.transY ,  m_labib.prefs.rendus.transZ  ]
				
			) else (
				
				in coordsys world rotate ptCam ( eulerAngles m_labib.prefs.rendus.rotXDetail 		 m_labib.prefs.rendus.rotYDetail  	m_labib.prefs.rendus.rotZDetail )
				ptCam.pos = m_centre_import
				in coordsys local 	move cameraApercu  [  m_labib.prefs.rendus.transXDetail  ,  m_labib.prefs.rendus.transYDetail ,  m_labib.prefs.rendus.transZDetail  ]
				
			)
			
			-- on l'ajoute à la liste import pour le suppr à la fin --
			append a_objetsImport ptCam
			
		),
		fn preparerRendu 		detail:  =(
			
			debug "preparerRendu - debut"
			
			-- conversion des materiaux  --
			m_edit.convertMateriauxScene ()
			
			
			-- on s'occupe des lumieres -- 
			preparerLumieres ()
			
			-- la camera --
			poserCamera 	detail:detail
			
			---- l'origine qui sert de parent à camera et lumiere ----
			poserOrigine  detail
			
			-- le sol --
			poserSol()
			
			-- le moteur de rendu
			nomMoteur = classof renderers.current as string
			
			if ( findString nomMoteur "Corona" != 0 ) do (
				
				debug "par là - 1"
				
				m_moteurRenduPrecedant 								= renderers.current
				renderers.current 										= CoronaRenderer() --execute m_labib.prefs.rendus.moteur
				
				debug "par là - 2"
				
				renderers.current.adaptivity_targetError 		= if detail then m_labib.prefs.rendus.noiseLevelDetail else m_labib.prefs.rendus.noiseLevel
-- 				renderers.current.adaptivity_targetError = 11.25
				
				debug "par là - 3"
				
				renderers.current.denoise_blendAmount		= m_labib.prefs.rendus.denoiseAmount
				renderers.current.denoise_filterType			= 2
				
				debug "par là - 4"
				
				renderers.current.colorMap_simpleExposure 			= m_labib.prefs.rendus.exposition
				renderers.current.colorMap_highlightCompression	= m_labib.prefs.rendus.highlightCompress
				renderers.current.colorMap_colorTemp						= m_labib.prefs.rendus.temperatureRendu
				renderers.current.colorMap_contrast						= m_labib.prefs.rendus.contraste
				
				debug "par là - 5"
				
-- 				renderers.current.vfb_type							= if m_labib.prefs.rendus.afficherVFB then 2	else 0 ---- 0:pour cacher le VFB corona  ----
				renderers.current.bg_texmap						= CoronaSky()
				renderers.current.bg_source						= 1
-- 				renderers.current.lockMax 							= true	---- bloquer max ? ----
				debug "par là - 6"
				
			)
			
			debug "preparerRendu - fin"
		),
		
		
		fn rendre detail:false	=(
			
			debug "rendre"
			
			local nomRendu 
			local prefix = if not detail 	then m_labib.prefs.rendus.nom
													else	m_labib.prefs.rendus.nomDetail
			
			nomRendu = m_labib.prefs.rendus.dossier + "\\" + ( creerNomRendu 	prefix ) + ".jpg"
			
			CoronaRenderer.CoronaFp.showVfB false
			
			Rendu = 	render cameraApercu 			outputSize:m_labib.prefs.rendus.taille   	\
							outputfile:nomRendu 			vfb:false 			quiet:true					\
							cancelled:&TestCancelled	 	missingExtFilesAction:#logmsg
			
-- 			CoronaRenderer.CoronaFp.showVfB true
			
-- 			display  Rendu
			nomRendu
		),
		
		
		fn remettreRenduInitial = (
			renderers.current = m_moteurRenduPrecedant
		),
		
		
		
		
		
		
		
	public
		fn creer		elems 	detail:false	= (
			
-- 				---- debug ----
				local nomRenduApercu
			
				-- on s'assure qu'elems soit un tableau
				toArray &elems
				local resultQuery = #no
				local fichierOuvert = maxFileName 
				
				besoinDeSauvegarder = getSaveRequired() 
				if besoinDeSauvegarder do (
					resultQuery = yesNoCancelBox  "Sauvegarder ?"
					if resultQuery == #yes do 
						if fichierOuvert != "" then
							saveMaxFile fichierOuvert
						else (
							theName = getMAXSaveFileName ()
							--If the result is not undefined, we can actually save the file:
							if theName != undefined do saveMaxFile theName
						)
				)
				
				if elems.count > 0 and  resultQuery != #cancel  do (
-- 					if querybox "voulez vous créer les aperçus ?" do (

-- 						holdPerso ()
						
						i = 1.
						for elem in elems do (
							
							if m_annuler do break
							
-- 							if rollPrincipal.cancelled do continue
							
							pourcent = ( ( i - 1.) / elems.count * 100. )
-- 							rollPrincipal.setProgress ("Rendu aperçu " + ( i as integer )  as string + "/" + elems.count as string  ) 	pourcent
							
							if doesfileexist elem.fichier then ( 
-- 								m_labib.outils.viderScene()
								
								resetMaxFile #noPrompt
								
								
-- 								elem.apercu = apercu.creer 	elem.fichier
								
								importer	elem.fichier
								
								calculerNbreVertex elem
								
								preparerRendu 	detail:detail
								nomRenduApercu 	= rendre  detail:detail
								if detail then 
									elem.detail 			= nomRenduApercu
								else
									elem.apercu 			= nomRenduApercu
								elem.enregistrer ()
-- 								try ( m_labib.m_rollrendus.bmp_ap.fileName = nomRenduApercu ) catch ()								
								
-- 								rollPrincipal.AfficherElements 		rollPrincipal.noeudSelect					
-- 								rollPrincipal.afficherInfos()
								
							)	else format "elem : % n'as pas de fichier valide : %\n" elem.nom elem.fichier
							i+=1
						)
						
						/* 
						if rollPrincipal.cancelled then 
							rollPrincipal.setProgress ("Rendu : " + ( i as integer )  as string + "/" + elems.count as string  + " aperçus. *Annulé*") 100
						else 
							rollPrincipal.setProgress ("Rendu : " + ( i as integer )  as string + "/" + elems.count as string  + " aperçus.") 100				
						rollPrincipal.cancelled = false
						
						rollPrincipal.AfficherElements 	noeudSelect					
						rollPrincipal.afficherInfos()
 */
-- 						if not deb do 
-- 						fetchMaxFile quiet:true
						
-- 						m_labib.arbo.ecrireFichier()
						
					)
					if fichierOuvert != "" do
						loadMaxFile  fichierOuvert
-- 					fetchPerso ()
					
-- 					
-- 			importer 	_fichier
-- 			preparerRendu 	detail:detail
-- 			nomRenduApercu = rendre  detail:detail
-- 			
-- 			try ( m_labib.m_rollrendus.bmp_ap.fileName = nomRenduApercu ) catch ()
-- 			
-- 			
			--nomRenduApercu
			
		)
		
		

) -- fin struct Apercu --


