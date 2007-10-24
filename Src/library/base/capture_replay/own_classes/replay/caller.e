indexing
	description: "[
					Object that's able to call features by name on a given target.
				 ]"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CALLER

feature -- Access

	has_error: BOOLEAN

	error_message: STRING

feature -- Basic operations
	call (target: ANY; feature_name: STRING; arguments: DS_LIST[ANY]) is
			-- Call `target'.`feature_name'(`arguments')
		require
			target_not_void: target /= Void
		deferred end

feature {NONE} -- Implementation
	report_and_set_error (message: STRING) is
			-- Report the error `message'
		require
			message_not_void: message /= Void
		do
			has_error := True
			error_message := message
		ensure
			error_set: has_error = True
			error_message_set: error_message /= Void
		end


	report_and_set_type_error (object: ANY) is
			-- Report that an unknown class was provided as argument
		require
			object_not_void: object /= Void
		do
			report_and_set_error ("error: CALLER cannot make calls on '" + object.generating_type + "'")
		ensure
			error_set: has_error = True
			error_message_set: error_message /= Void
		end

	report_and_set_feature_error(target: ANY; feature_name: STRING) is
			-- Report that a call to an unknown feature was requested.
		require
			target_not_void: target /= Void
			feature_name_not_void: feature_name /= Void
		do
			report_and_set_error ("feature '" + feature_name + "' is not known for type '" + target.generating_type + "'")
		ensure
			error_set: has_error = True
			error_message_set: error_message /= Void
		end

invariant
	invariant_clause: True -- Your invariant here

end
