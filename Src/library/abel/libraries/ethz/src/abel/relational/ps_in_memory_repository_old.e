note
	description: "Template class to inherit from to obtain a custom in-memory strategy"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_IN_MEMORY_REPOSITORY_OLD

inherit

	PS_REPOSITORY -- [PS_OO_CRITERION]
	--redefine
	--	execute_query

feature {NONE} -- Initialization

	make
			-- Initialize `Current' descendant.
		do
			--		create {ARRAYED_LIST [PS_CRITERION]} criteria.make (Default_dimension)
		end

feature -- Access

feature -- Basic operations

	match (projection: ARRAY [STRING])
			-- Try a match on the repository data by and-ing `criteria'. Update `matched'.
		deferred
		end

	match_any (projection: ARRAY [STRING])
			-- Try a match on the repository data by and-ing `criteria'. Update `matched'.
		deferred
		end

	execute_transactional_query (t_query: PS_TRANSACTION_UNIT)
			-- Execute an in-memory transactional query.
		deferred
		end

feature {PS_IN_MEMORY_REPOSITORY_OLD} -- Implementation
	--	criteria_as_agents: LIST [PREDICATE [ANY, TUPLE [ANY]]]
	--			
	-- List of agent criteria extracted from the list of criteria.
	--		do
	--			create {ARRAYED_LIST [PREDICATE [ANY, TUPLE [ANY]]]} Result.make (Default_dimension)
	--
	--			across criteria
	--				 as crit
	--			loop
	--				if attached {PS_OO_CRITERION} crit.item as c then
	--					Result.extend (c.agent_criterion)
	--				end
	--			end
	--		end

invariant
	invariant_clause: True -- Your invariant here

end
