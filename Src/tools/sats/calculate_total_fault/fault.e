note
	description: "Summary description for {FAULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FAULT

create
	make

feature{NONE} -- Initialization

	make (a_id: INTEGER; a_class: STRING; a_text_case: STRING; a_exception_code: INTEGER; a_tag: STRING; a_recipient_class: STRING; a_recipient_feature: STRING; a_bp_slot: INTEGER; a_messages: LIST [STRING]) is
			--
		do
			id := a_id
			classification := a_class.twin
			text_case_index := a_text_case.twin
			exception_code := a_exception_code
			tag := a_tag.twin
			recipient_class := a_recipient_class.twin
			recipient_feature := a_recipient_feature.twin
			breakpoint_slot := a_bp_slot
			messages := a_messages.twin
		end

feature -- Access

	id: INTEGER
			-- Id of current fault.

	classification: STRING

	text_case_index: STRING

	exception_code: INTEGER

	tag: STRING

	recipient_class: STRING

	recipient_feature: STRING

	breakpoint_slot: INTEGER

	messages: LIST [STRING]

feature -- Setting

	set_id (a_id: INTEGER) is
			--
		do
			id := a_id
		end


feature -- Status report

	is_original_equal (other: like Current): BOOLEAN is
			--
		do
			Result :=
				exception_code = other.exception_code and then
				breakpoint_slot = other.breakpoint_slot and then
				equal (recipient_class, other.recipient_class) and then
				equal (recipient_feature, other.recipient_feature) and then
				equal (tag, other.tag)
		end

end
