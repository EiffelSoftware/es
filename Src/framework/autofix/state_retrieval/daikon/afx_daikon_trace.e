note
	description: "Summary description for {AFX_DAIKON_TRACE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_DAIKON_TRACE
	inherit
		ANY
		   redefine
		     out
		   end

		REFACTORING_HELPER
		   undefine
		  	 out
		   end

	create
	   make
feature --Constructor

	make (equation : EPA_EQUATION) is
			-- create the trace with the current variable
		local
			expression_str:STRING
		do
			expression_str := equation.expression.text
			remove_space(expression_str)
			output := expression_str +"%N"
			output := output + get_value(equation) +"%N"
			output := output + "1%N"

		end

     out :STRING is
     		-- print the trace
     	do
			result := output
     	end

feature{NONE} -- Implementation

	get_value (equation : EPA_EQUATION):STRING is
			-- Return the right representation for each type
			-- Use visitor
		do
			if (equation.value.out.is_boolean) then
				if (equation.value.out.to_boolean) then
					Result := "1"
				else
					Result := "0"
				end
			elseif(equation.value.out.is_integer or equation.value.out.is_natural or equation.value.out.is_real) then
				Result := equation.value.out
			elseif equation.value.is_nonsensical then
				Result := equation.value.out
			else
				Result := equation.value.out.hash_code.out
			end
		end

   output : STRING
   	-- the trace

   	remove_space(str:STRING) is
   			--
   		local
   			i :INTEGER
   		do
   			from
   				i := 1
   			until
   				i = str.count
   			loop
   				if (str.at (i).is_space) then
   					str.remove_substring (i,i)
   				end
   				i := i + 1

   			end

   		end


end
