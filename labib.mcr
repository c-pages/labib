macroScript Labib
category:"#CPages"
toolTip:""
(
	
	Global 	labib = undefined
	
	on execute do 	(
		
		if labib == undefined then 
			fileIn "$userScripts\labib\labib.ms"
		
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