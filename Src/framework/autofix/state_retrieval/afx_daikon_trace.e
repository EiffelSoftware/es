note
	description: "Summary description for {AFX_DAIKON_TRACE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_DAIKON_TRACE
	inherit
		any
		   redefine
		   	out
		   	end
	create
	   make
feature --Constructor

	make (equation : AFX_EQUATION) is
			-- create the trace with the current variable
		do
			output := equation.expression.text +"%N"
			output := output + get_value(equation) +"%N"
			output := output + "1%N"

		end

     out :STRING is
     		-- print the trace
     	do
			result := output
     	end

feature{NONE} -- Implementation

	get_value (equation : AFX_EQUATION):STRING is
			-- Return the right representation for each type
		do
			if (equation.type.name.has_substring ("BOOLEAN")) then
				if (equation.value.out.has_substring ("True")) then
					result:= "1"
				else
					result:= "0"
				end
			else
				result := equation.value.out
			end
		end


   output : STRING
   	-- the trace

end
