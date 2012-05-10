note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_BASIC_TYPE

inherit

	IV_TYPE

create
	make_boolean,
	make_integer,
	make_real,
	make_reference,
	make_type,
	make_heap

feature {NONE} -- Initialization

	make_boolean
			-- Make this a boolean type.
		do
			is_boolean := True
		ensure
			is_boolean: is_boolean
		end

	make_integer
			-- Make this an integer type.
		do
			is_integer := True
		ensure
			is_integer: is_integer
		end

	make_real
			-- Make this a real type.
		do
			is_real := True
		ensure
			is_real: is_real
		end

	make_reference
			-- Make this a reference type.
		do
			is_reference := True
		ensure
			is_reference: is_reference
		end

	make_type
			-- Make this a type type.
		do
			is_type := True
		ensure
			is_type: is_type
		end

	make_heap
			-- Make this a heap type.
		do
			is_heap := True
		ensure
			is_heap: is_heap
		end

feature -- Visitor

	process (a_visitor: IV_TYPE_VISITOR)
			-- <Precursor>
		do
			if is_boolean then
				a_visitor.process_boolean_type (Current)
			elseif is_integer then
				a_visitor.process_integer_type (Current)
			elseif is_reference then
				a_visitor.process_reference_type (Current)
			elseif is_type then
				a_visitor.process_type_type (Current)
			elseif is_heap then
				a_visitor.process_heap_type (Current)
			else
				check False end
			end
		end

invariant
	exclusive_type: is_boolean xor is_integer xor is_real xor is_reference xor is_type

end
