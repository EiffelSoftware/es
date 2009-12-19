note
	description: "Summary description for {AFX_BEHAVIOR_CONSTRUCTOR_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BEHAVIOR_CONSTRUCTOR_FACTORY

create
    default_create

feature -- Factory method

	create_forward_constructor: AFX_FORWARD_BEHAVIOR_CONSTRUCTOR
			-- Create forward constructor.
		do
		    create Result.make
		end

	create_backward_constructor: AFX_BACKWARD_BEHAVIOR_CONSTRUCTOR
			-- Create backward constructor.
		do
		    create Result.make
		end

end
