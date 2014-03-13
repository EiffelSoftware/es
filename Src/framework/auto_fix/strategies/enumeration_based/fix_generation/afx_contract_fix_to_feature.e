note
	description: "Summary description for {AFX_CONTRACT_FIX_TO_FEATURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_CONTRACT_FIX_TO_FEATURE

inherit
	AFX_FIX_TO_FEATURE
		redefine out end

	DEBUG_OUTPUT
		redefine out end

create
	make

feature{NONE} -- Initialization

	make (a_feature: like context_feature; a_pre_add, a_pre_remove, a_post_add, a_post_remove: EPA_HASH_SET [EPA_EXPRESSION])
			--
		require
			(a_pre_add /= Void and then a_pre_remove /= Void) implies a_pre_add.is_disjoint (a_pre_remove)
			(a_post_add/= Void and then a_post_remove/= Void) implies a_post_add.is_disjoint (a_post_remove)
		do
			set_context_feature (a_feature)
			if     a_pre_add /= Void then     pre_clauses_to_add := a_pre_add     else create     pre_clauses_to_add.make_equal (1) end
			if  a_pre_remove /= Void then  pre_clauses_to_remove := a_pre_remove  else create  pre_clauses_to_remove.make_equal (1) end
			if    a_post_add /= Void then    post_clauses_to_add := a_post_add    else create    post_clauses_to_add.make_equal (1) end
			if a_post_remove /= Void then post_clauses_to_remove := a_post_remove else create post_clauses_to_remove.make_equal (1) end
		end

feature -- Changes to clauses

	pre_clauses_to_add: EPA_HASH_SET [EPA_EXPRESSION]
			-- Boolean expressions to be added to precondition.

	pre_clauses_to_remove: EPA_HASH_SET [EPA_EXPRESSION]
			-- Boolean expressions to be removed from precondition.

	post_clauses_to_add: EPA_HASH_SET [EPA_EXPRESSION]
			-- Boolean expressions to be added to postcondition.

	post_clauses_to_remove: EPA_HASH_SET [EPA_EXPRESSION]
			-- Boolean expressions to be removed from postcondition.

	is_pre: BOOLEAN
			--
		do
			Result := not pre_clauses_to_add.is_empty or else not pre_clauses_to_remove.is_empty
		end

	is_post: BOOLEAN
			--
		do
			Result := not post_clauses_to_add.is_empty or else not post_clauses_to_remove.is_empty
		end

feature -- Contract after fix

	contract_clauses_after_fix: TUPLE [pre, post: EPA_HASH_SET [EPA_EXPRESSION]]
			--
		do
			if contract_clauses_after_fix_cache = Void then
				compute_contract_clauses_after_fix
			end
			Result := contract_clauses_after_fix_cache
		end

feature -- Operation

	merge (other: like Current)
			--
		require
			other /= Void
			pre_clauses_to_add.is_disjoint (other.pre_clauses_to_remove)
			pre_clauses_to_remove.is_disjoint (other.pre_clauses_to_add)
			post_clauses_to_add.is_disjoint (other.post_clauses_to_remove)
			post_clauses_to_remove.is_disjoint (other.post_clauses_to_add)
		do
			pre_clauses_to_add.merge (other.pre_clauses_to_add)
			pre_clauses_to_remove.merge (other.pre_clauses_to_remove)
			post_clauses_to_add.merge (other.post_clauses_to_add)
			post_clauses_to_remove.merge (other.post_clauses_to_remove)

			contract_clauses_after_fix_cache := [Void, Void]
			out_cache := Void
		end

feature{NONE} -- Implementation

	compute_contract_clauses_after_fix
			--
		local
			l_contracts: TUPLE [pre: EPA_HASH_SET [EPA_EXPRESSION]; post: EPA_HASH_SET [EPA_EXPRESSION]]
			l_new_pre, l_new_post: EPA_HASH_SET [EPA_EXPRESSION]
		do
			l_contracts := context_feature.contracts
			l_new_pre := l_contracts.pre.twin
			l_new_pre.merge (pre_clauses_to_add)
			l_new_pre.subtract (pre_clauses_to_remove)
			l_new_post := l_contracts.post.twin
			l_new_post.merge (post_clauses_to_add)
			l_new_post.subtract (post_clauses_to_remove)

			contract_clauses_after_fix_cache := [l_new_pre, l_new_post]
		end

	expressions_to_string (a_category: STRING; a_exprs: EPA_HASH_SET [EPA_EXPRESSION]): STRING
			--
		local
			l_blanks: STRING
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_is_first_line: BOOLEAN
		do
			if a_exprs.is_empty then
				Result := ""
			else
				l_blanks := " "
				l_blanks.multiply (a_category.count)

				Result := a_category.twin
				from
					l_is_first_line := True
					l_cursor := a_exprs.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					if l_is_first_line then
						l_is_first_line := False
					else
						Result := Result + l_blanks
					end

					Result := Result + " " + l_cursor.item.text + "%N"
					l_cursor.forth
				end
				Result := Result.substring (1, Result.count - 1)
			end
		end

feature -- Redefine

	out: STRING
			-- <Precursor>
		local
			l_pairs: ARRAY[TUPLE[expressions: EPA_HASH_SET [EPA_EXPRESSION]; pre_fix: STRING]]
			l_index: INTEGER
			l_pair: TUPLE[expressions: EPA_HASH_SET [EPA_EXPRESSION]; pre_fix: STRING]
		do
			if out_cache = Void then
				out_cache := context_feature.qualified_feature_name.twin + "%N"
				l_pairs := <<[pre_clauses_to_add, "+ pre: "], [pre_clauses_to_remove, "- pre: "], [post_clauses_to_add, "+ post:"], [post_clauses_to_remove, "- post:"]>>
				from
					l_index := 1
				until
					l_index > l_pairs.count
				loop
					l_pair := l_pairs.at (l_index)
					if not l_pair.expressions.is_empty then
						out_cache.append ("    " + expressions_to_string (l_pair.pre_fix, l_pair.expressions) + "%N")
					end
					l_index := l_index + 1
				end
				out_cache := out_cache.substring (1, out_cache.count - 1)
			end
			Result := out_cache
		end

	debug_output: STRING
			-- <Precursor>
		do
			Result := out
		end

feature{NONE} -- Cache

	contract_clauses_after_fix_cache: TUPLE [pre, post: EPA_HASH_SET [EPA_EXPRESSION]]

	out_cache: STRING

end
