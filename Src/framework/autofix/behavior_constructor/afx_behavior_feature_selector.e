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

create
    default_create

feature -- operation

	is_satisfactory (a_class: CLASS_C; a_feature: FEATURE_I; a_context_class: CLASS_C): BOOLEAN
			-- is `a_feature' from `a_class' satisfactory according to this criterion in the context class `a_context_class'?
		local
		    l_class: CLASS_C
		    l_feature: FEATURE_I
		    l_creators: HASH_TABLE [EXPORT_I, STRING]
		do
		    l_creators := a_class.creators
		    if not (l_creators /= Void and then l_creators.has (l_feature.feature_name))
		    		and then l_feature.export_status.is_exported_to (a_context_class)
		    		and then l_feature.type = void_type
		    		and then l_feature.argument_count = 0
		    		then
				Result := True
		    end
		end


--feature -- initialize
--	make (a_class_set: DS_HASH_SET [CLASS_C]; a_heap: DS_HASH_TABLE [DS_HASH_TABLE[AFX_BOOLEAN_STATE, STRING], INTEGER])
--			-- initialize
--		do
--		    class_scope := a_class_set
--		    variable_scope := a_heap
--		end

--feature -- access

--	class_scope: DS_HASH_SET [CLASS_C]
--			-- scope of classes

--	available_objects: DS_HASH_TABLE [DS_HASH_TABLE[AFX_BOOLEAN_STATE, STRING], INTEGER]
--			-- objects available for feature call operands

end
