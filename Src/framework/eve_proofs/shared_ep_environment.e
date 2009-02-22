indexing
	description: "Shared access to EP_ENVIRONMENT"
	date: "$Date$"
	revision: "$Revision$"

class SHARED_EP_ENVIRONMENT

inherit

	SHARED_EVE_PROOFS_PREFERENCES

feature -- Access

	eve_proofs: EVE_PROOFS
			-- Shared EVE Proofs
		once
			create Result.make
		end

	feature_list: !EP_FEATURE_LIST
			-- Shared list of processed features
		once
			create Result.make
		end

	name_generator: !EP_DEFAULT_NAMES
			-- Shared name generator
		once
			create Result
		end

	type_mapper: !EP_TYPE_MAPPER
			-- Shared type mapper
		once
			create Result
		end

	errors: !LIST [EP_ERROR]
			-- Shared error list
		once
			create {LINKED_LIST [EP_ERROR]} Result.make
		end

	warnings: !LIST [EP_ERROR]
			-- Shared warnings list
		once
			create {LINKED_LIST [EP_ERROR]} Result.make
		end

	names: !EP_NAMES
			-- Shared access to interface names
		once
			create Result
		end

	text_output: TEXT_FORMATTER
			-- Access to text output handler
		do
			Result := text_output_cell.item
		end

	text_output_cell: CELL [TEXT_FORMATTER]
			-- Cell to hold text output handler
		once
			create Result
		end

	event_handler: EP_EVENT_HANDLER
			-- Event handler
		once
			create Result
		end

feature -- Convenience

-- TODO: move to its own class?
-- TODO: add 'indent' 'unindent' features

	is_class_proof_done (a_class: !CLASS_C): BOOLEAN
			-- Is proof of class `a_class' done?
		do
			Result := boolean_value_in_class_indexing (a_class, "proof", True)
		end

	is_feature_proof_done (a_feature: !FEATURE_I): BOOLEAN
			-- Is proof of feature `a_feature' done?
		do
			Result := boolean_value_in_feature_indexing (a_feature, "proof", True)
		end

	boolean_value_in_feature_indexing (a_feature: FEATURE_I; a_tag: STRING; a_default: BOOLEAN): BOOLEAN
			-- Value of first tag `a_tag' in indexing of `a_feature', or `a_default' if tag is not set
		local
			l_indexing_clause: INDEXING_CLAUSE_AS
		do
			l_indexing_clause := a_feature.written_class.ast.feature_with_name (a_feature.feature_name_id).indexes
			Result := boolean_value_in_indexing (l_indexing_clause, a_tag, a_default)
		end

	boolean_value_in_class_indexing (a_class: !CLASS_C; a_tag: STRING; a_default: BOOLEAN): BOOLEAN
			-- Value of first tag `a_tag' in indexing of `a_feature', or `a_default' if tag is not set
		local
			l_indexing_clause: INDEXING_CLAUSE_AS
		do
			l_indexing_clause := a_class.ast.internal_top_indexes
			Result := boolean_value_in_indexing (l_indexing_clause, a_tag, a_default)
		end

	boolean_value_in_indexing (a_indexing_clause: INDEXING_CLAUSE_AS; a_tag: STRING; a_default: BOOLEAN): BOOLEAN
			-- Value of first tag `a_tag' in indexing of `a_feature', or `a_default' if tag is not set
		local
			l_index: INDEX_AS
			l_bool: BOOL_AS
			l_found: BOOLEAN
		do
			Result := a_default
			if a_indexing_clause /= Void then
				from
					a_indexing_clause.start
				until
					a_indexing_clause.after or l_found
				loop
					l_index := a_indexing_clause.item
					if l_index.tag.name.as_lower.is_equal (a_tag.as_lower) then
						l_found := True
						l_bool ?= l_index.index_list.first
						if l_bool /= Void then
							Result := l_bool.value
						end
					end
					a_indexing_clause.forth
				end
			end
		end

	verify_value_in_indexing (a_indexing_clause: INDEXING_CLAUSE_AS): BOOLEAN
			-- Value of the first indexing tag `Verify'
			-- If the tag is not set, it will default to true.
		local
			l_index: INDEX_AS
			l_bool: BOOL_AS
			l_found: BOOLEAN
		do
			Result := True
			if a_indexing_clause /= Void then
				from
					a_indexing_clause.start
				until
					a_indexing_clause.after or l_found
				loop
					l_index := a_indexing_clause.item
						-- TODO: extract string literal
					if l_index.tag.name.as_lower.is_equal ("proof") then
						l_found := True
						l_bool ?= l_index.index_list.first
						if l_bool /= Void then
							Result := l_bool.value
						end
					end
					a_indexing_clause.forth
				end
			end
		end

end
