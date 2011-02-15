note
	description: "Summary description for {AFX_CALL_BASED_REQUEST_SELECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_CALL_BASED_REQUEST_SELECTOR

inherit
    SHARED_TYPES

create
	default_create

feature -- Operation

	is_suitable (a_request: AUT_CALL_BASED_REQUEST): BOOLEAN
			-- Is `a_request' suitable to be used to construct the model?
		local
		    l_feature: FEATURE_I
		    l_class: CLASS_C
		    l_creators: HASH_TABLE [EXPORT_I, STRING]
		do
		    l_feature := a_request.feature_to_call
		    l_class := a_request.target_type.associated_class
		    l_creators := l_class.creators

		    if not (l_creators /= Void and then l_creators.has (l_feature.feature_name)) and then l_feature.type = void_type then
				Result := True
		    end
		end

end
