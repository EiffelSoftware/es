note
	description : "Provide JavaScript translation relevant information about the classes in the universe."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	JSC_CLASS_INFORMER

inherit

	SHARED_JSC_CONTEXT
		export {NONE} all end

	SHARED_SERVER
		export {NONE} all end

	INTERNAL_COMPILER_STRING_EXPORTER
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize object
		do
			reset
		end

feature -- Status Report

	reset
		do
			create native_stubs.make (100)
			native_stubs.compare_objects

			create eiffel_base_redirect.make (10)
			eiffel_base_redirect.compare_objects

			create {LINKED_SET[INTEGER]}native_class_ancestors.make
			create {LINKED_SET[INTEGER]}stubs.make
			create {LINKED_SET[INTEGER]}fictive_stubs.make

			create find_class_named_cache.make(10)
		end

	is_native_stub (a_class_id: INTEGER): BOOLEAN
			-- A native stub with a qualified name of the native JavaScript class
		do
			Result := native_stubs.has (a_class_id)
		end

	is_fictive_stub (a_class_id: INTEGER): BOOLEAN
		do
			Result := fictive_stubs.has (a_class_id) or is_native_stub(a_class_id)
		end

	is_stub (a_class_id: INTEGER): BOOLEAN
		do
			Result := stubs.has (a_class_id) or is_fictive_stub(a_class_id)
		end

	is_ancestor_of_native_type (a_class_id: INTEGER): BOOLEAN
		do
			Result := native_class_ancestors.has (a_class_id)
		end

	eiffel_base_redirect_to (a_eiffel_base_class_name: attached STRING): attached STRING
			-- Name of the class which implements `a_eiffel_base_class_name' in JavaScript world.
		do
			if attached eiffel_base_redirect[a_eiffel_base_class_name] as safe_base_redirect then
				Result := safe_base_redirect
			else
				Result := "EIFFEL_" + a_eiffel_base_class_name
			end
		end

feature -- Basic Operation

	add_native_stub (a_class_id: INTEGER; a_native_name: attached STRING)
			-- A native stub with a qualified name of the native JavaScript class
		require
			not_added_before: not is_stub (a_class_id)
		do
			native_stubs.put (a_native_name, a_class_id)
		ensure
			is_native_stub: is_native_stub (a_class_id)
			is_fictive_stub: is_fictive_stub (a_class_id)
			is_stub: is_stub (a_class_id)
		end

	get_native_stub (a_class_id: INTEGER): attached STRING
			-- Get the qualified name of the native JavaScript class for a native stub
		require
			is_native_stub: is_native_stub (a_class_id)
		local
			l_result: STRING
		do
			l_result := native_stubs.at (a_class_id)
			check l_result /= Void end

			Result := l_result
		end

	add_fictive_stub (a_class_id: INTEGER)
			-- A native stub without a qualified name of the native JavaScript class. Think 'placeholder'.
		require
			not_added_before: not is_stub (a_class_id)
		do
			fictive_stubs.put (a_class_id)
		ensure
			is_fictive_stub: is_fictive_stub (a_class_id)
			is_stub: is_stub (a_class_id)
		end

	add_stub (a_class_id: INTEGER)
			-- A stub
		require
			not_added_before: not is_stub (a_class_id)
		do
			stubs.put (a_class_id)
		ensure
			is_stub: is_stub (a_class_id)
		end

	add_ancestor_of_native_type (a_class_id: INTEGER)
		do
			native_class_ancestors.put (a_class_id)
		ensure
			is_ancestor_of_native_type: is_ancestor_of_native_type(a_class_id)
		end

	add_eiffel_base_redirect (a_class_name: attached STRING; eiffel_base_names: attached LIST[attached STRING])
		local
			l_str: STRING
		do
			from
				eiffel_base_names.start
			until
				eiffel_base_names.after
			loop
				create l_str.make_from_string (eiffel_base_names.item)
				l_str.left_adjust
				l_str.right_adjust
				eiffel_base_redirect.put (a_class_name, l_str)

				eiffel_base_names.forth
			end
		end

feature -- Basic Operation

	find_class_named_cache: attached HASH_TABLE[CLASS_C, attached STRING]
	find_class_named (a_class_name: attached STRING): CLASS_C
			-- Find `a_class_name' in universe.
		local
			i: INTEGER
			l_found: CLASS_C
			l_system: SYSTEM_I
			l_classes: CLASS_C_SERVER
			l_class_name: STRING
		do
			if not find_class_named_cache.has (a_class_name) then
				l_system := system
				check l_system /= Void end

				l_classes := l_system.classes
				check l_classes /= Void end

				from
					i := l_classes.lower
				until
					i >= l_classes.upper or l_found /= Void
				loop
					if attached l_classes.item (i) as safe_class then
						l_class_name := safe_class.name_in_upper
						check l_class_name /= Void end

						if l_class_name.is_equal (a_class_name) then
							l_found := safe_class
						end
					end

					i := i + 1
				end

				find_class_named_cache[a_class_name] := l_found
			end

			Result := find_class_named_cache[a_class_name]
		end

	is_eiffel_base_class (a_class: attached CLASS_C): BOOLEAN
		local
			l_class: CLASS_I
			l_namespace: STRING
		do
			l_class := a_class.original_class
			check l_class /= Void end

			l_namespace := l_class.actual_namespace
			check l_namespace /= Void end

			Result := l_namespace.starts_with ("EiffelSoftware.Library.Base")
		end

	redirect_class (a_class: attached CLASS_C): attached CLASS_C
			-- Redirect `a_class' to equivalent JavaScript class if `a_class' belongs to EiffelBase
		local
			l_original_class_name: STRING
			l_class_name: STRING
		do
			l_original_class_name := a_class.name_in_upper
			check l_original_class_name /= Void end

			if is_eiffel_base_class (a_class) then
				l_class_name := eiffel_base_redirect_to (l_original_class_name)
				if attached find_class_named (l_class_name) as safe_class then
					Result := safe_class
				else
					jsc_context.add_error ("Missing EiffelBase class equivalent: " + l_class_name, "What to do: Make sure you have a class named " + l_class_name + "%N" +
						"  in your universe or remove dependency to " + l_original_class_name)

					Result := a_class
				end
			else
				Result := a_class
			end
		end

	redirect_feature (a_class: attached CLASS_C; a_feature: attached FEATURE_I) : attached FEATURE_I
			-- Redirect `a_class'.`a_feature' to equivalent JavaScript class.feature if `a_class' belongs to EiffelBase.
		local
			l_redirect_class: attached CLASS_C
			l_redirect_class_name: STRING
			l_feature_name: STRING
		do
			l_redirect_class := redirect_class (a_class)

			if l_redirect_class.class_id /= a_class.class_id then
				if attached l_redirect_class.feature_named (a_feature.feature_name) as safe_feature then
					if attached safe_feature.written_class as safe_written_class and then safe_written_class.is_class_any then
						l_feature_name := a_feature.feature_name
						check l_feature_name /= Void end

						l_redirect_class_name := l_redirect_class.name_in_upper
						check l_redirect_class_name /= Void end

						jsc_context.add_error ("Missing EiffelBase feature equivalent: " + l_redirect_class_name + "." + l_feature_name, "What to do: Make sure you have a feature named `" +
							l_feature_name + "'%N" + " in class " + l_redirect_class_name)
					end
					Result := safe_feature
				else
					l_feature_name := a_feature.feature_name
					check l_feature_name /= Void end

					l_redirect_class_name := l_redirect_class.name_in_upper
					check l_redirect_class_name /= Void end

					jsc_context.add_error ("Missing EiffelBase feature equivalent: " + l_redirect_class_name + "." + l_feature_name, "What to do: Make sure you have a feature named `" +
						l_feature_name + "'%N" + " in class " + l_redirect_class_name)

					Result := a_feature
				end
			else
				Result := a_feature
			end
		end

feature {NONE} -- Implementation

	native_stubs: attached HASH_TABLE[attached STRING, INTEGER]

	fictive_stubs: attached SET[INTEGER]

	stubs: attached SET[INTEGER]

	native_class_ancestors: attached SET[INTEGER]

	eiffel_base_redirect: attached HASH_TABLE[attached STRING, attached STRING]

end
