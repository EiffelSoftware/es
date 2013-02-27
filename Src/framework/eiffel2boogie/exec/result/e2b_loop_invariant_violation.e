note
	description: "TODO"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_LOOP_INVARIANT_VIOLATION

inherit
	E2B_VERIFICATION_ERROR
		redefine
			multi_line_message
		end

create
	make

feature -- Status report

	is_on_entry: BOOLEAN
			-- Is this violation on loop entry?

	is_on_iteration: BOOLEAN
			-- Is this violation on loop iterations?

feature -- Status setting

	set_on_entry
			-- Set `is_on_entry'.
		do
			is_on_entry := True
		ensure
			is_on_entry: is_on_entry
		end

	set_on_iteration
			-- Set `is_on_iteration'.
		do
			is_on_iteration := True
		ensure
			is_on_iteration: is_on_iteration
		end

feature -- Display

	single_line_message (a_formatter: TEXT_FORMATTER)
			-- <Precursor>
		do
			if is_on_entry then
				if attached tag then
					a_formatter.add ("Loop invariant ")
					a_formatter.add_manifest_string (tag)
					a_formatter.add (" might not hold on entry.")
				else
					a_formatter.add ("Loop invariant might not hold on entry (unnamed assertion).")
				end
			else
				check is_on_iteration end
				if attached tag then
					a_formatter.add ("Loop invariant ")
					a_formatter.add_manifest_string (tag)
					a_formatter.add (" might not be maintained.")
				else
					a_formatter.add ("Loop invariant might not be maintained (unnamed assertion).")
				end
			end
		end

	multi_line_message (a_formatter: TEXT_FORMATTER)
			-- <Precursor>
		do
			if is_on_entry then
				if attached tag then
					a_formatter.add ("Loop invariant ")
					a_formatter.add_manifest_string (tag)
					a_formatter.add (" might not hold on entry.")
				else
					a_formatter.add ("Loop invariant might not hold on entry (unnamed assertion).")
				end
			else
				check is_on_iteration end
				if attached tag then
					a_formatter.add ("Loop invariant ")
					a_formatter.add_manifest_string (tag)
					a_formatter.add (" might not be maintained.")
				else
					a_formatter.add ("Loop invariant might not be maintained (unnamed assertion).")
				end
			end
		end

end
