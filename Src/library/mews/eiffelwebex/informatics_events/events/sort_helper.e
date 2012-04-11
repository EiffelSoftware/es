indexing
	description: "Objects that help in sorting event list elements following different criteria"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$0.3.1$"

class
	SORT_HELPER


feature -- Basic operations
--------------------------------------------------------------------------------------------------------------------------------
	sort_event_list_by_name(event_list:ARRAYED_LIST[EVENT])
			--sorts the arraylist in ascending order of its event name using bubble sort (better then quicksort for n < 50)
		local
			i:INTEGER
			unswapped:BOOLEAN
		do
			from
				unswapped:=false
			until
				unswapped
			loop
				from
					event_list.start
					i:=1
					unswapped:=true
				until
					i>event_list.count-1 OR event_list.after
				loop
					if event_list.i_th (i).name > event_list.i_th (i+1).name then
						event_list.swap (i+1)
						unswapped:=false
					end
					i:=i+1
					event_list.forth
				end
			end
		end
--------------------------------------------------------------------------------------------------------------------------------
	sort_event_list_by_country(event_list:ARRAYED_LIST[EVENT])
			--sorts the arraylist in ascending order of its event name using bubble sort (better then quicksort for n < 50)
		local
			i:INTEGER
			unswapped:BOOLEAN
		do
			from
				unswapped:=false
			until
				unswapped
			loop
				from
					event_list.start
					i:=1
					unswapped:=true
				until
					i>event_list.count-1 OR event_list.after
				loop
					if event_list.i_th (i).country > event_list.i_th (i+1).country then
						event_list.swap (i+1)
						unswapped:=false
					end
					i:=i+1
					event_list.forth
				end
			end
		end
--------------------------------------------------------------------------------------------------------------------------------
	sort_event_list_by_starting_date(event_list:ARRAYED_LIST[EVENT])
			--sorts the arraylist in descending order of its starting dates using bubble sort (better then quicksort for n < 50)
		local
			i:INTEGER
			unswapped:BOOLEAN
		do
			from
				unswapped:=false
			until
				unswapped
			loop
				from
					event_list.start
					i:=1
					unswapped:=true
				until
					i>event_list.count-1 OR event_list.after
				loop
					if event_list.i_th (i).starting_date  < event_list.i_th (i+1).starting_date then
						event_list.swap (i+1)
						unswapped:=false
					end
					i:=i+1
					event_list.forth
				end
			end
		end
--------------------------------------------------------------------------------------------------------------------------------
	sort_event_list_by_papers_submission_deadline(event_list:ARRAYED_LIST[EVENT])
			--sorts the arraylist in ascending order of its starting dates using bubble sort (better then quicksort for n < 50)
		local
			i:INTEGER
			unswapped:BOOLEAN
		do
			from
				unswapped:=false
			until
				unswapped
			loop
				from
					event_list.start
					i:=1
					unswapped:=true
				until
					i>event_list.count-1 OR event_list.after
				loop
					if event_list.i_th (i).papers_submission_deadline  > event_list.i_th (i+1).papers_submission_deadline then
						event_list.swap (i+1)
						unswapped:=false
					end
					i:=i+1
					event_list.forth
				end
			end
		end

invariant
	invariant_clause: True -- Your invariant here

end
