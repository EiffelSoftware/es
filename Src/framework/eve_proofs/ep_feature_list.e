indexing
	description:
		"[
			List of features which are already generated and which still need to be generated.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_FEATURE_LIST

create
	make

feature {NONE} -- Implementation

	make
			-- Initialize object with emtpy lists.
		do
			create {LINKED_LIST [!FEATURE_I]} creation_routines_needed.make
			create {LINKED_LIST [!FEATURE_I]} creation_routines_generated.make
			create {LINKED_LIST [!FEATURE_I]} features_needed.make
			create {LINKED_LIST [!FEATURE_I]} features_generated.make
			create {LINKED_LIST [!FEATURE_I]} features_used_in_contracts.make
		end

feature -- Access

	creation_routines_needed: !LIST [!FEATURE_I]
			-- List of creation routines which still need to be generated

	creation_routines_generated: !LIST [!FEATURE_I]
			-- List of creation routines which have already been generated

	features_needed: !LIST [!FEATURE_I]
			-- List of feature which still need to be generated

	features_generated: !LIST [!FEATURE_I]
			-- List of featurew which have already been generated

	features_used_in_contracts: !LIST [!FEATURE_I]
			-- List of features used in contracts
			-- This list is used to determine which referenced features should
			-- be marked as pure when their signature is printed

feature -- Status report

	has_feature_used_in_contract (a_feature: !FEATURE_I): BOOLEAN
			-- Is `a_feature' used in a contract?
		do
			Result := features_used_in_contracts.there_exists (agent has_routine_id (?, a_feature.rout_id_set.first))
		end

-- TODO: move someplace else and improve
	is_pure (a_feature: !FEATURE_I): BOOLEAN
			-- Is `a_feature' a pure feature?
		local
			l_indexing_clause: INDEXING_CLAUSE_AS
			l_index: INDEX_AS
			l_bool: BOOL_AS
			l_found: BOOLEAN
		do
			Result := has_feature_used_in_contract (a_feature)
			if not Result then
				l_indexing_clause := a_feature.written_class.ast.feature_with_name (a_feature.feature_name_id).indexes
				if l_indexing_clause /= Void then
					from
						l_indexing_clause.start
					until
						l_indexing_clause.after or l_found
					loop
						l_index := l_indexing_clause.item
						if l_index.tag.name.as_lower.is_equal ("pure") then
							l_found := True
							l_bool ?= l_index.index_list.first
							if l_bool /= Void then
								Result := l_bool.value
							end
						end
						l_indexing_clause.forth
					end
				end
			end
		end


	is_creation_routine_already_generated (a_feature: !FEATURE_I): BOOLEAN
			-- Is `a_feature' already generated as a creation routine?
		do
			Result := creation_routines_generated.there_exists (agent has_routine_id (?, a_feature.rout_id_set.first))
		end


feature -- Element change

	record_creation_routine_needed (a_feature: !FEATURE_I)
			-- Record that `a_feature' is needed as a creation routine.
		local
			l_routine_id: INTEGER
		do
			l_routine_id := a_feature.rout_id_set.first
			if
				not creation_routines_needed.there_exists (agent has_routine_id (?, l_routine_id)) and then
				not creation_routines_generated.there_exists (agent has_routine_id (?, l_routine_id))
			then
				creation_routines_needed.extend (a_feature)
			end
		ensure
			-- not working, as we are checking over routine ids and not object identities
			--not creation_routines_generated.has (a_feature) implies creation_routines_needed.has (a_feature)
		end

	record_feature_needed (a_feature: !FEATURE_I)
			-- Record that `a_feature' is needed either in a contract or an implementation.
		local
			l_routine_id: INTEGER
		do
			l_routine_id := a_feature.rout_id_set.first
			if
				not features_needed.there_exists (agent has_routine_id (?, l_routine_id)) and then
				not features_generated.there_exists (agent has_routine_id (?, l_routine_id))
			then
				features_needed.extend (a_feature)
			end
		ensure
			-- not working, as we are checking over routine ids and not object identities
			--not features_generated.has (a_feature) implies features_needed.has (a_feature)
		end


	record_feature_used_in_contract (a_feature: !FEATURE_I)
			-- Record that `a_feature' is used in a contract.
		local
			l_routine_id: INTEGER
		do
			l_routine_id := a_feature.rout_id_set.first
			if not features_used_in_contracts.there_exists (agent has_routine_id (?, l_routine_id)) then
				features_used_in_contracts.extend (a_feature)
			end
		ensure
			-- not working, as we are checking over routine ids and not object identities
			--not features_generated.has (a_feature) implies features_needed.has (a_feature)
		end

feature -- Basic operations

	mark_creation_routine_as_generated (a_feature: !FEATURE_I)
			-- Mark that `a_feature' has been generated as a creation routine.
		do
			creation_routines_needed.prune_all (a_feature)
			creation_routines_generated.extend (a_feature)
		ensure
			a_feature_not_needed: not creation_routines_needed.has (a_feature)
			a_feature_generated: creation_routines_generated.has (a_feature)
		end

	mark_feature_generated (a_feature: !FEATURE_I)
			-- Mark that `a_feature' has been generated as a normal feature.
		do
			features_needed.prune_all (a_feature)
			features_generated.extend (a_feature)
		ensure
			a_feature_not_needed: not features_needed.has (a_feature)
			a_feature_generated: features_generated.has (a_feature)
		end

	reset
			-- Reset the lists.
		do
			creation_routines_needed.wipe_out
			creation_routines_generated.wipe_out
			features_needed.wipe_out
			features_generated.wipe_out
			features_used_in_contracts.wipe_out
		end

feature {NONE} -- Implementation

	has_routine_id (a_feature: !FEATURE_I; a_routine_id: INTEGER): BOOLEAN
			-- Has `a_feature' routine id `a_routine_id'?
		do
			Result := a_feature.rout_id_set.first = a_routine_id
		end

end
