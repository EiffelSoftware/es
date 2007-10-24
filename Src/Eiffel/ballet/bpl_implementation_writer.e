indexing
	description: "Write out the implementation of a feature"
	author: "Bernd Schoeller"
	date: "$Date$"
	revision: "$Revision$"

class
	BPL_IMPLEMENTATION_WRITER

inherit
	BPL_VISITOR
		redefine
			process_assign_as,
			process_reverse_as,
			process_check_as,
			process_bang_creation_as,
			process_create_creation_as,
			process_debug_as,
			process_if_as,
			process_inspect_as,
			process_loop_as,
			process_access_feat_as,
			process_access_id_as,
			process_access_inv_as,
			process_static_access_as,
			process_create_as,
			process_nested_as,
			process_nested_expr_as
		end

create
	make

feature -- Generation

	write_implementation (a_feature: FEATURE_I) is
			-- Write out the implementation of `a_feature'.
		local
			content: ROUTINE_AS
			l_as: FEATURE_AS
		do
			l_as := a_feature.body
			content ?= l_as.body.content
			if content /= Void then
				current_feature := a_feature
				create function_writer.make (current_class)
				function_writer.set_leaf_list (match_list)
				function_writer.set_current_feature (current_feature)
				function_writer.set_heap_ref ("Heap")
				function_writer.set_this_ref ("Current")
				function_writer.set_result_call ("Result")
				code := ""
				create temp_vars_needed.make (5)
				reset_labels
				bpl_out ("// Implementation: "+a_feature.feature_name+" of class "+current_class.name+"%N")
				bpl_out ("implementation proc.")
				bpl_out (current_class.name)
				bpl_out (".")
				bpl_out (bpl_mangled_feature_name (a_feature.feature_name))
				bpl_out ("(Current:ref")
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
							bpl_out ("arg.")
							bpl_out (l_as.body.arguments.item.names_heap.item (l_as.body.arguments.item.id_list.item))
							bpl_out (":")
							bpl_out (bpl_type_for (l_as.body.arguments.item.type))
							l_as.body.arguments.item.id_list.forth
						end
						l_as.body.arguments.forth
					end
				end
				bpl_out (")")
				if a_feature.is_function then
					bpl_out (" returns (Result:")
					bpl_out (bpl_type_for_type_a (a_feature.type))
					bpl_out (")")
				end
				bpl_out (" {%N")
				if content /= Void then
					if content.locals /= Void then
						from
							content.locals.start
						until
							content.locals.off
						loop
							from
								content.locals.item.id_list.start
							until
								content.locals.item.id_list.off
							loop
								bpl_out ("  var l.")
								bpl_out (content.locals.item.names_heap.item (content.locals.item.id_list.item))
								bpl_out (":")
								bpl_out (bpl_type_for (content.locals.item.type))
								bpl_out (";%N")
								content.locals.item.id_list.forth
							end
							content.locals.forth
						end
					end
					content.routine_body.process (Current)
					from
						temp_vars_needed.start
					until
						temp_vars_needed.off
					loop
						bpl_out ("  var ")
						bpl_out (temp_vars_needed.key_for_iteration)
						bpl_out (":")
						bpl_out (temp_vars_needed.item_for_iteration)
						bpl_out (";%N")
						temp_vars_needed.forth
					end
					bpl_out ("  entry:%N")
					bpl_out (code)
					bpl_out ("    return;%N")
				end
				bpl_out ("}%N")
			end
		end

feature -- Environment

	code: STRING

	temp_vars_needed: HASH_TABLE[STRING,STRING]

	last_label: STRING

	next_free_label: INTEGER

	reset_labels is
			-- Reset the label counter.
		do
			next_free_label := 0
			new_label ("l")
		end

	new_label (a_prefix: STRING) is
			-- Create a new label.
		require
			not_void: a_prefix /= Void
			not_empty: a_prefix.count >= 1
		do
			last_label := a_prefix+next_free_label.out
			next_free_label := next_free_label + 1
		end

	is_local_variable (a_name: STRING): BOOLEAN is
			-- Is `a_name' the name of a local variable ?
		local
			content: ROUTINE_AS
		do
			content ?= current_feature.body.body.content
			if content.locals /= Void then
				from
					content.locals.start
				until
					content.locals.off or Result
				loop
					from
						content.locals.item.id_list.start
					until
						content.locals.item.id_list.off or Result
					loop
						Result := content.locals.item.names_heap.item (content.locals.item.id_list.item).is_equal (a_name)
						content.locals.item.id_list.forth
					end
					content.locals.forth
				end
			end
		end

	function_writer: BPL_BN_FUNCTION_WRITER

	record_temp_var (a_name: STRING; a_bpl_type: STRING) is
			-- Record the need of a temp variable `a_name' of `a_bpl_type'
		do
			temp_vars_needed.put (a_bpl_type,a_name)
		end

feature -- Support features

	generate_dummy_proc_call (x: EXPR_AS) is
			-- Generate a proc call for expression `x' by rewriting fun.X.y(Heap,Current,...)
			-- to "call dummy_T := proc.X.y(Current,...);" and add the result to code
		local
			function: STRING
			index: INTEGER
			tmp_name: STRING
			tmp_type: STRING
		do
			tmp_type := bpl_type_for_type_a (type_for(x))
			tmp_name := "dump_"+tmp_type
			record_temp_var (tmp_name, tmp_type)
			code.append ("    call ")
			code.append (tmp_name)
			code.append (" := proc")
			function_writer.reset
			x.process (function_writer)
			function := function_writer.expr
			function.remove_substring (1, 3)
			index := function.substring_index ("Heap,", 1)
			function.remove_substring (index, index+4)
			code.append (function)
			code.append (";")
			code.append (location_info (x, Void))
		end

	generate_all_dummy_proc_calls is
			-- Generate all dummy proc calls for the calls stored in `function_writer'.
		local
			expr_list: LIST[EXPR_AS]
		do
			from
				expr_list := function_writer.call_list.twin
				expr_list.start
			until
				expr_list.off
			loop
				generate_dummy_proc_call (expr_list.item)
				expr_list.forth
			end
		end

	assert_expression (l_as: EXPR_AS; tag: STRING) is
			-- Process `l_as'.
		local
			expr: STRING
		do
			function_writer.reset
			l_as.process (function_writer)
			expr := function_writer.expr
			generate_all_dummy_proc_calls
			code.append ("    assert(");
			code.append (expr)
			code.append (");")
			code.append (location_info (l_as, tag))
		end

	assume_expression (l_as: EXPR_AS; tag: STRING) is
			-- Process `l_as'.
		do
			function_writer.reset
			l_as.process (function_writer)
			code.append ("    assume(");
			code.append (function_writer.expr)
			code.append (");")
			code.append (location_info (l_as, tag))
		end

	assert_negated_expression (l_as: EXPR_AS; tag: STRING) is
			-- Process `l_as'.
		local
			expr: STRING
		do
			function_writer.reset
			l_as.process (function_writer)
			expr := function_writer.expr
			generate_all_dummy_proc_calls
			code.append ("    assert(!(");
			code.append (expr)
			code.append ("));")
			code.append (location_info (l_as, tag))
		end

	assume_negated_expression (l_as: EXPR_AS; tag: STRING) is
			-- Process `l_as'.
		do
			function_writer.reset
			l_as.process (function_writer)
			code.append ("    assume(!(");
			code.append (function_writer.expr)
			code.append ("));")
			code.append (location_info (l_as, tag))
		end

feature -- Processors

	process_assign_as (l_as: ASSIGN_AS) is
			-- Create assignment.
		local
			result_as: RESULT_AS
			new_code: STRING
		do
			new_code := "    "
			result_as ?= l_as.target
			if is_local_variable (l_as.target.access_name) then
				new_code.append ("l.")
				new_code.append (l_as.target.access_name)
			elseif result_as /= Void then
				new_code.append ("Result")
			else
				new_code.append ("Heap[Current,field.")
				new_code.append (current_class.name)
				new_code.append (".")
				new_code.append (l_as.target.access_name)
				new_code.append ("]")
			end
			new_code.append (" := ")
			function_writer.reset
			l_as.source.process (function_writer)
			new_code.append (function_writer.expr)
			new_code.append (";")
			new_code.append (location_info (l_as, Void))
			generate_all_dummy_proc_calls
			code.append (new_code)
		end

	process_reverse_as (l_as: REVERSE_AS) is
			-- Process `l_as'.
		do

		end

	process_bang_creation_as (l_as: BANG_CREATION_AS) is
			-- Process `l_as'.
		do

		end

	process_create_creation_as (l_as: CREATE_CREATION_AS) is
			-- Process `l_as'.
		local
			v: STRING
			entity: STRING
			result_as: RESULT_AS
			nested_as: NESTED_AS
			bpl_type: STRING
		do
			result_as ?= l_as.target

         if is_local_variable (l_as.target.access_name) then
            entity := "l."
            entity.append (l_as.target.access_name)
            bpl_type := bpl_type_for_access_as(l_as.target)
         elseif result_as /= Void then
            entity := "Result"
            bpl_type := bpl_type_for_type_a(current_feature.type)
         else
            entity := "Heap[Current,field."
            entity.append (current_class.name)
            entity.append (".")
            entity.append (l_as.target.access_name)
            entity.append ("]")
            bpl_type := bpl_type_for_access_as(l_as.target)
         end

         if l_as.type /= Void then
            -- explicit type is given in {}
            bpl_type := bpl_type_for(l_as.type)
         end

         if bpl_type.is_equal("ref") then
            new_label ("new")
            v := last_label
            record_temp_var (v, "ref")
            code.append ("    havoc ")
            code.append (v)
            code.append (";%N")
            code.append ("    assume (!IsAllocated(Heap,")
            code.append (v)
            code.append ("));%N")
            code.append ("    Heap[")
            code.append (v)
            code.append (",$allocated] := true;%N")

            code.append ("    ")
            code.append (entity)
            code.append (" := ")
            code.append (v)
            code.append (";%N")
            if l_as.call /= Void then
               create nested_as.initialize (l_as.target, l_as.call, Void)
               nested_as.process (Current)
            end
         else
            code.append (entity)
            code.append (" := ")

				function_writer.reset
				l_as.process (function_writer)
				code.append (function_writer.expr)

            code.append ("%N")
         end
		end

	process_debug_as (l_as: DEBUG_AS) is
			-- Process `l_as'.
		do

		end

	process_if_as (l_as: IF_AS) is
			-- Process `l_as'.
		local
			end_label: STRING
			else_label: STRING
			true_label: STRING
			false_label: STRING
			expr: STRING
		do
			new_label ("endif")
			end_label := last_label
			new_label ("else")
			else_label := last_label
			new_label ("true")
			true_label := last_label
			if l_as.elsif_list /= Void then
				new_label ("false")
				false_label := last_label
			else
				false_label := else_label
			end
			function_writer.reset
			l_as.condition.process (function_writer)
			expr := function_writer.expr
			generate_all_dummy_proc_calls
			code.append ("    goto ")
			code.append (true_label)
			code.append (",")
			code.append (false_label)
			code.append (";%N")
			code.append ("  ")
			code.append (true_label)
			code.append (":%N")
			code.append ("    assume(")
			code.append (expr)
			code.append (");%N")
			l_as.compound.process (Current)
			code.append ("    goto ")
			code.append (end_label)
			code.append (";%N")
			if l_as.elsif_list /= Void then
				from
					l_as.elsif_list.start
				until
					l_as.elsif_list.off
				loop
					code.append ("  ")
					code.append (false_label)
					code.append (":%N")
					code.append ("    assume(!(")
					code.append (expr)
					code.append ("));%N")
					function_writer.reset
					l_as.elsif_list.item.expr.process (function_writer)
					expr := function_writer.expr
					generate_all_dummy_proc_calls
					new_label ("true")
					true_label := last_label
					if l_as.elsif_list.islast then
						false_label := else_label
					else
						new_label ("false")
						false_label := last_label
					end
					code.append ("    goto ")
					code.append (true_label)
					code.append (",")
					code.append (false_label)
					code.append (";%N")
					code.append ("  ")
					code.append (true_label)
					code.append (":%N")
					code.append ("    assume(")
					code.append (expr)
					code.append (");%N")
					l_as.elsif_list.item.compound.process (Current)
					code.append ("    goto ")
					code.append (end_label)
					code.append (";%N")
					l_as.elsif_list.forth
				end
			end
			code.append ("  ")
			code.append (else_label)
			code.append (":%N")
			code.append ("    assume(!(")
			code.append (expr)
			code.append ("));%N")
			if l_as.else_part /= Void then
				l_as.else_part.process (Current)
			end
			code.append ("    goto ")
			code.append (end_label)
			code.append (";%N")
			code.append ("  ")
			code.append (end_label)
			code.append (":%N")
		end

	process_inspect_as (l_as: INSPECT_AS) is
			-- Process `l_as'.
		do
			check
				not_implemented: False
			end
		end

	process_loop_as (l_as: LOOP_AS) is
			-- Process `l_as'.
		local
			loop_label,exit_label:STRING
			expr: STRING
			inv_expr_assert: STRING
			inv_expr_assume: STRING
			tmp_code: STRING
			loop_expr_code: STRING
		do
			if l_as.from_part /= Void then
				l_as.from_part.process (Current)
			end
			-- We store 'code' somewhere to get the generated dummy code into 'loop_expr_code'
			tmp_code := code
			code := ""
			function_writer.reset
			l_as.stop.process (function_writer)
			expr := function_writer.expr
			generate_all_dummy_proc_calls
			inv_expr_assert := ""
			inv_expr_assume := ""
			if l_as.invariant_part /= Void then
				from
					l_as.invariant_part.start
				until
					l_as.invariant_part.off
				loop
					function_writer.reset
					l_as.invariant_part.item.expr.process (function_writer)
					inv_expr_assume.append ("    assume(")
					inv_expr_assume.append (function_writer.expr)
					inv_expr_assume.append (");")
					inv_expr_assume.append (location_info (l_as.invariant_part.item.expr, l_as.invariant_part.item.tag))
					inv_expr_assert.append ("    assert(")
					inv_expr_assert.append (function_writer.expr)
					inv_expr_assert.append (");")
					inv_expr_assert.append (location_info (l_as.invariant_part.item.expr, l_as.invariant_part.item.tag))
					generate_all_dummy_proc_calls
					l_as.invariant_part.forth
				end
			end
			loop_expr_code := code
			code := tmp_code
			new_label ("loop")
			loop_label := last_label
			new_label ("exit")
			exit_label := last_label
			code.append (loop_expr_code)
			code.append (inv_expr_assert)
			code.append ("    goto ")
			code.append (loop_label)
			code.append (",")
			code.append (exit_label)
			code.append (";%N")

			code.append ("  ")
			code.append (loop_label)
			code.append (":%N")
			code.append ("    assume(!(")
			code.append (expr)
			code.append ("));%N")
			code.append (inv_expr_assume)
			if l_as.compound /= Void then
				l_as.compound.process (Current)
			end
			code.append (loop_expr_code)
			code.append (inv_expr_assert)
			code.append ("    goto ")
			code.append (loop_label)
			code.append (",")
			code.append (exit_label)
			code.append (";%N")
			code.append ("  ")
			code.append (exit_label)
			code.append (":%N")
			code.append ("    assume(")
			code.append (expr)
			code.append (");%N")
			code.append (inv_expr_assume)
		end

	process_check_as (l_as: CHECK_AS) is
			-- Process `l_as'.
		do
			if l_as.check_list /= Void then
				from
					l_as.check_list.start
				until
					l_as.check_list.off
				loop
					assert_expression (l_as.check_list.item.expr, l_as.check_list.item.tag)
					l_as.check_list.forth
				end
			end
		end

	process_nested_as (l_as: NESTED_AS) is
			-- Processing `l_as'.
		local
			nested_expr_as: NESTED_EXPR_AS
		do
			nested_expr_as := nested_as_to_nested_expr_as (l_as)
			nested_expr_as.process (Current)
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS) is
			-- Processing `l_as'.
		local
			new_code: STRING
			afa: ACCESS_FEAT_AS
			elist: LIST [EXPR_AS]
		do
			afa ?= l_as.message
			if afa /= Void then
				new_code := "    call proc."
				new_code.append (type_for (l_as.target).associated_class.name)
				new_code.append (".")
				new_code.append (afa.feature_name)
				new_code.append ("(")
				function_writer.reset
				l_as.target.process (function_writer)
				new_code.append (function_writer.expr)
				generate_all_dummy_proc_calls
				if afa.parameters /= Void then
					elist := afa.parameters
					from
						elist.start
					until
						elist.off
					loop
						function_writer.reset
						elist.item.process (function_writer)
						new_code.append (",")
						new_code.append (function_writer.expr)
						generate_all_dummy_proc_calls
						elist.forth
					end
				end
				new_code.append (");")
				code.append (new_code)
				code.append (location_info (l_as, Void))
			else
				check
					unknown_access: False
				end
			end
			record_usage (l_as)
		end

	process_static_access_as (l_as: STATIC_ACCESS_AS) is
			-- Process `l_as'.
		do
			check
				not_implemented: False
			end
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS) is
			-- Process `l_as'.
		local
			new_code: STRING
			elist: LIST[EXPR_AS]
		do
			new_code := "    call proc."
			new_code.append (current_class.name)
			new_code.append (".")
			new_code.append (l_as.feature_name)
			new_code.append ("(Current")
			if l_as.parameters /= Void then
				elist := l_as.parameters
				from
					elist.start
				until
					elist.off
				loop
					function_writer.reset
					elist.item.process (function_writer)
					new_code.append (",")
					new_code.append (function_writer.expr)
					generate_all_dummy_proc_calls
					elist.forth
				end
			end
			new_code.append (");")
			code.append (new_code)
			code.append (location_info (l_as, Void))
			record_usage (l_as)
		end

	process_access_id_as (l_as: ACCESS_ID_AS) is
			-- Process `l_as'.
		local
			new_code: STRING
			elist: LIST[EXPR_AS]
		do
			new_code := "    call proc."
			new_code.append (current_class.name)
			new_code.append (".")
			new_code.append (l_as.feature_name)
			new_code.append ("(Current")
			if l_as.parameters /= Void then
				elist := l_as.parameters
				from
					elist.start
				until
					elist.off
				loop
					function_writer.reset
					elist.item.process (function_writer)
					new_code.append (",")
					new_code.append (function_writer.expr)
					generate_all_dummy_proc_calls
					elist.forth
				end
			end
			new_code.append (");")
			code.append (new_code)
			code.append (location_info (l_as, Void))
			record_usage (l_as)
		end

	process_access_inv_as (l_as: ACCESS_INV_AS) is
			-- Process `l_as'.
		local
			new_code: STRING
			elist: LIST[EXPR_AS]
		do
			new_code := "    call proc."
			new_code.append (current_class.name)
			new_code.append (".")
			new_code.append (l_as.feature_name)
			new_code.append ("(Current")
			if l_as.parameters /= Void then
				elist := l_as.parameters
				from
					elist.start
				until
					elist.off
				loop
					function_writer.reset
					elist.item.process (function_writer)
					new_code.append (",")
					new_code.append (function_writer.expr)
					generate_all_dummy_proc_calls
					elist.forth
				end
			end
			new_code.append (");")
			code.append (new_code)
			code.append (location_info (l_as, Void))
			record_usage (l_as)
		end

	process_create_as (l_as: CREATE_AS) is
			-- Process `l_as'.
		do
			check
				not_implemented: False
			end
		end

end
