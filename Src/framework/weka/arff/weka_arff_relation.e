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
		end

	DEBUG_OUTPUT
		undefine
			is_equal,
			copy
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

	to_medium (a_media: IO_MEDIUM)
			-- Store current relation in `a_media'.
		require
			a_media_is_ready: a_media.is_open_write
		local
			l_cursor: CURSOR
		do
				-- Output the relation name part.
			a_media.put_string (relation_header)
			a_media.put_character (' ')
			a_media.put_string (name)
			a_media.put_character ('%N')
			a_media.put_character ('%N')

				-- Output attributes.
			l_cursor := attributes.cursor
			from
				attributes.start
			until
				attributes.after
			loop
				a_media.put_string (attributes.item_for_iteration.signature)
				a_media.put_character ('%N')
				attributes.forth
			end
			attributes.go_to (l_cursor)
			a_media.put_character ('%N')

				-- Output instances data.
			a_media.put_string (data_header)
			a_media.put_character ('%N')
			l_cursor := cursor
			from
				start
			until
				after
			loop
				a_media.put_string (instance_string)
				a_media.put_character ('%N')
				forth
			end
			go_to (l_cursor)
			a_media.put_character ('%N')
		end

	extend_instance (a_instance: like item)
			-- Extend `a_intance' into Current relation.
		require
			a_instance_valid: is_instance_valid (a_instance)
		do
			extend (a_instance)
		end

feature -- Constants

	relation_header: STRING = "@RELATION"
	data_header: STRING = "@DATA"

	initiail_data_capacity: INTEGER = 100
			-- The initial capacity of `data'

feature{NONE} -- Implementation

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
