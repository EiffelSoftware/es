note
	description: "Specialized configiration for Microsoft WindowsSDKs."
	legal: "See notice at end of class."
	status: "See notice at end of class.";
	date: "$date$";
	revision: "$revision$"

class
	WSDK_CONFIG

inherit
	MSC_REG_CONFIG
		redefine
			batch_file_arguments, batch_file_options
		end

	EIFFEL_LAYOUT

create
	make

feature -- Access

	wsdk_60: STRING = "WSDK60"
	wsdk_61: STRING = "WSDK61"
	wsdk_70: STRING = "WSDK70"
	wsdk_71: STRING = "WSDK71"
			-- Constants defining the various supported SDKs

feature {NONE} -- Access

	batch_file_name: PATH
			-- <Precursor>
		do
			if is_eiffel_layout_defined and then attached {FINISH_FREEZING_EIFFEL_LAYOUT} eiffel_layout as l_layout and then l_layout.is_valid_environment then
				if code.is_equal (wsdk_60) then
					Result := l_layout.config_eif_path.extended ("\windows_sdk_v6.0.cmd")
				elseif code.is_equal (wsdk_61) then
					Result := l_layout.config_eif_path.extended ("\windows_sdk_v6.1.cmd")
				elseif code.is_equal (wsdk_70) then
					Result := l_layout.config_eif_path.extended ("\windows_sdk_v7.0.cmd")
				elseif code.is_equal (wsdk_71) then
					Result := l_layout.config_eif_path.extended ("\windows_sdk_v7.1.cmd")
				else
						-- Default to using one found in SDK, typically happens for
						-- library consumers that are used in install application or are used
						-- with no product install base
					Result := install_path.extended ("Bin\SetEnv.cmd")
				end
			else
					-- Default to using one found in SDK, typically happens for
					-- library consumers that are used in install application or are used
					-- with no product install base
				Result := install_path.extended ("Bin\SetEnv.cmd")
			end
		end

	batch_file_arguments: STRING_32
			-- <Precursor>
		do
			create Result.make (10)

			if is_eiffel_layout_defined and then attached {FINISH_FREEZING_EIFFEL_LAYOUT} eiffel_layout as l_layout and then l_layout.is_valid_environment then
				if
					code.is_equal (wsdk_60) or
					code.is_equal (wsdk_61) or
					code.is_equal (wsdk_70) or
					code.is_equal (wsdk_71)
				then
						-- Need to do the same check as in `batch_file_name' to ensure we do
						-- not pass the install path as an argument when we are using the config library
						-- in an environment that has no install-base (like an installation program)
					Result.append_character ({CHARACTER_32} '"')
					Result.append_string (install_path.name)
					Result.append_character ({CHARACTER_32} '"')
					Result.append_character ({CHARACTER_32} ' ')
				end
			end
			Result.append ({STRING_32} "/Release ")
			if use_32bit then
				Result.append ({STRING_32} "/x86")
			else
				Result.append ({STRING_32} "/x64")
			end
		end

	batch_file_options: READABLE_STRING_32
			-- <Precursor>
		do
			Result := {STRING_32} "/V:ON"
		end

	full_product_reg_path: STRING
			-- <Precursor>
		do
			create Result.make (256)
			Result.append ("HKEY_LOCAL_MACHINE\SOFTWARE\")
			Result.append (product_reg_path)
		end

	install_path_value_name: STRING
			-- <Precursor>
		once
			Result := "InstallationFolder"
		end

;note
	copyright:	"Copyright (c) 1984-2017, Eiffel Software"
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
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
