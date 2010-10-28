note
	description: "From two lists of attributes computes the conversion rules and the converter code."
	author: "Matthias Loeu, Teseo Schneider, Marco Piccioni"
	date: "09.04.09"

class
	CONVERTER_MAKE
inherit
	ANY
		redefine
			out
		end

create
	make

feature -- Initialization

	make
			-- Initialize `Current'.
		do
			first_name := ""
			second_name := ""
			text := ""
			message := ""
			create rules.make
		end

feature -- Access
	out: STRING
			-- Invoke and then output the converter.
		do
			create_converter
			Result := ""
			--Result.append (list_attributes).
			Result.append (text)
		end

	message: STRING

	list_attributes: STRING
			-- Output both classes with a list of their attributes.
		do
			create Result.make_from_string (first_name)
			Result.append_code(10)

			if has_first then
				-- output the table
				from first.start until first.after loop
					Result.append(first.key_for_iteration+" - "+first.item_for_iteration)
					Result.append_code(10)
					first.forth
				end
			end
			Result.append_code(10)

			Result.append(second_name)
			Result.append_code(10)

			if has_second then
				-- output the table
				from second.start until second.after loop
					Result.append(second.key_for_iteration+" - "+second.item_for_iteration)
					Result.append_code(10)
					second.forth
				end
			end
		end

feature -- Status report

	has_first: BOOLEAN
			--
		do
			Result := first /= Void
		end

	has_second:BOOLEAN
			--
		do
			Result := second /= Void
		end

	rule_count: INTEGER
			--
		do
			if rules /= void then
				Result := rules.count
			else
				Result := 0
			end
		end

feature -- Status setting

	set_first (n: STRING; s: DS_HASH_TABLE[STRING, STRING])
			--
		do
			first_name := n
			first := s
		end

	set_second (n: STRING; s: DS_HASH_TABLE[STRING, STRING])
			--
		do
			second_name := n
			second := s
		end


feature -- Element change
	create_converter
			-- Create the rules and the converter.
		do
			text := ""
			--text_append_line ("")
			--text_append_line ("")
			if has_first and has_second then
				if first_name /= second_name then
					-- first, the rules
					create_rules
					-- then, the converter
					create_converter_imp
				else
					text_append_line ("Both classes are the same, we do not need to convert!")
				end
			else
				text_append_line ("Please drag two classes to here to generate converter.")
			end
		end

	add_rule(r: CONVERTER_RULE)
			-- Add a new rule to the list
		require
			r /= Void
		do
			rules.force (r)
		end

feature -- Removal

	unset_first
			--
		do
			first_name := ""
			first := void
		end

	unset_second
			--
		do
			second_name := ""
			second := void
		end

	remove_rule(i: INTEGER)
			-- Remove the i-th rule from the list
		require
			i>0
			i<rule_count
		local
			j: INTEGER
		do
			from
				rules.start
				j := 1
			until
				rules.after or j = i
			loop
				rules.forth
				j := j + 1
			end
			rules.remove
		end

feature {NONE} -- Implementation

	create_rules
			-- Create the rules from both classes
		local
			feature_name: STRING
			feature_class: STRING
			r: CONVERTER_RULE
		do
			from second.start until second.after loop
				feature_name := second.key_for_iteration
				feature_class := second.item_for_iteration
				if first.has (feature_name) then -- has same attribute
					if first.item (feature_name).is_equal (feature_class) then -- no change
						r := create {CONVERTER_RULE_SAME}.make (feature_name)
					else -- other type
						r := create {CONVERTER_RULE_CHANGE}.make (feature_name)
						r.set_new_type (feature_class)
						r.set_old_type (first.item (feature_name))
						--r.add_comment ("Old attribute is of type " + first.item (feature_name)+". Does it conform or convert?")
					end
				else -- added attribute
					r := create {CONVERTER_RULE_NEW}.make (feature_name)
					r.set_new_type (feature_class)
					r.add_comment ("My best guess for initialization is the default value.")
					r.add_comment ("Please change it if you think it is necessary to establish the class invariant.")
				end
				add_rule (r)
				second.forth
			end

			-- for completeness' sake, make a comment about the attributes we remove
			from first.start until first.after loop
				if not second.has (first.key_for_iteration) then
					add_rule(create {CONVERTER_RULE_REMOVE}.make (first.key_for_iteration))
				end
				first.forth
			end
		end

	create_converter_imp
			-- Write the converter code from the rules
		do
			from rules.start until rules.after loop
				text_append_line (rules.item.out)

				message:=message+rules.item.process+"%N------------%N"

				rules.forth
			end

			--text_append_line_tabs ("end", 2)

		end


	first: DS_HASH_TABLE[STRING, STRING]

	first_name: STRING

	second: DS_HASH_TABLE[STRING, STRING]

	second_name: STRING

	text: STRING
			-- holds the actual converter

	rules: LINKED_LIST[CONVERTER_RULE]

	text_append_line(s: STRING)
			-- append a string to text, followed by a new line
		do
			text.append (s)
			text.append_code (10)
		end

	text_append_line_tabs(s: STRING; t: INTEGER)
			-- append t tabs to text, then s, then a new line
		require
			t >= 0
		local
			n: STRING
			i: INTEGER
		do
			n := ""
			from i := 0 until i = t loop
				n.append_code (9) -- tab character
				i := i + 1
			end
			text_append_line (n + s)
		end

invariant
	rules_exist: rules /= Void

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
