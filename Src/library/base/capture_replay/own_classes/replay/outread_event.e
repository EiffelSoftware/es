indexing
	description: "Objects that represent an outread event"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	OUTREAD_EVENT

inherit
	EVENT

create
	make

feature -- Initialization

	make (a_target: NON_BASIC_ENTITY; an_attribute_name: STRING; a_value: ENTITY) is
			-- Create a new OUTREAD_EVENT.
		require
			target_not_void: target /= Void
			attribute_name_not_void: attribute_name /= Void
			value_not_void: value /= Void
		do
			target := a_target
			attribute_name := an_attribute_name
			value := a_value
		ensure
			target_set: target = a_target
			attribute_set: attribute_name = an_attribute_name
			value_set: value = a_value
		end


feature -- Access

	target: NON_BASIC_ENTITY

	attribute_name: STRING

	value: ENTITY

invariant
	target_not_void: target /= Void
	attribute_name_not_void: attribute_name /= Void
	value_not_void: value /= Void

end
