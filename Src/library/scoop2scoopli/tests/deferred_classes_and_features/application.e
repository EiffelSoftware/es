class APPLICATION

create
  make

feature
  make
    local
		l_child: attached separate CHILD
		l_argument: attached separate A
    do
    	create l_argument
		create l_child.effective_child_procedure (l_argument)
		run (l_child)
    end

	run (a_node: attached separate PARENT)
		local
			l_argument: attached separate A
		do
			create l_argument
			a_node.deferred_parent_procedure (l_argument)
			a_node.effective_parent_procedure (l_argument)
		end
end

