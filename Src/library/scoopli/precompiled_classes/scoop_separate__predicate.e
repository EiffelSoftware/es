note
	description: "Proxy class for {PREDICATE}."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_SEPARATE__PREDICATE[BASE_TYPE, OPEN_ARGS -> detachable TUPLE create default_create end]

inherit
	 SCOOP_SEPARATE__FUNCTION[BASE_TYPE, OPEN_ARGS, BOOLEAN]
		redefine
			implementation_,
			make
		end

create
	make


convert
	-- This conversion is a work around so that the compiler doesn't throw an
	-- error in a proxy class where a local agent is an argument
	-- It is also important for campatibility with base libraryclasses.
	implementation_: {
			PREDICATE[BASE_TYPE, OPEN_ARGS]
	}

feature -- Initialization
	make (a_processor_: like processor_; impl: PREDICATE[BASE_TYPE, OPEN_ARGS])
		do
			processor_ := a_processor_
			implementation_ := impl
		end

feature -- Separateness

	implementation_: PREDICATE[BASE_TYPE, OPEN_ARGS]
			-- reference to actual object
end
