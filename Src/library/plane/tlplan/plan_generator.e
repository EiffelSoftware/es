note
	description: "Summary description for {PLAN_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAN_GENERATOR

create
	make

feature
	make (a_name: STRING; a_dom: ADL_DOMAIN; a_goal: GOAL_FILE; a_dir : STRING)
		do
			name := a_name
			dom := a_dom
			goal := a_goal
			dir := a_dir
		end

	dom: ADL_DOMAIN
	name: STRING
	goal: GOAL_FILE
	dir: STRING

	generate : LIST [STRING]
		local
			p_fact: PROCESS_FACTORY
			proc : PROCESS
		do
			create p_fact
			proc := p_fact.process_launcher ( "/home/scott/local/bin/tlplan"
			                                , create {ARRAYED_LIST [STRING]}.make_from_array (<<goal_file_name>>)
			                                , dir)
--			print (proc.command_line + "%N")
			proc.redirect_error_to_agent (agent error_process)
			proc.redirect_output_to_agent (agent output_process) -- update_finished_status)
			proc.enable_terminal_control
			proc.set_buffer_size (512)
			proc.enable_launch_in_new_process_group
			proc.launch
			proc.wait_for_exit

			create {ARRAYED_LIST[STRING]}Result.make (0)
		end

	plan_found: BOOLEAN


	error_process (str: STRING)
		do
--			print ("planner error: <<")
--			print (str)
--			print (">>")
			if str.has_substring ("Elapsed CPU time") then
				plan_found := str.has_substring ("Planning completed.  Plan found.")
			end
		end

	output_process (str: STRING)
		do
--			io.put_string ("planner output: ")
--			io.put_string (str)

		end

	goal_file_name: STRING
		do
			Result := name + "Run.lisp"
		end

	goal_full_path: STRING
		do
			Result := dir + goal_file_name
		end

	write_goal
		local
			file: PLAIN_TEXT_FILE
		do
			create file.make_open_write (goal_full_path)
			file.put_string (goal.print_string)
			file.close
		end

	write_files
		local
			file : PLAIN_TEXT_FILE
		do
			create file.make_open_write (dir + name + "Domain.tlp.lisp")
			file.put_string (dom.print_string)
			file.close

			write_goal
		end

end
