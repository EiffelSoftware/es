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

feature -- Element change

	record_creation_routine_needed (a_feature: !FEATURE_I)
			-- Record that `a_feature' is needed as a creation routine.
		local
			l_found: BOOLEAN
		do
			-- TODO: do this different...
			from
				creation_routines_needed.start
			until
				creation_routines_needed.after or l_found
			loop
				if creation_routines_needed.item_for_iteration.rout_id_set.first = a_feature.rout_id_set.first then
					l_found := True
				end
				creation_routines_needed.forth
			end
			from
				creation_routines_generated.start
			until
				creation_routines_generated.after or l_found
			loop
				if creation_routines_generated.item_for_iteration.rout_id_set.first = a_feature.rout_id_set.first then
					l_found := True
				end
				creation_routines_generated.forth
			end

			if not l_found then
				creation_routines_needed.extend (a_feature)
			end

--			if not creation_routines_generated.has (a_feature) then
--				creation_routines_needed.extend (a_feature)
--			end
--		ensure
--			not creation_routines_generated.has (a_feature) implies creation_routines_needed.has (a_feature)
		end

	record_feature_needed (a_feature: !FEATURE_I)
			-- Record that `a_feature' is needed either in a contract or an implementation.
		do
			if not features_generated.has (a_feature) then
				features_needed.extend (a_feature)
			end
		ensure
			not features_generated.has (a_feature) implies features_needed.has (a_feature)
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
		end

end
