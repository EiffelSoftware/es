note
	description: "Summary description for {AFX_STATE_TRANSITION_MODEL_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_TRANSITION_MODEL_FACTORY

create
    default_create

feature -- Factory feature

	create_default_forward_model: AFX_FORWARD_STATE_TRANSITION_MODEL
			-- Create default forward model.
		do
		    create Result.make_default
		end

	create_default_backward_model (a_size: INTEGER): AFX_BACKWARD_STATE_TRANSITION_MODEL
			-- Create default backward model.
		do
		    create Result.make_default
		end

	create_forward_model_with_size (a_size: INTEGER): AFX_FORWARD_STATE_TRANSITION_MODEL
			-- Create forward model.
		do
		    create Result.make (a_size)
		end

	create_backward_model_with_size (a_size: INTEGER): AFX_BACKWARD_STATE_TRANSITION_MODEL
			-- Create backward model.
		do
		    create Result.make (a_size)
		end

end
