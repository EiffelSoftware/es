note
	description: "Class which infers contracts from given data"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CI_INFERRER

feature -- Access

	logger: EPA_LOG_MANAGER
			-- Logger

feature -- Basic operations

	infer (a_data: LINKED_LIST [CI_TEST_CASE_TRANSITION_INFO])
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		deferred
		end

feature -- Setting

	set_logger (a_logger: like logger)
			-- Set `logger' with `a_logger'.
		do
			logger := a_logger
		ensure
			logger_set: logger = a_logger
		end



end
