
try destroydialog labib.fenetre.m_dialog	catch  ()

Global 	labib = fileIn "$userScripts\labib\labib.ms" 
labib.ouvrir 	()
/* 

	Global 	labib = fileIn "$userScripts\labib\labib.ms" 
	labib.ouvrir 	()
	
 */
 
 
macroScript Labib
category:"#CPages"
toolTip:""
(
	
	Global 	labib = fileIn "$userScripts\labib\labib.ms" 
	
	on execute do 	
		if ( labib.estOuvert () )	
			then		labib.fermer	()
			else 	labib.ouvrir 	()
	
	on isChecked return try ( labib.estOuvert () )  catch	( false )	
	
)
/*


 #### Arbo ####
labib.arbo.afficherNoeud labib.arbo.root
execute "#(0, 0, 0, 0, 0, 0, 0, 0)"
labib.arbo.root.enfants[2].enfants[1].enfants[1].dateDernierImport
labib.arbo.root.enfants[2].enfants[1].enfants[1].dateCreation
mouseTrack [on:<node>] [prompt:<message_string>] [snap:#2D|#3D] [trackCallback:fn|#(fn,arg)]



 #### LV ####
show 				labib.fenetre.m_dialog.ui_LV
showmethods		labib.fenetre.m_dialog.ui_LV

labib.fenetre.m_dialog.m_LV.m_selection



 #### DOCK ####
cui.RegisterDialogBar 		labib.fenetre.m_dialog
cui.DockDialogBar			labib.fenetre.m_dialog		#cui_dock_left

cui.UnRegisterDialogBar 	labib.fenetre.m_dialog




*/