note
	description: "Constructs an association of AST nodes to a temporary variable name."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_CHAIN_BREAKER

inherit
	AST_ITERATOR
		redefine
			process_nested_as,
			process_access_feat_as,
			process_access_id_as,
			process_assign_as,
			process_do_as,
			process_id_as
		end
create
	make

feature
	make
		do
			create replacements.make (20)
			create lines.make (10)
			first_nested := True
		end

	process (l_as: FEATURE_AS)
		do
			process_feature_as (l_as)
		end

	replacements: HASH_TABLE [STRING, AST_HASHWRAP]
	lines: ARRAYED_LIST [AST_EIFFEL]

	print_replacements
		do
			from
				replacements.start
			until
				replacements.after
			loop
				io.put_string (replacements.key_for_iteration.ast.out)
				io.put_string (" :")
				io.put_string (replacements.item_for_iteration)
				io.new_line

				replacements.forth
			end
		end

feature {NONE} -- Private attributes

	temp_var_name: STRING_32 = "ssa_temp_"
	depth: INTEGER
	processing_assign: BOOLEAN
	first_nested: BOOLEAN


feature {NONE} -- Internal traversal of the AST
	process_assign_as (l_as: ASSIGN_AS)
		do
			processing_assign := True
			first_nested := False

			add_line (l_as)

			store_and_incr (l_as)
			safe_process (l_as.source)

			first_nested := True
			processing_assign := False
		end

	in_feature_body: BOOLEAN

	process_do_as (l_as: DO_AS)
		do
			in_feature_body := True
			safe_process (l_as.compound)
			in_feature_body := False
		end

	process_id_as (l_as: ID_AS)
		do
			if in_feature_body then
				store_and_incr (l_as)
			end
		end

	process_access_id_as (l_as: ACCESS_ID_AS)
		do
			process_access_feat_as (l_as)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local
			was_first: BOOLEAN
		do
			if first_nested then
				lines.extend (l_as)
				first_nested := False
				was_first := True
			end

			safe_process (l_as.parameters)
			safe_process (l_as.feature_name)

			if was_first then
				first_nested := True
			end
		end

	process_nested_as (l_as: NESTED_AS)
		local
			was_first: BOOLEAN
		do
			if first_nested then
				add_line (l_as)
				first_nested := False
				was_first := True
			end

			safe_process (l_as.target)

			store_and_incr (l_as)

			safe_process (l_as.message)

			if was_first then
				first_nested := True
			end
		end


feature {NONE}

		-- A routine to succinctly wrap up an AST node, because I hate the
		-- create expression.
	wrap (a_ast: AST_EIFFEL): AST_HASHWRAP
		do
			create Result.make (a_ast)
		end

	add_line (l_as: AST_EIFFEL)
		do
			if in_feature_body then
				lines.extend (l_as)
			end
		end

	store_and_incr (l_as: AST_EIFFEL)
		do
			depth := depth + 1
			replacements [wrap (l_as)] := temp_var_name + depth.out
		end

end
