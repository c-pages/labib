/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA m_labib
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
 diverse manipulations des nodes, compter vertex, bounding box ...
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [30/10/2016] -----------------------------------------------------------------------------
########################################################################################################################*/



----------------------------------------
------ La structure manipNodes --------

----------------------------------------
struct str_manipNodes (
	
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="manipNodes",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
		
	
		
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
		
		
		fn calculerBB 	_objets	=	 (
			--debug "calculerBB"
			
			-- on calcul le bounding box de l'ensemble des objets --			
			local BB_result = #([0,0,0], [0,0,0])
			local mtrx_repereWorld = (matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0] )
			if _objets.count>0 then ( 
				BB_result = ( nodeGetBoundingBox _objets[1] mtrx_repereWorld  )
				
				for obj in _objets where ( superclassof obj != light  	and	superclassof obj != camera 	and 	superclassof obj != helper	and 	superclassof obj != shape and classOf obj != Targetobject and not obj.ishidden )	do (
					
					BoundingTemp = ( nodeGetBoundingBox obj mtrx_repereWorld  )

					format "BB_result : %		BoundingTemp : %\n"   BB_result  BoundingTemp
					
					if BoundingTemp[1].x < BB_result[1].x 	do 	BB_result[1].x = BoundingTemp[1].x 
					if BoundingTemp[1].y < BB_result[1].y 	do 	BB_result[1].y = BoundingTemp[1].y 
					if BoundingTemp[1].z < BB_result[1].z 	do 	BB_result[1].z = BoundingTemp[1].z 
						
					if BoundingTemp[2].x > BB_result[2].x 	do 	BB_result[2].x = BoundingTemp[2].x 
					if BoundingTemp[2].y > BB_result[2].y 	do 	BB_result[2].y = BoundingTemp[2].y
					if BoundingTemp[2].z > BB_result[2].z 	do 	BB_result[2].z = BoundingTemp[2].z 					
					
				)

			)
			return BB_result
			
		),
		fn calculerTaillesBB 	_objets =(
			local bb 		= calculerBB _objets
			local result		= [ abs ( bb[2].x - bb[1].x ), abs ( bb[2].y - bb[1].y ), abs ( bb[2].z - bb[1].z  ) ]
			result
		),
		
		fn calculerCentre 	_objets =(
			local bb 		= calculerBB _objets
			local result		= [ ( bb[2].x - bb[1].x )/2 + bb[1].x, ( bb[2].y - bb[1].y )/2 +bb[1].y, ( bb[2].z - bb[1].z  )/2 + bb[1].z ]
			result
		),
		
		fn creerDummyParent _objets =(
			
		)
		

) -- fin struct Apercu --


