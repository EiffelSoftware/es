indexing
	description	: "Command to statically verify a class (or feature) with ballet"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date		: "$Date$"
	revision	: "$Revision: 67291 $"

class
	EB_VERIFY_COMMAND

inherit
	EB_STANDARD_CMD
		redefine
			make
		end

	EV_SHARED_APPLICATION
	EB_SHARED_PIXMAPS


	-- EB_SHARED_GRAPHICAL_COMMANDS
	-- SHARED_WORKBENCH
	-- SHARED_BPL_ENVIRONMENT
	-- SHARED_ERROR_HANDLER
	-- COMPILER_EXPORTER

create
	make

feature -- Initialization

	make
			-- Inititialize `Current'.
		do
			Precursor{EB_STANDARD_CMD}
			name := "Verify_command"
			pixmap := pixmaps.icon_pixmaps.general_tick_icon
			pixel_buffer := pixmaps.icon_pixmaps.general_tick_icon_buffer
			menu_name := "Verify Class"
			tooltext := "Verify Class"
			tooltip := "Verify current class"
			execute_agents.extend (agent start_verification)
		end

feature -- Verification

	start_verification is
			-- Start verification run.
		local
			class_stone: CLASSI_STONE
			eiffel_class: EIFFEL_CLASS_I
		do
			print ("Hello World%N")
			class_stone ?= window_manager.last_focused_development_window.stone
			if class_stone /= Void then
				eiffel_class ?= class_stone.class_i
				if eiffel_class /= Void then
					print (eiffel_class.name)
				end
			end
		end


indexing
	copyright:	"Copyright (c) 2006-2007, Raphael Mack and Bernd Schoeller"
	license:	"GPL version 2 or later"
	copying: "[
             This program is free software; you can redistribute it and/or
             modify it under the terms of the GNU General Public License as
             published by the Free Software Foundation; either version 2 of
             the License, or (at your option) any later version.
             
             This program is distributed in the hope that it will be useful,
             but WITHOUT ANY WARRANTY; without even the implied warranty of
             MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
             GNU General Public License for more details.
             
             You should have received a copy of the GNU General Public
             License along with this program; if not, write to the Free Software
             Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
             MA 02110-1301  USA
             ]"

end -- class EB_VERIFY_COMMAND

