note
	description: "Summary description for {FAULT_LOADER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FAULT_LOADER

create
	make

feature{NONE} -- Initialization

	make (a_file_path: STRING) is
			-- Load faults from `a_file_path', store result in `faults'.
		local
			l_file: PLAIN_TEXT_FILE
			l_fault_signature: STRING
			l_messages: LINKED_LIST [STRING]
			l_line: STRING
		do
			create {LINKED_LIST [FAULT]} faults.make
			create l_messages.make
			create l_file.make_open_read (a_file_path)
			from
				l_file.read_line
			until
				l_file.after
			loop
				l_line := l_file.last_string.twin
				if l_line.is_empty or else l_line.item (1) = '-' then
						-- Empty line or comment line, it must belong to some fault.
					l_messages.extend (l_line)
				else
						-- Fault signature line.
					if l_fault_signature /= Void then
						analyze_fault (l_fault_signature, l_messages)
					end
					l_messages.wipe_out
					l_fault_signature := l_line.twin
				end
				l_file.read_line
			end
			l_file.close
			analyze_fault (l_fault_signature, l_messages)
		end

	analyze_fault (a_fault_signature: STRING; a_messages: LIST [STRING]) is
			--
		local
			l_sections: LIST [STRING]
			l_local_id: INTEGER
			l_classification: STRING
			l_text_case_index: STRING
			l_sec: LIST [STRING]
			l_exception_code: INTEGER
			l_tag: STRING
			l_recipient: STRING
			l_recipient_class: STRING
			l_recipient_feature: STRING
			l_bp_slot: INTEGER
			l_fault: FAULT
		do
			io.put_string (a_fault_signature + "%N")
			l_sections := a_fault_signature.split ('%T')
			l_local_id := l_sections.i_th (1).to_integer
			l_classification := l_sections.i_th (2)
			l_text_case_index := l_sections.i_th (3)
			l_sec := l_sections.i_th (4).split ('=')
			l_exception_code := l_sec.i_th (2).to_integer
			l_sec := l_sections.i_th (5).split ('=')
			l_tag := l_sec.i_th (2)
			l_sec := l_sections.i_th (6).split ('=')
			l_recipient := l_sec.i_th (2)
			l_sec := l_recipient.split ('.')
			l_recipient_class := l_sec.i_th (1)
			l_recipient_feature := l_sec.i_th (2)
			l_sec := l_sections.i_th (7).split ('=')
			l_bp_slot := l_sec.i_th (2).to_integer

			create l_fault.make (l_local_id, l_classification, l_text_case_index, l_exception_code, l_tag, l_recipient_class, l_recipient_feature, l_bp_slot, a_messages)
			faults.extend (l_fault)
		end

feature -- Access

	faults: LIST [FAULT]
			-- faults that have been loaded.

end
