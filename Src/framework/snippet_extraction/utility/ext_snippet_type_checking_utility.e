note
	description: "[
		Class to provide a typed environment for a snippet by simulating
		a fake feature containing that snippet.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_SNIPPET_TYPE_CHECKING_UTILITY

inherit
	EPA_UTILITY

feature -- Access

	context (a_snippet: EXT_SNIPPET): detachable EPA_CONTEXT
			-- Context used for type checking program elements
			-- inside `a_snippet'
			-- Return Void if no such context is available, for example,
			-- some required types are not compiled in current loaded project.
		local
			l_opd_types: HASH_TABLE [TYPE_A, STRING]
			l_has_error: BOOLEAN
		do
				-- Calculate the types of operands in `a_snippet'.
			create l_opd_types.make (a_snippet.operands.count)
			l_opd_types.compare_objects
			across a_snippet.operands as l_opds until l_has_error loop
				if attached{TYPE_A} type_a_from_string_in_application_context (l_opds.item) as l_type then
					l_opd_types.force (l_type, l_opds.key)
				else
					l_has_error := True
				end
			end

			if not l_has_error then
				create Result.make (l_opd_types)
			end
		end

end
