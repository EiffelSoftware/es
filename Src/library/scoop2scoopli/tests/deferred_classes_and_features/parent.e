deferred class PARENT

feature
	deferred_parent_procedure (a_argument: attached separate A)
		require
			a_argument.is_ready
		deferred
		ensure
			a_argument.is_ready
			Current.is_ready
		end

	effective_parent_procedure (a: attached separate A)
		do
		end

	is_ready: BOOLEAN
		do
			Result := true
		end
end

