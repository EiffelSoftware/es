note
	description: "[
					Default table in annotated (with hints) mode.
					Only shows the skeleton of features and hides the rest.
					This behaviour can of course be overridden by local annotations.
				]"
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_DEFAULT_ANNOTATED_HINT_TABLE

inherit

	AT_HINT_TABLE

create
	make

feature {NONE} -- Initialization

		-- DO NOT PRETTIFY THIS CLASS!

	make
			-- Initialization for `Current'.
		do
			create table.make (16)

			-- Hint level:	1
			table.put (<< 	True	>>, "feature")			-- Always show features
			table.put (<< 	True	>>, "arguments")		-- Always show arguments
			table.put (<< 	False	>>, "precondition")		-- Never show preconditions
			table.put (<< 	False	>>, "locals")			-- Never show locals
			table.put (<< 	False	>>, "body")				-- Never show body
			table.put (<< 	False	>>, "postcondition")	-- Never show postconditions
			table.put (<< 	False	>>, "classinvariant")	-- Never show class invariants
		end

end
