note
	description: "Effective class generator: Processes a deferred class and makes all features effective."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_ECG_VISITOR
inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
			process_class_as,
			process_deferred_as
		end
	REFACTORING_HELPER
		export
			{NONE} all
		end
create
	make

feature {NONE} -- Implementation

	features_to_add: LIST[FEATURE_I]
			-- Features that will be added from an ancestor

	def_remover_output: ETR_AST_STRING_OUTPUT
			-- Feature's with the deferred-keyword removed

	def_remover: ETR_ECG_DEFERRED_REMOVER
			-- Visitor that removes the deferred-keywords

feature {NONE} -- Creation

	make(a_output: like output; a_features_to_add: like features_to_add)
		do
			make_with_output(a_output)

			features_to_add := a_features_to_add
			create def_remover_output.make
			create def_remover.make_with_output(def_remover_output)
		end

feature {AST_EIFFEL} -- Roundtrip

	process_deferred_as (l_as: DEFERRED_AS)
		do
			-- print do instead of deferred
			output.append_string ( ti_do_keyword+ti_new_line)
		end

	process_class_as (l_as: CLASS_AS)
		do
			-- the start is copied from Precursor
			-- just deferred-part is left out
			-- and the effective features added

			if l_as.is_frozen then
				output.append_string(ti_frozen_keyword+ti_Space)
			end

			if l_as.is_expanded then
				output.append_string(ti_expanded_keyword+ti_Space)
			end

			if l_as.is_partial then
				output.append_string("partial"+ti_Space)
			end

			if processing_needed (l_as.top_indexes, l_as, 1) then
				output.append_string (ti_note_keyword+ti_new_line)
				process_child_block_list (l_as.top_indexes, ti_new_line, l_as, 1)
				output.append_string (ti_new_line+ti_new_line)
			end

			output.append_string (ti_class_keyword+ti_New_line)
			output.enter_block
			process_child(l_as.class_name, l_as, 2)

			if processing_needed (l_as.generics, l_as, 3) then
				output.append_string (ti_l_bracket)
				process_child_list (l_as.generics, ti_comma+ti_Space, l_as, 3)
				output.append_string (ti_r_bracket)
			end
			output.append_string(ti_New_line)
			output.exit_block

			if processing_needed (l_as.obsolete_message, l_as, 4) then
				output.append_string(ti_obsolete_keyword+ti_New_line)
				process_child_block(l_as.obsolete_message, l_as, 4)
			end

			if processing_needed (l_as.parents, l_as, 5)  then
				output.append_string (ti_inherit_keyword+ti_new_line)
				process_child_block (l_as.parents, l_as, 5)
			end

			process_child (l_as.creators, l_as, 6)

			if processing_needed (l_as.convertors, l_as, 7)  then
				output.append_string (ti_convert_keyword+ti_New_line)
				output.enter_block
				process_child_list(l_as.convertors, ti_comma+ti_New_line, l_as, 7)
				output.append_string (ti_New_line)
				output.exit_block
			end

			output.append_string(ti_New_line)

			process_child(l_as.features, l_as, 8)

			-- print the effective features
			if features_to_add.count > 0 then
				output.append_string ("feature%N")
				from
					features_to_add.start
				until
					features_to_add.after
				loop
					output.enter_block
					def_remover_output.reset
					def_remover.print_modified_feature (features_to_add.item)
					output.append_string (def_remover_output.string_representation)
					output.exit_block
					features_to_add.forth
				end
			end

			process_child(l_as.invariant_part, l_as, 9)

			if processing_needed (l_as.bottom_indexes, l_as, 10) then
				-- Make sure parsing successful
				-- Semicolon or end needed before 'note'
				if l_as.features.is_empty or else l_as.features.last.features.is_empty or else (l_as.features.last.features.last.is_attribute or l_as.features.last.features.last.is_constant) then
					output.append_string (ti_semi_colon)
				end
				output.append_string (ti_note_keyword+ti_new_line)
				process_child_block_list (l_as.bottom_indexes, ti_new_line, l_as, 10)
				output.append_string (ti_new_line)
			end

			output.append_string (ti_End_keyword+ti_New_line)
		end
note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
