note
	description: "Class that represents a configuration for a query"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_QUERY_CONFIG

inherit
	SEM_CONSTANTS

create
	make

feature{NONE} -- Initialization

	make (a_queryable: like queryable)
			-- Initialize `queryable' with `a_queryable'.
		local
			i: IR_QUERY
		do
			set_queryable (a_queryable)
			set_primary_property_type_form (static_type_form)
			create supporting_property_type_forms.make
			create terms.make
		end

feature -- Access

	queryable: SEM_QUERYABLE
			-- The queryable that used in this "Query by Example" context
			-- The query will return some queryables that "look like" the one
			-- given here.

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

feature{NONE} -- Setting

	set_queryable (a_queryable: like queryable)
			-- Set `queryable' with `a_queryable'.
		do
			queryable := a_queryable
		ensure
			queryable_set: queryable = a_queryable
		end

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

invariant
	primary_property_type_form_valid: is_type_form_valid (primary_property_type_form)
	supporting_property_type_forms_valid: across supporting_property_type_forms as l_forms all is_type_form_valid (l_forms.item) end

end
