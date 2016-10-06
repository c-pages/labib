
------ OUTPUTS	------------------------------------------------------------------------------------------------------------------------------------


fn remplirTexte  _txt  var:	 param:   = (
	
	local result =""
	global dbg_elemTmp
	if var != unsupplied then (
		
		result += "	- " + _txt +  " : "	
		
		if classof 	var == Array then (
			
			if param != unsupplied then (
				result += "(" + var.count as string + ")  "
				for i = 1 to var.count do (
					if var[i]	 != undefined then (
					dbg_elemTmp	= var[i]					
					
					result +=  ( execute ("dbg_elemTmp." + param ) ) as string 
					
					if i != var.count	do result += ", "
					) else result += "undefined"
				)
			) else 	result += var as string
		) else 
		if param != unsupplied  then (
			if var != undefined then (
				dbg_elemTmp	= var
				result += ( execute ("dbg_elemTmp." + param ) ) as string 
			) else 	result += "undefined"
		) else 	result += var as string
	) else 	result += _txt
	result
)
	
----- debug ------------------------------
global debug
DEBUG_MODE = true

fn debug 	_txt  var:	 param:    = 	(
	if DEBUG_MODE   do (
		local txtFinal = "<DEBUG>	"
		
		txtFinal += remplirTexte  _txt  var:var	 param:param
		
		format "%\n"	txtFinal
	)
)		
----- output ------------------------------
fn ecrire 		_txt  var:	 param:   = 	(
	local txtFinal = "<Labib>	"
	
	txtFinal += remplirTexte  _txt  var:var	 param:param
	
	format "%\n"	txtFinal
	
)

------ OUTPUT	------------------------------------------------------------------------------------------------------------------------------------
