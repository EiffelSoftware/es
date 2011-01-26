note
	description: "[
		Class to find feature calls in a routine
		Note: This class only handles simple cases, it does not support
		nested calls in arguments, for examples, a.b(c.e, f) or argumented-calls in target, for example a.b(c).e
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FEATURE_CALL_FINDER

inherit
	AST_ITERATOR
		redefine
			process_access_id_as,
			process_access_feat_as,
			process_nested_as,
			process_nested_expr_as,
			process_create_creation_as,
			process_create_creation_expr_as
		end


	EPA_TYPE_UTILITY

	EPA_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

feature -- Access

	last_calls: LINKED_LIST [TUPLE [feature_name: STRING; operands: HASH_TABLE [STRING, INTEGER]]]
			-- Feature calls found by last `find'
			-- Keys of `operands' are 0-based operand indexs, values are operand names.
			-- `feature_name' is the name of the feature call.

feature -- Basic operations

	find (a_class: CLASS_C; a_feature: FEATURE_I)
			-- Find feature calls in `a_feature', viewed from `a_class'.
			-- Make result available in `last_calls'.
		local
			l_expr: EPA_AST_EXPRESSION
			i: INTEGER
		do
			feature_ := a_feature
			context_class := a_class
			written_class := feature_.written_class

			create last_calls.make

			if attached {DO_AS} body_ast_from_feature (feature_) as l_do then
				create feature_context.make (feature_, create {ETR_CLASS_CONTEXT}.make (context_class))
				local_table := feature_context.local_by_name
				if local_table = Void then
					create local_table.make (0)
					local_table.compare_objects
				end
				arguments := arguments_of_feature (feature_)
				create calls.make (10)

					-- Process the feature body AST.
				l_do.process (Current)
				prune_calls
			end
		end

feature{NONE} -- Implementation

	prune_calls
			-- Prune elements in `calls' which are not supported.
		local
			l_as: AST_EIFFEL
			l_text: STRING
			l_should_keep: BOOLEAN
			l_kepted_calls: like calls
			l_first_target: STRING
			l_rev_args: like relevant_arguments
			l_args: HASH_TABLE [like relevant_arguments, STRING]
			l_has_paran: BOOLEAN
			l_has_dot: BOOLEAN
			l_target_name: STRING
			l_feature_name: STRING
			l_ind1, l_ind2: INTEGER
		do
			create l_args.make (5)
			l_args.compare_objects
			create l_kepted_calls.make (calls.count)
			l_kepted_calls.compare_objects
			from
				calls.start
			until
				calls.after
			loop
				l_as := calls.item_for_iteration
				l_text := calls.key_for_iteration
				l_should_keep := True

				if l_text.occurrences ('(') > 1 or l_text.occurrences ('.') > 1 or l_text.has ('{') then
					l_should_keep := False
				end
				if l_should_keep then
					l_first_target := first_target_of_call (l_as)
				end

				if l_should_keep then
					l_should_keep := is_relevant_nested_call (l_as)
				end

				if l_should_keep then
					l_rev_args := relevant_arguments (l_as)
					if l_rev_args = Void then
						l_should_keep := False
					else
						l_args.force (l_rev_args, l_text)
					end
				end
				if l_should_keep then
					l_kepted_calls.force (calls.item_for_iteration, calls.key_for_iteration)
				end
				calls.forth
			end
			calls := l_kepted_calls
			from
				calls.start
			until
				calls.after
			loop
				l_text := calls.key_for_iteration
				l_ind1 := l_text.index_of ('.', 1)
				l_ind2 := l_text.index_of ('(', 1)
				l_has_paran := l_ind2 > 0
				l_has_dot := l_ind1 > 0
				if l_has_paran and l_has_dot then
					l_target_name := l_text.substring (1, l_ind1 - 1)
					l_feature_name := l_text.substring (l_ind1 + 1, l_ind2 - 1)
				elseif l_has_paran and then not l_has_dot then
					l_target_name := ti_current.twin
					l_feature_name := l_text.substring (1, l_ind2 - 1)
				elseif not l_has_paran and then l_has_dot then
					l_target_name := l_text.substring (1, l_ind1 - 1)
					l_feature_name := l_text.substring (l_ind1 + 1, l_text.count)
				else
					l_target_name := ti_current.twin
					l_feature_name := l_text.twin
				end
				l_target_name.left_adjust
				l_target_name.right_adjust
				l_feature_name.left_adjust
				l_feature_name.right_adjust
				l_args.item (calls.key_for_iteration).force (l_target_name, 0)
				last_calls.extend ([l_feature_name, l_args.item (calls.key_for_iteration)])
				calls.forth
			end
		end

	is_relevant_nested_call (l_as: AST_EIFFEL): BOOLEAN
			-- Is `l_as' a relevant feature call?
		do
			if attached {ACCESS_FEAT_AS} l_as as l_feat then
				Result := True
			elseif attached {NESTED_AS} l_as as l_nested then
				if attached {STRING} first_target_of_call (l_as) as l_target then
					Result :=
						l_target ~ ti_current or else
						(arguments.has (l_target))
				end
			elseif attached {NESTED_EXPR_AS} l_as as l_nested then
				if attached {STRING} first_target_of_call (l_as) as l_target then
					Result :=
						l_target ~ ti_current or else
						(arguments.has (l_target))
				end
			end
		end

	relevant_arguments (l_as: AST_EIFFEL): detachable HASH_TABLE [STRING, INTEGER]
			-- Are all arguments of `l_as' (if it is a feature call)
			-- relevant?
			-- Keys are 0-based operand ids, values are the operand names.
			-- Void as result means the arguments are not relevant.
		local
			l_text: STRING
			l_index1, l_index2: INTEGER
			l_args: LIST [STRING]
			l_arg_text: STRING
			i: INTEGER
		do
			if attached {ACCESS_FEAT_AS} l_as as l_feat then
				if l_feat.internal_parameters /= Void then
					l_text := "(" + text_from_ast (l_feat.internal_parameters) + ")"
				end
			elseif attached {NESTED_AS} l_as as l_nested then
				l_text := text_from_ast (l_nested.message)
			elseif attached {NESTED_EXPR_AS} l_as as l_nested then
				l_text := text_from_ast (l_nested.message)
			end
			if l_text = Void then
				create Result.make (0)
			else
				l_index1 := l_text.index_of ('(', 1)
				l_index2 := l_text.index_of (')', l_index1 + 1)
				l_args := l_text.substring (l_index1 + 1, l_index2 - 1).split (',')
				create Result.make (5)
				from
					i := 1
					l_args.start
				until
					l_args.after or else Result = Void
				loop
					l_arg_text := l_args.item_for_iteration
					l_arg_text.left_adjust
					l_arg_text.right_adjust
					if l_arg_text ~ ti_current or else arguments.has (l_arg_text) then
						Result.force (l_arg_text, i)
					else
						Result := Void
					end
					i := i + 1
					l_args.forth
				end
			end
		end

	first_target_of_call (l_as: AST_EIFFEL): detachable STRING
			-- Target of feature call in `a_as', if any
		local
			l_index: INTEGER
			l_text: STRING
		do
			l_text := text_from_ast (l_as)
			if attached {ACCESS_FEAT_AS} l_as as l_feat then
				Result := ti_current.twin
			elseif attached {NESTED_AS} l_as as l_nested then
				l_index := l_text.index_of ('.', 1)
				Result := l_text.substring (1, l_index - 1)
				Result.left_adjust
				Result.right_adjust
			elseif attached {NESTED_EXPR_AS} l_as as l_nested then
				l_index := l_text.index_of ('.', 1)
				Result := l_text.substring (1, l_index - 1)
				Result.left_adjust
				Result.right_adjust
			end
		end

	feature_: FEATURE_I
			-- Feature being processed

	context_class: CLASS_C
			-- Class where `feature_' is viewed

	written_class: CLASS_C
			-- Class where `feature_' is written

	calls: HASH_TABLE [AST_EIFFEL, STRING]
			-- Feature calls that have been collected
			-- Keys are string representation for ASTs.
			-- Values are the actual AST nodes

	feature_context: ETR_FEATURE_CONTEXT
			-- Featue context

	local_table: HASH_TABLE [ETR_TYPED_VAR, STRING]
			-- Table for locals
			-- Keys are local names, values are types of those locals

	arguments: like arguments_of_feature
			-- Table for arguments of `feature_'
			-- Keys are argument names, values are 1-based argument index.

feature{NONE} -- Process

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local
			l_name: STRING
		do
			l_name := l_as.access_name
			if not arguments.has (l_name) and not local_table.has (l_name) then
				calls.force (l_as, text_from_ast (l_as))
			end
		end

	process_access_id_as (l_as: ACCESS_ID_AS)
		do
			process_access_feat_as (l_as)
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS)
		do
			calls.force (l_as, text_from_ast (l_as))
		end

	process_nested_as (l_as: NESTED_AS)
		do
			calls.force (l_as, text_from_ast (l_as))
		end

	process_create_creation_as (l_as: CREATE_CREATION_AS)
			-- Process `l_as'.
		do
		end

	process_create_creation_expr_as (l_as: CREATE_CREATION_EXPR_AS)
			-- Process `l_as'.
		do
		end


end
