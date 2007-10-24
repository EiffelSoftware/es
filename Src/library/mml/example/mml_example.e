indexing
	description: "Root class for the example project"
	version: "$Id$"
	author: "Bernd Schoeller"
	copyright: "see License.txt"

class
	MML_EXAMPLE

create
	main

feature -- Model Implementations

	default_bag: MML_DEFAULT_BAG [INTEGER]
	default_endorelation: MML_DEFAULT_ENDORELATION [INTEGER]
	default_pair: MML_DEFAULT_PAIR [INTEGER,INTEGER]
	default_powerset: MML_DEFAULT_POWERSET [INTEGER]
	default_relation: MML_DEFAULT_RELATION [INTEGER,INTEGER]
	default_sequence: MML_DEFAULT_SEQUENCE [INTEGER]
	default_set: MML_DEFAULT_SET [INTEGER]
	default_range: MML_RANGE_SET
	default_graph: MML_GRAPH [INTEGER]

	ll: FLAT_LINKED_LIST[INTEGER]
	ol: FLAT_LINKED_LIST[INTEGER]

	x: MML_COMPOSITION [INTEGER,INTEGER,INTEGER]

feature -- Main

	print_list is
			-- Print the contents of `ll'.
		local
			cursor: FLAT_LINKED_LIST_CURSOR [INTEGER]
			index: INTEGER
		do
			cursor := ll.cursor
			index := ll.index
			if index = 0 then
				print ("*")
			end
			print ("<")
			from
				ll.start
			until
				ll.off
			loop
				print (ll.item)
				if ll.index = index then
					print ("*")
				end
				if not ll.islast then
					print (",")
				end
				ll.forth
			end
			print (">")
			ll.go_to (cursor)
			if index = ll.count + 1 then
				print ("*")
			end
			print ("%N")
		end


	main is
		-- Execute the MML example
	do
		print ("-----%N")
		create ll.make
		print_list

		print ("force(1)%N")
		ll.force (1)
		print_list

		print ("forth%N")
		ll.forth
		print_list

		print ("forth%N")
		ll.forth
		print_list

		print ("wipe_out%N")
		ll.wipe_out
		print_list

		print ("put%N")
		ll.force (1)
		print_list

		ll.finish
		ll.put_left (2)
		print_list

		ll.start
		ll.put_right (3)
		print_list

		create x
		print (x.composed (ll.model_sequence,ll.model_sequence).out+"%N")
		print (x.composed (ll.model_sequence.inversed,ll.model_sequence).out+"%N")

		create ol.make
		ol.force (5)
		ol.force (4)
		ll.merge_left (ol)
		print_list

		ol.force (6)
		ol.force (7)
		ll.merge_right (ol)
		print_list

	end

end
