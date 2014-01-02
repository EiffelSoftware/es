note
	description: "Summary description for {CA_UNUSED_ARGUMENT_FIX}."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_UNUSED_ARGUMENT_FIX

inherit
	CA_FIX
		rename
			make as make_fix
		redefine
			process_body_as
		end

create
	make

feature {NONE} -- Initialization

	make (a_class: CLASS_C; a_affected_body: BODY_AS; a_var_name: STRING_32)
			-- Initialization for `Current'.
		do
			make_fix (ca_names.unused_argument_fix + a_var_name, a_class)
			affected_body := a_affected_body
			var_name := a_var_name
		end

feature {NONE} -- Implementation

	affected_body: BODY_AS

	var_name: STRING_32

feature -- Iteration

	process_body_as (a_body: BODY_AS)
		local
			j: INTEGER
		do
			if a_body.is_equivalent (affected_body) then
				if attached a_body.arguments then
					across a_body.arguments as l_args loop
						from
							j := 1
						until
							j > l_args.item.id_list.count
						loop
							if var_name.is_equal (l_args.item.item_name (j)) then
									-- TODO: replace AST text
								l_args.item.replace_text ("", matchlist)
--								l_args.item.id_list.go_i_th (j)
--								l_args.item.id_list.remove
							end
							j := j + 1
						end
					end
				end
			end
		end

end
