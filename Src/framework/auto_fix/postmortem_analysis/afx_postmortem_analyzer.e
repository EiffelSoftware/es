note
	description: "Summary description for {AFX_POSTMORTEM_ANALYZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_POSTMORTEM_ANALYZER

inherit
	AFX_SHARED_SESSION

create
	make

feature{NONE} -- Initialization

	make (a_source: STRING)
			-- Initialization.
		require
			source_attached: a_source /= Void
		do
			data_source := a_source
		end

feature -- Access

	data_source: STRING
			-- Full path to the source of data for postmortem analysis.

	report: DS_HASH_TABLE[DS_LINKED_LIST[AFX_POSTMORTEM_ANALYSIS_RECORD], STRING]
			-- Records organized in categories.
			-- Key: explicitly specified category ID, or "default".
			-- Val: list of records, one for each fix.

feature -- Basic operation

	analyze
			-- Analyze the fixes from `data_source', and generate `report'.
		require
			source_attached: data_source /= Void
		local
		do
			create report.make_equal(10)
			collect_data_source_files
			analyze_data_source_files
			save_report
		end

feature -- Const

	default_category_id: STRING = "default"
			-- ID for the default result category.

	data_file_extension: STRING = "proper"
			-- File name extension for data files.

feature{NONE} -- Implementation

	data_source_files: DS_HASH_TABLE[DS_LINKED_LIST[FILE_NAME], STRING]
			-- Files of data sources organized in categories.
			-- Key: category id.
			-- Val: list of file names.

	report_file_name: STRING = "report.data"
			-- Default file name for the save report.

	collect_data_source_files
			-- Collect, recursively, data source files from `data_source' into `data_source_files'.
			-- Make `data_source_files' empty if `data_source' is not a valid path.
		require
			source_attached: data_source /= Void
		local
			l_source_path: FILE_NAME
			l_potentials: DS_LINKED_LIST[TUPLE[id: STRING; path: FILE_NAME]]
			l_potential_source: TUPLE[id: STRING; path: FILE_NAME]
			l_current_id, l_next_level_id: STRING
			l_current_path, l_next_level_path: FILE_NAME
			l_file_list: DS_LINKED_LIST[FILE_NAME]

			l_source, l_entry_source: RAW_FILE
			l_source_dir:  DIRECTORY
			l_entry_name: STRING_8
		do
			create data_source_files.make_equal (10)

			create l_source_path.make_from_string (data_source)
			if l_source_path.is_valid then
				create l_potentials.make
				l_potentials.force_last ([default_category_id, l_source_path])
				from
				until
					l_potentials.is_empty
				loop
					l_potentials.start
					l_potential_source := l_potentials.item_for_iteration
					l_current_id := l_potential_source.id
					l_current_path := l_potential_source.path

					create l_source.make(l_current_path)
					if l_source.exists then
						if l_source.is_directory then
							create l_source_dir.make (l_current_path)
							l_source_dir.open_read
							if not l_source_dir.is_closed then
								from
									l_source_dir.start
									l_source_dir.readentry
								until
									l_source_dir.lastentry = Void
								loop
									l_entry_name := l_source_dir.lastentry

									if l_entry_name /~ once "." and then l_entry_name /~ once ".." then
										create l_next_level_path.make_from_string (l_current_path)
										l_next_level_path.set_file_name (l_entry_name)
										create l_entry_source.make (l_next_level_path)
										check l_entry_source.exists end
										if l_entry_source.is_directory and then l_current_id ~ default_category_id then
											l_next_level_id := l_entry_name
										else
											l_next_level_id := l_current_id
										end
										l_potentials.force_last ([l_next_level_id, l_next_level_path])
									end

									l_source_dir.readentry
								end
							end
						elseif l_current_path.out.ends_with ("." + data_file_extension) then
								-- Add file at `l_current_path' to `data_source_files' under category `l_current_id'.
							if data_source_files.has (l_current_id) then
								data_source_files.item (l_current_id).force_last (l_current_path)
							else
								create l_file_list.make
								l_file_list.force_last (l_current_path)
								data_source_files.force (l_file_list, l_current_id)
							end
						end
					end

					l_potentials.remove_first
				end

			end

		end

	analyze_data_source_files
			-- Analyze the data source files in `data_source_files', and save results in `report'.
		require
			data_source_files_attached: data_source_files /= Void
		local
			l_category_id: STRING
			l_files: DS_LINKED_LIST[FILE_NAME]
			l_records: DS_LINKED_LIST[AFX_POSTMORTEM_ANALYSIS_RECORD]
		do
			create report.make_equal (data_source_files.count + 1)
			from data_source_files.start
			until data_source_files.after
			loop
				l_category_id := data_source_files.key_for_iteration
				l_files := data_source_files.item_for_iteration

				if l_files.count > 0 then
					create l_records.make
					report.force (l_records, l_category_id)
					l_files.do_all (
							agent (a_file: FILE_NAME; a_records: DS_LINKED_LIST[AFX_POSTMORTEM_ANALYSIS_RECORD])
								local
									l_file_analyzer: AFX_POSTMORTEM_REPORT_ANALYZER
									l_record: AFX_POSTMORTEM_ANALYSIS_RECORD
								do
									create l_file_analyzer.make (a_file, config)
									l_file_analyzer.analyze_report
									a_records.append_last (l_file_analyzer.result_records)
								end
							(?, l_records)
						)
				end

				data_source_files.forth
			end
		end

	save_report
			-- Save all the records in `report' into `config.postmortem_analysis_output_dir' with the name 'report_file_name'.
		require
		local
			l_file_name: FILE_NAME
			l_file: PLAIN_TEXT_FILE
			l_category: STRING
			l_records: DS_LINKED_LIST[AFX_POSTMORTEM_ANALYSIS_RECORD]
			l_record: AFX_POSTMORTEM_ANALYSIS_RECORD
		do
			if config.postmortem_analysis_output_dir /= Void then
				create l_file_name.make_from_string (config.postmortem_analysis_output_dir)
				l_file_name.set_file_name (report_file_name)
				create l_file.make (l_file_name)
				l_file.open_write
				if l_file.is_open_write then
					if not report.is_empty then
						l_file.put_string ("category, " + report.first.first.csv_header + "%N")
						from report.start
						until report.after
						loop
							l_category := report.key_for_iteration
							l_records := report.item_for_iteration

							from l_records.start
							until l_records.after
							loop
								l_file.put_string (l_category + ", " + l_records.item_for_iteration.csv_out + "%N")
								l_records.forth
							end

							report.forth
						end
					end
					l_file.close
				end
			end
		end


end
