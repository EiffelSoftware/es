note
	description: "[
		Objects needed to allow serialization of objects that don't inherit from {STORABLE}, 
		when using the {PS_CLASSIC_SERIALIZER}.
	]"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_STORABLE_WRAPPER

inherit

	STORABLE

create
	set_wrapped_object

feature -- Access

	wrapped_object: detachable ANY

feature -- Status setting

	set_wrapped_object (obj: detachable ANY)
			-- Set the object that will be wrapped in the Current object inheriting from STORABLE.
		do
			wrapped_object := obj
		ensure
			wrapped_object_set: wrapped_object = obj
		end

end
