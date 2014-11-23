note
	description: "Fixes violations of rule #50 ('Local variable only used for Result')."
	date: "$Date$"
	revision: "$Revision$"

class
	CA_LOCAL_USED_FOR_RESULT_FIX

inherit
	CA_FIX
		redefine
			execute,
			process_access_id_as
		end

create
	make_with_feature_and_name

feature {NONE} -- Initialization
	make_with_feature_and_name (a_class: attached CLASS_C; a_feature: attached FEATURE_AS; a_local_name: attached STRING)
			-- Initializes `Current' with class `a_class'. `a_local_name' is the local variable which violates the rule.
			-- `a_feature' is the feature in which the rule was violated.
		do
			make (ca_names.local_used_for_result_fix, a_class)
			local_name := a_local_name
			feature_as := a_feature
		end

feature {NONE} -- Implementation

	execute (a_class: attached CLASS_AS)
		local
			l_index: INTEGER
		do
				-- Remove local
			if
				attached feature_as.body.as_routine as l_routine
				and then attached l_routine.locals as l_locals
			then
				across l_locals as l_local_dec loop
					across l_local_dec.item.id_list as l_id loop
						l_index := l_local_dec.item.id_list.index_of(l_id.item, 1)
						if l_local_dec.item.item_name(l_index).is_equal(local_name) then
								-- Found the local variable to be removed.
							if l_local_dec.item.id_list.count > 1 then
								if l_local_dec.item.id_list.i_th(l_index) = l_local_dec.item.id_list.last then
										-- The local is the last in the list of same-typed locals.
									l_locals.replace_subtext (", " + local_name, "", True, matchlist)
								else
										-- The local is somewhere in between in the list of same-typed locals.
									l_locals.replace_subtext (local_name + ",", "", True, matchlist)
								end
							else
								-- The local is the only one of its type.
								l_local_dec.item.replace_text("", matchlist)
							end
						end
					end
				end
			end

				-- Process the feature
			process_feature_as (feature_as)
		end

	process_access_id_as (a_access_id: attached ACCESS_ID_AS)
		do
			do_nothing
		end

	local_name: STRING
		-- The name of the local variable to be replaced and removed.

	feature_as: FEATURE_AS
		-- The ast node of the feature in wich the rule was violated.

end
