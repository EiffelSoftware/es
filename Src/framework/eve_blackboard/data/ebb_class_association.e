note
	description: "Item associated to a class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EBB_CLASS_ASSOCIATION

inherit

	SHARED_WORKBENCH

feature {NONE} -- Initialization

	make_with_class_id (a_class_id: like class_id)
			-- Initialize associated to `a_class_id'.
		require
			class_exists: system.class_of_id (a_class_id) /= Void
		do
			class_id := a_class_id
		ensure
			class_id_set: class_id = a_class_id
		end

	make_with_class (a_class: attached like associated_class)
			-- Initialize associated to `a_class'.
		do
			make_with_class_id (a_class.class_id)
		ensure
			class_id_set: class_id = a_class.class_id
		end

feature -- Access

	class_id: INTEGER
			-- Class ID of class associated with this data.

	class_name: attached STRING
			-- Class name of class associated with this data.
		do
			Result := associated_class.name_in_upper
		end

	associated_class: attached CLASS_C
			-- Class associated with this data.
		do
			Result := system.class_of_id (class_id)
		end

invariant
	class_id_set: class_id /= 0
	associated_class_consistent: associated_class.class_id = class_id

end
