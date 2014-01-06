note
	description: "Summary description for {CA_FEATURE_NEVER_CALLED_FIX}."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_FEATURE_NEVER_CALLED_FIX

inherit
	CA_FIX
		redefine
			process_feature_as
		end

create
	make_with_feature

feature {NONE} -- Initialization

	make_with_feature (a_class: CLASS_C; a_feature: FEATURE_AS)
		do
			make (ca_names.feature_never_called_fix + a_feature.feature_name.name_32 + "'", a_class)
			feature_to_remove := a_feature
		end

feature {NONE} -- Implementation

	feature_to_remove: FEATURE_AS

feature {NONE} -- Visitor

	process_feature_as (a_feature: FEATURE_AS)
		do
			if a_feature.is_equivalent (feature_to_remove) then
				a_feature.replace_text ("", matchlist)
			end
		end

end
