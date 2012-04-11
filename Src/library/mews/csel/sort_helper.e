indexing
	description: "Objects that help in sorting conference list elements following different criteria"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$0.3.1$"

class
	SORT_HELPER


feature -- Basic operations
--------------------------------------------------------------------------------------------------------------------------------
	sort_conference_list_by_name(conference_list:ARRAYED_LIST[CONFERENCE])
			--sorts the arraylist in ascending order of its conference name using bubble sort (better then quicksort for n < 50)
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
					conference_list.start
					i:=1
					unswapped:=true
				until
					i>conference_list.count-1 OR conference_list.after
				loop
					if conference_list.i_th (i).name > conference_list.i_th (i+1).name then
						conference_list.swap (i+1)
						unswapped:=false
					end
					i:=i+1
					conference_list.forth
				end
			end
		end
--------------------------------------------------------------------------------------------------------------------------------
	sort_conference_list_by_country(conference_list:ARRAYED_LIST[CONFERENCE])
			--sorts the arraylist in ascending order of its conference name using bubble sort (better then quicksort for n < 50)
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
					conference_list.start
					i:=1
					unswapped:=true
				until
					i>conference_list.count-1 OR conference_list.after
				loop
					if conference_list.i_th (i).country > conference_list.i_th (i+1).country then
						conference_list.swap (i+1)
						unswapped:=false
					end
					i:=i+1
					conference_list.forth
				end
			end
		end
--------------------------------------------------------------------------------------------------------------------------------
	sort_conference_list_by_starting_date(conference_list:ARRAYED_LIST[CONFERENCE])
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
					conference_list.start
					i:=1
					unswapped:=true
				until
					i>conference_list.count-1 OR conference_list.after
				loop
					if conference_list.i_th (i).starting_date  > conference_list.i_th (i+1).starting_date then
						conference_list.swap (i+1)
						unswapped:=false
					end
					i:=i+1
					conference_list.forth
				end
			end
		end
--------------------------------------------------------------------------------------------------------------------------------
	sort_conference_list_by_papers_submission_deadline(conference_list:ARRAYED_LIST[CONFERENCE])
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
					conference_list.start
					i:=1
					unswapped:=true
				until
					i>conference_list.count-1 OR conference_list.after
				loop
					if conference_list.i_th (i).papers_submission_deadline  > conference_list.i_th (i+1).papers_submission_deadline then
						conference_list.swap (i+1)
						unswapped:=false
					end
					i:=i+1
					conference_list.forth
				end
			end
		end

invariant
	invariant_clause: True -- Your invariant here

end
