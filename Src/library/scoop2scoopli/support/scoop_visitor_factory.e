indexing
	description: "Summary description for {SCOOP_VISITOR_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_VISITOR_FACTORY

inherit
	SCOOP_WORKBENCH
		export
			{NONE} all
		end

--create
--	make

feature -- Initialisation

--	make

feature -- Support visitors

	new_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR is
			-- Create a `SCOOP_FEATURE_NAME_VISITOR' object.
		local
			l_visitor: SCOOP_FEATURE_NAME_VISITOR
		do
			create l_visitor.make
			l_visitor.setup (class_as, match_list, true, true)
			Result := l_visitor
		end

	new_feature_name_visitor_for_class (a_class: CLASS_AS; a_list: LEAF_AS_LIST): SCOOP_FEATURE_NAME_VISITOR is
			-- Create a `SCOOP_FEATURE_NAME_VISITOR' object.
		local
			l_visitor: SCOOP_FEATURE_NAME_VISITOR
		do
			create l_visitor.make
			l_visitor.setup (a_class, a_list, true, true)
			Result := l_visitor
		end

	new_generics_visitor (a_context: ROUNDTRIP_CONTEXT): SCOOP_GENERICS_VISITOR is
			-- Create a `SCOOP_GENERICS_VISITOR' object.
		local
			l_visitor: SCOOP_GENERICS_VISITOR
		do
			create l_visitor.make_with_context (a_context)
			l_visitor.setup (class_as, match_list, true, true)
			Result := l_visitor
		end

	new_type_expr_visitor: SCOOP_TYPE_EXPR_VISITOR
		do
			create Result
			Result.setup (class_as, match_list, true, true)
		end

feature -- Client class generation

	new_client_printer: SCOOP_SEPARATE_CLIENT_PRINTER is
			-- Create a `SCOOP_SEPARATE_CLIENT_PRINTER' object.
		local
			l_visitor: SCOOP_SEPARATE_CLIENT_PRINTER
		do
			create l_visitor.make_with_default_context
			l_visitor.setup (class_as, match_list, true, true)
			Result := l_visitor
		end

	new_client_parent_visitor (a_context: ROUNDTRIP_CONTEXT): SCOOP_CLIENT_PARENT_VISITOR is
			-- Create a `SCOOP_CLIENT_PARENT_VISITOR' object.
		local
			l_visitor: SCOOP_CLIENT_PARENT_VISITOR
		do
			create l_visitor.make_with_context (a_context)
			l_visitor.setup (class_as, match_list, true, true)
			Result := l_visitor
		end

	new_client_feature_visitor (a_context: ROUNDTRIP_CONTEXT): SCOOP_CLIENT_FEATURE_VISITOR is
			-- Create a `SCOOP_CLIENT_FEATURE_VISITOR' object.
		local
			l_visitor: SCOOP_CLIENT_FEATURE_VISITOR
		do
			create l_visitor.make (a_context)
			l_visitor.setup (class_as, match_list, true, true)
			Result := l_visitor
		end

	new_client_argument_visitor_for_class (a_class: CLASS_AS; a_list: LEAF_AS_LIST): SCOOP_CLIENT_ARGUMENT_VISITOR is
			-- Create a `SCOOP_CLIENT_ARGUMENT_VISITOR' object.
		local
			l_visitor: SCOOP_CLIENT_ARGUMENT_VISITOR
		do
			create l_visitor
			l_visitor.setup (a_class, a_list, true, true)
			Result := l_visitor
		end

	new_client_feature_assertion_visitor (a_context: ROUNDTRIP_CONTEXT): SCOOP_CLIENT_FEATURE_ASSERTION_VISITOR is
			-- Create a `SCOOP_CLIENT_FEATURE_ASSERTION_VISITOR' object.
		local
			l_visitor: SCOOP_CLIENT_FEATURE_ASSERTION_VISITOR
		do
			create l_visitor.make_with_context (a_context)
			l_visitor.setup (class_as, match_list, true, true)
			Result := l_visitor
		end

	new_client_feature_lr_visitor (a_context: ROUNDTRIP_CONTEXT): SCOOP_CLIENT_FEATURE_LR_VISITOR is
			-- Create a `SCOOP_CLIENT_FEATURE_LR_VISITOR' object.
		local
			l_visitor: SCOOP_CLIENT_FEATURE_LR_VISITOR
		do
			create l_visitor.make (a_context)
			l_visitor.setup (class_as, match_list, true, true)
			Result := l_visitor
		end

	new_client_feature_er_visitor (a_context: ROUNDTRIP_CONTEXT): SCOOP_CLIENT_FEATURE_ER_VISITOR is
			-- Create a `SCOOP_CLIENT_FEATURE_ER_VISITOR' object.
		local
			l_visitor: SCOOP_CLIENT_FEATURE_ER_VISITOR
		do
			create l_visitor.make (a_context)
			l_visitor.setup (class_as, match_list, true, true)
			Result := l_visitor
		end

	new_client_feature_wc_visitor (a_context: ROUNDTRIP_CONTEXT): SCOOP_CLIENT_FEATURE_WC_VISITOR is
			-- Create a `SCOOP_CLIENT_FEATURE_WC_VISITOR' object.
		local
			l_visitor: SCOOP_CLIENT_FEATURE_WC_VISITOR
		do
			create l_visitor.make (a_context)
			l_visitor.setup (class_as, match_list, true, true)
			Result := l_visitor
		end

	new_client_feature_nsp_visitor (a_context: ROUNDTRIP_CONTEXT): SCOOP_CLIENT_FEATURE_NSP_VISITOR is
			-- Create a `SCOOP_CLIENT_FEATURE_NSP_VISITOR' object.
		local
			l_visitor: SCOOP_CLIENT_FEATURE_NSP_VISITOR
		do
			create l_visitor.make (a_context)
			l_visitor.setup (class_as, match_list, true, true)
			Result := l_visitor
		end

	new_client_feature_sp_visitor (a_context: ROUNDTRIP_CONTEXT): SCOOP_CLIENT_FEATURE_SP_VISITOR is
			-- Create a `SCOOP_CLIENT_FEATURE_SP_VISITOR' object.
		local
			l_visitor: SCOOP_CLIENT_FEATURE_SP_VISITOR
		do
			create l_visitor.make (a_context)
			l_visitor.setup (class_as, match_list, true, true)
			Result := l_visitor
		end

	new_client_feature_isp_visitor (a_context: ROUNDTRIP_CONTEXT): SCOOP_CLIENT_FEATURE_ISP_VISITOR is
			-- Create a `SCOOP_CLIENT_FEATURE_ISP_VISITOR' object.
		local
			l_visitor: SCOOP_CLIENT_FEATURE_ISP_VISITOR
		do
			create l_visitor.make (a_context)
			l_visitor.setup (class_as, match_list, true, true)
			Result := l_visitor
		end

	new_client_type_expr_visitor: SCOOP_CLIENT_TYPE_EXPR_VISITOR is
			-- Create a `SCOOP_CLIENT_TYPE_EXPR_VISITOR' object.
		local
			l_visitor: SCOOP_CLIENT_TYPE_EXPR_VISITOR
		do
			create l_visitor
			l_visitor.setup (class_as, match_list, true, true)
			Result := l_visitor
		end

	new_explicit_processor_specification_visitor(a_class: CLASS_C): SCOOP_EXPLICIT_PROCESSOR_SPECIFICATION_VISITOR is
			-- Create a `SCOOP_EXPLICIT_PROCESSOR_SPECIFICATION_VISITOR' object.
		require
			a_class_ast_not_void: a_class /= Void and then a_class.ast /= Void
		local
			l_visitor: SCOOP_EXPLICIT_PROCESSOR_SPECIFICATION_VISITOR
		do
			create l_visitor
			l_visitor.setup (a_class.ast,  match_list_server.item (a_class.class_id), true, true)
			Result := l_visitor
		end

feature -- Proxy class generation

	new_proxy_printer: SCOOP_SEPARATE_PROXY_PRINTER is
			-- Create a `SCOOP_SEPARATE_PROXY_PRINTER' object.
		local
			l_visitor: SCOOP_SEPARATE_PROXY_PRINTER
		do
			create l_visitor.make_with_default_context
			l_visitor.setup (class_as, match_list, true, true)
			Result := l_visitor
		end

	new_proxy_parent_visitor (a_context: ROUNDTRIP_CONTEXT): SCOOP_PROXY_PARENT_VISITOR is
			-- Create a `SCOOP_PROXY_PARENT_VISITOR' object.
		local
			l_visitor: SCOOP_PROXY_PARENT_VISITOR
		do
			create l_visitor.make_with_context (a_context)
			l_visitor.setup (class_as, match_list, true, true)
			Result := l_visitor
		end

	new_proxy_feature_visitor (a_context: ROUNDTRIP_CONTEXT): SCOOP_PROXY_FEATURE_VISITOR is
			-- Create a `SCOOP_PROXY_FEATURE_VISITOR' object.
		local
			l_visitor: SCOOP_PROXY_FEATURE_VISITOR
		do
			create l_visitor.make_with_context (a_context)
			l_visitor.setup (class_as, match_list, true, true)
			Result := l_visitor
		end

	new_proxy_type_attriute_wrapper_printer (a_context: ROUNDTRIP_CONTEXT): SCOOP_PROXY_TYPE_ATTRIBUTE_WRAPPER_PRINTER is
			-- Create a `SCOOP_PROXY_TYPE_ATTRIBUTE_WRAPPER_PRINTER' object.
		local
			l_visitor: SCOOP_PROXY_TYPE_ATTRIBUTE_WRAPPER_PRINTER
		do
			create l_visitor.make_with_context (a_context)
			l_visitor.setup (class_as, match_list, true, true)
			Result := l_visitor
		end

	new_proxy_type_local_printer (a_context: ROUNDTRIP_CONTEXT): SCOOP_PROXY_TYPE_LOCALS_PRINTER is
			-- Create a `SCOOP_PROXY_TYPE_LOCALS_PRINTER' object.
		local
			l_visitor: SCOOP_PROXY_TYPE_LOCALS_PRINTER
		do
			create l_visitor.make_with_context (a_context)
			l_visitor.setup (class_as, match_list, true, true)
			Result := l_visitor
		end

	new_proxy_type_signature_printer (a_context: ROUNDTRIP_CONTEXT): SCOOP_PROXY_TYPE_SIGNATURE_PRINTER is
			-- Create a `SCOOP_PROXY_TYPE_SIGNATURE_PRINTER' object.
		local
			l_visitor: SCOOP_PROXY_TYPE_SIGNATURE_PRINTER
		do
			create l_visitor.make_with_context (a_context)
			l_visitor.setup (class_as, match_list, true, true)
			Result := l_visitor
		end

feature {NONE} -- Match list

	match_list: LEAF_AS_LIST is
			-- Returns the current match list
		do
			Result := match_list_server.item (class_c.class_id)
		end

end
