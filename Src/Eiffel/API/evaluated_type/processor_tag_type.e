indexing
	description: "The type model of a processor tag, including some ordering on the instances."

class PROCESSOR_TAG_TYPE

inherit
	ANY
		redefine
			default_create,
			is_equal
		end

	PART_COMPARABLE
		undefine
			default_create
		redefine
			is_equal,
			infix "<"
		end

create
	make,
	make_top,
	make_bottom,
	make_current,
	default_create

feature --Creation
	default_create
		do
			make_current
		end

	make (is_separate : BOOLEAN; proc_name : ! STRING ; a_handled : BOOLEAN)
		require
			handled_has_name: a_handled implies not proc_name.is_empty
		do
			make_empty

			set_tag_name (proc_name)
			is_sep  := is_separate
			is_handled := a_handled

			if is_separate then
				if is_handled and proc_name.is_equal ("Current") then
					make_current
				elseif proc_name.is_empty then
					make_top
				end
			else
				make_current
			end
		end

	make_current
		do
			make_empty
			current_proc := True
		end

	make_top
		do
			make_empty
			top := True
		end
	make_bottom
		do
			make_empty
			bottom := True
		end

feature --Copy
	duplicate : ! PROCESSOR_TAG_TYPE
			-- Duplicate the current processor tag.
		do
			create Result.make (is_sep, tag_name, is_handled)
			Result.set_controlled (is_controlled)
		end

feature --Compare
	infix "<" (other : like Current) : BOOLEAN
		do
			Result := (other.top and not top) or else
			          (bottom and not other.bottom)
		end

	is_equal (other : like Current) : BOOLEAN
		do
			Result := (other.top    and top)    or else
			          (other.bottom and bottom) or else
			          (other.is_current and is_current) or else
			          (not other.is_current and not is_current and
			               other.tag_name.is_equal (tag_name))
		end

feature --Access
	is_current : BOOLEAN
			-- Determines whether this tag represents the same
			-- processor where the type was declared.
		do
			Result := current_proc
		end

	is_controlled : BOOLEAN
			-- Report whether this type is controlled
		do
			Result := controlled
		end

	set_controlled (contr : BOOLEAN)
			-- Set whether this type is controlled
		do
			controlled := contr
		end

  has_explicit_tag : BOOLEAN
  	do
  		Result := not tag_name.is_empty or is_handled
  	end

	tag_name : ! STRING
	bottom   : BOOLEAN
	top      : BOOLEAN

feature --Debug
	dump_info
		do
			io.put_string ("Separate tag with: is_sep: " + is_sep.out)
			io.put_string (" process name: " + tag_name)
			io.put_string (" handled: " + is_handled.out)
			io.put_string (" current: " + current_proc.out)
			io.new_line
		end

feature {NONE} -- Implementation
	set_tag_name (name :!STRING)
			-- Sets the name of the tag to `name'
		do
			tag_name := name.twin
		end



	make_empty
		do
			tag_name     := ""
			controlled   := False
			current_proc := False
			top          := False
			bottom       := False
		end

	controlled   : BOOLEAN
	current_proc : BOOLEAN
	is_sep       : BOOLEAN
	is_handled      : BOOLEAN

invariant
	top_bottom_exclusive: (bottom implies not top)
	tag_exclusive:        not tag_name.is_empty implies (not top and not bottom)

end
