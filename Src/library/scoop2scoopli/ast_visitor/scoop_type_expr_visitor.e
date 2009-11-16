indexing
	description: "Summary description for {SCOOP_TYPE_EXPR_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_TYPE_EXPR_VISITOR

inherit
	AST_ROUNDTRIP_ITERATOR
		redefine
			process_id_as,
			process_class_type_as,
			process_generic_class_type_as,
			process_named_tuple_type_as,
			process_like_id_as,
			process_formal_as,
			process_result_as
		end
	SCOOP_WORKBENCH

feature -- Access

	evaluate_type_from_expr (an_expr: EXPR_AS; a_base_class: CLASS_C) is
			-- Given a EXPR_AS node, get the is_separate information of the evaluated expression
		require
			feature_as_not_void: feature_as /= Void
			an_expression_not_void: an_expr /= Void
			a_base_class_not_void: a_base_class /= Void
		local
			routine_as: ROUTINE_AS
		do
			is_last_type_separate := false
			base_class := a_base_class

			-- get internal arguments and internal locals
			if feature_as.body /= Void then

				internal_arguments := feature_as.body.internal_arguments

				routine_as ?= feature_as.body.content
				if routine_as /= Void then
					internal_locals := routine_as.internal_locals
				end
			end
			safe_process (an_expr)
		end

	get_new_base_class: CLASS_C is
			-- getter for 'new_base_class'
		do
			Result := new_base_class
		end

	evaluate_type_from_type_as (a_type: TYPE_AS; a_base_class: CLASS_C) is
			-- Given a TYPE_AS node, get the is_separate information from the declaration
		require
			a_base_class_not_void: a_base_class /= Void
		do
			is_last_type_separate := false
			base_class := a_base_class
			safe_process (a_type)
		end

feature {NONE} -- id_as type evaluation

	process_id_as (l_as: ID_AS) is
		local
			l_new_type: TYPE_AS
			l_argument_object: SCOOP_CLIENT_ARGUMENT_OBJECT
			l_argument_visitor: SCOOP_CLIENT_ARGUMENT_VISITOR
		do
			debug ("SCOOP_CLIENT_TYPE_EXT")
				io.error.put_string ("%NXXX TE_V: id[" + l_as.name + "]%T ")
			end

			if base_class.feature_table.has (l_as.name) and then
				base_class.feature_table.item (l_as.name).type /= Void then
				-- feature table knows current id

				new_base_class := base_class.feature_table.item (l_as.name).type.associated_class
				--new_base_class := get_class_by_name(l_new_type_name)
				debug ("SCOOP_CLIENT_TYPE_EXT")
					io.error.put_string ("%TFeat.Tab. ")
				end
				is_last_type_separate := base_class.feature_table.item (l_as.name).type.is_separate
			elseif internal_locals /= Void and then has_internal_local (l_as.name) then
				-- id is defined in the locals
				debug ("SCOOP_CLIENT_TYPE_EXT")
					io.error.put_string ("%Tlocals")
				end
				is_last_type_separate := is_internal_local_separate (l_as.name)
				l_new_type := get_internal_local_type (l_as.name)
				new_base_class := get_class_by_type (l_new_type)
			else
				l_argument_visitor := scoop_visitor_factory.new_client_argument_visitor_for_class (parsed_class, match_list)
				l_argument_object := l_argument_visitor.process_arguments (internal_arguments)
				if l_argument_object.is_separate_argument (l_as.name) then
					debug ("SCOOP_CLIENT_TYPE_EXT")
						io.error.put_string ("%Tint.arg.")
					end
					is_last_type_separate := true
					l_new_type := l_argument_object.get_argument_by_name (l_as.name).type
					new_base_class := get_class_by_type (l_new_type)
				end
			end

			debug ("SCOOP_CLIENT_TYPE_EXT")
				io.error.put_string ("%T, is separate:")
				io.error.put_string (is_last_type_separate.out)
				if new_base_class /= Void then
					io.error.put_string (" - Class_C: " + new_base_class.name)
				else
					io.error.put_string (" - Class_C not found!!")
				end
			end
		end

feature {NONE} -- Visitor implementation: type_as evaluation

	process_class_type_as (l_as: CLASS_TYPE_AS) is
		do
			if l_as.is_separate then
				is_last_type_separate := true
			end
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS) is
		do
			if l_as.is_separate then
				is_last_type_separate := true
			end
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS) is
		-- Process `l_as'. Take only 'is_separate' information.
		-- We are not interested in the TUPLE parameter types.
		do
			if l_as.is_separate then
				is_last_type_separate := true
			end
		end

	process_formal_as (l_as: FORMAL_AS) is
		do
			-- we do not need to process `l_as', as it is just a formal generic parameter
		end

	process_like_id_as (l_as: LIKE_ID_AS) is
			-- Process `l_as'. Take class the LIKE_ID_AS type.
		do
			if base_class.feature_table.has (l_as.anchor.name.as_lower) then
				new_base_class := base_class.feature_table.item (l_as.anchor.name.as_lower).type.associated_class
				is_last_type_separate := base_class.feature_table.item (l_as.anchor.name.as_lower).type.is_separate
			end
		end

	process_result_as (l_as: RESULT_AS) is
		do
			process_leading_leaves (l_as.index)
			last_index := l_as.index
		end

feature -- Access

	is_last_type_separate: BOOLEAN
		-- separate state of last evaluated type

feature {NONE} -- Implementation, internal locals

	has_internal_local (a_name: STRING): BOOLEAN is
			-- returns true if the name occurs in the list
		local
			i, j, nb, nbj: INTEGER
			l_local: TYPE_DEC_AS
		do
			if internal_locals /= Void then
				from
					i := 1
					nb := internal_locals.locals.count
				until
					i > nb
				loop
					l_local := internal_locals.locals.i_th (i)
					from
						j := 1
						nbj := l_local.id_list.count
					until
						j > nbj
					loop
						if l_local.item_name (j).is_equal (a_name) then
							Result := true
						end
						j := j + 1
					end
					i := i + 1
				end

			else
				Result := false
			end
		end

	is_internal_local_separate (a_name: STRING): BOOLEAN is
			-- returns the separate type information of the local
		require
			has_internal_local (a_name)
		local
			i, j: INTEGER
			l_local: TYPE_DEC_AS
			l_type_visitor: SCOOP_TYPE_EXPR_VISITOR
		do
			if internal_locals /= Void then
				from
					i := 1
				until
					i > internal_locals.locals.count
				loop
					l_local := internal_locals.locals.i_th (i)
					from
						j := 1
					until
						j > l_local.id_list.count
					loop
						if l_local.item_name (j).is_equal (a_name) then
							create l_type_visitor
							l_type_visitor.setup (parsed_class, match_list, true, true)
							l_type_visitor.evaluate_type_from_type_as (l_local.type, class_c)
							Result := l_type_visitor.is_last_type_separate
						end
						j := j + 1
					end
					i := i + 1
				end

			else
				Result := false
			end
		end

	get_internal_local_type (a_name: STRING): TYPE_AS is
			-- returns the separate type information of the local
		require
			has_internal_local (a_name)
		local
			i, j: INTEGER
			l_local: TYPE_DEC_AS
		do
			if internal_locals /= Void then
				from
					i := 1
				until
					i > internal_locals.locals.count
				loop
					l_local := internal_locals.locals.i_th (i)
					from
						j := 1
					until
						j > l_local.id_list.count
					loop
						if l_local.item_name (j).is_equal (a_name) then
							Result := l_local.type
						end
						j := j + 1
					end
					i := i + 1
				end
			else
				Result := Void
			end
		end

feature {NONE} -- Implementation

	get_class_by_type (l_type: TYPE_AS): CLASS_C is
			-- Returns the class_c of the corresponding type.
		local
			l_type_visitor: SCOOP_TYPE_VISITOR
		do
			-- evaluate new base class
			create l_type_visitor
			l_type_visitor.setup (parsed_class, match_list, true, true)
			Result := l_type_visitor.evaluate_class_from_type (l_type, base_class)
		end

	get_class_by_name (l_name: STRING): CLASS_C is
			-- Returns the class_c with name 'l_name'
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > system.classes.count
			loop
				if system.classes.item (i).name_in_upper.is_equal (l_name.as_upper) then
					Result := system.classes.item (i)
				end
				i := i + 1
			end
		end

	internal_arguments: FORMAL_ARGU_DEC_LIST_AS
			-- Internal list (of list) of arguments.

	internal_locals: LOCAL_DEC_LIST_AS
			-- Local declarations, in which keyword "local" is stored.

	base_class: CLASS_C
			-- Base class for type analysis -> feature table.

	new_base_class: CLASS_C
			-- Type class of actual processed call type.

end
