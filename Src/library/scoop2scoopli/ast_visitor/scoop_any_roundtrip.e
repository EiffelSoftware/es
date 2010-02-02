note
	description: "Roundtrip visitor to process class `NONE'."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_ANY_ROUNDTRIP

inherit
	COMPILER_EXPORTER

	AST_ROUNDTRIP_PRINTER_VISITOR
		redefine
			process_feature_clause_as
		end

create
	make_with_default_context

feature

	process
		do
			process_ast_node (parsed_class)
		end

	process_feature_clause_as (fc_as : FEATURE_CLAUSE_AS )
		do
			if has_default_create (fc_as) then

				if fc_as.clients /= Void and then fc_as.clients.clients /= Void then
					fc_as.clients.clients.remove_text (match_list)
	--				fc_as.clients.clients.set_rcurly_symbol (Void)
				end
--				fc_as.clients.remove_text (match_list)

				safe_process (fc_as.feature_keyword)
--				if fc_as.clients /= Void and then fc_as.clients.is_text_available (match_list) then
					safe_process (fc_as.clients)
--				end
				safe_process (fc_as.features)
			else
				Precursor (fc_as)
--				safe_process (fc_as.feature_keyword)
--				if fc_as.clients /= Void and then fc_as.clients.is_text_available (match_list) then
--					safe_process (fc_as.clients)
--				end
--				safe_process (fc_as.features)
			end
		end


feature {NONE}
	skip_these_clients : BOOLEAN
	first_sym : BOOLEAN

	remove_none_client (fc_as : FEATURE_CLAUSE_AS)
		local
			clients : CLASS_LIST_AS
		do
			clients := fc_as.clients.clients

			from
				clients.start
			until
				clients.after
			loop
				if clients.item.name.is_equal ("NONE") then
					clients.remove
				else
					clients.forth
				end
			end
		end


		-- replace this with `has_feature_name' from FEATURE_CLAUSE_AS
	has_default_create (fc_as : FEATURE_CLAUSE_AS) : BOOLEAN
		require
			fc_as /= Void
			fc_as.features /= Void
		do
			Result := fc_as.features.there_exists (agent name_is_equal_def_create)
		ensure
			Result = fc_as.features.there_exists (agent name_is_equal_def_create)
		end

	name_is_equal_def_create (f : FEATURE_AS) : BOOLEAN
		require
			f /= Void
		do
			Result := f.feature_name.name.is_equal (def_create_string)
		ensure
			Result = f.feature_name.name.is_equal (def_create_string)
		end

	def_create_string : STRING = "default_create"

;note
	copyright:	"Copyright (c) 1984-2010, Chair of Software Engineering"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
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
			ETH Zurich
			Chair of Software Engineering
			Website http://se.inf.ethz.ch/
		]"

end -- SCOOP_ANY_ROUNDTRIP
