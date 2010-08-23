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
			associated_class := system.class_of_id (a_class_id).original_class
		ensure
			class_id_set: class_id = a_class_id
		end

	make_with_class (a_class: attached like associated_class)
			-- Initialize associated to `a_class'.
		do
			associated_class := a_class
		ensure
			class_id_set: associated_class = a_class
		end

feature -- Access

	associated_class: attached CLASS_I
			-- Class associated with this data.

	class_name: attached STRING
			-- Class name of class associated with this data.
		do
			Result := associated_class.name
		end

	class_id: INTEGER
			-- Class ID of class associated with this data.
		require
			compiled: is_compiled
		do
			if internal_class_id = 0 and associated_class.is_compiled then
				internal_class_id := associated_class.compiled_class.class_id
			end
			Result := internal_class_id
		end

	compiled_class: attached CLASS_C
			-- Compiled class associated with this data.
		require
			compiled: is_compiled
		do
			Result := associated_class.compiled_class
		end

feature -- Status report

	is_compiled: BOOLEAN
			-- Is class associated with this data compiled?
		do
			Result := associated_class.is_compiled
		end

feature {NONE} -- Implementation

	internal_class_id: INTEGER
			-- Class id of associated class (if any).

invariant
	class_id_set: is_compiled implies class_id /= 0
	compiled_class_consistent: is_compiled implies compiled_class.class_id = class_id

end
