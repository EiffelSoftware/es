note
	description: "Summary description for {CA_FIX}."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_FIX

inherit
	AST_ROUNDTRIP_ITERATOR

	CA_SHARED_NAMES

create
	make

feature {NONE} -- Implementation
	make (a_caption: STRING_32; a_class: CLASS_C)
		do
			caption := a_caption
			class_to_change := a_class
		end

feature -- Properties

	caption: STRING_32

	class_to_change: CLASS_C

end
