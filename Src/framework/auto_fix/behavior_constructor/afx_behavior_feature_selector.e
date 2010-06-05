note
	description: "Summary description for {AFX_BEHAVIOR_FEATURE_SELECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BEHAVIOR_FEATURE_SELECTOR

inherit
    AFX_BEHAVIOR_FEATURE_SELECTOR_I

   	SHARED_TYPES

   	INTERNAL_COMPILER_STRING_EXPORTER

create
    default_create

feature -- Operation

	is_suitable (a_class: CLASS_C; a_feature: FEATURE_I; a_context_class: CLASS_C): BOOLEAN
			-- <Precursor>
		local
		    l_class: CLASS_C
		    l_creators: HASH_TABLE [EXPORT_I, STRING]
		do
		    l_creators := a_class.creators
		    if not (l_creators /= Void and then l_creators.has (a_feature.feature_name))
		    		and then a_feature.export_status.is_exported_to (a_context_class)
		    			-- non-query
		    		and then a_feature.type = void_type
		    			-- argumentless routine
		    			-- comment out the following line if features with arguments are allowed
		    		and then a_feature.argument_count = 0
		    		then
				Result := True
		    end
		end
end
