note
	description: "Objects that represent an ARFF relation"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEKA_ARFF_RELATION

inherit
	ARRAYED_LIST [ARRAYED_LIST [STRING]]
		rename
			make as old_make
		redefine
			out
		end

	DEBUG_OUTPUT
		undefine
			is_equal,
			copy,
			out
		end

	WEKA_SHARED_EQUALITY_TESTERS
		undefine
			is_equal,
			copy,
			out
		end

	KL_SHARED_STRING_EQUALITY_TESTER
		undefine
			is_equal,
			copy,
			out
		end

create
	make

feature{NONE} -- Initialization

	make (a_attributes: like attributes)
			-- Initialize Current.
		do
			create attributes.make (a_attributes.count)
			attributes.compare_objects
			attributes.append (a_attributes)

			name := "noname"
			comment := ""
			trailing_comment := ""

			old_make (initiail_data_capacity)
		end

feature -- Access

	name: STRING
			-- Name of current file

	attributes: ARRAYED_LIST [WEKA_ARFF_ATTRIBUTE]
			-- List of attributes mentioned in current relation
			-- The order of attributes in this list determines the order of values.			
			-- Each element in current list represent an instance,
			-- and the inner list stores the values of all attributes in that instance,
			-- with the same order as `attributes'.	
			-- Note: Elements in the list should not contain duplications.
			-- It is stored in a list instead of a set because we want to make sure the order of elements
			-- are not changed. For getting a set of attributes, see `attribute_set'.

	attribute_set: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]
			-- Set representation of `attributes'
		do
			create Result.make (attributes.count)
			Result.set_equality_tester (weka_arff_attribute_equality_tester)
			attributes.do_all (agent Result.force_last)
		end

	comment: STRING
			-- Comments to be located after the relation name, before attribute declaration	

	trailing_comment: STRING
			-- Comments that appear at the end of the file

	out, as_string: STRING
			-- Current weka relation as string
		local
			l_cursor: CURSOR
			l_lines: LIST [STRING]
		do
			create Result.make (8192)

				-- Output the relation name part.
			Result.append_string ({WEKA_CONSTANTS}.relation)
			Result.append_character (' ')
			Result.append_string (name)
			Result.append_character ('%N')
			Result.append_character ('%N')

				-- Output comment.
			l_lines := comment.split ('%N')
			from
				l_lines.start
			until
				l_lines.after
			loop
				Result.append_character ('%%')
				Result.append_string (l_lines.item_for_iteration)
				Result.append_character ('%N')
				l_lines.forth
			end

				-- Output attributes.
			l_cursor := attributes.cursor
			from
				attributes.start
			until
				attributes.after
			loop
				Result.append_string (attributes.item_for_iteration.signature)
				Result.append_character ('%N')
				attributes.forth
			end
			attributes.go_to (l_cursor)
			Result.append_character ('%N')

				-- Output instances data.
			Result.append_string ({WEKA_CONSTANTS}.data)
			Result.append_character ('%N')
			l_cursor := cursor
			from
				start
			until
				after
			loop
				Result.append_string (instance_string)
				Result.append_character ('%N')
				forth
			end
			go_to (l_cursor)
			Result.append_character ('%N')

				-- Append trailing comment.
			Result.append_character ('%N')
			Result.append (trailing_comment)
		end


	value_set: DS_HASH_TABLE [DS_HASH_SET [STRING], WEKA_ARFF_ATTRIBUTE]
			-- Table from attribute to values of that attributes in all instances
			-- Key is an attribute, value is the set of values that attribute have across all instances.
		local
			l_instance: ARRAYED_LIST [STRING]
			i: INTEGER
			l_values: DS_HASH_SET [STRING]
			l_value: STRING
			l_attr: WEKA_ARFF_ATTRIBUTE
		do
			create Result.make (attributes.count)
			Result.set_key_equality_tester (weka_arff_attribute_equality_tester)

				-- Create an empty value set for each attribute.
			across attributes as l_attrs loop
				create l_values.make (5)
				l_values.set_equality_tester (string_equality_tester)
				Result.force_last (l_values, l_attrs.item)
			end

				-- Iterate through all instances in Current and
				-- collect values that each attribute can have.
			across Current as l_instances loop
				l_instance := l_instances.item
				i := 1
				across attributes as l_attrs loop
					l_attr := l_attrs.item
					l_value := l_instance.i_th (i)
					l_values := Result.item (l_attr)
					if not l_values.has (l_value) then
						l_values.force_last (l_value)
					end
					i := i + 1
				end
			end
		end

	values_of_attribute (a_attribute: WEKA_ARFF_ATTRIBUTE): LINKED_LIST [STRING]
			-- List of values of `a_attribute' across all instances.
			-- The order of values are preserved.
		local
			l_index: INTEGER
		do
			create Result.make
			Result.compare_objects

			l_index := attributes.index_of (a_attribute, 1)
			across Current as l_instances loop
				Result.extend (l_instances.item.i_th (l_index))
			end
		end

	projection (a_attribute_selection_function: FUNCTION [ANY, TUPLE [WEKA_ARFF_ATTRIBUTE], BOOLEAN]): like Current
			-- Projection of Current by selecting only attributes that satisfies `a_attribute_selection_function'
			-- The order of the attributes in the resulting relation is the same as in the original relation.
		local
			l_indexes: LINKED_LIST [INTEGER]
			i: INTEGER
			l_attributes: like attributes
			l_instance: like item
			l_prj_instance: like item
		do
				-- Store indexes of remaining attributes in `l_indexes'.
			create l_indexes.make
			create l_attributes.make (attributes.count)
			i := 1
			across attributes as l_attrs loop
				if a_attribute_selection_function.item ([l_attrs.item]) then
					l_indexes.extend (i)
					l_attributes.extend (l_attrs.item)
				end
				i := i + 1
			end

				-- Iterate through all instances in Current and store the projected data into Result.
			create Result.make (l_attributes)
			across Current as l_instances loop
				l_instance := l_instances.item
				create l_prj_instance.make (l_indexes.count)
				across l_indexes as l_attr_indexes loop
					l_prj_instance.extend (l_instance.i_th (l_attr_indexes.item))
				end
				Result.extend (l_prj_instance)
			end

			Result.set_name (name)
			Result.set_comment (comment)
			Result.set_trailing_comment (trailing_comment)
		end

	cloned_object: like Current
			-- Cloned version of Current
		do
			create Result.make (attributes)
			do_all (agent Result.extend)
			Result.set_comment (comment)
			Result.set_trailing_comment (trailing_comment)
			Result.set_name (name)
		end

	nominalized_cloned_object: like Current
			-- Cloned version of Current, with all numeric values normalized
		local
			l_new_attrs: like attributes
			l_value_set: like value_set
		do
			l_value_set := value_set
			create l_new_attrs.make (attributes.count)
			across attributes as l_attrs loop
				if l_attrs.item.is_nominal then
					l_new_attrs.extend (l_attrs.item)
				else
					l_new_attrs.extend (l_attrs.item.as_nominal (l_value_set.item (l_attrs.item)))
				end
			end

			create Result.make (l_new_attrs)
			do_all (agent Result.extend)
			Result.set_comment (comment)
			Result.set_trailing_comment (trailing_comment)
			Result.set_name (name)
		end

	attribute_by_name (a_name: STRING): WEKA_ARFF_ATTRIBUTE
			-- Attribute in `attributes' with `a_name'
		require
			a_name_exists: has_attribute_by_name (a_name)
		do
			across attributes as l_attrs until Result /= Void loop
				if l_attrs.item.name ~ a_name then
					Result := l_attrs.item
				end
			end
		end



feature -- Hash table generators

	item_as_hash_table: HASH_TABLE [STRING, STRING]
			-- Returns a hash table where the keys are the attribute names and the values comes from the current item
		require
			valid_item: not off
		do
			Result := data_as_hash_table(item)
		ensure
			attributes.for_all (
				agent (a_attr: WEKA_ARFF_ATTRIBUTE; a_result: HASH_TABLE [STRING, STRING]): BOOLEAN
					do
						Result := a_result.has (a_attr.name)
					end (?, Result))
			-- every_attribute_included: attributes.for_all (Result.has)
		end

	i_th_as_hash_table(a_i:INTEGER): HASH_TABLE[STRING, STRING]
			-- returns a hash table where the keys are the attribute names and the values comes from the ith item
		do
			Result := data_as_hash_table (i_th (a_i))
		end

	attributes_as_hash_table: HASH_TABLE [STRING, STRING]
			-- returns a hash table where the keys are the attributes and the values are void
		do
			create Result.make(attributes.count)
			Result.compare_objects
			from attributes.start until attributes.after loop
				Result[attributes.item_for_iteration.name] := Void
				attributes.forth
			end
		end

feature -- Status report

	is_instance_valid (a_instance: like item): BOOLEAN
			-- Does `a_instance' contain valid values for `attribute'?
		local
			i: INTEGER
			l_attrs: like attributes
			l_cursor: CURSOR
		do
			if a_instance.count = attributes.count then
				l_attrs := attributes
				l_cursor := l_attrs.cursor
				from
					Result := True
					i := 1
					l_attrs.start
				until
					l_attrs.after or not Result
				loop
					Result := l_attrs.item_for_iteration.is_valid_value (a_instance.i_th (i))
					i := i + 1
					l_attrs.forth
				end
				l_attrs.go_to (l_cursor)
			end
		end

	has_attribute_by_name (a_name: STRING): BOOLEAN
			-- Is there an attribute in Current with `a_name'?
		do
			Result := False
			across attributes as l_attrs until Result loop 
				Result := l_attrs.item.name ~ a_name
			end
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
			-- Only the attribute part is included, the instance part is ignored.
		local
			l_cursor: CURSOR
		do
			create Result.make (1024)
			Result.append ("Name: ")
			Result.append (name)
			Result.append_character ('%N')
			l_cursor := attributes.cursor
			from
				attributes.start
			until
				attributes.after
			loop
				Result.append (attributes.item_for_iteration.signature)
				Result.append_character ('%N')
				attributes.forth
			end
			Result.append ("Instances: " + count.out)
			Result.append_character ('%N')
			attributes.go_to (l_cursor)
		end

feature -- Basic operations

	set_name (a_name: like name)
			-- Set `name' with `a_name'.
		do
			name := a_name.twin
		ensure
			good_result: name ~ a_name
		end

	set_comment (a_comment: STRING)
			-- Set `comment' with `a_comment'.
			-- Make a copy from `a_comment'.
		do
			if a_comment = Void then
				comment := ""
			else
				comment := a_comment.twin
			end
		end

	set_trailing_comment (a_trailing_comment: STRING)
			-- Set `trailing_comment' with `a_trailing_comment'.
			-- Make a copy from `a_trailing_comment'.
		do
			if a_trailing_comment = Void then
				trailing_comment := ""
			else
				trailing_comment := a_trailing_comment.twin
			end
		end

	to_medium (a_medium: IO_MEDIUM)
			-- Store current relation in `a_medium'.
		require
			a_medium_is_ready: a_medium.is_open_write
		do
			a_medium.put_string (as_string)
		end

	extend_instance (a_instance: like item)
			-- Extend `a_intance' into Current relation.
		require
			a_instance_valid: is_instance_valid (a_instance)
		do
			extend (a_instance)
		end

feature -- Constants

	initiail_data_capacity: INTEGER = 100
			-- The initial capacity of `data'

feature{NONE} -- Implementation

	data_as_hash_table(a_list: LIST[STRING]): HASH_TABLE [STRING, STRING]
			-- Returns an hash table where the attribute names are the keys and tha data comes from the array
		do
			create Result.make (attributes.count)
			Result.compare_objects
			from attributes.start; a_list.start until attributes.after or a_list.after loop
				Result[attributes.item_for_iteration.name] := a_list.item_for_iteration
				attributes.forth
				a_list.forth
			end
		end

	instance_string: STRING
			-- String for the data in current `item'
		require
			not_off: not off
		local
			l_data: like item
			l_cursor: CURSOR
			l_attrs: like attributes
			i: INTEGER
		do
			create Result.make (256)
			l_attrs := attributes
			l_data := item
			l_cursor := l_data.cursor
			from
				i := 1
				l_data.start
				Result.append (l_attrs.i_th (i).value (l_data.item_for_iteration))
				i := i + 1
				l_data.forth
			until
				l_data.after
			loop
				Result.append_character (',')
				Result.append (l_attrs.i_th (i).value (l_data.item_for_iteration))
				i := i + 1
				l_data.forth
			end
		end

end
