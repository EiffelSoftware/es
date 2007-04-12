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

start_incall(feature_name: STRING; target: ANY)
require
	no_call_pending: not call_pending
do
ensure
	call_pending: call_pending
end

finish_incall()
require
	call_pending: call_pending
do
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

invariant
	invariant_clause: True -- Your invariant here

end
