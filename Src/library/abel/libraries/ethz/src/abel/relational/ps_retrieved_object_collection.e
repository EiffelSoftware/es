note
	description: "Summary description for {PS_RETRIEVED_OBJECT_COLLECTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_RETRIEVED_OBJECT_COLLECTION

inherit
	PS_RETRIEVED_COLLECTION

create make

feature


	primary_key: INTEGER

	class_metadata: PS_CLASS_METADATA


feature -- Additional information


	add_information (description:STRING; value:STRING)
		do
			additional_information.extend (description, value)
		end

	get_information (description:STRING):STRING
		do
			Result:=attach (additional_information[description])
		end


feature{NONE}



	additional_information: HASH_TABLE[STRING, STRING]


	make (key:INTEGER; meta:PS_CLASS_METADATA)
		do
			primary_key:= key
			class_metadata:= meta
			create additional_information.make (10)
			create collection_items.make
		end



end
