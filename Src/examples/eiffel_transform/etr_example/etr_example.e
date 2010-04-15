class
	ETR_EXAMPLE

inherit
	ETR_SHARED_CONSTANTS
	ETR_SHARED_OPERATORS
	ETR_SHARED_TOOLS
	ETR_SHARED_FACTORIES
	ETR_SHARED_PARSERS

create
	make

feature {NONE} -- Creation

	make
			-- Run application.
		local
			l_class, l_attr: ETR_TRANSFORMABLE
			l_first_feature: AST_PATH
		do
			-- Use parsers without a compiler factory since there is no loaded project
			parsing_helper.set_compiler_factory (false)

			-- Parse `example_class' into CLASS_AS
			etr_class_parser.parse_from_string (example_class, void)

			-- Create a transformable, no need to duplicate
			create l_class.make (etr_class_parser.root_node, context_factory.new_empty_context, false)

			-- Instrument the class
			instrument_class (l_class)

			-- Get the first feature, i.e. `attr'
			create l_first_feature.make_from_string(c_first_feature)
			path_tools.find_node (l_first_feature, l_class)

			-- Create the transformable for the feature.
			-- This time duplicate so the paths in `l_class' won't be changed
			create l_attr.make (path_tools.last_ast, context_factory.new_empty_context, true)

			-- Set `set_attr' as assigner for `attr'
			set_assigner (l_attr, "set_attr")

			-- Now replace the old attr in `l_class'
			l_class.apply_modification (basic_operators.replace (l_first_feature, l_attr))

			-- Print the resulting class
			io.put_string (l_class.out)
		end

feature -- Constants

	example_class: STRING = "{
	class
		EXAMPLE
	feature
		attr: STRING
		
		set_attr (a: STRING)
			do
				attr := a
			end
	
		f1
			do
				ins1
				ins2
				ins3
			end
			
		f2
			do
				if a>b then
					ins1
				else
					ins2
				end
			end
	end
	}"

feature -- Example operators

	set_assigner (a_attribute: ETR_TRANSFORMABLE; a_name: STRING)
				-- Set `a_name' as assigner for `a_attribute'
				-- Example from 11.1.1
		local
			path: AST_PATH
			mod: ETR_AST_MODIFICATION
		do
			create path.make_from_string (f_assigner)
			mod := basic_operators.replace_with_string (path, a_name)
			a_attribute.apply_modification (mod)
		end

	instrument_class (a_class: ETR_TRANSFORMABLE)
				-- Instrument a `a_class' to call {LOGGER}.log in every feature
				-- Example from 11.1.2
		local
			mods: LINKED_LIST[ETR_AST_MODIFICATION]
			feature_list: LIST[FEATURE_AS]
			path, list_path: AST_PATH
		do
			create mods.make
			create list_path.make_from_string (c_conforming_parent_list)
			mods.extend (basic_operators.list_append_text (list_path, "LOGGER"))
			feature_list := ast_tools.feature_list (a_class)
			from
				feature_list.start
			until
				feature_list.after
			loop
				create path.make_subpath (
					feature_list.item.path,
			 		f_instruction_list
				)
				mods.extend (
					basic_operators.list_prepend_text (
						path,
						"log(%"Entering feature "+feature_list.item.feature_name.name +"%")"
					)
				)
				feature_list.forth
			end
			a_class.apply_modifications (mods)
		end
end
