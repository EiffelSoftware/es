indexing
	description:
		"[
			List of types which are already generated and which still need to be generated.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_TYPE_LIST

create
	make

feature {NONE} -- Implementation

	make
			-- Initialize object with emtpy lists.
		do
			create {LINKED_LIST [TYPE_A]} types_needed.make
			create {LINKED_LIST [TYPE_A]} types_generated.make
		end

feature -- Access

	types_needed: !LIST [TYPE_A]
			-- List of types which still need to be generated

	types_generated: !LIST [TYPE_A]
			-- List of types which have already been generated

feature -- Element change

	record_type_needed (a_type: TYPE_A)
			-- Record that `a_type' is needed.
		local
			l_routine_id: INTEGER
			l_type: TYPE_A
		do
			l_type := a_type.deep_actual_type.as_attachment_mark_free
			if
				not l_type.is_like and then
				not l_type.is_expanded and then
				not l_type.is_formal and then
				not types_generated.there_exists (agent is_same_type (?, l_type)) and then
				not types_needed.there_exists (agent is_same_type (?, l_type))
			then
				types_needed.extend (l_type)
			end
		end

feature -- Basic operations

	mark_type_as_generated (a_type: TYPE_A)
			-- Mark that `a_type' has been generated.
		do
			from
				types_needed.start
			until
				types_needed.off
			loop
				if is_same_type (a_type, types_needed.item_for_iteration) then
					types_needed.remove
				end
				if not types_needed.off then
					types_needed.forth
				end
			end
			types_generated.extend (a_type)
		ensure
			a_type_not_needed: not types_needed.has (a_type)
			a_type_generated: types_generated.has (a_type)
		end

	reset
			-- Reset the lists.
		do
			types_needed.wipe_out
			types_generated.wipe_out
		end

feature {NONE} -- Implementation

	is_same_type (a_type: TYPE_A; a_other_type: TYPE_A): BOOLEAN
			-- Is `a_type' and `a_other_type' same type?
		do
				-- TODO: do we have a real context class?
			Result := a_type.same_as (a_other_type)
--			Result := a_type.is_conformant_to (a_other_type.associated_class, a_other_type) and then a_other_type.is_conformant_to (a_other_type.associated_class, a_type)
		end

end
