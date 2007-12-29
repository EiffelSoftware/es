indexing
	description: "Represents the outcome of the execution of a single routine in the interpreter"
	author: "aleitner"
	date: "$Date$"
	revision: "$Revision$"

class CDD_ROUTINE_INVOCATION_RESPONSE

inherit

	ANY
		redefine
			out
		end

create

	make_bad,
	make_normal,
	make_exceptional

feature {NONE} -- Initialization

	make_bad (a_response_text: like response_text) is
			-- Create new bad response.
		require
			a_response_text_not_void: a_response_text /= Void
		do
			response_text := a_response_text
			is_bad := True
		ensure
			response_text_set: response_text = a_response_text
			is_bad: is_bad
		end

	make_normal (a_response_text: like response_text; an_output: like output) is
			-- Create new normal response.
		require
			a_response_text_not_void: a_response_text /= Void
			an_output_not_void: an_output /= Void
		do
			response_text := a_response_text
			output := an_output
			is_normal := True
		ensure
			response_text_set: response_text = a_response_text
			output_set: output = an_output
			is_normal: is_normal
		end

	make_exceptional (a_response_text: like response_text; an_output: like output; an_exception: like exception) is
			-- Create new exceptional response.
		require
			a_response_text_not_void: a_response_text /= Void
			an_exception_not_void: an_exception /= Void
		do
			response_text := a_response_text
			output := an_output
			exception := an_exception
			is_exceptional := True
		ensure
			response_text_set: response_text = a_response_text
			output_set: output = an_output
			exception_set: exception = an_exception
			is_exceptional: is_exceptional
		end

feature {ANY} -- Status

	is_bad: BOOLEAN
			-- Was the response gotten not in the expected format?
			-- Usually this means that the interpreter was in a state
			-- so damaged it could not respond correctly anymore.

	is_normal: BOOLEAN
			-- Was the execution successful? (I.e. no exception has been thrown)

	is_exceptional: BOOLEAN
			-- Has an exception been thrown?

feature {ANY} -- Access


	exception: AUT_EXCEPTION
			-- Exception thrown if any

	response_text: STRING
			-- Response text in unparsed form

	output: STRING
			-- String printed by the routine to stdout and stderr.

feature {ANY} -- Output

	out: STRING is
			-- String representation of `Current'.
		do
			if is_exceptional then
				Result := "[exception]%N"
				Result.append ("%Ttag: " + exception.exception_tag_name)
				Result.append ("%N%Tclass: " + exception.exception_class_name)
				Result.append ("%N%Tfeature: " + exception.exception_recipient_name)
			elseif is_normal then
				Result := "[normal]"
			else
				Result := "[bad]"
			end
		end

invariant

	is_bad_definition: is_bad = (not is_normal and not is_exceptional)
	is_normal_xor_is_exception: not is_bad = (is_normal xor is_exceptional)
	output: (is_normal or is_exceptional) = (output /= Void)
	exception: is_exceptional = (exception /= Void)

end
