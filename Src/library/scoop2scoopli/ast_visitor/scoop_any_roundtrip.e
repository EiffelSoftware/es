indexing
	description: "Summary description for {SCOOP_ANY_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_ANY_ROUNDTRIP

inherit
	COMPILER_EXPORTER

	AST_ROUNDTRIP_PRINTER_VISITOR
		redefine
			process_feature_clause_as
		end

create
	make_with_default_context

feature

	process
		do
			process_ast_node (parsed_class)
		end

	process_feature_clause_as (fc_as : FEATURE_CLAUSE_AS )
		do
			if has_default_create (fc_as) then

				if fc_as.clients /= Void and then fc_as.clients.clients /= Void then
					fc_as.clients.clients.remove_text (match_list)
	--				fc_as.clients.clients.set_rcurly_symbol (Void)
				end
--				fc_as.clients.remove_text (match_list)

				safe_process (fc_as.feature_keyword)
--				if fc_as.clients /= Void and then fc_as.clients.is_text_available (match_list) then
					safe_process (fc_as.clients)
--				end
				safe_process (fc_as.features)
			else
				Precursor (fc_as)
--				safe_process (fc_as.feature_keyword)
--				if fc_as.clients /= Void and then fc_as.clients.is_text_available (match_list) then
--					safe_process (fc_as.clients)
--				end
--				safe_process (fc_as.features)
			end
		end


feature {NONE}
	skip_these_clients : BOOLEAN
	first_sym : BOOLEAN

	remove_none_client (fc_as : FEATURE_CLAUSE_AS)
		local
			clients : CLASS_LIST_AS
		do
			clients := fc_as.clients.clients

			from
				clients.start
			until
				clients.after
			loop
				if clients.item.name.is_equal ("NONE") then
					clients.remove
				else
					clients.forth
				end
			end
		end


		-- replace this with `has_feature_name' from FEATURE_CLAUSE_AS
	has_default_create (fc_as : FEATURE_CLAUSE_AS) : BOOLEAN
		require
			fc_as /= Void
			fc_as.features /= Void
		do
			Result := fc_as.features.there_exists (agent name_is_equal_def_create)
		ensure
			Result = fc_as.features.there_exists (agent name_is_equal_def_create)
		end

	name_is_equal_def_create (f : FEATURE_AS) : BOOLEAN
		require
			f /= Void
		do
			Result := f.feature_name.name.is_equal (def_create_string)
		ensure
			Result = f.feature_name.name.is_equal (def_create_string)
		end

	def_create_string : STRING = "default_create"

end
