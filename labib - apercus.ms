/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA m_labib
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	le manager des apercus
	
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
struct str_apercus (
	
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="apercus",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
		
		
	public
		m_labib,
		m_edit = m_labib.edit,
		
		-- la CAMERA --
		cameraApercu,
		soleilCorona,
		
		sol,
		
		-- pour IMPORT dans scene --
		a_objetsImport 		= #(),
		-- stockage de l'ancien moteur de rendu et ses parametres -
		moteurRenduPrecedant,
		
	public
		BB_import,
		centre_import,
		longueurMax_import,
		
		
-- 	private
	public
		
		fn creerNomRendu	_prefix	= (
			
			local nouveauNom =""
			listeApercus = getFiles ( m_labib.prefs.apercus.dossier + "\\*.jpg" )
			
			trouveNouveauNom = false
			i = 0
			while not trouveNouveauNom do (
				present = false
				nouveauNom = _prefix + i as string 
				for app in listeApercus do (
					if getFilenameFile app == nouveauNom
						do present = true
				)
				if present == false then trouveNouveauNom = true
				else		i += 1
			)
			
			nouveauNom  
		),
		
		
		fn calculerBB 	_objets	=	(
			
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
			centre_import = [ ( BB_import[2].x - BB_import[1].x )/2 + BB_import[1].x, ( BB_import[2].y - BB_import[1].y )/2 +BB_import[1].y, ( BB_import[2].z - BB_import[1].z  )/2 + BB_import[1].z ]
			
			--- la longueur max ---
			BBLargeur	=	BB_import[2].x - BB_import[1].x
			BBLongeur	=	BB_import[2].y - BB_import[1].y
			BBHauteur	=	BB_import[2].z - BB_import[1].z
			hypot_1  = sqrt   ( BBLargeur*BBLargeur   + BBLongeur*BBLongeur)   
			longueurMax_import = sqrt ( hypot_1*hypot_1 + BBHauteur*BBHauteur)
			
			
			return BB_result
		),
		
		
		fn importer		_fichier = (
						
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
			
		),	--FIN Importer_Fichier_Pour_Edition
		
		fn poserCamera 	detail:false	 = (
			
			local CameraPosX, distCam, ptCam
			
			marge 	= longueurMax_import * 0
			
			distCam 	= longueurMax_import * m_labib.prefs.apercus.coefDistance
			
			CameraPosX = centre_import.x  + distCam 
			CameraPosY = centre_import.y 
			CameraPosZ = centre_import.z			
			
			TargetX =  centre_import.x
			TargetY =  centre_import.y
			TargetZ =  centre_import.z		
			
			if ( not detail ) then
				Capture_FOV = m_labib.prefs.apercus.angleVue
			else 
				Capture_FOV = m_labib.prefs.apercus.angleVueDetail
			
			cameraApercu =  Targetcamera fov:Capture_FOV pos:[CameraPosX,CameraPosY,CameraPosZ] name:"Camera_apercu" orthoProjection:false target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [TargetX,TargetY, TargetZ] ) name:"TargetCapture") 
			viewport.setCamera cameraApercu
			cameraApercu.type = #free			
			
			-- on l'ajoute à la liste import pour le suppr à la fin --
			append a_objetsImport cameraApercu
			
			cameraApercu
			
		),
		fn poserSol 		 = (
			
			TailleSol 	= longueurMax_import * 100
			Extrusion 	= longueurMax_import * 50
			
			sol = Plane 	length:TailleSol 		width:TailleSol 		pos:[centre_import.x,centre_import.y,BB_import[1].z + Extrusion ] 		isSelected:off   lengthsegs:2 widthsegs:2
			
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
			
			posLum = 500 --longueurMax_import * 2
						
			-- creation de la lumiere pour l'apercu --
			soleilCorona = CoronaSun targeted:on name:"Soleil_apercu" pos:[centre_import.x + 5*posLum ,centre_import.y + 5*posLum, centre_import.z + 10*posLum] isSelected:off  target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [centre_import.x,centre_import.y, centre_import.z] ) name:"TargetLumiereCapture") 
			soleilCorona.targeted = off
			),
		fn poserOrigine 		detail = (
			
			ptCam = point name:"point camera" 	pos:centre_import
			cameraApercu.parent  = ptCam
			soleilCorona.parent = ptCam
			
			if not detail then (
				
				in coordsys world rotate ptCam ( eulerAngles m_labib.prefs.apercus.rotX 		 m_labib.prefs.apercus.rotY  	m_labib.prefs.apercus.rotZ )
				ptCam.pos = centre_import
				in coordsys local 	move cameraApercu  [  m_labib.prefs.apercus.transX  ,  m_labib.prefs.apercus.transY ,  m_labib.prefs.apercus.transZ  ]
				
			) else (
				
				in coordsys world rotate ptCam ( eulerAngles m_labib.prefs.apercus.rotXDetail 		 m_labib.prefs.apercus.rotYDetail  	m_labib.prefs.apercus.rotZDetail )
				ptCam.pos = centre_import
				in coordsys local 	move cameraApercu  [  m_labib.prefs.apercus.transXDetail  ,  m_labib.prefs.apercus.transYDetail ,  m_labib.prefs.apercus.transZDetail  ]
				
			)
			
			-- on l'ajoute à la liste import pour le suppr à la fin --
			append a_objetsImport ptCam
		),
		fn preparerRendu 		detail:  =(
			
			-- conversion des materiaux  --
			m_edit.convertMateriauxScene ()
			
			-- on s'occupe des lumieres -- 
			preparerLumieres()
			
			-- la camera --
			poserCamera 	detail:detail
			
			---- l'origine qui sert de parent à camera et lumiere ----
			poserOrigine  detail
			
			-- le sol --
			poserSol()
			
			-- le moteur de rendu
			nomMoteur = classof renderers.current as string
			
			if ( findString nomMoteur "Corona" != 0 ) do (
				moteurRenduPrecedant 								= renderers.current
				renderers.current 										= execute m_labib.prefs.apercus.moteur
				renderers.current.adaptivity_targetError 		= if detail then m_labib.prefs.apercus.noiseLevelDetail else m_labib.prefs.apercus.noiseLevel
				renderers.current.denoise_blendAmount		= m_labib.prefs.apercus.denoiseAmount
				renderers.current.denoise_filterType			= 2
				
				renderers.current.colorMap_simpleExposure 			= m_labib.prefs.apercus.exposition
				renderers.current.colorMap_highlightCompression	= m_labib.prefs.apercus.highlightCompress
				renderers.current.colorMap_colorTemp						= m_labib.prefs.apercus.temperatureRendu
				renderers.current.colorMap_contrast						= m_labib.prefs.apercus.contraste
				
-- 				renderers.current.vfb_type							= if m_labib.prefs.apercus.afficherVFB then 2	else 0 ---- 0:pour cacher le VFB corona  ----
				renderers.current.bg_texmap						= CoronaSky()
				renderers.current.bg_source						= 1
-- 				renderers.current.lockMax 							= true	---- bloquer max ? ----
			)
			
		),
		
		
		fn rendre detail:false	=(
			debug "apercu->rendre"
			local nomRendu 
			local prefix = if not detail 	then ( "" + m_labib.prefs.apercus.nom )
														else	( "" + m_labib.prefs.apercus.nomDetail )
			
			nomRendu = m_labib.prefs.apercus.dossier + "\\" + ( creerNomRendu 	prefix ) + ".jpg"
			
			Rendu = 	render cameraApercu 			outputSize:m_labib.prefs.apercus.taille   \
							outputfile:nomRendu 			vfb:false 			quiet:false					\
							cancelled:&TestCancelled	 	missingExtFilesAction:#logmsg
			
-- 			display  Rendu
			nomRendu
		),
		
		
		fn remettreRenduInitial = (
			renderers.current = moteurRenduPrecedant
		),
		
		
		
		
		
		
		
	public
		fn creer		elems 	detail:false	= (
			
-- 				---- debug ----
-- 				local  deb = true
				local nomRenduApercu
				toArray &elems
			
-- 				rollPrincipal = m_labib.m_rollPrincipal
				
				if elems.count > 0 do 
					if querybox "voulez vous créer les aperçus ?" do (
-- 						rollPrincipal.setProgress "Rendu aperçu ..." 0	
-- 						rollPrincipal.cancelled = false
						
-- 						holdMaxFile() 
						holdPerso ()
						
						i = 1.
						for elem in elems do (
							
-- 							if rollPrincipal.cancelled do continue
							
							pourcent = ( ( i - 1.) / elems.count * 100. )
-- 							rollPrincipal.setProgress ("Rendu aperçu " + ( i as integer )  as string + "/" + elems.count as string  ) 	pourcent
							
							if doesfileexist elem.fichier then( 
-- 								m_labib.outils.viderScene()
								resetMaxFile #noPrompt
								
								
-- 								elem.apercu = apercu.creer 	elem.fichier
								
								importer	elem.fichier
								preparerRendu 	detail:detail
								nomRenduApercu 	= rendre  detail:detail
								if detail then 
									elem.detail 			= nomRenduApercu
								else
									elem.apercu 			= nomRenduApercu
								elem.enregistrer ()
-- 								try ( m_labib.m_rollApercus.bmp_ap.fileName = nomRenduApercu ) catch ()								
								
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
					
						fetchPerso ()
					
-- 					
-- 			importer 	_fichier
-- 			preparerRendu 	detail:detail
-- 			nomRenduApercu = rendre  detail:detail
-- 			
-- 			try ( m_labib.m_rollApercus.bmp_ap.fileName = nomRenduApercu ) catch ()
-- 			
-- 			
			--nomRenduApercu
			
		)
		
		
		/* 
		fn creerApercu elems = (
				
-- 				---- debug ----
				local  deb = true
				
				rollPrincipal = m_labib.m_rollPrincipal
				
				if elems.count > 0 do 
					if querybox "voulez vous créer l'aperçu ?" do (
						rollPrincipal.setProgress "Rendu aperçu ..." 0	
						rollPrincipal.cancelled = false
						
						holdMaxFile() 
						
						i = 1.
						for elem in elems do (
							
							if rollPrincipal.cancelled do continue
							
							pourcent = ( ( i - 1.) / elems.count * 100. )
							rollPrincipal.setProgress ("Rendu aperçu " + ( i as integer )  as string + "/" + elems.count as string  ) 	pourcent
							
							if doesfileexist elem.fichier then( 
								outils.viderScene()
								resetMaxFile #noPrompt
								
								elem.apercu = apercu.creer 	elem.fichier
								
								rollPrincipal.AfficherElements 		rollPrincipal.noeudSelect					
								rollPrincipal.afficherInfos()
								
							)	else format "elem : % n'as pas de fichier valide : %\n" elem.nom elem.fichier
							i+=1
						)
						
						
						if rollPrincipal.cancelled then 
							rollPrincipal.setProgress ("Rendu : " + ( i as integer )  as string + "/" + elems.count as string  + " aperçus. *Annulé*") 100
						else 
							rollPrincipal.setProgress ("Rendu : " + ( i as integer )  as string + "/" + elems.count as string  + " aperçus.") 100				
						rollPrincipal.cancelled = false
						
						rollPrincipal.AfficherElements 	noeudSelect					
						rollPrincipal.afficherInfos()

						if not deb do 
						fetchMaxFile quiet:true
						
						m_labib.arbo.ecrireFichier()
						
					)
			),
		
			fn creerDetail  elems = (
				
				rollPrincipal = m_labib.m_rollPrincipal
				
				if elems.count > 0 do 
					if querybox "voulez vous créer l'aperçu Détail?" do (
						rollPrincipal.setProgress "Rendu détail ..." 0	
						rollPrincipal.cancelled = false
						
						holdMaxFile() 
						i=1.
						for elem in elems do (
							
							if rollPrincipal.cancelled do continue
							
							pourcent = ( ( i - 1.) / elems.count * 100. )
							rollPrincipal.setProgress ("Rendu détail " + ( i as integer )  as string + "/" + elems.count as string  ) 	pourcent
							if doesfileexist elem.fichier then( 
								outils.viderScene()
								elem.detail = apercu.creer 	elem.fichier detail:true
								rollPrincipal.AfficherElements m_rollPrincipal.noeudSelect					
								rollPrincipal.afficherInfos()
							)	else format "elem : % n'as pas de fichier valide : %\n" elem.nom elem.fichier
							i+=1
						)
						
						if rollPrincipal.cancelled then 
							rollPrincipal.setProgress ("Rendu détail : " + elems.count   as string + " aperçus. *Annulé*") 100
						else 
							rollPrincipal.setProgress ("Rendu détail : " + elems.count   as string + " aperçus.") 100				
						rollPrincipal.cancelled = false
				
						rollPrincipal.AfficherElements 	m_rollPrincipal.noeudSelect					
						rollPrincipal.afficherInfos()
						
						fetchMaxFile quiet:true
						
						m_labib.arbo.ecrireFichier()
						
					)
					
			)	
		, */


) -- fin struct Apercu --


