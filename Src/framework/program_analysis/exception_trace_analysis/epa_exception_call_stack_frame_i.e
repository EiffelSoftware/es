note
	description: "Summary description for {AFX_EXCEPTION_CALL_STACK_FRAME_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_EXCEPTION_CALL_STACK_FRAME_I

feature -- Access

	context_class_name: detachable STRING_8
			-- Name of the context class.
		deferred
		end

	origin_class_name: detachable STRING_8
			-- Name of the origin class.
		deferred
		end

	feature_name: detachable STRING_8
			-- Name of the feature.
		deferred
		end

	breakpoint_slot_index: INTEGER
			-- Index of the breakpoint where an exception was raised.
		deferred
		end

	tag: STRING
			-- Tag of violated assertion.
		deferred
		end

	nature_of_exception: STRING
			-- Nature of exception.
		deferred
		end

	nested_breakpoint_slot_index: INTEGER
			-- Nested index of the breakpoint slot.
		deferred
		end

	context_class: detachable CLASS_C assign set_context_class
			-- Context class of the feature.
		deferred
		end

	origin_class: detachable CLASS_C assign set_origin_class
			-- Origin class of the feature.
		deferred
		end

	origin_feature: detachable FEATURE_I assign set_origin_feature
			-- Origin feature.
		deferred
		end

	breakpoint_info: detachable DBG_BREAKABLE_POINT_INFO assign set_breakpoint_info
			-- Breakpoint information.
		deferred
		end

feature -- Status Report

	is_relevant: BOOLEAN
			-- Is this frame relevant for the exception?
		deferred
		end

	is_information_complete: BOOLEAN
			-- Is information necessary for analysis complete?
		do
		    Result := (context_class_name /= Void and then not context_class_name.is_empty)
		    		and then (origin_class_name /= Void and then not origin_class_name.is_empty)
		    		and then (feature_name /= Void and then not feature_name.is_empty)
		    		and then breakpoint_slot_index >= 0
		end

	is_resolved: BOOLEAN
			-- Is everything resolved successfully?
		deferred
		end

feature -- Setting

	set_relevant (l_relevant: BOOLEAN)
			-- set relevant to `l_relevant'
		deferred
		end

feature{AFX_EXCEPTION_POSITION_RESOLVER_I} --Setting

	set_context_class (a_class: like context_class)
			-- Set `context_class' to be `a_class'.
		deferred
		end

	set_origin_class (a_class: like origin_class)
			-- Set `origin_class' to be `a_class'.
		deferred
		end

	set_origin_feature (a_context: like origin_feature)
			-- set the context feature
		deferred
		end

	set_breakpoint_info (an_info: like breakpoint_info)
			-- set the breakpoint info
		deferred
		end

feature -- Operating

--	resolve_exception_position_info
--			-- resolve detailed exception position info
--		require
--		    is_information_complete: is_information_complete
--		deferred
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
