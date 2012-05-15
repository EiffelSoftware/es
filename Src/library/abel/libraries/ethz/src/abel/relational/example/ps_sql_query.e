note
	description: "Summary description for {PS_SQL_QUERY}."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_SQL_QUERY
	--inherit
	--	PS_QUERY
	--redefine
	--	compile,
	--	repository
	--end

create
	make_with_relational_repository

feature {NONE} -- Initialization

	make_with_relational_repository (a_repository: PS_RDB_REPOSITORY)
			-- Initialization for `Current'.
		do
			create {ARRAYED_LIST [PS_CRITERION]} criteria.make (0)
			create projected_data.make_empty
			repository := a_repository
			create sql.make_empty
			create {ARRAYED_LIST [ANY]} matched.make (Default_dimension)
			mapping := a_repository.mapping
			new_criteria := create {PS_AGENT_CRITERION}.make (agent  (obj: ANY): BOOLEAN
				do
					Result := true
				end)
			class_name := ""
			repository.set_query (Current)
		ensure
			repository_set: repository = a_repository
		end

feature -- Access

	sql: STRING
			-- Sql string.

	mapping: PS_MAPPING
			-- Mapping associated to `Current'.

	repository: PS_RDB_REPOSITORY
			-- Repository against which `Current' will be run.

feature -- Status setting

feature -- Miscellaneous

feature -- Basic operations

	compile
			-- Create a string representing an SQL query.
		local
			tab_name: STRING
			value: ANY
			index_1, index_2: INTEGER
			matched_attribute: STRING
			sql_validator: PS_SQL_VALIDATOR
		do
			sql.wipe_out
			sql.append_string ("SELECT ")
			if attached {PS_ONE_TO_ONE_MAPPING} mapping as m then
					-- Loop over `projected_data' to find the correspondent column names and add them to the query.
				from
					index_1 := 1
				until
					index_1 > projected_data.count
				loop
					matched_attribute := translate_attribute_to_column (projected_data [index_1], m)
					sql.append_string (matched_attribute)
					if index_1 < projected_data.count then
						sql.append_string (", ")
					end
					index_1 := index_1 + 1
				end
				sql.append (" FROM ")
				tab_name := m.table_name
				sql.append (tab_name)
				sql.append (" WHERE ")
					-- Loop through criteria and build the corresponding query parts.
					-- TODO: devise a mechanism that works with all supported criteria and with any combination of OR and AND.
				across
					criteria as cur
				loop
					if index_2 > 0 then
						sql.append (" AND ")
					end
					if attached {PS_PREDEFINED_CRITERION} cur.item as crit then
						sql.append (translate_attribute_to_column (crit.attribute_name, m))
						sql.append_character (' ')
						sql.append (crit.operation)
						sql.append_character (' ')
							-- TODO :Refactor the following to check for all basic types in a separate routine
						if attached {INTEGER} crit.value as v then
							sql.append (v.out)
						else
							check
								criterion_value_does_not_have_the_expected_type: false
							end
						end
						index_2 := index_2 + 1
					else
						check
							unexpected_criterion_type: false
						end
					end
				end
				sql.append_character (';')
				create sql_validator
				sql_validator.validate (sql)
				check
					sql_validator.is_validated
				end
				print ("%Ngenerated sql: " + sql)
			end
		end

feature {NONE} -- Implementation

	translate_attribute_to_column (att: STRING; map: PS_ONE_TO_ONE_MAPPING): STRING
			-- Get the column name given the attribute name for teh current table.
		require
			att_exists: not att.is_empty
		local
			exit_loop: BOOLEAN
		do
			create Result.make_empty
			from
				map.column_maps.start
			until
				map.column_maps.after or exit_loop = True
			loop
				if att.is_equal (map.column_maps.item.attribute_name) then
					Result := map.column_maps.item.column_name
					exit_loop := True
				end
				map.column_maps.forth
			end
		ensure
			mapping_attribute_to_column_found: not Result.is_empty
		end

invariant
	invariant_clause: True -- Your invariant here

end
