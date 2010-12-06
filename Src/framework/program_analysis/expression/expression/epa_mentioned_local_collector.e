note
	description: "Class to collect mentioned locals in an AST"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_MENTIONED_LOCAL_COLLECTOR

inherit
	KL_SHARED_STRING_EQUALITY_TESTER

	AST_ITERATOR
		redefine
			process_access_id_as,
			process_address_as
		end

feature -- Access

	mentioned_locals: DS_HASH_SET [STRING]
			-- Mentioned locals in last `collect'

feature -- Basic operations

	collect (a_ast: AST_EIFFEL; a_all_locals: DS_HASH_SET [STRING])
			-- Collect locals that are mentioned in `a_ast'.
			-- All declared locals are in `a_all_locals'.
			-- Make results available in `mentioned_locals'.
		do
			all_locals := a_all_locals
			create mentioned_locals.make (10)
			mentioned_locals.set_equality_tester (string_equality_tester)
			a_ast.process (Current)
		end

feature{NONE} -- Implementation

	all_locals: DS_HASH_SET [STRING]
			-- All locals

feature{NONE} -- Access

	process_access_id_as (l_as: ACCESS_ID_AS)
			-- Process `l_as'.
		local
			l_name: STRING
		do
			l_name := l_as.access_name_8.as_lower
			if all_locals.has (l_name) then
				mentioned_locals.force_last (l_name)
			end
			safe_process (l_as.internal_parameters)
		end

	process_address_as (l_as: ADDRESS_AS)
			-- Process `l_as'.
		local
			l_name: STRING
		do
			l_name := l_as.feature_name.internal_name.name_8
			if all_locals.has (l_name) then
				mentioned_locals.force_last (l_name)
			end
		end

end
