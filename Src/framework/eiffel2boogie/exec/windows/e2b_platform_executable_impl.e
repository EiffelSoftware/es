note
	description: "Boogie executable for Windows."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_PLATFORM_EXECUTABLE_IMPL

inherit

	E2B_PLATFORM_EXECUTABLE
		redefine
			default_create
		end

feature {NONE} -- Implementation

	default_create
			-- Initialize Windows executable.
		do
			boogie_file_name := default_boogie_code_file_name
			create input.make
		end

feature {NONE} -- Implementation

	boogie_file_name: attached STRING
			-- File name used to generate Boogie file.

	boogie_executable: attached STRING
			-- Executable name to launch Boogie (including path if necessary).
		local
			l_ee: EXECUTION_ENVIRONMENT
--			l_registry: WEL_REGISTRY
--			l_registry_value: WEL_REGISTRY_KEY_VALUE
			l_possible_paths: LINKED_LIST [STRING]
			l_ise_eiffel, l_eiffel_src: STRING
			l_file: RAW_FILE
		once
			create Result.make_empty
			create l_possible_paths.make
			create l_ee

				-- 1. Delivery of installation
			l_ise_eiffel := l_ee.get ("ISE_EIFFEL")
			if l_ise_eiffel /= Void then
				l_possible_paths.extend (l_ise_eiffel + "studio/tools/boogie/bin/Boogie.exe")
			end

				-- 2. Delivery of development version
			l_eiffel_src := l_ee.get ("EIFFEL_SRC")
			if l_eiffel_src /= Void then
				l_possible_paths.extend (l_eiffel_src + "/Delivery/studio/tools/boogie/bin/Boogie.exe")
				l_possible_paths.extend (l_eiffel_src + "/../Delivery/studio/tools/boogie/bin/Boogie.exe")
			end

				-- 3. Registry entry of Spec# installation
--			create l_registry
--			l_registry_value := l_registry.open_key_value ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SpecSharp", "InstallDir")
--			if l_registry_value /= Void then
--				l_possible_paths.extend (l_registry_value.string_value + "Boogie.exe")
--			end

			from
				l_possible_paths.start
			until
				l_possible_paths.after or else not Result.is_empty
			loop
				create l_file.make (l_possible_paths.item)
				if l_file.exists then
					Result := l_possible_paths.item
				end
				l_possible_paths.forth
			end

			if Result.is_empty then
					-- 4. Assume it's in the PATH
				Result := "Boogie.exe"
			end
		end

	default_boogie_code_file_name: STRING
			-- File name for Boogie code file
		local
			l_output_path: FILE_NAME
			l_random: RANDOM
		do
			create l_random.set_seed ((create {TIME}.make_now).compact_time)
			Result := "C:\Temp\output" + (l_random.item \\ 100).out + ".bpl"
		end

end
