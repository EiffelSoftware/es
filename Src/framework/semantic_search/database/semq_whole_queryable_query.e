note
	description: "Query which can retrieve a whole document based on its document uuid"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_WHOLE_QUERYABLE_QUERY

inherit
	SEMQ_QUERY

	SEM_FIELD_NAMES

create
	make,
	make_with_variable_mappings

feature{NONE} -- Initialization

	make (a_uuid: STRING; a_queryable_type: STRING)
			-- Initialize `uuid' with `a_uuid'.
		require
			a_queryable_type_valid: is_queryable_type_valid (a_queryable_type)
		do
			uuid := a_uuid.twin
			queryable_type := a_queryable_type
			set_maximal_variables_in_properties (9)
		end

	make_with_variable_mappings (a_uuid: STRING; a_mappings: like variable_mappings; a_queryable_type: STRING)
			-- Initialize `uuid' with `a_uuid' and `variable_mappings' with `a_variable_mappings'.
		require
			a_queryable_type_valid: is_queryable_type_valid (a_queryable_type)
		do
			make (a_uuid, a_queryable_type)
			set_variable_mappings (a_mappings)
		end

feature -- Access

	queryable_type: STRING
			-- Type of the queryable to be returned			

	uuid: STRING
			-- UUID of the document to retrieve

	variable_mappings: detachable HASH_TABLE [SEM_VARIABLE_WITH_UUID, STRING]
			-- Mappings from variable names to the actual variables in the returned queryables
			-- Key is names of variable in the original query, value is the variable names
			-- as written in the retrieved queryables. 		
			-- Is Current attribute is attached, the retrieved queryable will have its original
			-- variable names replaced by the names specified in the keys of this table.

	maximal_variables_in_properties: INTEGER
			-- The maximal number of variables in properties to be retrieved.
			-- Default is 9, which means all properties will be retrieved.
			-- Set this to a smaller number can speed up the queryable loading

feature -- Setting

	set_variable_mappings (a_mappings: like variable_mappings)
			-- Set `variable_mappings' with `a_mappings'.
			do
				variable_mappings := a_mappings
			ensure
				variable_mappings_set: variable_mappings = a_mappings
			end

	set_maximal_variables_in_properties (i: INTEGER)
			-- Set `maximal_variables_in_properties' with `i'.
		require
			i_valid: i >= 1 and i <= 9
		do
			maximal_variables_in_properties := i
		ensure
			maximal_variables_in_properties_set: maximal_variables_in_properties = i
		end

feature -- Process

	process (a_visitor: SEMQ_QUERY_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_whole_document_query (Current)
		end

end
