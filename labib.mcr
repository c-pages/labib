

	try labib.fenetre.fermer () catch ()
	Global 	labib = fileIn "$userScripts\labib\labib.ms" 
	
	
macroScript labib
category:"#CPages"
toolTip:""
(
	
	on execute do 	(
		
-- 		if labib == undefined then 
-- 			labib =	
		
		if labib.fenetre.estOuverte then	(
			labib.fermer	()
			labib.fenetre.estOuverte = false
		) else (
			labib.ouvrir 	()
			labib.fenetre.estOuverte = true 
		)
		
	)
	
	on isChecked return try labib.fenetre.estOuverte  catch	( false )
	
)
