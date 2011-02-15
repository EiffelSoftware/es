note
	description: "A very basic representation of a Daikon declaration if the attributes are not specified a default declaration will be used"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_DAIKON_DECLARATION

inherit
	ANY
	  redefine
	 	out
	  end

	AFX_DAIKON_VARIABLE_NAME_CODEC
		redefine
			out
		end

create
	make,
	make_with_expression

feature{NONE} -- Initialization

	make (equation : EPA_EQUATION)
			-- the variable name used for the declaration
		do
 			make_with_expression (equation.expression)
		end

	make_with_expression (a_expression: EPA_EXPRESSION)
			-- Initialize Current variable declaraction with `a_expression'.
		do
			var_kind := "variable"
 			rep_type := get_rep_type (a_expression.type)
 			dec_type := rep_type.twin
 			-- flags := "non_null"

-- 			variable_name := a_expression.text
-- 			remove_space(variable_name)
 			variable_name := escaped_variable_name (a_expression.text)
		end

feature -- Set

	out : STRING is
			-- generate the declaration output
			--	variable all_default
			--		var-kind field all_default
		    --		dec-type boolean
			--		rep-type boolean
			--		flags non_null
		do
			result := "%T variable "+ variable_name + "%N"
			result := result + "%T%T var-kind "+ var_kind + "%N"
			result := result + "%T%T dec-type "+ dec_type + "%N"
			result := result + "%T%T rep-type "+ rep_type + "%N"
		end



feature {NONE} -- Implementation

	get_rep_type ( type : TYPE_A) :STRING is
			-- return a representation type
			--boolean, int, hashcode, double, or java.lang.String or hashcode

		do
			if (type.is_integer or type.is_natural) then
				result :="int";

			elseif (type.is_real_32 or type.is_real_64 )  then
				result :="double";

			elseif (type.is_boolean )  then
				result :="boolean";
			else
				result :="hashcode"
			end
		end

  	remove_space(str:STRING) is
   			--
   		local
   			i :INTEGER
   		do
   			from
   				i := 1
   			until
   				i >= str.count
   			loop
   				if (str.at (i).is_space) then
   					str.remove_substring (i,i)
   				else
	   				i := i + 1
   				end
   			end

   		end


	variable_name : STRING
		-- The variable name for the declaration

	var_kind : STRING
		-- Possible values field, function, array, variable, return

 	dec_type : STRING
 		-- Java types int, boolean,

 	rep_type : STRING
 		-- boolean, int, hashcode, double, or java.lang.String or hashcode for other objs  and

 	flags : STRING
 		--is_param , no_dups ,not_ordered,classname ,to_string, non_null

invariant
	invariant_clause: True -- Your invariant here

end
