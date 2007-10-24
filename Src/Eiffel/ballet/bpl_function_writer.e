indexing
	description: "Write out the functional definition for functions"
	author: "Bernd Schoeller"
	date: "$Date$"
	revision: "$Revision$"

class
	BPL_FUNCTION_WRITER

inherit
	BPL_VISITOR
		redefine
			make,
			process_binary_as,
			process_unary_as,
			process_integer_as,
			process_bool_as,
			process_void_as,
			process_un_old_as,
			process_expr_call_as,
			process_access_feat_as,
			process_access_id_as,
			process_access_inv_as,
			process_current_as,
			process_result_as,
			process_nested_as,
			process_nested_expr_as,
			process_string_as
		end

create
	make

feature -- Initialization

	make (a_class: EIFFEL_CLASS_C) is
			-- Initialize.
		do
			Precursor {BPL_VISITOR} (a_class)
			reset
		end

feature -- Main

	write_function (a_function: FEATURE_I) is
			-- Write the definition of the function pointed to by `a_function'.
		require
			as_not_void: a_function /= Void
		local
			feat_name: STRING
			func_name: STRING
			return_type: STRING
			routine: ROUTINE_AS
			ass_list: LIST[TAGGED_AS]
			intro: STRING
			l_as: FEATURE_AS
		do
			set_this_ref ("C")
			set_heap_ref ("H")
			current_feature := a_function
			l_as := a_function.body
			feat_name := bpl_mangled_feature_name (l_as.feature_name)
			func_name := "fun." + current_class.name + "." + feat_name
			return_type := bpl_type_for (l_as.body.type)
			bpl_out ("// Function: " + l_as.feature_name + " of class " + current_class.name + "%N")
			bpl_out ("function ")
			bpl_out (func_name)
			bpl_out ("([ref,name]any, ")
			bpl_out (bpl_type_for_class (current_class))
			result_call := func_name+"(H,C"
			if l_as.body.arguments /= Void then
				from
					l_as.body.arguments.start
				until
					l_as.body.arguments.off
				loop
					from
						l_as.body.arguments.item.id_list.start
					until
						l_as.body.arguments.item.id_list.off
					loop
						bpl_out (",")
						result_call.append (",")
						bpl_out (bpl_type_for (l_as.body.arguments.item.type))
						result_call.append ("arg.")
						result_call.append (l_as.body.arguments.item.names_heap.item (l_as.body.arguments.item.id_list.item))
						l_as.body.arguments.item.id_list.forth
					end
					l_as.body.arguments.forth
				end
			end
			bpl_out (") returns ("+return_type+");%N")
			result_call.append (")")
			routine ?= l_as.body.content
			intro := "forall H:[ref,name]any,C:ref"
			if routine /= Void then
				if l_as.body.arguments /= Void then
					from
						l_as.body.arguments.start
					until
						l_as.body.arguments.off
					loop
						from
							l_as.body.arguments.item.id_list.start
						until
							l_as.body.arguments.item.id_list.off
						loop
							intro.append (",")
							intro.append ("arg.")
							intro.append (l_as.body.arguments.item.names_heap.item (l_as.body.arguments.item.id_list.item))
							intro.append (":")
							intro.append ( bpl_type_for (l_as.body.arguments.item.type))
							l_as.body.arguments.item.id_list.forth
						end
						l_as.body.arguments.forth
					end
				end
				intro.append (":: (C != null)")
				if routine.precondition /= Void and then routine.precondition.assertions /= Void then
					ass_list := routine.precondition.assertions
					from
						ass_list.start
					until
						ass_list.off
					loop
						intro.append (" && (")
						expr := ""
						ass_list.item.process (Current)
						intro.append (expr)
						intro.append (")")
						ass_list.forth
					end
				end
				intro.append (" ==> ")

				if routine.postcondition /= Void and then routine.postcondition.assertions /= Void then
					ass_list := routine.postcondition.assertions
					from
						ass_list.start
					until
						ass_list.off
					loop
						bpl_out ("axiom (")
						bpl_out (intro)
						expr := ""
						ass_list.item.process (Current)
						bpl_out (expr)
						bpl_out (");%N")
						ass_list.forth
					end
				end
			else
				-- TODO: Support constants	
			end
			bpl_out ("%N")
		end

feature -- Processing Environment

	result_call: STRING
		-- String to insert for `Result'

	set_result_call (a_string:STRING) is
			-- Set the text to insert on a Result to `a_string'.
		require
			not_void: a_string /= Void
		do
			result_call := a_string
		ensure
			value_set: result_call = a_string
		end

	heap_ref: STRING

	set_heap_ref (a_string:STRING) is
			-- Set the text to insert on a Heap reference.
		require
			not_void: a_string /= Void
		do
			heap_ref := a_string
		ensure
			value_set: heap_ref = a_string
		end

	this_ref: STRING

	set_this_ref (a_string:STRING) is
			-- Set the text to insert on a reference to the current object.
		require
			not_void: a_string /= Void
		do
			this_ref := a_string
		ensure
			value_set: this_ref = a_string
		end

	expr: STRING
		-- Expression output

	current_expression: EXPR_AS
		-- The current expression processed

	reset is
			-- Reset `expr' to the empty string.
		do
			expr := ""
			create call_list.make (0)
		ensure
			expr_reset: expr.is_equal ("")
		end

	call_list: ARRAYED_LIST[EXPR_AS]
		-- Expressions that are feature calls used during the generation.

	record_call (e: EXPR_AS) is
			-- Record that the following call is used in the expression.
		do
			call_list.extend (e)
			record_usage (e)
		end

feature -- Processing

	process_result_as (l_as: RESULT_AS) is
			-- Process `l_as'.
		do
			expr.append (result_call)
		end

	process_binary_as (l_as: BINARY_AS) is
			-- Prcoess `l_as'.
		local
			target_type: TYPE_A
		do
			-- TODO
			target_type := type_for (l_as.left)
			if target_type.is_integer or target_type.is_boolean or
				l_as.op_name.is_equal ("=") or l_as.op_name.is_equal ("/=")
				then
				expr.append ("(")
				l_as.left.process (Current)
				expr.append (" ")
				expr.append (bpl_infix_operator_for(l_as.op_name))
				expr.append (" ")
				l_as.right.process (Current)
				expr.append (")")
			else
				expr.append ("fun.")
				expr.append (target_type.associated_class.name)
				expr.append (".")
				expr.append (bpl_mangled_operator (l_as.op_name))
				expr.append ("(")
				expr.append (heap_ref)
				expr.append (",")
				l_as.left.process (Current)
				expr.append (",")
				l_as.right.process (Current)
				expr.append (")")
				record_call (l_as)
			end
		end

	process_unary_as (l_as: UNARY_AS) is
			-- Prcoess `l_as'.
		local
			target_type: TYPE_A
		do
			-- TODO
			target_type := type_for (l_as.expr)
			if target_type.is_integer or target_type.is_boolean then
				expr.append ("(")
				expr.append (bpl_prefix_operator_for(l_as.operator_name))
				expr.append (" ")
				l_as.expr.process (Current)
				expr.append (")")
			else
				expr.append ("fun.")
				expr.append (target_type.associated_class.name)
				expr.append (".")
				expr.append (bpl_mangled_operator(l_as.operator_name))
				expr.append ("(")
				expr.append (heap_ref)
				expr.append (",")
				l_as.expr.process (Current)
				expr.append (")")
				record_call (l_as)
			end
		end

	process_integer_as (l_as: INTEGER_AS) is
			-- Process `l_as'.
		do
			expr.append (l_as.integer_64_value.out)
		end

	process_bool_as (l_as: BOOL_AS) is
			-- Process `l_as'.
		do
			if l_as.value then
				expr.append ("true")
			else
				expr.append ("false")
			end
		end

	process_string_as (l_as: STRING_AS) is
			-- Process `l_as'.
		do
			expr.append ("any_string(")
			environment.new_string_id
			expr.append (environment.last_string_id.out)
			expr.append (")")
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS) is
			-- Process `l_as'.
		local
			elist: LIST[EXPR_AS]
		do
			-- TODO
			if l_as.is_argument then
				expr.append ("arg.")
				expr.append (l_as.feature_name)
			elseif l_as.is_local then
				expr.append ("l.")
				expr.append (l_as.feature_name)
			else
				expr.append ("fun.")
				expr.append (current_class.feature_named (l_as.feature_name).written_class.name)
				expr.append (".")
				expr.append (l_as.feature_name)
				expr.append ("(")
				expr.append (heap_ref)
				expr.append (",")
				expr.append (this_ref)
				if l_as.parameters /= Void then
					elist := l_as.parameters
					from
						elist.start
					until
						elist.off
					loop
						expr.append (",")
						elist.item.process (Current)
						elist.forth
					end
				end
				expr.append (")")
				record_call (current_expression)
			end
		end

	process_access_inv_as (l_as: ACCESS_INV_AS) is
			-- Process `l_as'.
		local
			elist: LIST[EXPR_AS]
		do
			-- TODO
			if l_as.is_argument then
				expr.append ("arg.")
				expr.append (l_as.feature_name)
			elseif l_as.is_local then
				expr.append ("l.")
				expr.append (l_as.feature_name)
			else
				expr.append ("fun.")
				expr.append (current_class.feature_named (l_as.feature_name).written_class.name)
				expr.append (".")
				expr.append (l_as.feature_name)
				expr.append ("(")
				expr.append (heap_ref)
				expr.append (",")
				expr.append (this_ref)
				if l_as.parameters /= Void then
					elist := l_as.parameters
					from
						elist.start
					until
						elist.off
					loop
						expr.append (",")
						elist.item.process (Current)
						elist.forth
					end
				end
				expr.append (")")
				record_call (current_expression)
			end
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS) is
			-- Process `l_as'.
		local
			afa: ACCESS_FEAT_AS
			elist: LIST[EXPR_AS]
		do
			-- TODO
			afa ?= l_as.message
			if afa /= Void then
				expr.append ("fun.")
				expr.append (type_for (l_as.target).associated_class.name)
				expr.append (".")
				expr.append (afa.feature_name)
				expr.append ("(")
				expr.append (heap_ref)
				expr.append (",")
				l_as.target.process (Current)
				if afa.parameters /= Void then
					elist := afa.parameters
					from
						elist.start
					until
						elist.off
					loop
						expr.append (",")
						elist.item.process (Current)
						elist.forth
					end
				end
				expr.append (")")
				record_call (current_expression)
			else
				check
					unknown_access: False
				end
			end
		end

	process_nested_as (l_as: NESTED_AS) is
			-- Process `l_as'.
		local
			nested_expr_as: NESTED_EXPR_AS
		do
			nested_expr_as := nested_as_to_nested_expr_as (l_as)
			nested_expr_as.process (Current)
		end

	process_void_as (l_as: VOID_AS) is
			-- Process `l_as'.
		do
			expr.append ("null")
		end


	process_access_id_as (l_as: ACCESS_ID_AS) is
			-- Process `l_as'.
		local
			elist: LIST[EXPR_AS]
		do
			if l_as.is_local then
				expr.append ("l.")
				expr.append (l_as.access_name)
			elseif l_as.is_argument then
				expr.append ("arg.")
				expr.append (l_as.access_name)
			else
				expr.append ("fun.")
				expr.append (current_class.name)
				expr.append (".")
				expr.append (l_as.access_name)
				expr.append ("(")
				expr.append (heap_ref)
				expr.append (",")
				expr.append (this_ref)
				if l_as.parameters /= Void then
					elist := l_as.parameters
					from
						elist.start
					until
						elist.off
					loop
						expr.append (",")
						elist.item.process (Current)
						elist.forth
					end
				end
				expr.append (")")
				record_call (current_expression)
			end
		end

	process_current_as (l_as: CURRENT_AS) is
			-- Process `l_as'.
		do
			expr.append (this_ref)
		end

	process_un_old_as (l_as: UN_OLD_AS) is
			-- Process `l_as'.
		do
			expr.append ("old(")
			l_as.expr.process (Current)
			expr.append (")")
		end

	process_expr_call_as (l_as: EXPR_CALL_AS) is
			-- Process `l_as'.
		local
			old_expr: EXPR_AS
		do
			old_expr := current_expression
			current_expression := l_as
			Precursor {BPL_VISITOR} (l_as)
			current_expression := old_expr
		end

invariant
	call_list_not_void: call_list /= Void
end
