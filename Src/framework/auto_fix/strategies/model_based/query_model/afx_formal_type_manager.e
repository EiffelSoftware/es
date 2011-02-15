note
	description: "Summary description for {AFX_FORMAL_TYPE_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FORMAL_TYPE_MANAGER

inherit
    DS_HASH_TABLE[DS_ARRAYED_LIST[TYPE_A], FEATURE_I]

    SHARED_TYPES
    	undefine
    		is_equal,
    		copy
    	end

create
    make, make_default

feature -- Query

	query_feature_formal_types (a_feature: FEATURE_I; a_context_type: TYPE_A): DS_ARRAYED_LIST[TYPE_A]
			-- Query the static types of the feature operands.
		local
			l_array: DS_ARRAYED_LIST[TYPE_A]
			l_type: TYPE_A
			l_feature_type: TYPE_A
			l_feature_class: CLASS_C
			l_arguments: FEAT_ARG
		do
		    Result := value (a_feature)
		    if Result = Void then
		        l_feature_class := a_context_type.associated_class
		        l_feature_type := l_feature_class.actual_type

		        create l_array.make (a_feature.argument_count + 2)

					-- target type
		        l_array.force_last (l_feature_type)

		        	-- argument types
		        l_arguments := a_feature.arguments
		        if l_arguments /= Void then
    		        from l_arguments.start
    		        until l_arguments.after
    		        loop
    		            l_type := resolve_actual_type (l_arguments.item_for_iteration, l_feature_type, l_feature_class)
    		            l_array.force_last (l_type)
    		            l_arguments.forth
    		        end
		        end

		        	-- result type of query
		        if a_feature.type /= void_type then
			        l_type := resolve_actual_type (a_feature.type, l_feature_type, l_feature_class)
		            l_array.force_last (l_type)
		        end

				force (l_array, a_feature)
				Result := l_array
		    end
		end

feature -- Implementation

	resolve_actual_type (a_type, a_context_type: TYPE_A; a_context_class: CLASS_C): TYPE_A
			-- Resolve actual type of `a_type', given `a_context_type' and `a_context_class'.
		local
		    l_actual_type: TYPE_A
		do
		    l_actual_type := a_type.instantiation_in(a_context_type, a_context_class.class_id).deep_actual_type

			if attached {FORMAL_A} l_actual_type as l_formal then
			    if not l_formal.is_multi_constrained (a_context_class) then
					l_actual_type := l_formal.constrained_type (a_context_class)
				else
				    check multi_constrained_formal_not_supported: False end
				end
			end

			Result := l_actual_type
		ensure
			result_attached: Result /= Void
		end

end
