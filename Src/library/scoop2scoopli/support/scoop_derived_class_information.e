note
	description: "Representation of derived information of the currently processed class"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "damienm"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_DERIVED_CLASS_INFORMATION

create
	make

feature -- Access
	make is
			-- Creates SCOOP_DERIVED_CLASS_INFORMATION
		do
			create create_creations.make
			create create_creation_wrappers.make
			create_creation_wrappers.wipe_out
		ensure
			not_void: create_creations /= void
			not_void: create_creation_wrappers /= void
		end

	create_creations: LINKED_LIST[CREATE_CREATION_EXPR_AS]
		-- Maps the position of an create creation in the class. The occurence in the class corelates with the position in the list.
		-- Used to create/call the correct create creation wrappers.

	create_creation_wrappers: LINKED_LIST[STRING]
		-- Names of the added wrappers to the class.
		-- Is needed to check if we need to add a wrapper or if it was already added when processing an create creation multiple times

	wrapper_insertion_index: LINKED_LIST_CURSOR[STRING]
		-- Start position of the last processed feature

	set_wrapper_insertion_index(crs:LINKED_LIST_CURSOR[STRING]) is
		-- set start position
		do
			wrapper_insertion_index := crs
		end



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

end -- class SCOOP_DERIVED_CLASS_INFORMATION

