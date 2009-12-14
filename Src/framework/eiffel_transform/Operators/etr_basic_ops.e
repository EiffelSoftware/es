note
	description: "Basic mutation operators"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_BASIC_OPS
inherit
	ETR_SHARED
		export
			{NONE} all
		end

	REFACTORING_HELPER
		export
			{NONE} all
		end

feature {NONE} -- Implementation

	end_keyword: KEYWORD_AS is
			-- simple end keyword with no location or text information
		once
			create Result.make_null 
			Result.set_code ({EIFFEL_TOKENS}.te_end)
		ensure
			Result.is_end_keyword
		end

feature -- Transform

--	boolean_replace(a_transformable: ETR_TRANSFORMABLE; a_cond: BOOLEAN):ETR_TRANSFORMABLE is
--			-- replace all boolean expressions created by comparison operators in a_transformable by a_cond
--		local
--			replacer: ETR_AST_REPLACER
--		do

--		end

	if_wrap(a_transformable:ETR_TRANSFORMABLE; a_condition: ETR_TRANSFORMABLE):ETR_TRANSFORMABLE is
			-- Wrap a_transformable with cond
			-- result has context of a_transformable!
			-- todo: some compability checks?
		local
			if_part: EIFFEL_LIST[INSTRUCTION_AS]
			instr: INSTRUCTION_AS
			if_node: IF_AS
			condition_node: EXPR_AS
			body_node: AST_EIFFEL
		do
			-- compatibility checks
			-- todo: find more elegant way for this
			condition_node ?= a_condition.target_node
			if condition_node = void then
				-- todo: output error (incompatible)
			end

			-- check if it's EIFFEL_LIST[INSTRUCTION_AS] or INSTRUCTION_AS
			if a_transformable.target_node ~ if_part then
				if_part ?= a_transformable.target_node
			elseif a_transformable.target_node ~ instr then
				instr ?= a_transformable.target_node
				if_part := single_instr_list (instr)
			else
				-- todo: output error (incompatible)
			end

			-- assemble new IF_AS
			create if_node.initialize (condition_node, if_part, void, void, end_keyword, void, void, void)

			-- reindex it
			index_ast (if_node)
			-- make adjustments for context
			adjust_for_context (if_node, a_transformable.context)

			-- create new ETR_TRANSFORMABLE
			create Result.make_with_node (if_node, a_transformable.context)
		end

--	replace(a_transformable: ETR_TRANSFORMABLE; a_position: AST_PATH) is
--			-- move a_transformable to a_position in its context, replacing anything thats there
--		do

--		end

--	insert(a_transformable: ETR_TRANSFORMABLE; a_position: AST_PATH) is
--			-- insert a_transformable at a_position in its context
--		do

--		end
note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
