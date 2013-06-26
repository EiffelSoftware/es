class MML_SET

inherit

	ANY
		redefine
			default_create
		end

create
	default_create,
	make_from_tuple,
	make_from_array

feature {NONE} -- Initialization

	default_create
		do
		end

	make_from_tuple (a_tuple: TUPLE)
		do
		end

	make_from_array (a_array: ARRAY [ANY])
		do
		end
    
feature -- Status report
    
	has (a_object: ANY): BOOLEAN
		do
		end
    
  is_disjoint (a_other: MML_SET): BOOLEAN
    do
    end
    
feature -- Basic operations

  union alias "+" (a_other: MML_SET): MML_SET
    do
    end
    
  intersection alias "*" (a_other: MML_SET): MML_SET
    do
    end
    
  difference alias "-" (a_other: MML_SET): MML_SET
    do
    end        

end
