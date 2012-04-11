indexing
	component:   "openEHR Archetype Project"
	description: "[
				 Node of simple type in an dADL parse tree. Simple
				 types include: STRING, INTEGER, REAL, CHARACTER,
				 BOOLEAN. Occurrences set to the default of {1..1}
			 ]"
	keywords:    "test, ADL"
	author:      "Thomas Beale"
	support:     "Ocean Informatics <support@OceanInformatics.biz>"
	copyright:   "Copyright (c) 2003 Ocean Informatics Pty Ltd"
	license:     "See notice at bottom of class"

	file:        "$URL: http://www.openehr.org/svn/ref_impl_eiffel/TRUNK/libraries/common_libs/src/structures/data_tree/dt_primitive_object_list.e $"
	revision:    "$LastChangedRevision$"
	last_change: "$LastChangedDate$"

class DT_PRIMITIVE_OBJECT_LIST

inherit
	DT_OBJECT_LEAF

create
	make_identified, make_anonymous

feature -- Initialisation

	make_identified(a_value: SEQUENCE[ANY]; a_node_id: STRING) is
		require
			Item_valid: a_value /= Void
			Node_id_valid: a_node_id /= Void and then not a_node_id.is_empty
		do
			default_create
			create representation.make(a_node_id, Current)
			set_node_id(a_node_id)
			set_value(a_value)
		ensure
			is_typed
			is_addressable
		end

	make_anonymous(a_value: SEQUENCE[ANY]) is
		require
			Item_valid: a_value /= Void
		do
			default_create
			create representation.make_anonymous(Current)
			set_value(a_value)
		ensure
			is_typed
			not is_addressable
		end

feature -- Access

	value: SEQUENCE[ANY]

feature -- Status Report

	is_valid: BOOLEAN is
			-- report on validity
		do
			create invalid_reason.make(0)
			invalid_reason.append(rm_type_name + ": ")
			if value = Void then
				invalid_reason.append("simple type constraint not specified")
			else
				Result := True
			end
		end

feature -- Modification

	set_value(a_value: SEQUENCE[ANY]) is
		require
			Item_valid: a_value /= Void
		local
			string_list: SEQUENCE[STRING]
			char_list:SEQUENCE[CHARACTER]
			l_str:STRING
		do
			value := a_value
			string_list ?= value
			char_list ?= value
			is_string := string_list /= Void
			is_character := char_list /= void
			rm_type_name := a_value.generating_type

			if is_string then
				from
					string_list.start
				until
					string_list.after
				loop
					l_str := string_list.item
					if l_str /= void then
						l_str.replace_substring_all ("&quot;", "%"")
					end
					string_list.forth
				end
			end
		end

feature -- Conversion

	as_string: STRING is
		local
			out_val: STRING
		do
			create Result.make(0)
			from
				value.start
			until
				value.off
			loop
				if value.index > 1 then
					Result.append(", ")
				end
				if value.item /= void then
					if is_string then
						Result.append("%"")
					elseif is_character then
						Result.append("'")
					end
					out_val := value.item.out
						-- MP fixed generating_type.name
					if value.item.generating_type.name.starts_with ("STRING") then
						out_val.replace_substring_all ("%"","&quot;")
					end
					Result.append(out_val)
					-- FIXME: REAL.out is broken; forgets to output '.0'
						-- MP fixed generating_type.name
					if value.item.generating_type.name.substring(1,4).is_equal("REAL") and then out_val.index_of('.', 1) = 0 then
						Result.append(".0")
					end
					if is_string then
						Result.append("%"")
					elseif is_character then
						Result.append("'")
					end
				else
					Result.append("void")
				end

				value.forth
			end
			if value.count = 1 then -- append syntactic indication of list continuation
				Result.append(", ...")
			end
		end

feature -- Serialisation

	enter_subtree(serialiser: DT_SERIALISER; depth: INTEGER) is
			-- perform serialisation at start of block for this node
		do
			serialiser.start_primitive_object_list(Current, depth)
		end

	exit_subtree(serialiser: DT_SERIALISER; depth: INTEGER) is
			-- perform serialisation at end of block for this node
		do
			serialiser.end_primitive_object_list(Current, depth)
		end

feature {NONE} -- Implementation

	is_string: BOOLEAN
	is_character:BOOLEAN

end


--|
--| ***** BEGIN LICENSE BLOCK *****
--| Version: MPL 1.1/GPL 2.0/LGPL 2.1
--|
--| The contents of this file are subject to the Mozilla Public License Version
--| 1.1 (the 'License'); you may not use this file except in compliance with
--| the License. You may obtain a copy of the License at
--| http://www.mozilla.org/MPL/
--|
--| Software distributed under the License is distributed on an 'AS IS' basis,
--| WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
--| for the specific language governing rights and limitations under the
--| License.
--|
--| The Original Code is dadl_object_simple_list.e.
--|
--| The Initial Developer of the Original Code is Thomas Beale.
--| Portions created by the Initial Developer are Copyright (C) 2003-2004
--| the Initial Developer. All Rights Reserved.
--|
--| Contributor(s):
--|
--| Alternatively, the contents of this file may be used under the terms of
--| either the GNU General Public License Version 2 or later (the 'GPL'), or
--| the GNU Lesser General Public License Version 2.1 or later (the 'LGPL'),
--| in which case the provisions of the GPL or the LGPL are applicable instead
--| of those above. If you wish to allow use of your version of this file only
--| under the terms of either the GPL or the LGPL, and not to allow others to
--| use your version of this file under the terms of the MPL, indicate your
--| decision by deleting the provisions above and replace them with the notice
--| and other provisions required by the GPL or the LGPL. If you do not delete
--| the provisions above, a recipient may use your version of this file under
--| the terms of any one of the MPL, the GPL or the LGPL.
--|
--| ***** END LICENSE BLOCK *****
--|
