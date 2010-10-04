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
	make (a_name: STRING; a_dom: ADL_DOMAIN; a_prob: PDDL_PROBLEM; a_dir : STRING)
		do
			name := a_name
			dom := a_dom
			prob := a_prob
			dir := a_dir
			create plan.make (a_name)
		end

	dom : ADL_DOMAIN
	name : STRING
	prob : PDDL_PROBLEM
	plan : GOAL_FILE
	dir : STRING

	generate : LIST [STRING]
		local
			p_fact: PROCESS_FACTORY
			proc : PROCESS
		do
			create p_fact
			proc := p_fact.process_launcher ( "/home/scott/local/bin/tlplan"
			                                , create {ARRAYED_LIST [STRING]}.make_from_array (<<name + "Run.lisp">>)
			                                , dir)
			print (proc.command_line + "%N")
			proc.redirect_error_to_agent (agent io.put_string)
			proc.redirect_output_to_agent (agent io.put_string)
			proc.enable_terminal_control
			proc.set_buffer_size (512)
			proc.enable_launch_in_new_process_group
			proc.launch
			proc.wait_for_exit

			create {ARRAYED_LIST[STRING]}Result.make (0)
		end

	write_files
		local
			file : PLAIN_TEXT_FILE
		do
			create file.make_open_write (dir + name + "Domain.tlp.lisp")
			file.put_string (dom.print_string)
			file.close

			create file.make_open_write (dir + name + "Problem.tlp.lisp")
			file.put_string (prob.print_string)
			file.close

			create file.make_open_write (dir + name + "Run.lisp")
			file.put_string (plan.print_string)
			file.close
		end

end
