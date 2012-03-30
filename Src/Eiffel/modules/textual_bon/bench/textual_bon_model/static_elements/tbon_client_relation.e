note
	description: "A client relation in a static diagram."
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_CLIENT_RELATION

inherit
	TBON_STATIC_RELATION
		rename
			process_to_informal_textual_bon as process_to_textual_bon,
			process_to_formal_textual_bon as process_to_textual_bon
		redefine
			process_to_textual_bon
		end

create
	make_element

feature -- Initialization
	make_element (a_text_formatter: like text_formatter_decorator)
			-- Create a client relation.
		do
			make (a_text_formatter)
		end

feature -- Access

	client_class: attached TBON_CLASS_TYPE
			-- Which client class is described by this relation?

	semantic_label: STRING
			-- What is the semantic label of this relation?

	supplier_class: attached TBON_CLASS_TYPE
			-- Which supplier class is described by this relation?

	type_mark: TBON_TYPE_MARK
			-- What is the type mark of this relation?


			-- What client entities are described by this relation?

feature -- Status report
	has_type_mark: BOOLEAN
			-- Does this relation have a type mark?
		do
			Result := type_mark /= Void
		end

	has_semantic_label: BOOLEAN
			-- Does this relation have a semantic label?
		do
			Result := semantic_label /= Void
		end

feature -- Processing
	process_to_textual_bon
			-- Process this element into textual BON.
		do

		end


invariant
	must_specify_a_client_class: client_class /= Void
			-- A client relation must specify a client class.

	must_specify_a_supplier_class: supplier_class /= Void
			-- A client relation must specify a supplier class.


note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
