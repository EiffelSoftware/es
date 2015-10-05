note
	description: "Summary description for {AFX_EXCEPTION_CALL_STACK_FRAME_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXCEPTION_TRACE_FRAME

inherit
	EPA_UTILITY

create
	make_rescue, make

feature{NONE} -- Initialization

	make_rescue
			-- Make a rescue frame.
		do
			set_is_rescue_frame (True)
		end

	make (a_context_class_name, a_routine_name: STRING; a_bp_slot_index: INTEGER; a_tag, a_written_class_name, a_nature: STRING)
			-- Make a frame, using the arguments.
		require
			context_class_name_not_empty: a_context_class_name /= Void and then not a_context_class_name.is_empty
			routine_name_not_empty: a_routine_name /= Void and then not a_routine_name.is_empty
			other_names_attached: a_written_class_name /= Void and then a_tag /= Void and then a_nature /= Void
		do
			set_context_class_name (a_context_class_name)
			set_routine_name (a_routine_name)
			set_breakpoint_slot_index (a_bp_slot_index)
			set_written_class_name (a_written_class_name)
			set_tag (a_tag)
			set_nature_of_exception (a_nature)
		end

feature -- Access

	context_class_name: STRING_8 assign set_context_class_name
			-- Name of the context class of the failing routine.
		do
			if context_class_name_cache = Void then
				create context_class_name_cache.make_empty
			end
			Result := context_class_name_cache
		end

	written_class_name: STRING_8 assign set_written_class_name
			-- Name of the written class of the failing routine.
		do
			if written_class_name_cache = Void then
				written_class_name_cache := context_class_name.twin
			end
			Result := written_class_name_cache
		end

	routine_name: STRING_8 assign set_routine_name
			-- Name of the routine.
			-- It can be a feature name, or some other special string.
		do
			if routine_name_cache = Void then
				create routine_name_cache.make_empty
			end
			Result := routine_name_cache
		end

	breakpoint_slot_index: INTEGER assign set_breakpoint_slot_index
			-- Index of the breakpoint where an exception was raised.

	tag: STRING assign set_tag
			-- Tag of violated assertion.
		do
			if tag_cache = Void then
				create tag_cache.make_empty
			end
			Result := tag_cache
		end

	nature_of_exception: STRING assign set_nature_of_exception
			-- Nature of exception.
		do
			if nature_of_exception_cache = Void then
				create nature_of_exception_cache.make_empty
			end
			Result := nature_of_exception_cache
		end

feature -- Derived access

	context_class: CLASS_C
			-- Context class of the feature.
		require
			context_class_name_not_empty: context_class_name /= Void and then not context_class_name.is_empty
		do
			Result := first_class_starts_with_name (context_class_name)
		end

	written_class: CLASS_C
			-- Written class of the feature.
		do
			Result := first_class_starts_with_name (written_class_name)
		end

	context_feature: FEATURE_I
			-- Context feature.
		require
			is_feature_related: is_feature_related
			context_class_attached: context_class /= Void
		do
			Result := context_class.feature_named_32 (routine_name)
		end

feature -- Status report

	is_rescue_frame: BOOLEAN assign set_is_rescue_frame
			-- Is current frame a rescue frame?

	is_feature_related: BOOLEAN
			-- Is current frame related to a specific feature?
		local
			l_routine_name: STRING
		do
			if not is_rescue_frame then
				l_routine_name := routine_name
				Result := not ( l_routine_name = Void or else l_routine_name.is_empty
							or else is_routine_name_invariant or else is_routine_name_root_creation)
			else
				-- Rescue frames are not feature-related.
				Result := False
			end
		end

	is_routine_name_invariant: BOOLEAN
			-- Is current frame correspond to invariant violation?
		require
			routine_name_attached: routine_name /= Void
		do
			Result := routine_name ~ Routine_name_invariant
		end

	is_routine_name_root_creation: BOOLEAN
			-- Is current frame correspond to root's creation?
		require
			routine_name_attached: routine_name /= Void
		do
			Result := routine_name ~ Routine_name_root_creation
		end

	is_nature_precondition_violation: BOOLEAN
			-- Is the nature of current frame precondition violation?
		require
			nature_of_exception_attached: nature_of_exception /= Void
		do
			Result := nature_of_exception ~ Nature_precondition_violated
		end

	is_nature_postcondition_violation: BOOLEAN
			-- Is the nature of current frame postcondition violation?
		require
			nature_of_exception_attached: nature_of_exception /= Void
		do
			Result := nature_of_exception ~ Nature_postcondition_violated
		end

	is_nature_assertion_violation: BOOLEAN
			-- Is the nature of current frame assertion violation?
		require
			nature_of_exception_attached: nature_of_exception /= Void
		do
			Result := nature_of_exception ~ Nature_assertion_violated
		end

	is_nature_class_invariant_violation: BOOLEAN
			-- Is the nature of current frame precondition violation?
		require
			nature_of_exception_attached: nature_of_exception /= Void
		do
			Result := nature_of_exception ~ Nature_class_invariant_violated
		end

	is_nature_routine_failure: BOOLEAN
			-- Is the nature of current frame precondition violation?
		require
			nature_of_exception_attached: nature_of_exception /= Void
		do
			Result := nature_of_exception ~ Nature_routine_failure
		end

	is_nature_feature_call_on_void_target: BOOLEAN
			-- Is the nature of current frame feature call on void target?
		require
			nature_of_exception_attached: nature_of_exception /= Void
		do
			Result := nature_of_exception ~ Nature_feature_call_on_void_target
		end

	is_nature_unmatched_inspect_value: BOOLEAN
		do
			Result := nature_of_exception ~ Nature_unmatched_inspect_value
		end


feature -- Status set

	set_context_class_name (a_name: STRING)
			-- Set `context_class_name'.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			context_class_name_cache := a_name.twin
		end

	set_written_class_name (a_name: STRING)
			-- Set `written_class_name'.
		require
			name_attached: a_name /= Void
		do
			if a_name.is_empty then
				-- The same as `context_class_name' by default.
				written_class_name_cache := context_class_name.twin
			else
				written_class_name_cache := a_name.twin
			end
		end

	set_routine_name (a_name: STRING)
			-- Set `feature_name'.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			routine_name_cache := a_name.twin
		end

	set_breakpoint_slot_index (a_index: INTEGER)
			-- Set `breakpoint_slot_index'.
		do
			breakpoint_slot_index := a_index
		ensure
			breakpoint_slot_index_inside_feature: ((breakpoint_slot_index /= 0) implies is_feature_related)
							and then (is_feature_related implies (breakpoint_slot_index /= 0))
		end

	set_tag (a_tag: STRING)
			-- Set `tag'.
		require
			tag_attached: a_tag /= Void
		do
			tag_cache := a_tag.twin
		end

	set_nature_of_exception (a_nature: STRING)
			-- Set `nature_of_exception'.
		require
			nature_attached: a_nature /= Void
		do
			nature_of_exception_cache := a_nature.twin
		end

feature{NONE} -- Status set

	set_is_rescue_frame (a_flag: BOOLEAN)
			-- Set `is_rescue_frame'.
		do
			is_rescue_frame := a_flag
		end

feature -- Constant

	Routine_name_root_creation: STRING = "root%'s creation"

	Routine_name_invariant: STRING = "_invariant"

	Nature_routine_failure: STRING = "Routine failure."

	Nature_postcondition_violated: STRING = "Postcondition violated."

	Nature_precondition_violated: STRING = "Precondition violated."

	Nature_class_invariant_violated: STRING = "Class invariant violated."

	Nature_assertion_violated: STRING = "Assertion violated."

	Nature_feature_call_on_void_target: STRING = "Feature call on void target."

	Nature_unmatched_inspect_value: STRING = "Unmatched inspect value."

feature{NONE} -- Cache

    context_class_name_cache: STRING
            -- Cache for `context_class_name'.

    written_class_name_cache: STRING
            -- Cache for `written_class_name'.

    routine_name_cache: STRING
            -- Cache for `routine_name'.

    tag_cache: STRING
            -- Cache for `tag'.

    nature_of_exception_cache: STRING
            -- Cache for `nature_of_exception'.

;note
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
