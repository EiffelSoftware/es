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

	create
	  make

feature -- Constructor
	make (equation : AFX_EQUATION) is
			-- the variable name used for the declaration
		do
			var_kind := "variable"
 			dec_type := equation.expression.text
 			rep_type := get_rep_type (equation.type)
 			flags := "non_null"

 			variable_name := equation.expression.text
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
			result := result + "%T%T flags "+ flags + "%N"

		end



feature {NONE} -- Implementation

	get_rep_type ( type : TYPE_A) :STRING is
			-- return a representation type
			--boolean, int, hashcode, double, or java.lang.String or hashcode

		do
			if (type.name.has_substring ("INTEGER") ) then
				result :="int";

			elseif (type.name.has_substring ("DOUBLE") )  then
				result :="double";

			elseif (type.name.has_substring ("BOOLEAN") )  then
				result :="boolean";

			elseif (type.name.has_substring ("STRING") )  then
				result :="java.lang.String";
			else
				result :="hashcode"
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
