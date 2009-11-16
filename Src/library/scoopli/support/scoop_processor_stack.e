indexing
	description: "Objects that implement stacks of processors."
	author: "Piotr Nienaltowski"
	date: "$Date 2006/11/11 18:55:00 $"
	revision: "$Revision$"
	build_number: "0.4.4000"

class
	SCOOP_PROCESSOR_STACK

inherit
	LINKED_LIST [SCOOP_PROCESSOR]
	rename
		extend as push
	end


create
	make

feature

	push_whole_stack (other: like Current) is
		-- Merge current stack with `other' without wiping `other'.
		require
			other /= void
		do
			start
			merge_right (other.twin)
		end

	pop is
			-- Remove top of current stack.
		require
			not is_empty
		do
			go_i_th (count)
			remove
		ensure
			count = old count - 1
		end

	trim (n: INTEGER_32) is
			-- Chop off all elements after n-th element.
		require
			n > 0
			n <= count
		do
			go_i_th (n)
			active.forget_right
			count := n
		ensure
			count = n
		end
end
