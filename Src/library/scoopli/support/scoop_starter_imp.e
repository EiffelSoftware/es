indexing
	description: "Objects that initialize SCOOP applications."
	author: "Piotr Nienaltowski"
	date: "$Date$"
	revision: "$Revision$"
	build_number: "0.4.4000"

class SCOOP_STARTER_IMP

inherit
	SCOOP_SEPARATE_CLIENT
		redefine
			proxy_
		end

	ANY

	ARGUMENTS

create
	make

feature {NONE} -- Not to be used

	proxy_: SCOOP_SEPARATE__ANY
		do
			result := void
		end


feature {NONE} -- Implementation

	make is
		-- Creation procedure.
		do

-- SCOOP REPLAY
			parse_record_replay_arguments
-- SCOOP REPLAY end

			io.put_new_line
			processor_ := scoop_scheduler.new_processor_ (Void)
			create root_object.set_processor_ (scoop_scheduler.new_processor_ (processor_))
			separate_execute_routine ([root_object.processor_], agent execute (root_object), Void, Void, Void)
			scoop_scheduler.all_processors_finished.wait_one
		end

	execute (a_root_object: like root_object) is
		do
			-- Insert call to root creation procedure here.
			-- Attention: root creation procedure should be called without `create' keyword, just like a normal routine.
			-- e.g. `root_object.make'
		end

	root_object: SCOOP_SEPARATE__ANY
		-- Root object on which root creation procedure is called.
		-- Redefine `root_object' to be _of the type specified as root class in Ace file.
		-- Attention: always decorate the type with keyword `separate'.


-- SCOOP REPLAY
	parse_record_replay_arguments
			-- Parsing RECORD-REPLAY arguments and passing to scheduler.
			-- Returns FALSE if error occurred.
		local
			i: INTEGER
			is_record: BOOLEAN
			is_replay: BOOLEAN
			is_diagram: BOOLEAN
			is_verbose_info: BOOLEAN
			record_filename: STRING
			replay_filename: STRING
			diagram_filename: STRING
			open_pos: INTEGER
			close_pos: INTEGER
			tmp: STRING
			tmp_next: STRING
			res: BOOLEAN
		do
			open_pos := {INTEGER}.max_value
			close_pos := {INTEGER}.min_value
			create tmp.make_empty
			create tmp_next.make_empty
			res := True

			-- Searching for record-replay arguments bounds (-REC_REP and +REC_REP)
			from
				i := 1
			until
				i > argument_count
			loop
				tmp.copy (argument_array.item (i))
				tmp.to_upper
				if tmp.is_equal ({SCOOP_LIBRARY_CONSTANTS}.REPLAY_command_line_argument_beginning) then
					open_pos := i
				end
				if tmp.is_equal ({SCOOP_LIBRARY_CONSTANTS}.REPLAY_command_line_argument_end) then
					close_pos := i
				end
				i := i + 1
			end
			-- Main searching loop
			if open_pos < close_pos + 1 then
				from
					i := open_pos + 1
				until
					i = close_pos or res = False
				loop
					tmp.copy (argument_array.item (i))
					tmp.to_upper
					-- Searching for record parameters
					if tmp.is_equal ({SCOOP_LIBRARY_CONSTANTS}.REPLAY_command_line_argument_record) then
						is_record := True
						if i + 1 < close_pos then
							tmp_next.copy (argument_array.item (i + 1))
							tmp_next.to_upper
							if not tmp_next.is_equal ({SCOOP_LIBRARY_CONSTANTS}.REPLAY_command_line_argument_replay) and
								not tmp_next.is_equal ({SCOOP_LIBRARY_CONSTANTS}.REPLAY_command_line_argument_diagram) and
								not tmp_next.is_equal ({SCOOP_LIBRARY_CONSTANTS}.REPLAY_command_line_argument_verbose_info) then
								create record_filename.make_empty
								record_filename.copy (argument_array.item (i + 1))
							end
						end
					end
					-- Searching for replay parameters
					if tmp.is_equal ({SCOOP_LIBRARY_CONSTANTS}.REPLAY_command_line_argument_replay) then
						is_replay := True
						if i + 1 < close_pos then
							create replay_filename.make_empty
							replay_filename.copy (argument_array.item (i + 1))
						else
							res := False
						end
					end
					-- Searching for diagram parameters
					if tmp.is_equal ({SCOOP_LIBRARY_CONSTANTS}.REPLAY_command_line_argument_diagram) then
						is_diagram := True
						if i + 1 < close_pos then
							tmp_next.copy (argument_array.item (i + 1))
							tmp_next.to_upper
							if not tmp_next.is_equal ({SCOOP_LIBRARY_CONSTANTS}.REPLAY_command_line_argument_record)  and
								not tmp_next.is_equal ({SCOOP_LIBRARY_CONSTANTS}.REPLAY_command_line_argument_replay) and
								not tmp_next.is_equal ({SCOOP_LIBRARY_CONSTANTS}.REPLAY_command_line_argument_verbose_info) then
								create diagram_filename.make_empty
								diagram_filename.copy (argument_array.item (i + 1))
							end
						end
					end

					if tmp.is_equal ({SCOOP_LIBRARY_CONSTANTS}.REPLAY_command_line_argument_verbose_info) then
						is_verbose_info := True
					end

					i := i + 1
				end
				if res then
					-- Pass parameters if they exist and have right format
					scoop_scheduler.set_record_replay_options (is_record, record_filename, is_replay, replay_filename, is_diagram, diagram_filename, is_verbose_info)
				else
					io.putstring ("%NERROR! Wrong set of REPLAY parameters.%NModify command line arguments to use SCOOP REPLAY tool.%N")
				end
			end
		end
-- SCOOP REPLAY end


end
