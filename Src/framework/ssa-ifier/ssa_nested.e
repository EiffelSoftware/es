note
	description: "Summary description for {SSA_NESTED}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_NESTED

inherit
	SSA_EXPR

create
	make

feature
	make (a_target: SSA_EXPR; a_name: STRING; a_args: LIST [SSA_EXPR])
		do
			target := a_target
			name := a_name
			args := a_args
		end

	target: SSA_EXPR
	name: STRING
	args: LIST [SSA_EXPR]

	as_code: STRING
		do
			Result := target.as_code + "." + name

			if not args.is_empty then
				Result := Result + " ("

				from
					args.start
				until
					args.after
				loop
					Result := Result + args.item.as_code
					args.forth

					if not args.after then
						Result := Result + ", "
					end
				end

				Result := Result + ")"
			end
		end

end
