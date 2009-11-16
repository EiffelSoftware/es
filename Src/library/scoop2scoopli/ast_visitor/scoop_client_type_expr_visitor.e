indexing
	description: "Summary description for {SCOOP_CLIENT_TYPE_EXPR_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_TYPE_EXPR_VISITOR

inherit
	AST_ROUNDTRIP_ITERATOR
		export
			{NONE} all
			{SCOOP_VISITOR_FACTORY} setup
		redefine
			process_access_feat_as,
			process_access_inv_as,
			process_access_id_as,
			process_static_access_as,
			process_current_as,
			process_precursor_as,
			process_result_as,
			process_class_type_as,
			process_generic_class_type_as,
			process_named_tuple_type_as
		end
	SCOOP_WORKBENCH
		export
			{NONE} all
		end

feature -- Access

	is_access_as_separate (l_as: ACCESS_AS): BOOLEAN is
			-- Given `l_as' of type `ACCESS_AS', evaulate the separate state and return it as result.
		local
			l_last_index: INTEGER
		do
			-- init
			is_separate := false

			-- save processed leaf list position
			l_last_index := last_index

			-- process node
			safe_process (l_as)

			-- restore index
			last_index := l_last_index

			-- Return result value
			Result := is_separate
		end

feature {NONE} -- Visitor implementation: access_as nodes

	process_access_feat_as (l_as: ACCESS_FEAT_AS) is
		do
			last_index := l_as.feature_name.index - 1
			evaluate_id (l_as.feature_name)
		end

	process_access_inv_as (l_as: ACCESS_INV_AS) is
		do
			last_index := l_as.dot_symbol_index
			evaluate_id (l_as.feature_name)
		end

	process_access_id_as (l_as: ACCESS_ID_AS) is
		do
			last_index := l_as.feature_name.index - 1
			evaluate_id (l_as.feature_name)
		end

	process_static_access_as (l_as: STATIC_ACCESS_AS) is
		local
			l_type_visitor: SCOOP_TYPE_VISITOR
		do
			-- get base class of the static call
			create l_type_visitor
			l_type_visitor.setup (parsed_class, match_list, true, true)
			last_base_class := l_type_visitor.evaluate_class_from_type (l_as.class_type, class_c)

			-- process feature name
			last_index := l_as.dot_symbol_index
			evaluate_id (l_as.feature_name)
		end

	process_current_as (l_as: CURRENT_AS) is
		do
			-- do nothing.
		end

	process_precursor_as (l_as: PRECURSOR_AS) is
		do
			-- do nothing.
		end

	process_result_as (l_as: RESULT_AS) is
		do
			-- process the type of the current routine
			safe_process (feature_as.body.type)

			-- take separate status of current processed routine
			is_separate := is_type_separate
		end

feature {NONE} -- Visitor implementation: Separate type

	process_class_type_as (l_as: CLASS_TYPE_AS) is
		do
			is_type_separate := l_as.is_separate
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS) is
		do
			is_type_separate := l_as.is_separate
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS) is
		do
			is_type_separate := l_as.is_separate
		end

feature {NONE} -- Implementation

	evaluate_id (l_as: ID_AS) is
			-- evaluates the separated state of the entity behind id
		local
			l_type_expr_visitor: SCOOP_TYPE_EXPR_VISITOR
		do
			-- get is_separate information of the current call
			create l_type_expr_visitor
			l_type_expr_visitor.setup (parsed_class, match_list, true, true)
			if last_base_class /= Void then
				l_type_expr_visitor.evaluate_type_from_expr (l_as, last_base_class)
			else
				l_type_expr_visitor.evaluate_type_from_expr (l_as, class_c)
			end
			is_separate := l_type_expr_visitor.is_last_type_separate
		end

	is_separate: BOOLEAN
		-- Result value of current query.

	is_type_separate: BOOLEAN
		-- Remembers the separate status of the current processed result type.

	last_base_class: CLASS_C
		-- Reference to class on wich access call is called.

end
