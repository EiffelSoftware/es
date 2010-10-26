note
	description: "Class that represents a configuration for a query"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_QUERY_CONFIG

inherit
	SEM_CONSTANTS

	REFACTORING_HELPER

create
	make,
	make_with_primary_type_form

feature{NONE} -- Initialization

	make (a_queryable: like queryable)
			-- Initialize `queryable' with `a_queryable'.
		do
			set_queryable (a_queryable)
			set_primary_property_type_form (static_type_form)
			create supporting_property_type_forms.make
			create terms.make
			create returned_fields.make
			create extra_fields.make (5)
			extra_fields.compare_objects
		end

	make_with_primary_type_form (a_queryable: like queryable; a_type_form: INTEGER)
			-- Initialize `queryable' with `a_queryable' and set
			-- `primary_type_form' with `a_type_form'.
		require
			a_type_form_valid: is_type_form_valid (a_type_form)
		do
			make (a_queryable)
			set_primary_property_type_form (a_type_form)
		end

feature -- Access

	queryable: SEM_QUERYABLE
			-- The queryable that used in this "Query by Example" context
			-- The query will return some queryables that "look like" the one
			-- given here.

	variables: DS_HASH_SET [EPA_EXPRESSION]
			-- Variables from `queryable'
		do
			Result := queryable.variables
		end

	variable_types: HASH_TABLE [TYPE_A, INTEGER]
			-- Table from variable indexes (key) to variable types (value)
		do
			Result := queryable.variable_types
		end

	variable_indexes: DS_HASH_SET [INTEGER]
			-- Set of indexes of `variables'
		do
			Result := queryable.variable_position_set
		end

	variable_count: INTEGER
			-- Number of variables in `variables'
		do
			Result := variables.count
		end

	primary_property_type_form: INTEGER
			-- Type form for searchable properties (dynamic type form, static type form or anonymous type form)
			-- Default is `static_type_form'

	supporting_property_type_forms: LINKED_LIST [INTEGER]
			-- List of supporting type forms that are also enabled during the search
			-- Those type forms are used to support the `primary_property_type_form',
			-- in the sense that if a property is translated into both `primary_property_type_form'
			-- and type forms in this list, a matched document may be ranked higher, because
			-- there are more matched terms.
			-- The weights of the type forms decreases.
			-- Default: an empty list
			-- Note: A certain query engine may ignore `support_property_type_forms' and only
			-- make use of `primary_property_type_form'.

	terms: LINKED_LIST [SEM_TERM]
			-- List of terms that specify matching criteria

	text: STRING
			-- String representation of Current query config
		do
			create Result.make (1024)
			Result.append (once "Primary type form: ")
			Result.append (property_type_form_name (primary_property_type_form))
			Result.append_character ('%N')
			Result.append (once "Terms:%N")
			across terms as l_terms loop
				Result.append (l_terms.item.text)
				Result.append_character ('%N')
			end
		end

	returned_fields: LINKED_LIST [STRING]
			-- List of names of fields that are to be returned.
			-- This list contains fields that are additionally specified,
			-- usually those fields has nothing to do with searched criteria.

	extra_fields: HASH_TABLE [STRING, STRING]
			-- List of fields along with their values.
			-- Key is field name, value is field value.
			-- Fields listed here always have "MUST" as occurrence flag.

feature -- Basic operations

	add_default_searchable_properties (a_term_veto_function: detachable FUNCTION [ANY, TUPLE [SEM_TERM], BOOLEAN]; a_term_occurrence_function: detachable FUNCTION [ANY, TUPLE [SEM_TERM], INTEGER])
			-- Add default searchable properties from `queryable' into `terms'.
			-- Searchable properties include:
			-- For transitions: variables, precondition, postcondition, relative change, absolute change
			-- For objects: variables, properties.
			-- A candidate term is only added into `terms' if `a_term_veto_function' returns True on it.
			-- If `a_term_veto_function' is Void, all candidate terms are added.
			-- `a_term_occurrence_function' is a function to set the occurrence flag into the argument term.
			-- If `a_term_occurrence_function' is Void, the default occurrence flag of terms are not changed.
		local
			l_term_generator: SEM_TERM_GENERATOR
			l_terms: like terms
		do
				-- Generate all terms from `queryable'.
			create l_term_generator
			l_term_generator.generate (queryable)

				-- Filter terms that do not satisfy `a_term_veto_function'.
			l_terms := terms
			across l_term_generator.last_terms as l_all_terms loop
				if a_term_veto_function = Void or else a_term_veto_function.item ([l_all_terms.item]) then
					if a_term_occurrence_function /= Void then
						l_all_terms.item.set_occurrence (a_term_occurrence_function.item ([l_all_terms.item]))
					end
					l_terms.extend (l_all_terms.item)
				end
			end
		end

feature -- Setting

	set_primary_property_type_form (a_type_form: INTEGER)
			-- Set `primary_property_type_form' with `a_type_form'
		require
			a_type_form_valid: is_type_form_valid (a_type_form)
		do
			primary_property_type_form := a_type_form
		ensure
			primary_property_type_form_set: primary_property_type_form = a_type_form
		end

	set_type_forms (a_forms: LINKED_LIST [INTEGER])
			-- Set `primary_property_type_form' and `supporting_property_type_forms'
			-- at the same time.
			-- The first value in `a_forms' is used to for `primary_property_type_form' and the rest
			-- values are used for `supporting_property_type_forms'.
		require
			not_a_forms_empty: not a_forms.is_empty
			a_forms_valid: across a_forms as l_forms all is_type_form_valid (l_forms.item) end
		local
			i: INTEGER
		do
			supporting_property_type_forms.wipe_out
			set_primary_property_type_form (a_forms.first)

			i := 1
			across a_forms as l_forms loop
				if i > 1 then
					supporting_property_type_forms.extend (l_forms.item)
				end
				i := i + 1
			end
		end

feature{NONE} -- Setting

	set_queryable (a_queryable: like queryable)
			-- Set `queryable' with `a_queryable'.
		do
			queryable := a_queryable
		ensure
			queryable_set: queryable = a_queryable
		end

invariant
	primary_property_type_form_valid: is_type_form_valid (primary_property_type_form)
	supporting_property_type_forms_valid: across supporting_property_type_forms as l_forms all is_type_form_valid (l_forms.item) end

end
