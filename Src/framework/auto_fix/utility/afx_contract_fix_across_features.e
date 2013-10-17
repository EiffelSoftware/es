note
	description: "Summary description for {AFX_CONTRACT_FIX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_CONTRACT_FIX_ACROSS_FEATURES

inherit
	DS_HASH_TABLE [TUPLE[pre, post: AFX_CONTRACT_FIX_PER_FEATURE], AFX_FEATURE_TO_MONITOR]
		redefine out end

	DEBUG_OUTPUT
		undefine is_equal, copy
		redefine out
		end

create
	make_equal

feature -- Status report

--	is_strengthening (a_feature: AFX_FEATURE_TO_MONITOR): BOOLEAN
--		require
--			has_feature: has (a_feature)
--		do
--			Result := item (a_feature).is_strengthening
--		end

--	is_weakening (a_feature: AFX_FEATURE_TO_MONITOR): BOOLEAN
--		require
--			has_feature: has (a_feature)
--		do
--			Result := item (a_feature).is_weakening
--		end

feature -- Basic operation

	as_fix_in_ast_expressions: like Current
		local
			l_cursor: DS_HASH_TABLE_CURSOR [TUPLE[pre, post: AFX_CONTRACT_FIX_PER_FEATURE], AFX_FEATURE_TO_MONITOR]
			l_pre, l_post: AFX_CONTRACT_FIX_PER_FEATURE
		do
			create Result.make_equal (Current.count + 1)
			from
				l_cursor := Current.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if l_cursor.item.pre /= Void then
					l_pre := l_cursor.item.pre.as_fix_in_ast_expressions
				else
					l_pre := Void
				end
				if l_cursor.item.post /= Void then
					l_post := l_cursor.item.post.as_fix_in_ast_expressions
				else
					l_post := Void
				end
				Result.force ([l_pre, l_post], l_cursor.key)
				l_cursor.forth
			end
		end

	merge_fix_per_feature (a_fix_per_feature: AFX_CONTRACT_FIX_PER_FEATURE)
		require
			fix_per_feature_attached: a_fix_per_feature /= Void
		local
			l_feature: AFX_FEATURE_TO_MONITOR
			l_tuple: TUPLE[pre, post: AFX_CONTRACT_FIX_PER_FEATURE]
		do
			l_feature := a_fix_per_feature.context_feature
			if has (l_feature) then
				l_tuple := item (l_feature)
				if a_fix_per_feature.is_pre then
					if l_tuple.pre /= Void then
						l_tuple.pre.merge (a_fix_per_feature)
					else
						l_tuple.pre := a_fix_per_feature
					end
				else
					if l_tuple.post /= Void then
						l_tuple.post.merge (a_fix_per_feature)
					else
						l_tuple.post := a_fix_per_feature
					end
				end
			else
				if a_fix_per_feature.is_pre then
					force ([a_fix_per_feature, Void], l_feature)
				else
					force ([void, a_fix_per_feature], l_feature)
				end
			end

			out_cache := Void
		end

	rebuild_out
		do
			out_cache := Void
		end

feature -- Redefinition

	out: STRING
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

	rank: REAL assign set_rank

	set_rank (a_rank: REAL)
			--
		do
			rank := a_rank
		end


feature{NONE} -- Implementation

	build_out
		local
			l_cursor: DS_HASH_TABLE_CURSOR [TUPLE[pre, post: AFX_CONTRACT_FIX_PER_FEATURE], AFX_FEATURE_TO_MONITOR]
			l_tuple: TUPLE[pre, post: AFX_CONTRACT_FIX_PER_FEATURE]
		do
			create out_cache.make (1024)
			from
				l_cursor := new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_tuple := l_cursor.item
				if l_tuple.pre /= Void then
					out_cache.append (l_tuple.pre.out + "%N")
				end
				if l_tuple.post /= Void then
					out_cache.append (l_tuple.post.out + "%N")
				end

				l_cursor.forth
			end
		end

feature{NONE} -- Cache

	out_cache: STRING

end
