indexing
	description: "Pixmaps used in AutoTest interface"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_SHARED_PIXMAPS

feature -- Icons

	Icon_auto_test: EV_PIXMAP is
			-- menu icon for AutoTest
			-- modified copy of `EB_SHARED_PIXMAPS.load_pixmap_from_repository'
			-- returns `Void' if file is not found
		local
			full_path: FILE_NAME
			pixmap_file: RAW_FILE
			pixmap_suffix: STRING
		once
			pixmap_suffix := "png"
				-- Initialize the path and load the AutoTest menu icon
			create full_path.make_from_string ((create {EIFFEL_ENV}).bitmaps_path)
			full_path.extend (pixmap_suffix)
			full_path.extend ("icon_auto_test_16")
			full_path.add_extension (pixmap_suffix)
			create pixmap_file.make (full_path)
			if pixmap_file.exists then
				create Result
				Result.set_with_named_file (full_path)
			else
					-- if image does not exist, don't display any image
				Result := Void
			end
		end

	Icon_auto_test_window: EV_PIXMAP is
			-- icon for AutoTest windows
			-- if `icon_auto_test' is `Void' then a default icon is returned
		once
			if icon_auto_test /= Void then
				Result := icon_auto_test.twin
			else
				Result := (create {EB_SHARED_PIXMAPS}).icon_dialog_window
			end
		ensure
			Result_not_void: Result /= Void
		end


indexing
	copyright:	"Copyright (c) 2006, The AECCS Team"
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
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			The AECCS Team
			Website: https://eiffelsoftware.origo.ethz.ch/index.php/AutoTest_Integration
		]"

end -- class AT_SHARED_PIXMAPS
