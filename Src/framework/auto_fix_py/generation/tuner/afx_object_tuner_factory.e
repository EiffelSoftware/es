note
	description: "Summary description for {AFX_OBJECT_TUNER_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_OBJECT_TUNER_FACTORY

feature -- Access

	reference_tuner: AFX_REFERENCE_TUNER
			-- reference tuner
		once
		    create Result.make
		end

	integer_number_tuner: AFX_INTEGER_NUMBER_TUNER
			-- integer tuner
		once
		    create Result.make
		end

	real_number_tuner: AFX_REAL_NUMBER_TUNER
			-- real number tuner
		once
		    create Result.make
		end

	boolean_tuner: AFX_BOOLEAN_TUNER
			-- boolean tuner
		once
		    create Result.make
		end

--feature{NONE} -- Implementation

--	reference_tuner_internal: detachable AFX_REFERENCE_TUNER
--			-- internal reference tuner
--			
--	last_integer_number_tuner: detachable AFX_INTEGER_NUMBER_TUNER
--			-- internal integer tuner

--	last_real_number_tuner: detachable AFX_REAL_NUMBER_TUNER
--			-- internal real number tuner

--	last_boolean_tuner: detachable AFX_BOOLEAN_TUNER
--			-- internal boolean tuner

--			
--feature -- Factory routine

--    make_reference_tuner (an_ref_name: STRING; an_ref_type: TYPE_A; a_context_feature: E_FEATURE)
--    		-- reference tuner factory routine
--    	require
--    	    ref_name_not_empty: not an_ref_name.is_empty
--    	do
--    	    create last_reference_tuner.make (an_ref_name, an_ref_type, a_context_feature)
--    	end

--    make_integer_number_tuner (an_obj_name: STRING)
--    		-- integer number tuner factory routine
--    	require
--    	    object_name_not_empty: not an_obj_name.is_empty
--    	do
--    	    create last_integer_number_tuner.make (an_obj_name)
--    	end

--    make_real_number_tuner (an_obj_name: STRING)
--    		-- real number tuner factory routine
--    	require
--    	    object_name_not_empty: not an_obj_name.is_empty
--    	do
--    	    create last_real_number_tuner.make (an_obj_name)
--    	end

--    make_boolean_tuner (an_obj_name: STRING)
--    		-- boolean tuner factory routine
--    	require
--    	    object_name_not_empty: not an_obj_name.is_empty
--    	do
--    	    create last_boolean_tuner.make (an_obj_name)
--    	end

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
