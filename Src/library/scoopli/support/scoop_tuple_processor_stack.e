indexing
	description: "Objects that implement stacks of tuples of processors."
	author: "Piotr Nienaltowski"
	date: "$Date 2005/07/19 13:51:00 $"
	revision: "$Revision$"
	build_number: "0.4.4000"

class
	SCOOP_TUPLE_PROCESSOR_STACK

inherit
	LINKED_LIST [TUPLE [SCOOP_PROCESSOR]]
	rename
		has as linked_list_has,
		extend as push
	end


create
	make

feature
	has (a_processor: SCOOP_PROCESSOR): BOOLEAN is
			-- Does `a_processor' occur in current stack?
		require
			a_processor_exists: a_processor /= void
		local
			i: INTEGER_32
		do
			from
				start
			until
				after or else Result
			loop
				from
					i := 1
				until
					i > item.count or else Result
				loop
					if item.item (i) = a_processor then
						Result := true
					end
					i := i + 1
				end
				forth
			end
		end

feature {SCOOP_PROCESSOR}

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
