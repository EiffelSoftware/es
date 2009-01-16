indexing
	description: "Shared access to an EP_ENVIRONMENT"
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

	environment: EP_ENVIRONMENT
			-- Shared Eve Proofs environement
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

feature -- Convenience

-- TODO: move to its own class?
-- TODO: add 'indent' 'unindent' features

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

	put_indentation
			-- Put indentation to output buffer.
		do
			environment.output_buffer.put_indentation
		end

	put (a_string: STRING)
			-- Put `a_string' to output buffer.
		do
			environment.output_buffer.put (a_string)
		end

	put_line (a_line: STRING)
			-- Put `a_line' to output buffer and append a new line.
		do
			environment.output_buffer.put_line (a_line)
		end

	put_comment_line (a_line: STRING)
			-- Put `a_line' to output buffer as a comment and append a new line.
		do
			environment.output_buffer.put_comment_line (a_line)
		end

	put_new_line
			-- Put a new line to output buffer.
		do
			environment.output_buffer.put_new_line
		end

end
