note
	description: "Summary description for {AFX_EXCEPTION_CALL_STACK_FRAME_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_EXCEPTION_CALL_STACK_FRAME_I

feature -- Access

	class_name: detachable STRING_8
			-- name of the class
		deferred
		end

	origin_class_name: detachable STRING_8
			-- name of the class
		deferred
		end

	routine_name: detachable STRING_8
			-- name of the feature
		deferred
		end

	breakpoint_slot_index: INTEGER
			-- Index of the breakpoint where an exception was raised
		deferred
		end

	e_feature: detachable E_FEATURE assign set_context_feature
			-- E_FEATURE of the feature `class_name'.`feature_name'
		deferred
		end

	breakpoint_info: detachable DBG_BREAKABLE_POINT_INFO assign set_breakpoint_info
			-- breakpoint information
		deferred
		end

feature -- Status Report

	is_relevant: BOOLEAN
			-- should this position be considered when generating fixes?
		deferred
		end

	is_information_complete: BOOLEAN
			-- is information necessary for analysis complete?
		do
		    Result := (class_name /= Void and then not class_name.is_empty)
		    		and then (origin_class_name /= Void and then not origin_class_name.is_empty)
		    		and then (routine_name /= Void and then not routine_name.is_empty)
		    		and then breakpoint_slot_index > 0
		end

	is_resolved: BOOLEAN
			-- is everything resolved successfully?
		deferred
		end

feature -- Setting

	set_relevant (l_relevant: BOOLEAN)
			-- set relevant to `l_relevant'
		deferred
		end

feature{AFX_EXCEPTION_POSITION_RESOLVER_I} --Setting

	set_context_feature (a_context: like e_feature)
			-- set the context feature
		deferred
		end

	set_breakpoint_info (an_info: like breakpoint_info)
			-- set the breakpoint info
		deferred
		end

feature -- Operating

	resolve_exception_position_info
			-- resolve detailed exception position info
		require
		    is_information_complete: is_information_complete
		deferred
		end


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
