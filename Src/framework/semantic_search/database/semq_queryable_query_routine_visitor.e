note
	description: "Queryable query helper AST visitor to turn routine call AST into a string"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_QUERYABLE_QUERY_ROUTINE_VISITOR

inherit
	AST_ITERATOR
		redefine
			process_access_feat_as,
			process_current_as
		end

create
	make

feature{NONE} -- Initialization

	make
			-- Initialization
		do
			argument_count := 0
			create arguments.make
			create target.make_empty
			create feature_name.make_empty
		end


feature -- Access

	argument_count: INTEGER
		-- Number of arguments

	arguments: LINKED_LIST [STRING]
		-- Arguments

	target: STRING
		-- Target of routine call

	target_and_arguments: LINKED_LIST [STRING]
			-- Target and arguments of routine call
		do
			create Result.make
			Result.extend (target)
			Result.append (arguments)
		end

	feature_name: STRING
		-- Name of routine called

	call_as_string: STRING
			-- The routine call as a string
		do
			Result := call_as_string_implementation (False)
		end

	call_as_string_anonymous: STRING
			-- The routine call with all features replaced by '$'
		do
			Result := call_as_string_implementation (True)
		end

feature{NONE} -- Implementation

	call_as_string_implementation (is_anonymous: BOOLEAN): STRING
			-- Implementation of routine call as a string
		do
			if is_anonymous then
				create Result.make_from_string (once "$")
			else
				create Result.make_from_string (target)
			end
			if feature_name.count > 0 then
				Result.append_character ('.')
				Result.append (feature_name)
			end
			if arguments.count > 0 then
				Result.append_character (' ')
				Result.append_character ('(')
				from
					arguments.start
				until
					arguments.after
				loop
					if is_anonymous then
						Result.append_character ('$')
					else
						Result.append (arguments.item)
					end
					arguments.forth
					if not arguments.after then
						Result.append_character (',')
						Result.append_character (' ')
					end
				end
				Result.append_character (')')
			end
		end

	process_access_name (a_name: STRING)
		do
			-- Target
			if target.is_empty then
				target := a_name

			-- Feature Name
			elseif feature_name.is_empty then
				feature_name := a_name
				argument_count := argument_count - 1 -- Fix

			-- Arguments
			else
				arguments.extend (a_name)
			end

			-- Counting
			argument_count := argument_count + 1
		end

feature -- Roundtrip

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			process_access_name (l_as.access_name_8)
			Precursor (l_as)
		end

	process_current_as (l_as: CURRENT_AS)
		do
			process_access_name (l_as.access_name_8)
			Precursor (l_as)
		end

end
