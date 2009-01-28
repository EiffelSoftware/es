indexing
	description:
		"[
			TODO
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_FRAME_EXTRACTOR

inherit

	EP_VISITOR

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize frame extractor.
		do
			create last_frame_condition.make_empty
		end

feature -- Access

	last_frame_condition: STRING
			-- Last built frame condition

feature -- Basic operations

	build_frame_condition (a_feature: !FEATURE_I)
			-- Build frame condition for feature `a_feature'.
		do
			if is_pure (a_feature) then
				last_frame_condition := "frame.modifies_nothing(Heap, old(Heap))"
			else
				last_frame_condition := "true"
			end
		ensure
			frame_condition_built: not last_frame_condition.is_empty
		end

feature {NONE} -- Visitors


feature {NONE} -- Implementation


-- TODO: move someplace else and improve
	is_pure (a_feature: !FEATURE_I): BOOLEAN
			-- Is `a_feature' a pure feature?
		local
			l_indexing_clause: INDEXING_CLAUSE_AS
			l_index: INDEX_AS
			l_bool: BOOL_AS
			l_found: BOOLEAN
		do
			Result := feature_list.features_used_in_contracts.has (a_feature)
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

end
