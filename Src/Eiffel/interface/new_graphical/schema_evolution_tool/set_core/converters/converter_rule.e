note
	description: "Objects that contains one rule for conversion"
	author: "Matthias Loeu, Marco Piccioni"
	date: "09.04.09"

deferred class
	CONVERTER_RULE

inherit
	ANY
		redefine
			out
		end

feature {NONE} -- Initialization
	make (n: STRING)
			-- Initialize `Current'.
		require
			n /= Void
			n.count > 0
		do
			create name.make_from_string (n)
			create comments.make

			old_type := ""
			new_type := ""
			old_object := "a"
			new_object := "Current"
			num_tabs := 3
			assignment_type := 0

			create message
		end

feature -- Access
	out: STRING
			-- the whole rule with comments...
		do
			Result := ""
			Result.append (comment)
			Result.append (rule)
			Result.append_code (10)
		end

	name: STRING
			-- the name of the feature/attribute

	old_type: STRING
			-- the old type of the attribute (convert from)

	new_type: STRING
			-- the new type of the attribute (convert to)

	old_object: STRING
			-- the old object, default "a"

	new_object: STRING
			-- the new object, default "Current"

	message: CONVERTER_MESSAGES
			--messages

	comment: STRING
			-- formatted string with the comments
		do
			if first_comment.count > 0 then
				comments.put_front (first_comment)
			end
			Result := ""
			from comments.start until comments.after loop
				Result.append (tabs_d)
				Result.append ("-- " + comments.item)
				Result.append_code (10)
				comments.forth
			end
		end

	rule: STRING
			-- formatted string with the rule
		deferred
		end

	process: STRING
			-- an aut of all the process


feature -- Element change
	set_name(s: STRING)
			--
		do
			name := Void
			create name.make_from_string (s)
		end

	set_old_type(t: STRING)
			--
		do
			old_type := Void
			create old_type.make_from_string (t)
		end

	set_new_type(t: STRING)
			--
		do
			new_type := Void
			create new_type.make_from_string (t)
		end

	set_old_object(o: STRING)
			--
		do
			old_object := Void
			create old_object.make_from_string (o)
		end

	set_new_object(o: STRING)
			--
		do
			new_object := Void
			create new_object.make_from_string(o)
		end

	add_comment(s: STRING)
			--
		do
			comments.force (s)
		end

	set_num_tabs(n : INTEGER)
			--
		require
			n >= 0
		do
			num_tabs := n
		end

	set_assignment_assignment
			-- default, use assignment
		do
			assignment_type := 0
		end

	set_assignment_force
			-- use a "force()"
		do
			assignment_type := 1
		end

	set_assignment_put
			-- use a "put()"
		do
			assignment_type := 2
		end

feature {NONE} -- Implementation

	first_comment: STRING
			-- The first comment that appears for this rule. May be the empty string
		deferred
		end

	comments: LINKED_LIST[STRING]
			-- the list of comments which will appear with the rule

	assignment_type: INTEGER
			-- see "set_assignment_*" for more infos

	tabs_d: STRING
			-- formatted string containing `num_tabs' tabs
		do
			Result := tabs (num_tabs)
		end

	tabs(n: INTEGER): STRING
			-- string `n' tab characters
		require
			n > 0
		local
			i: INTEGER
		do
			Result := ""
			from i := 0 until i = n loop
				Result.append_code (9)
				i := i + 1
			end
		end

	num_tabs: INTEGER
			-- the number of tabs we have to put in each line for formatted code!
invariant
	-- Insert invariant here
note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
