note
	description: "Summary description for {AFX_FIXING_TARGET_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_FIXING_TARGET_I

inherit
    ANY
    	redefine
    	    is_equal
    	end

feature -- Access

	context_feature: E_FEATURE
			-- context feature where the target was used
		deferred
		end

	representation: STRING
			-- representation of the fixing target in the code
		deferred
		end

	type: TYPE_A
			-- type of the fixing target
		deferred
		end

	tunning_operations: DS_LINEAR [AFX_FIX_OPERATION_TUNNING]
			-- tunning operations for this target
		deferred
		end

	same_as (a_target: AFX_FIXING_TARGET_I): BOOLEAN
			-- are the current and `a_target' the same?
		do
		    Result := a_target /= Void
		    		and then representation ~ a_target.representation
		    		and then type.same_as (a_target.type)
		end

feature -- Status report

	is_equal (a_target: like Current): BOOLEAN
			-- <Precursor>
		do
		    if a_target /= Void and then context_feature = a_target.context_feature and then representation ~ a_target.representation then
		        Result := True
		    end
		end

feature{AFX_FIXING_TARGET_TUNING_SERVICE} -- Tune

	register_tunning_operations (a_operations: like tunning_operations)
			-- register possible tunning operations with this target
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
