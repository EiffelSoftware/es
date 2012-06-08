note
	description: "Summary description for {PS_RETRIEVED_COLLECTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_RETRIEVED_COLLECTION

inherit PS_EIFFELSTORE_EXPORT


feature

	collection_items: LINKED_LIST[PS_PAIR[STRING, STRING]]


	add_item (value, class_of_value: STRING)
		do
			collection_items.extend (create {PS_PAIR[STRING, STRING]}.make (value, class_of_value))
		end

end
