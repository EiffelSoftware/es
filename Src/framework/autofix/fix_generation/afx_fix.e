note
	description: "Summary description for {AFX_FIX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX

inherit
	DEBUG_OUTPUT

create
	make

feature{NONE} -- Initialization

	make (a_spot: like exception_spot)
			-- Initialize.
		require
			a_spot_attached: a_spot /= Void
		do
			exception_spot := a_spot
			text := ""
			feature_text := ""
		end

feature -- Access

	exception_spot: AFX_EXCEPTION_SPOT
			-- Exception related information

	text: STRING
			-- Text of the feature body containing current fix

	feature_text: STRING
			-- Text of the whole feature `exception_spot'.`recipient'

	ranking: AFX_FIX_RANKING
			-- Ranking for current fix

	precondition: detachable AFX_STATE
			-- Precondition of the snippet part of current fix

	postcondition: detachable AFX_STATE
			-- Postcondition of the snippet part of current fix

	recipient_: FEATURE_I
			-- Recipient of current fault
		do
			Result := exception_spot.recipient_
		end

	recipient_class: CLASS_C
			-- Class of `recipient_'
		do
			Result := exception_spot.recipient_class_
		end

feature -- Setting

	set_text (a_text: STRING)
			-- Set `text' with `a_text'.
		do
			text := a_text.twin
		end

	set_feature_text (a_text: STRING)
			-- Set `feature_text' with `a_text'.
		do
			feature_text := a_text.twin
		end

	set_exception_spot (a_spot: like exception_spot)
			-- Set `exception_spot' with `a_spot'.
		do
			exception_spot := a_spot
		end

	set_ranking (a_ranking: like ranking)
			-- Set `ranking' with `a_ranking'.
		do
			ranking := a_ranking
		end

	set_precondition (a_precondition: like precondition)
			-- Set `precondition' with `a_precondition'.
		do
			precondition := a_precondition
		ensure
			precondition_set: precondition = a_precondition
		end

	set_postcondition (a_postcondition: like postcondition)
			-- Set `postcondition' with `a_postcondition'.
		do
			postcondition := a_postcondition
		ensure
			postcondition_set: postcondition = a_postcondition
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := feature_text
		end

	information: STRING
			-- Information about Current fix
		do
			create Result.make (1024)
			Result.append ("Exception: ")
			Result.append (exception_spot.id)
			Result.append_character ('%N')

			Result.append ("Precondition:%N")
			if attached {AFX_STATE} precondition as l_pre then
				Result.append (l_pre.debug_output)
			else
				Result.append ("Void%N")
			end

			Result.append ("Postcondition:%N")
			if attached {AFX_STATE} postcondition as l_post then
				Result.append (l_post.debug_output)
			else
				Result.append ("Void%N")
			end

			Result.append ("Ranking: " + ranking.score.out + "%N%N")
			Result.append (feature_text)
			Result.append_character ('%N')
		end

end
