clearListener ()
try ( 	labib.fermer ()	) catch  ()

Global 	labib = fileIn "$userScripts\labib\labib.ms" 
 format "\n\n"

labib.ouvrir 	()
/* 
labib.ouvrir 	()
	Global 	labib = fileIn "$userScripts\labib\labib.ms" 
	labib.ouvrir 	()
	
 */
 
macroScript Labib
category:"#CPages"
toolTip:""
(
	
	Global 	labib  = fileIn "$userScripts\labib\labib.ms" 
	
	on execute do 	(
		
		if ( labib.estOuvert () )	
			then	labib.fermer	()
			else 	labib.ouvrir 	()
	)
	on isChecked return try ( labib.estOuvert () )  catch	( false )	
	
)


/*



labib.fenetre.m_dialog.m_TV.stocker_etatItems ()
labib.fenetre.m_dialog.m_TV.restaurer_etatItems ()

labib.fenetre.m_dialog.m_TV.m_etatItems


labib.creerArboDeBase()





debug "test" var:labib.arbo.root.enfants 	param:#nom

ShellLaunch "explorer.exe" @"C:\Users\kris\AppData\Local\Autodesk\3dsMax\2014 - 64bit\ENU\scripts\labib\data\"


 #### Arbo ####
labib.arbo.afficherNoeud labib.arbo.root
execute "#(0, 0, 0, 0, 0, 0, 0, 0)"
labib.arbo.root.enfants[2].enfants[1].enfants[1].dateDernierImport
labib.arbo.root.enfants[2].enfants[1].enfants[1].dateCreation
mouseTrack [on:<node>] [prompt:<message_string>] [snap:#2D|#3D] [trackCallback:fn|#(fn,arg)]


labib.edit.ouvrir 	labib.arbo.root.enfants[1]

labib.arbo.fichier_supprimer ()
labib.arbo.fichier_ouvrir ()
labib.arbo.enregistrer ()
labib.arbo.afficher()


labib.arbo.initialiser ()
labib.fenetre.m_dialog.viderListes ()
labib.fenetre.actualiser ()
labib.arbo.root.enregistrer ()
debug 	"" var:labib.arbo.root.enfants	 param:#nom


labib.fenetre.m_dialog.m_LV.m_brancheCourante.enfants.count

labib.arbo.fichier_ouvrir()


 #### TV ####
show 				labib.fenetre.m_dialog.ui_TV
showmethods 				labib.fenetre.m_dialog.ui_TV.nodes.item[1]
show 				labib.fenetre.m_dialog.ui_TV.nodes.item[1]
labib.fenetre.m_dialog.ui_TV.nodes.item[1].IsExpanded = true

labib.fenetre.m_dialog.ui_TV.nodes.item[0].nodes.item[1].expand ()
labib.fenetre.m_dialog.ui_TV.nodes.item[0].nodes.item[1].Collapse ()

 #### LV ####
show 				labib.fenetre.m_dialog.ui_LV
showmethods		labib.fenetre.m_dialog.ui_LV

labib.fenetre.m_dialog.m_LV.m_selection

labib.fenetre.m_dialog.ui_LV.selectedItems.item[1].name


 #### DOCKing ####
cui.RegisterDialogBar 		labib.fenetre.m_dialog		style:#(	#cui_handles, #cui_dock_left )
cui.DockDialogBar			labib.fenetre.m_dialog		#cui_dock_right -- #cui_dock_top -- #cui_dock_left

cui.UnRegisterDialogBar 	labib.fenetre.m_dialog




























*/

























