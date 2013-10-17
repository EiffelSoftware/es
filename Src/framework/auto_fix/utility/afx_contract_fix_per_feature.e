note
	description: "[
		Revision to the contract of a feature.
		
		No sophisticated check is conducted to ensure the addings and removings do not conflict.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_CONTRACT_FIX_PER_FEATURE

inherit
	ANY
		redefine out, is_equal end

	HASHABLE
		redefine out, is_equal end

	DEBUG_OUTPUT
		redefine out, is_equal end

create
	make

feature{NONE} -- Initialization

	make (a_feature: AFX_FEATURE_TO_MONITOR; a_pre: BOOLEAN; a_clauses_to_add, a_clauses_to_remove: EPA_HASH_SET [EPA_AST_EXPRESSION])
			--
		require
			feature_attached: a_feature /= Void
		do
			context_feature := a_feature
			is_pre := a_pre
			create clauses_to_add.make_equal (5)
			if a_clauses_to_add /= Void then clauses_to_add.merge (a_clauses_to_add) end
			create clauses_to_remove.make_equal (5)
			if a_clauses_to_remove /= Void then clauses_to_remove.merge (a_clauses_to_remove) end
		end


feature -- Access

	context_feature: AFX_FEATURE_TO_MONITOR

	is_pre: BOOLEAN
			-- Is Current revision based on the precondition?

	clauses_to_add: EPA_HASH_SET [EPA_AST_EXPRESSION]

	clauses_to_remove: EPA_HASH_SET [EPA_AST_EXPRESSION]

feature -- Status report

	is_strengthening: BOOLEAN
		do
			Result := not clauses_to_add.is_empty
		end

	is_weakening: BOOLEAN
		do
			Result := not clauses_to_remove.is_empty
		end

feature -- Basic operation

	as_fix_in_ast_expressions: like Current
			--
		local
			l_add, l_remove: EPA_HASH_SET [EPA_AST_EXPRESSION]
		do
			if clauses_to_add /= Void then
				create l_add.make_equal (clauses_to_add.count)
				clauses_to_add.do_all (
						agent (a_clause: EPA_AST_EXPRESSION; a_set: EPA_HASH_SET [EPA_AST_EXPRESSION])
							local
								l_exp: EPA_AST_EXPRESSION
								l_creator: EPA_AST_EXPRESSION_SAFE_CREATOR
							do
								l_exp := l_creator.safe_create_with_expression (a_clause)
								if l_exp /= Void then
									a_set.force (l_exp)
								end
							end (?, l_add)
				)
			end
			if clauses_to_remove /= Void then
				create l_remove.make_equal (clauses_to_remove.count)
				clauses_to_remove.do_all (
						agent (a_clause: EPA_AST_EXPRESSION; a_set: EPA_HASH_SET [EPA_AST_EXPRESSION])
							local
								l_exp: EPA_AST_EXPRESSION
								l_creator: EPA_AST_EXPRESSION_SAFE_CREATOR
							do
								l_exp := l_creator.safe_create_with_expression (a_clause)
								if l_exp /= Void then
									a_set.force (l_exp)
								end
							end (?, l_remove)
				)
			end
			create Result.make (context_feature, is_pre, l_add, l_remove)
		end

	merge (other: AFX_CONTRACT_FIX_PER_FEATURE)
			--
		require
			other_attached: other /= Void
			same_location: context_feature ~ other.context_feature and then is_pre = other.is_pre
		local

		do
			clauses_to_add.merge (other.clauses_to_add)
			clauses_to_remove.merge (other.clauses_to_remove)

			out_cache := Void
		end

feature -- Override

	out: STRING
			-- <Precursor>
		local
		do
			if out_cache = Void then
				build_out
			end
			Result := out_cache
		end

	debug_output: STRING
		do
			Result := out
		end

	hash_code: INTEGER_32
			-- Hash code value
		do
			Result := context_feature.hash_code
		end

	is_equal (other: like Current): BOOLEAN
		do
			Result := context_feature ~ other.context_feature and then is_pre = other.is_pre
					and then clauses_to_add ~ other.clauses_to_add and then clauses_to_remove ~ other.clauses_to_remove
		end

feature{NONE} -- Implementation

	build_out
		do
			create out_cache.make (1024)
			out_cache.append (context_feature.context_class.name_in_upper + "." + context_feature.feature_.feature_name_32)
			if is_pre then
				out_cache.append (".pre%N")
			else
				out_cache.append (".post%N")
			end
			from clauses_to_add.start
			until clauses_to_add.after
			loop
				out_cache.append ("++%T" + clauses_to_add.item_for_iteration.text + "%N")
				clauses_to_add.forth
			end
			from clauses_to_remove.start
			until clauses_to_remove.after
			loop
				out_cache.append ("--%T" + clauses_to_remove.item_for_iteration.text + "%N")
				clauses_to_remove.forth
			end
		end

feature -- Cache

	out_cache: STRING

end
