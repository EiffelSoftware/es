indexing
	description: "Summary description for {SCOOP_WORKBENCH_OBJECTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_WORKBENCH_OBJECTS

create
	make

feature -- Initialization

	make
			-- Initialize the SCOOP workbench objects
		do
			create proxy_parent_objects.make
			create parent_redefine_list.make
		end

feature -- Access

	reset is
			-- Resets classdependant values
		do
			current_class_as := Void
			current_class_c := Void
			current_feature_as := Void
			current_feature_object := Void
			proxy_parent_objects.wipe_out
			parent_redefine_list.wipe_out
			if proxy_infix_prefix_wrappers /= Void then
				proxy_infix_prefix_wrappers.wipe_out
			end
		end

feature -- Current CLASS_C access

	current_class_c: CLASS_C
		-- Current processed class_c - access from shared scoop workbench

	set_current_class_c (a_class: CLASS_C) is
			-- Setter for 'current_class_c'
		do
			current_class_c := a_class
		end

feature -- Current CLASS_AS access

	current_class_as: CLASS_AS
		-- Current processed class_as - access from shared scoop workbench

	set_current_class_as (a_class: CLASS_AS) is
			-- Setter for 'current_class_as'
		do
			current_class_as := a_class
		end

feature -- Current FEATURE_AS access

	current_feature_as: FEATURE_AS
		-- Current processed feature_as

	set_current_feature_as (a_feature: FEATURE_AS) is
			-- Setter for 'current_feature_as'
		do
			current_feature_as := a_feature
		end

feature -- Current FEATURE_CLAUSE_AS access

	current_feature_clause_as: FEATURE_CLAUSE_AS
		-- Current processed feature_clause_as

	set_current_feature_clause_as (a_feature_clause: FEATURE_CLAUSE_AS) is
			-- Setter for 'current_feature_clause_as'
		do
			current_feature_clause_as := a_feature_clause
		end

feature -- Current FEATURE_CLAUSE_AS access

	is_first_feature: BOOLEAN
		-- Indicates the first occurence of a feature in a feature clause

	set_is_first_feature (a_value: BOOLEAN) is
			-- Setter for 'is_first_feature'
		do
			is_first_feature := a_value
		end

feature -- SCOOP_SEPARATE_CLASS_LIST access

	scoop_classes: SCOOP_SEPARATE_CLASS_LIST
			-- contains all classes which have to be processed.

	set_scoop_classes (a_list: SCOOP_SEPARATE_CLASS_LIST) is
			-- Setter for 'scoop_class_list'
		do
			scoop_classes := a_list
		end

feature -- SCOOP_CLIENT_FEATURE_OBJECT access

	current_feature_object: SCOOP_CLIENT_FEATURE_OBJECT
			-- Reference to current feature object

	set_current_feature_object (a_feature_object: SCOOP_CLIENT_FEATURE_OBJECT) IS
			-- Setter for `current_feature_object'.
		do
			current_feature_object := a_feature_object
		end

feature -- SCOOP proxy feature name access

	current_proxy_feature_name: STRING
			-- Name of current processed feature

	set_current_proxy_feature_name (a_name: STRING)
			-- Setter for `current_proxy_feature_name'
		do
			current_proxy_feature_name := a_name
		end

feature -- SCOOP_PROXY_PARENT_OBJECT access

	add_proxy_parent_object (a_proxy_parent_object: SCOOP_PROXY_PARENT_OBJECT) is
			-- Adds `a_proxy_parent_object' to the `proxy_parent_objects'.
		require
			a_proxy_parent_object_not_void: a_proxy_parent_object /= Void
		do
			if not has_proxy_parent_object (a_proxy_parent_object.parent_name) then
				proxy_parent_objects.extend (a_proxy_parent_object)
			end
		end

	get_proxy_parent_object (a_parent_name: STRING): SCOOP_PROXY_PARENT_OBJECT is
			-- Get the proxy parent object with name `a_parent_name'.
		require
			a_parent_name_not_void: a_parent_name /= Void
		local
			i, nb: INTEGER
		do
			from
				i := 1
				nb := proxy_parent_objects.count
			until
				i > nb
			loop
				if proxy_parent_objects.i_th (i).parent_name.is_equal (a_parent_name) then
					Result := proxy_parent_objects.i_th (i)
				end
				i := i + 1
			end
		end

	has_proxy_parent_object (a_parent_name: STRING): BOOLEAN is
			-- Returns true if there is already a parent object
			-- with name `a_parent_name' in the list
		require
			a_parent_name_not_void: a_parent_name /=  Void
		local
			i, nb: INTEGER
		do
			from
				i := 1
				nb := proxy_parent_objects.count
			until
				i > nb
			loop
				if proxy_parent_objects.i_th (i).parent_name.is_equal (a_parent_name) then
					Result := True
				end
				i := i + 1
			end
		end

	append_parent_redefine_list (a_list: like parent_redefine_list) is
			-- Setter for `parent_redefine_list'.
		require
			a_list_not_void: a_list /= Void
		do
			parent_redefine_list.append (a_list)
		end

	insert_redefine_statement (an_original_feature_name, an_original_alias_name, a_feature_name: STRING; a_string_context: ROUNDTRIP_STRING_LIST_CONTEXT) is
			-- Insert a redefine statement for the assigner wrapper feature
			-- if `an_original_feature_name' is in the parent redefine list.
		require
			an_original_feature_name_not_void: an_original_feature_name /= Void
		local
			i, nb: INTEGER
			l_str: STRING
			l_parent_object: SCOOP_PROXY_PARENT_OBJECT
			l_tuple: TUPLE [orignial_feature_name, original_feature_alias_name: STRING; parent_object: SCOOP_PROXY_PARENT_OBJECT ]
		do
			from
				i := 1
				nb := parent_redefine_list.count
			until
				i > nb
			loop
				l_tuple := parent_redefine_list.i_th (i)
				if l_tuple.orignial_feature_name.is_equal (an_original_feature_name)
					or l_tuple.original_feature_alias_name.is_equal (an_original_alias_name) then
					-- get parent object
					l_parent_object := l_tuple.parent_object

					-- create redefine string
					create l_str.make_from_string (a_feature_name + "_scoop_separate_assigner_")

					-- insert a redefine feature for the wrapper feature
					l_parent_object.add_redefine_clause (l_str, a_string_context)
				end

				i := i + 1
			end
		end

feature -- SCOOP proxy infix prefix wrapper feature

	proxy_infix_prefix_wrappers: LINKED_LIST [STRING]
			-- List of new created wrapper features
			-- Remove this item with EiffelStudio 6.4

	extend_proxy_infix_prefix_wrappers (a_wrapper: STRING) is
			-- Adds the wrapper feature tot he wrapper list
			-- Remove this item with EiffelStudio 6.4
		do
			if proxy_infix_prefix_wrappers = Void then
				create proxy_infix_prefix_wrappers.make
			end
			proxy_infix_prefix_wrappers.extend (a_wrapper)
		end

feature {NONE} -- SCOOP_CLIENT_FEATURE_OBJECT implementation

	proxy_parent_objects: LINKED_LIST[SCOOP_PROXY_PARENT_OBJECT]
			-- List of proxy parent objects

	parent_redefine_list: LINKED_LIST [TUPLE [orignial_feature_name, original_feature_alias_name: STRING; parent_object: SCOOP_PROXY_PARENT_OBJECT ]]
			-- List of redefine features with corresponding parent object.

invariant
	proxy_parent_objects_not_void: proxy_parent_objects /= Void

end
