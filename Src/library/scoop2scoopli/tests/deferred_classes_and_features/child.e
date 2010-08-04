class CHILD

inherit
	PARENT
		rename
			deferred_parent_procedure as effective_child_procedure
		end

create
	effective_child_procedure

feature
	effective_child_procedure (a_attribute: attached separate A)
		require else
			a_attribute.is_ready
		do
		ensure then
			a_attribute.is_ready
		end
end

