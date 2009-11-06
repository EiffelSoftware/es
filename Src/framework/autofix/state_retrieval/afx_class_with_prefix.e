note
	description: "Summary description for {AFX_CLASS_WITH_PREFIX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_CLASS_WITH_PREFIX

inherit
	HASHABLE
		redefine
			is_equal,
			hash_code
		end

	AFX_UTILITY
		undefine
			is_equal
		end

create
	make,
	make_with_class_name

feature{NONE} -- Initialization

	make (a_class: like class_; a_prefix: like prefix_)
			-- Initialize Current.
		local
			l_hash: STRING
		do
			class_ := a_class
			prefix_ := a_prefix.twin

				-- Generate hash code
			create l_hash.make (32)
			l_hash.append (class_.name)
			l_hash.append_character ('.')
			l_hash.append (a_prefix)
			hash_code := l_hash.hash_code
		end

	make_with_class_name (a_class_name: STRING; a_prefix: like prefix_)
			-- Initialize Current.
		local
			l_class: CLASS_C
		do
			l_class := first_class_starts_with_name (a_class_name)
			check l_class /= Void end
			make (l_class, a_prefix)
		end

feature -- Access

	class_: CLASS_C
			-- Class

	prefix_: STRING
			-- Prefix

feature -- Equality

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result :=
				class_.class_id = other.class_.class_id and then
				prefix_ ~ other.prefix_
		end

feature -- Access

	hash_code: INTEGER
			-- Hash code value

end
