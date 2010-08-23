note
	description: "Helper class to connect the compiler with the blackboard."
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_BLACKBOARD_COMPILER_HELPER

feature -- Basic operations

	handle_changed_feature (a_feature: FEATURE_I)
			-- Handle that feature `a_feature' changed.
		do
			if attached blackboard as l_blackboard and then l_blackboard.is_running then
				l_blackboard.handle_changed_feature (a_feature)
			end
		end

	handle_removed_feature (a_feature: FEATURE_I)
			-- Handle that feature `a_feature' was removed.
		do
			if attached blackboard as l_blackboard and then l_blackboard.is_running then
				l_blackboard.handle_removed_feature (a_feature)
			end
		end

	handle_added_class (a_class: CLASS_I)
			-- Handle that class `a_class' was added.
		do
			if attached blackboard as l_blackboard and then l_blackboard.is_running then
				l_blackboard.handle_added_class (a_class)
			end
		end

	handle_removed_class (a_class: CLASS_I)
			-- Handle that class `a_class' was removed.
		do
			if attached blackboard as l_blackboard and then l_blackboard.is_running then
				l_blackboard.handle_removed_class (a_class)
			end
		end

feature {NONE} -- Implementation

	blackboard: EBB_BLACKBOARD
			-- Shared blackboard.
		local
			l_service_consumer: SERVICE_CONSUMER [BLACKBOARD_S]
		do
			create l_service_consumer
			if l_service_consumer.is_service_available and then l_service_consumer.service.is_interface_usable then
				Result ?= l_service_consumer.service
			end
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
