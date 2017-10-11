/* 	---- collecter les bitmaps --------
			fn chercher_fichier  _bitmap_map 	_dossier	=(
				
				local dossiers_recherche = #(	"D:\01 - modeles 3D\00 - collections\ARCHMODELS\MAPS Evermotion" )
				local recurant = true
				local chemin_fichier = _bitmap_map.fileName
				local fichier = filenameFromPath chemin_fichier
							format"fichier a chercher :%\n" (  fichier)
				
				local i = 1
				local trouve= false
			
				for dossier in dossiers_recherche where not trouve	do (
					if doesFileExist ( dossier + "\\" + fichier) then (
						format"fichier trouvé:%\n" ( dossier + "\\" + fichier)
						_bitmap_map.fileName = ( dossier + "\\" + fichier)
						trouve	= true
					) else if recurant do (
						format"sous dossiers\n" 
						local sousDossiers = getDirectories dossier
						for sousDossier in sousDossiers where not trouve	do
							trouve = chercher_fichier  _bitmap_map 
						
					)
					
					
				)
				
				trouve
			) */
			---- collecter les bitmaps --------
			fn chercher_fichier  _bitmap_map 	_dossier	=(
				
				local recurant = true
				local chemin_fichier = _bitmap_map.fileName
				local fichier = filenameFromPath chemin_fichier
-- 							format"fichier a chercher :%\n" (  fichier)
				
				local i = 1
				local trouve= false
		
				if doesFileExist ( _dossier + "\\" + fichier) then (
					format"	---->	fichier trouvé:%	<----\n" ( _dossier + "\\" + fichier)
					_bitmap_map.fileName = ( _dossier + "\\" + fichier)
					trouve	= true
				) else if recurant do (
					local sousDossiers = getDirectories 	(_dossier + "*")
					for sousDossier in sousDossiers where not trouve	do (
						
						format"	sous dossiers:%\n"  sousDossier
						trouve = chercher_fichier  _bitmap_map 	sousDossier
					)
				)
					
				trouve
			)
			
			
			dossiers_recherche = #(	"D:\01 - modeles 3D\00 - collections\ARCHMODELS\MAPS Evermotion" )
			allTxtMaps = getClassInstances BitmapTexture

			for bitmap_map in allTxtMaps do
			(
				
				bitmap_map.fileName
				if not (doesFileExist ( bitmap_map.fileName ) ) do (
					format"fichier manquant:%\n" ( bitmap_map.fileName)
					local trouve = false
					for dossier in dossiers_recherche where not trouve	do (
						trouve = chercher_fichier	bitmap_map  dossier
					)
				)
				
			)

