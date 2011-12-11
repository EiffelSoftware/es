note
	description: "Summary description for {EPA_COLLECTED_RUNTIME_DATA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_COLLECTED_RUNTIME_DATA

create
	make

feature -- Creation procedure

	make (a_class: like class_; a_feature: like feature_; a_order: like order; a_data: like data)
			--
		do
			class_ := a_class
			feature_ := a_feature
			order := a_order
			data := a_data
		end

feature -- Access

	class_: CLASS_C
			--

	feature_: FEATURE_I
			--

	order: LINKED_LIST [TUPLE [INTEGER, INTEGER]]
			--

	data: DS_HASH_TABLE [LINKED_LIST [TUPLE [EPA_POSITIONED_VALUE, EPA_POSITIONED_VALUE]], STRING]
			--

end
