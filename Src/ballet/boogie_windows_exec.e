indexing
	description	: "bpl verifier calling boogie in an windows environment"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date		: "$Date$"
	revision	: "$Revision$"

class
	BOOGIE_WINDOWS_EXEC

inherit
	BOOGIE_VERIFIER

inherit {NONE}

	SHARED_WORKBENCH
		export {NONE} all end

create
	make

feature {NONE} -- Initialisation

	make is
		do
			create process_factory
		end

feature	-- Verification

	verify is
			-- verifies all bpl code written to `input'
			-- verification errors are inserted into
			-- environment.error_log
		local
			launcher: BOOGIE_LAUNCHER
			ee: EXECUTION_ENVIRONMENT
			args: LINKED_LIST[STRING]
			tmp_filename: STRING
			output_file: KL_TEXT_OUTPUT_FILE;
		do
			create ee
--			tmp_filename := ee.get("TEMP") + "\output" + process_factory.current_process_info.process_id.out + ".bpl"

				-- Output name
			--"ballet_" + workbench.eiffel_universe.conf_system.name + "_" + classname + ".bpl"
			tmp_filename := "C:\Temp\output" + process_factory.current_process_info.process_id.out + ".bpl"
			bpl_code := input.string.twin

			create output_file.make (tmp_filename)
			output_file.open_write
			if not output_file.is_open_write then
				add_error (create {BPL_ERROR}.make ("cannot write to temporary file '" + tmp_filename + "'"))
			else
				output_file.put_string(input.string)
				output_file.close
				create launcher.make (Current)
				create args.make
				create ee
				args.extend(tmp_filename)
				launcher.prepare_command_line ("boogie", args, ee.current_working_directory)
				launcher.launch (True, True)
				launcher.wait_for_exit
				-- TODO: output_file.delete temporary files should be deleted
			end
		end

feature {NONE} -- implementation

	process_factory: PROCESS_FACTORY ;

indexing
	copyright:	"Copyright (c) 2006, Raphael Mack"
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

end -- class BOOGIE_WINDOWS_EXEC
