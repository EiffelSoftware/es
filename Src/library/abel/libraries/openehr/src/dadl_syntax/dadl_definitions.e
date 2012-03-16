note
	component:   "openEHR Archetype Project"
	description: "Definitions for DADL language."
	keywords:    "test, DADL"
	author:      "Thomas Beale"
	support:     "ETHZ Abel project <http://abel.origo.ethz.ch/issues>"
	copyright:   "Copyright (c) 2011 Ocean Informatics Pty Ltd <http://www.oceaninformatics.com>"
	license:     "See notice at bottom of class"

	file:        "$URL: https://svn.origo.ethz.ch/abel/trunk/libraries/openehr/src/dadl_syntax/dadl_definitions.e $"
	revision:    "$LastChangedRevision$"
	last_change: "$LastChangedDate$"

class DADL_DEFINITIONS

feature -- Definitions

	Eiffel_generic_type_left_delimiter: CHARACTER = '['
	Eiffel_generic_type_right_delimiter: CHARACTER = ']'

	Uml_generic_type_left_delimiter: CHARACTER = '<'
	Uml_generic_type_right_delimiter: CHARACTER = '>'

	Eiffel_signed_integer_8_type_name: STRING = "INTEGER_8"
	Eiffel_signed_integer_16_type_name: STRING = "INTEGER_16"
	Eiffel_signed_integer_32_type_name: STRING = "INTEGER_32"
	Eiffel_signed_integer_64_type_name: STRING = "INTEGER_64"

	Eiffel_unsigned_integer_8_type_name: STRING = "NATURAL_8"
	Eiffel_unsigned_integer_16_type_name: STRING = "NATURAL_16"
	Eiffel_unsigned_integer_32_type_name: STRING = "NATURAL_32"
	Eiffel_unsigned_integer_64_type_name: STRING = "NATURAL_64"

	Eiffel_float_32_type_name: STRING = "REAL_32"
	Eiffel_float_64_type_name: STRING = "REAL_64"
	Eiffel_real_type_name: STRING = "REAL"
	Eiffel_double_type_name: STRING = "DOUBLE"

feature -- Conversion

	eiffel_to_uml_typename (a_type_name: attached STRING): STRING
			-- convert generic typenames with Eiffel '[]' to using industry standard '<>'
		local
			i: INTEGER
		do
			Result := a_type_name.twin
			from i := 1 until i > a_type_name.count loop
				if a_type_name[i] = Eiffel_generic_type_left_delimiter then
					Result[i] := Uml_generic_type_left_delimiter
				elseif a_type_name[i] = Eiffel_generic_type_right_delimiter then
					Result[i] := Uml_generic_type_right_delimiter
				end
				i := i + 1
			end
		end

	uml_to_eiffel_typename (a_type_name: attached STRING): STRING
			-- convert generic typenames with industry standard '<>' to Eiffel form using '[]'
		local
			i: INTEGER
		do
			Result := a_type_name.twin
			from i := 1 until i > a_type_name.count loop
				if a_type_name[i] = Uml_generic_type_left_delimiter then
					Result[i] := Eiffel_generic_type_left_delimiter
				elseif a_type_name[i] = Uml_generic_type_right_delimiter then
					Result[i] := Eiffel_generic_type_right_delimiter
				end
				i := i + 1
			end
		end

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
--| The Original Code is dadl_definitions.e.
--|
--| The Initial Developer of the Original Code is Thomas Beale.
--| Portions created by the Initial Developer are Copyright (c) 2011
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
