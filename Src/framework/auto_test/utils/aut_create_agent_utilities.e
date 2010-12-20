note
	description: "Features used to check for agent types."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_CREATE_AGENT_UTILITIES

inherit
	ERL_G_TYPE_ROUTINES
		export {NONE} all end

feature -- Access

	is_routine (a_type: TYPE_A): BOOLEAN
			-- is `a_type' a routine?
		require
			type_attached: a_type /= Void
			type_resolved: a_type.has_associated_class
		do
			Result := a_type.associated_class.name ~ once "ROUTINE"
		ensure
			result_set: Result = a_type.associated_class.name ~ "ROUTINE"
		end

	is_procedure (a_type: TYPE_A): BOOLEAN
			-- is `a_type' a procedure?
		require
			type_attached: a_type /= Void
			type_resolved: a_type.has_associated_class
		do
			Result := a_type.associated_class.name ~ once "PROCEDURE"
		ensure
			result_set: Result = a_type.associated_class.name ~ "PROCEDURE"
		end

	is_function (a_type: TYPE_A): BOOLEAN
			-- is `a_type' a function?
		require
			type_attached: a_type /= Void
			type_resolved: a_type.has_associated_class
		do
			Result := a_type.associated_class.name ~ once "FUNCTION"
		ensure
			result_set: Result = a_type.associated_class.name ~ "FUNCTION"
		end

	is_predicate (a_type: TYPE_A): BOOLEAN
			-- is `a_type' a predicate?
		require
			type_attached: a_type /= Void
			type_resolved: a_type.has_associated_class
		do
			Result := a_type.associated_class.name ~ once "PREDICATE"
		ensure
			result_set: Result = a_type.associated_class.name ~ "PREDICATE"
		end

	is_agent_type (a_type: TYPE_A): BOOLEAN
			-- is `a_type' a type that can be wrapped by an agent?
		require
			type_attached: a_type /= Void
			type_resolved: a_type.has_associated_class
		do
			Result := is_procedure(a_type) or else is_function(a_type)
					  or else is_predicate(a_type) or else is_routine(a_type)
		end

	has_anchored_arguments (a_feature: FEATURE_I): BOOLEAN
			-- Does `a_feature' have arguments that are anchored to other arguments?
		require
			feature_attached: a_feature /= Void
		do
			Result := a_feature.arguments /= Void and then a_feature.arguments.there_exists (
				agent (a_type:TYPE_A):BOOLEAN
					do
						Result := attached {LIKE_ARGUMENT} a_type as l_anch
					end
			)
		end

	contains_agent_arguments (a_feature: AUT_FEATURE_OF_TYPE): BOOLEAN
			-- Does `a_feature' have arguments that are of agent type?
		require
			feature_attached: a_feature /= Void
		local
			l_args: LIST [TYPE_A]
		do
			l_args := feature_argument_types (a_feature.feature_, a_feature.type)
			Result := l_args.there_exists (agent is_agent_type)
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
