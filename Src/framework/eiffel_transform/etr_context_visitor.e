note
	description: "Ensure that some AST conforms to a context"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_CONTEXT_VISITOR
	--todo: rename?
inherit
	AST_ITERATOR
		redefine
--			process_id_as,
			process_class_as
--			process_feature_as
			-- theres probably a lot more to do
			-- invariant_as ?
			-- all IDABLE ?
		end
	REFACTORING_HELPER
		export
			{NONE} all
		end
create
	make_with_context

feature -- Access

	target_context: ETR_CONTEXT
			-- target contexts of this ast

	has_errors: BOOLEAN

	last_error: STRING

feature	-- Creation

	make_with_context, set_context( a_target_context: like target_context ) is
			-- make with target context
		require
			context_not_void: a_target_context /= void
		do
			target_context := a_target_context
			has_errors := false
			last_error := void
		end

feature -- Roundtrip
--	process_id_as(l_as: ID_AS) is
--			-- process ID_AS node
--		local
--			id: INTEGER
--		do
--			fixme("Is this necessary at all ?!?!")

--			-- search for the name in the target context
--			-- slow inverse lookup!
--			id := target_context.system.names.id_of (l_as.name)

--			check
--				id/=0
--				-- if the name is unknown in the target context
--				-- we can't do anything without it
--				-- todo: raise proper error. maybe set flag or so.
--			end

--			-- is it a different id?
--			if id /= l_as.name_id then
--				-- set the correct id!
--				l_as.set_name_id (id)
--			end
--		end

--	process_feature_as (l_as: FEATURE_AS)
--		do
--			Precursor(l_as)

--			to_implement("Check feature id's")
--			-- probably a little bit harder...
--			-- have to use class_id etc
--		end

	process_class_as (l_as: CLASS_AS)
		local
			matching_classes: LIST[CLASS_I]
			cid: INTEGER
		do
			Precursor(l_as)

			-- search for a class with this name in the target context
			-- ugly slow inverse lookup
			matching_classes := target_context.universe.classes_with_name (l_as.class_name.name)

			check
				matching_classes.count=1
				-- otherwise not found or multiple (how can this be? which to pick?)
			end

			cid := matching_classes.first.compiled_class.class_id

			-- set new id if different
			if cid /= l_as.class_id  then
				l_as.set_class_id (cid)
			end
		end

invariant
	context_not_void: target_context /= void

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
