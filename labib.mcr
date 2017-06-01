
clearListener ()
-- try ( 	labib.fermer ()	) catch  ()

-- fileIn "$userScripts\cp - labib\labib.ms" 
--  format "\n\n"

-- labib.creerArboDeBase()
-- labib.creerArboDeBase()

-- labib.ouvrir 	()
/*
labib.ouvrir 	()
	Global 	labib = fileIn "$userScripts\labib\labib.ms" 
	labib.ouvrir 	()
	scene vertex
 */

	
try ( 	
-- 	labib.fermer()
	destroydialog labib.fenetre.m_dialog		
) catch  ()

	
macroScript Labib
category:"#CPages"
toolTip:""
(

	global labib
	
	fileIn	 "$userScripts\cp - labib\labib.ms" 
-- 	fileIn "C:\Users\kris\AppData\Local\Autodesk\3dsMax\2014 - 64bit\ENU\scripts\labib\labib.ms" 
	
	labib.prefs.reset()
	
	on execute do 	(
		
		if ( labib.estOuvert () )	
			then	labib.fermer	()
			else 	labib.ouvrir 	()
		
	)
	on isChecked return try ( labib.estOuvert () )  catch	( false )	
	
)

-- 	labib.ouvrir 	()

/*
labib.prefs.fermer()

labib.prefs.m_dialog.ui_btnReset.height
labib.prefs.m_dialog.ui_editBiblio.height


labib.edit.
labib.edit.getNdsAAfficher ()

labib.edit.m_ndsAAfficher
labib.arbo.fichier_supprimer ()
labib.arbo.fichier_ouvrir ()

labib.creerArboDeBase()
labib.ouvrir ()


debuger "" var:(labib.edit.getSelection ()) param:#nom
showmethods labib.fenetre.m_dialog.m_LV.m_ui.BackgroundImage
show  labib.fenetre.m_dialog.m_LV.m_ui.BackgroundImageLayout
show labib.fenetre.m_dialog.m_LV.m_ui
labib.fenetre.m_dialog.m_LV.m_ui.ResetBackColor() ()

show labib.fenetre.m_dialog.m_LV.m_ui.borderstyle
 labib.fenetre.m_dialog.m_LV.m_ui.BackgroundImageLayout =  (dotnetclass "System.Windows.Forms.ImageLayout").zoom
 
 
 
 

labib.cmd.defaire()


labib.fenetre.m_dialog.m_TV.stocker_etatItems ()
labib.fenetre.m_dialog.m_TV.restaurer_etatItems ()

labib.fenetre.m_dialog.m_TV.m_etatItems




debug "test" var:labib.arbo.root.enfants 	param:#nom

ShellLaunch "explorer.exe" @"C:\Users\Windows\AppData\Local\Autodesk\3dsMax\2017 - 64bit\ENU\scripts\cp - Labib\data\"


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

tmp = labib.fenetre.m_dialog.ui_TV.SelectedNode
labib.fenetre.m_dialog.ui_TV.SelectedNode = tmp
cible = labib.arbo.root.enfants[1]

labib.arbo.recherche.ajouterEnfant cible

######" recherche ######
show 				labib.fenetre.m_dialog.ui_recherche.ContextMenu
showmethods 				labib.fenetre.m_dialog.ui_recherche


labib.fenetre.m_dialog.ui_recherche.text = ""

labib.fenetre.m_dialog.m_recherche.actualiser ()

labib.edit.actualiser ()
labib.fenetre.m_dialog.actualiser ()
 #### LV ####
show 				labib.fenetre.m_dialog.ui_LV.items.item[1]
showmethods		labib.fenetre.m_dialog.ui_LV

labib.fenetre.m_dialog.ui_LV.SelectedItems

labib.fenetre.m_dialog.m_LV.m_selection

labib.fenetre.m_dialog.ui_LV.selectedItems.item[1].name


 #### DOCKing ####
cui.RegisterDialogBar 		labib.fenetre.m_dialog		style:#(	#cui_handles, #cui_dock_left )
cui.DockDialogBar			labib.fenetre.m_dialog		#cui_dock_right -- #cui_dock_top -- #cui_dock_left

cui.UnRegisterDialogBar 	labib.fenetre.m_dialog




labib.fenetre.m_dialog.ui_LV.items.item[2].selected


labib.fenetre.m_dialog.ui_LV









 #### ui tags ####
show 				labib.fenetre.m_dialog.ui_tags.items.item[0].checked

showmethods 				labib.fenetre.m_dialog.ui_tags.items

labib.fenetre.m_dialog.m_tags.getChecked ()


labib.fenetre.m_dialog.ui_tags.items.count
labib.fenetre.m_dialog.ui_tags.items.item[1].text







*/

























