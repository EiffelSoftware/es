
note
	description: "Result from result matching"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_QUERYABLE_MATCHING_RESULT

inherit
	IR_TERM_OCCURRENCE

	SEM_SHARED_EQUALITY_TESTER

create
	make

feature{NONE} -- Initialization

	make (a_query_config: like query_config; a_document: like document; a_full_solution: BOOLEAN; a_query_data: like query_data)
			-- Initialize.
		do
			query_config := a_query_config
			document := a_document
			query_data := a_query_data

			create matched_variables.make (5)
			create matched_criteria.make (5)
			matched_criteria.set_key_equality_tester (sem_matching_criterion_equality_tester)
			is_full_solution := a_full_solution
		end

feature -- Access

	query_config: SEM_QUERY_CONFIG
			-- Config of the executed query

	query_data: SEM_SEARCHED_QUERYABLE_DATA
			-- Data about `query_config'

	queryable: SEM_QUERYABLE
			-- Queryable from `query_config'
		do
			Result := query_config.queryable
		end

	document: SEM_CANDIDATE_QUERYABLE
			-- The matched document

	matched_variables: HASH_TABLE [INTEGER, INTEGER]
			-- Table of matched variables
			-- Key is index of variables from the query side,
			-- value is index of objects from the document side.

	matched_criteria: DS_HASH_TABLE [SEM_MATCHING_CRITERION, SEM_MATCHING_CRITERION]
			-- Table of criteria (from the query side) that are matched
			-- Key is the matched criterion (from the query side), value is the candidate criterion in the document

	content: detachable STRING
			-- Content of the matched document

	text: STRING
			-- Text represention of Current result
		local
			i: INTEGER
			l_cursor: DS_HASH_SET_CURSOR [INTEGER]
			l_cri_cursor: DS_HASH_SET_CURSOR [SEM_MATCHING_CRITERION]
			l_str: STRING
			l_ccursor: DS_HASH_TABLE_CURSOR [SEM_MATCHING_CRITERION, SEM_MATCHING_CRITERION]
		do
			create Result.make (1024)

				-- Append document information.
			Result.append (once "Document ID: ")
			Result.append (document.uuid)
			Result.append_character ('%N')

				-- Append document content.
			if content /= Void then
				Result.append (content)
				Result.append_character ('%N')
			end

				-- Append matched variable information.
			Result.append (once "Matched variables: ")
			i := 0
			across matched_variables as l_vars loop
				if i > 0 then
					Result.append (once ", ")
				end
				Result.append (queryable.reversed_variable_position.item (l_vars.key).text)
				Result.append_character ('(')
				Result.append (l_vars.item.out)
				Result.append_character (')')
				i := i + 1
			end
			Result.append_character ('%N')

				-- Append matched criteria information.
			Result.append (once "Matched criteria: %N")
			from
				l_ccursor := matched_criteria.new_cursor
				l_ccursor.start
			until
				l_ccursor.after
			loop
				if attached {SEM_TERM} l_ccursor.key.term as l_term then
					Result.append_character ('%T')
					Result.append (l_term.text)
					Result.append (once " (")
					Result.append (l_ccursor.item.value.text)
					Result.append_character (')')
					Result.append_character ('%N')
				end
				l_ccursor.forth
			end

				-- Append unmatched variable information.			
			create l_str.make (256)
			from
				i := 0
				l_cursor := query_data.variable_indexes.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if not matched_variables.has (l_cursor.item) then
					if i > 0 then
						l_str.append (once ", ")
					end
					l_str.append (queryable.reversed_variable_position.item (l_cursor.item).text)
					i := i + 1
				end
				l_cursor.forth
			end
			if not l_str.is_empty then
				Result.append (once "%NUnmatched variables: ")
				Result.append (l_str)
				Result.append_character ('%N')
			end

				-- Append unmatched criteria information.
			create l_str.make (256)
			from
				l_cri_cursor := query_data.searched_criteria.new_cursor
				l_cri_cursor.start
			until
				l_cri_cursor.after
			loop
				if not matched_criteria.has (l_cri_cursor.item) then
					if attached {SEM_TERM} l_cri_cursor.item.term as l_term and then l_term.occurrence /= term_occurrence_must_not then
						l_str.append_character ('%T')
						l_str.append (l_term.text)
						l_str.append_character ('%N')
					end
				end
				l_cri_cursor.forth
			end
			if not l_str.is_empty then
				Result.append (once "%NUnmatched properties:%N")
				Result.append (l_str)
			end
			Result.append (once "Full solution: ")
			Result.append (is_full_solution.out)
			Result.append_character ('%N')
		end

feature -- Status report

	is_full_solution: BOOLEAN
			-- Is current matching a full solution?
			-- Full solution means that all the variables
			-- and all the criteria are satisfied.

feature -- Setting

	set_content (a_content: like content)
			-- Set `content' with `a_content'.
		do
			content := a_content
		ensure
			content_set: content = a_content
		end

end
