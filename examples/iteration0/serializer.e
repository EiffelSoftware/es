indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SERIALIZER

feature -- Access
call_pending: BOOLEAN --Call started, serializer is ready for arguments.
file_open: BOOLEAN --log file open and initialized.

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations
--TODO: replace ANY by 'OBSERVABLE'.

write_incall(feature_name: STRING; target: ANY; arguments: TUPLE)
	require
		feature_name_not_void: feature_name /= Void
		target_not_void: target /= Void
		arguments_not_void:	arguments /= Void
	do
		write_line("<InCall>")
		increase_indent
		write_target(target)
		write_arguments(arguments)
		decrease_indent
		write_line("</InCall>")
	end

write_incallret(the_result: ANY)


	--finish arguments, and call
ensure
	no_call_pending: not call_pending
end

add_argument_object(arg: IDENTIFIED)
require
	call_pending: call_pending
do

end

add_argument_basic(value: STRING) --hm... how can we pass this?
require
	call_pending: call_pending
do

end


open_file(file_name: STRING)
require
	file_closed: not file_open
do

ensure
	file_open: file_open
end

close_file
require
	file_open: file_open
do

ensure
	file_closed: not file_open
end


incall_ret_object(object:IDENTIFIED)
require
	object_not_void: object /= Void
do

end

incall_ret_basic(value: STRING)
require
	value_not_void: value /= Void
do

end

outcall_ret_object(object: IDENTIFIED)
require
	object_not_void: object /= Void
do

end

outcall_ret_basic(value:STRING)
require
	value_not_void: value /= Void
do

end



feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	indent: STRING
			-- tabs in front of the next line

	increase_indent
			-- add a tab to the indent
		do
			indent:=indent+ "%T"
		ensure
			indent_increased: indent.count = old indent.count + 1
		end

	decrease_indent
			-- remove a tab from the indent
		require
			indent_not_minimal: indent.count > 0
		do
			indent:=indent.remove(0)
		ensure
			indent_decreased: indent.count = old indent.count - 1
		end

write_object(tag_name: STRING; object: IDENTIFIED)
require
	tag_name_not_Void: tag_name /= Void
	object_not_Void: object /= Void
do

end

write_basic(tag_name: STRING; value: STRING)
require
	tag_name_not_void: tag_name /= Void
	object_not_void: value /= Void
do

end

write_target(target: ANY)
		-- write the target element
	require
		target_not_void: target /= Void
	do
		write_line("<Target>")
		increase_indent
		write_object(target)
		decrease_indent
		write_line("</Target>")
	end

write_arguments(arguments: TUPLE)
		--write the arguments element
	require
		arguments_not_void: arguments /= Void
	local
		i: INTEGER
	do
		write_line("<Arguments>")
		increase_indent
		from
			i := 0
		until
			i >= arguments.count
		loop
			if
		end
		decrease_indent
		write_line("</Arguments>")
	end


write_line(content: STRING)
	require
		content_not_void: content /= Void
	do
		print(content + "%N") --just for testing	
	end


invariant
	invariant_clause: True
end
