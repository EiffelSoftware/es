note
	description: "[
		Given an exception position inside a context class, the strategy describe which positions are collected as potential fix positions.
		TODO: can we start collecting from FEATURE_AS, rather than from CLASS_AS?
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_FIX_POSITION_COLLECTER_I

feature -- Setting up

	config (a_feature: like context_feature; an_exception_position: like exception_position)
			-- config the strategy
		deferred
		end

feature -- Collect

    collect_fix_positions
    		-- collect possible fix positions, and save result to `last_collection'
    	require
    	    is_ready_to_collect: is_ready_to_collect
    	deferred
    	ensure
    	    last_collection_not_void: last_collection /= Void
    	end

feature -- Status report

	is_ready_to_collect: BOOLEAN
			-- is all necessary information ready so that we can start collecting?
		do
		    Result := context_feature /= Void and then exception_position /= Void
		end

feature -- Access

	context_feature: detachable FEATURE_AS
			-- the feature where the collection would be done
		deferred
		end

	exception_position: detachable EPA_EXCEPTION_CALL_STACK_FRAME_I
			-- the position of the exception
		deferred
		end

	last_collection: detachable DS_ARRAYED_LIST[AFX_FIX_POSITION]
			-- collection result for last run
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
