indexing
	description: "[
				This class iterates over asts of classes, extracts the arguments to the translation functions from the i18n 
				library, generates appropriate PO_ENTRYs for them and adds them to a PO_FILE.
				To use it one should call set_po_file, set_translator, set_plural_translator and setup first.
				Then it is sufficient to do an process_node_as on the ast in question.
		]"
	author: "leof@student.ethz.ch"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_AST_ITERATOR
inherit
	AST_ROUNDTRIP_ITERATOR
	redefine
		process_access_feat_as,
		process_access_id_as
	end
	CHARACTER_ROUTINES

feature
	--PO file to insert results into
	po_file: PO_FILE
	--Routine IDs to search for
	translator: ID_SET
	plural: ID_SET

	set_translator(a: ID_SET) is
			-- set translator function routine is
			require
				a_not_void: a /= Void
			do
				translator := a
			ensure
				a_set: a.same_as (translator)
			end

	set_plural_translator(a: ID_SET) is
			-- set plural translator function routine id
			require
				a_not_void: a /= Void
			do
				plural := a
			ensure
				a_set: a.same_as (plural)
			end


		set_po_file(po:PO_FILE) is
				-- set the po file that results will be written into
			require
				po_not_void: po /= Void
			do
				po_file := po
			end




feature

	analyse_call(node: ACCESS_FEAT_AS) is
		local
			called_id: ID_SET
			param1: STRING_AS
			param2: STRING_AS
			plural_entry: PO_FILE_ENTRY_PLURAL
			temp:  STRING_32
		do
			called_id := node.routine_ids
			if called_id /= Void and then called_id.same_as (translator) then
				param1 ?= node.parameters.first
				if param1 /= Void then
					temp := eiffel_string_32(param1.value.as_string_32)
					temp.replace_substring_all("%%N", "\n")
					if (not po_file.has_entry(temp)) then
						po_file.add_entry (create {PO_FILE_ENTRY_SINGULAR}.make (temp))
					end
				end
			elseif called_id /= Void and then called_id.same_as (plural) then
				param1 ?= node.parameters.first
				param2 ?= node.parameters.i_th (node.parameters.index_set.lower+1) --should be 2d item :)
				if param1 /= Void and then param2 /= Void then
					temp := eiffel_string_32(param1.value.as_string_32)
					temp.replace_substring_all("%%N", "\n")
					if (not po_file.has_entry(temp)) then
						create plural_entry.make (temp)
						temp := eiffel_string_32(param2.value.as_string_32)
						temp.replace_substring_all("%%N","\n")
						plural_entry.set_msgid_plural (temp)
						po_file.add_entry (plural_entry)
					end
				end
			end
		end



	process_access_id_as(l_as: ACCESS_ID_AS) is
			-- eh?
			do
				analyse_call(l_as)
				safe_process (l_as.feature_name)
				safe_process (l_as.internal_parameters)
			end

	process_access_feat_as (l_as: ACCESS_FEAT_AS) is
			-- process a feature
			--what do we want from a feature?
			--it must be a feature call to feature i18n of SHARED_I18N_LOCALIZATOR
			--(check others later)
	do
		analyse_call(l_as)
		safe_process (l_as.feature_name)
		safe_process (l_as.internal_parameters)
	end


end
