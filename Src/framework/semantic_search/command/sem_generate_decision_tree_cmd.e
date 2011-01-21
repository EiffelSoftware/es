note
	description: "Class to generate decision trees from ARFF files using RapidMiner"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_GENERATE_DECISION_TREE_CMD

inherit
	SHARED_WORKBENCH

	EPA_UTILITY

	EPA_FILE_UTILITY

	SHARED_EIFFEL_PROJECT

	KL_SHARED_FILE_SYSTEM

	RM_VISUALIZATION_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_config: like config)
			-- Initialize Current.
		do
			config := a_config
		end

feature -- Access

	config: SEM_CONFIG
			-- Configuration for semantic search

feature -- Basic operations

	execute
			-- Execute current command			
		local
			l_input: PLAIN_TEXT_FILE
			l_searcher: EPA_FILE_SEARCHER
			l_arffs: LINKED_LIST [TUPLE [path: STRING; file: STRING]]
			l_basename: STRING
			l_output_path: FILE_NAME
			l_dot_path: FILE_NAME

		do
			create l_input.make (config.input)
			if l_input.exists and then not l_input.is_directory then
				generate_decision_tree (config.rapidminer_process_path, config.input, config.output, config.dot_path)
			else
					-- Assume `config'.`output' and `config'.`dot_path' are directories as well.
					-- Search for all ARFF files.
				create l_arffs.make
				create l_searcher.make_with_pattern (".*\.arff$")
				l_searcher.set_is_search_recursive (True)
				l_searcher.file_found_actions.extend (
					agent (a_dir, a_file: STRING; a_results: LINKED_LIST [TUPLE [STRING, STRING]])
						do
							a_results.extend ([a_dir, a_file])
						end (?, ?, l_arffs))

				l_searcher.search (config.input)
				across l_arffs as l_files loop
						-- We always ignore ARFFs which do not report faults.
					if not l_files.item.file.has_substring (once "noname") then
						l_basename := file_system.basename (l_files.item.path).twin
						l_basename.remove_tail (5)

						create l_output_path.make_from_string (config.output)
						l_output_path.set_file_name (l_basename + ".tree")

						if config.dot_path /= Void then
							create l_dot_path.make_from_string (config.dot_path)
							l_dot_path.set_file_name (l_basename + ".dot")
						else
							l_dot_path := Void
						end
						generate_decision_tree (config.rapidminer_process_path, l_files.item.path, l_output_path, l_dot_path)
					end
				end
			end
		end

feature{NONE} -- Implementation

	generate_decision_tree (a_process_file: STRING; a_input_file: STRING; a_output_file: STRING; a_dot_file: detachable STRING)
			-- Generate decision tree from `a_process_file' from ARFF file specified in `a_input_file',
			-- and store result into `a_output_file'.
			-- If `a_dot_file' is attached, generate Dot representation of the decision tree and store
			-- it in that location.
		local
			l_runner: RM_PROCESS_RUNNER
			l_tree_loader: RM_DECISION_TREE_PARSER
			l_graph: like graph_of_decision_tree
			l_file: PLAIN_TEXT_FILE
			l_graph_printer: EGX_SIMPLE_DOT_GRAPH_PRINTER [STRING, STRING]
			l_retried: BOOLEAN
		do
			if not l_retried then
				create l_runner.make (config.rapidminer_home)
				l_runner.set_process_file_path (a_process_file)
				l_runner.parameters.force (a_input_file, "${INPUT}")
				l_runner.parameters.force (a_output_file, "${OUTPUT}")
				l_runner.set_maximal_memory (1024)
				l_runner.run

				if a_dot_file /= Void then
					create l_tree_loader.make (a_output_file)
					l_tree_loader.parse
					l_graph := graph_of_decision_tree (l_tree_loader.last_node_as_tree ("fault_signature"))
					create l_graph_printer.make_default
					l_graph_printer.print_graph (l_graph)
					create l_file.make_create_read_write (a_dot_file)
					l_file.put_string (l_graph_printer.last_printing)
					l_file.close
				end
			end
		rescue
			l_retried := True
			retry
		end

end
