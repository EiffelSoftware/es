deferred class
	METRIC_UTILITY

inherit
	QL_UTILITY

	QL_SHARED

	QL_VISITOR

feature -- QL Manipulation

	features_of_class (a_class : QL_CLASS) : LIST[FEATURE_I] is
			-- get all immediate features of a class and return it as
			-- a list
		require
			a_class_set: a_class /= Void
		local
			l_feature_factory : QL_FEATURE_CRITERION_FACTORY
			l_feature_criterion : QL_FEATURE_CRITERION
			l_feature_domain : QL_FEATURE_DOMAIN
		do
			l_feature_factory := a_class.feature_criterion_factory
			l_feature_criterion := l_feature_factory.simple_criterion_with_index (l_feature_factory.c_is_immediate)
			l_feature_domain ?= a_class.new_domain (l_feature_criterion.domain_generator (True, True))

			create {LINKED_LIST[FEATURE_I]} Result.make
			if l_feature_domain /= Void then
				from
					l_feature_domain.content.start
				until
					l_feature_domain.content.after
				loop
					if l_feature_domain.content.item.is_real_feature then
						Result.extend (l_feature_domain.content.item.e_feature.associated_feature_i)
					end
					l_feature_domain.content.forth
				end
			end
		ensure
			result_set : Result /= Void
		end

	classes_of_group (a_cluster : QL_GROUP) : LIST[CLASS_I] is
		local
			l_class_factory : QL_CLASS_CRITERION_FACTORY
			l_class_criterion : QL_CLASS_CRITERION
			l_class_domain : QL_CLASS_DOMAIN
		do
			l_class_factory := a_cluster.class_criterion_factory
			l_class_criterion := l_class_factory.simple_criterion_with_index (l_class_factory.c_true)
			l_class_domain ?= a_cluster.new_domain (l_class_criterion.domain_generator (True, True))

			Result := class_list (l_class_domain, Void)
		end

	abstract_classes_of_group (a_cluster : QL_GROUP) : LIST[CLASS_I] is
		local
			l_class_factory : QL_CLASS_CRITERION_FACTORY
			l_class_criterion : QL_CLASS_CRITERION
			l_class_domain : QL_CLASS_DOMAIN
		do
			l_class_factory := a_cluster.class_criterion_factory
			l_class_criterion := l_class_factory.simple_criterion_with_index (l_class_factory.c_is_deferred)
			l_class_domain ?= a_cluster.new_domain (l_class_criterion.domain_generator (True, True))

			Result := class_list (l_class_domain, Void)
		end

	lines_of_code_of_item (an_item : QL_ITEM) : INTEGER is
		local
			l_line_factory : QL_LINE_CRITERION_FACTORY
			l_line_criterion : QL_LINE_CRITERION
			l_line_domain : QL_LINE_DOMAIN
		do
			l_line_factory := an_item.line_criterion_factory
			l_line_criterion := l_line_factory.simple_criterion_with_index (l_line_factory.c_true)
			l_line_domain ?= an_item.new_domain (l_line_criterion.domain_generator (True, True))

			if l_line_domain /= Void then
				Result := l_line_domain.count
			end
		end

	client_classes (l_as : QL_CLASS) : LIST[CLASS_I] is
			-- returns a list of classes which all use the given class (client
			-- relation).
		local
			l_client_cri : QL_CLASS_CLIENT_RELATION_CRI
			l_class_domain_generator : QL_CLASS_DOMAIN_GENERATOR
			l_class_domain : QL_CLASS_DOMAIN
		do
			create l_client_cri.make (l_as.wrapped_domain, True, True, False)
			create l_class_domain_generator.make (l_client_cri, True)
			l_class_domain ?= system_target_domain.new_domain (l_class_domain_generator)

			Result := class_list (l_class_domain, Void)
		end

	supplier_classes (l_as : QL_CLASS) : LIST[CLASS_I] is
			-- returns a list of classes which this class uses (supplier
			-- relation).
		local
			l_client_cri : QL_CLASS_SUPPLIER_RELATION_CRI
			l_class_domain_generator : QL_CLASS_DOMAIN_GENERATOR
			l_class_domain : QL_CLASS_DOMAIN
		do
			create l_client_cri.make (l_as.wrapped_domain, True, True, False)
			create l_class_domain_generator.make (l_client_cri, True)
			l_class_domain ?= system_target_domain.new_domain (l_class_domain_generator)

			Result := class_list (l_class_domain, Void)
		end

	parent_classes (l_as : QL_CLASS) : LIST[CLASS_I] is
		local
			l_client_cri : QL_CLASS_ANCESTOR_RELATION_CRI
			l_class_domain_generator : QL_CLASS_DOMAIN_GENERATOR
			l_class_domain : QL_CLASS_DOMAIN
		do

			create l_client_cri.make (l_as.wrapped_domain, {QL_CLASS_ANCESTOR_RELATION_CRI}.parent_type)
			create l_class_domain_generator.make (l_client_cri, True)
			l_class_domain ?= system_target_domain.new_domain (l_class_domain_generator)

			Result := class_list (l_class_domain, l_as)
		end

	heir_classes (l_as : QL_CLASS) : LIST[CLASS_I] is
		local
			l_client_cri : QL_CLASS_DESCENDANT_RELATION_CRI
			l_class_domain_generator : QL_CLASS_DOMAIN_GENERATOR
			l_class_domain : QL_CLASS_DOMAIN
		do
			io.put_string ("here:"+l_as.name+"%N")
			create l_client_cri.make (l_as.wrapped_domain, {QL_CLASS_DESCENDANT_RELATION_CRI}.heir_type)
			create l_class_domain_generator.make (l_client_cri, True)
			l_class_domain ?= system_target_domain.new_domain (l_class_domain_generator)

			Result := class_list (l_class_domain, l_as)
		end

feature {METRIC} -- QL iterators

	process_real_features_in_class (l_as : QL_CLASS) is
			-- processes all real features in a cluster by calling the
			-- 'process_real_feature' feature, returning the number of
			-- processed features
		require
			l_as_set : l_as /= Void
		local
			list : LIST[FEATURE_I]
			real_feature : QL_REAL_FEATURE
		do
			list := features_of_class (l_as)

			from
				list.start
			until
				list.after
			loop
				real_feature ?= query_feature_item_from_e_feature(list.item.e_feature)
				if real_feature /= Void and then real_feature.is_real_feature then
					process_real_feature (real_feature)
				end

				list.forth
			end
		end

	process_classes_in_group (l_as : QL_GROUP) is
			-- processes all classes in a cluster by calling the
			-- 'process_class' feature, returning the number of
			-- processed features
		require
			l_as_set : l_as /= Void
		local
			list : LIST[CLASS_I]
			class_i : CLASS_I
		do
			list := classes_of_group (l_as)
			from
				list.start
			until
				list.after
			loop
				class_i := list.item
				if class_i /= Void and then class_i.is_compiled then
					process_class (query_class_item_from_class_i (class_i))
				end
				list.forth
			end
		end

feature {NONE} -- Implementation

	class_list (l_class_domain : QL_CLASS_DOMAIN; l_as: QL_CLASS) : LIST[CLASS_I] is
			-- if l_as /= Void then returned list contains unique names of classes
		do
			create {LINKED_LIST[CLASS_I]} Result.make
			if l_class_domain /= Void then
				from
					l_class_domain.content.start
				until
					l_class_domain.content.after
				loop
					if l_as = Void or not l_class_domain.content.item.is_equal (l_as) then
						Result.extend (l_class_domain.content.item.class_i)
					end
					l_class_domain.content.forth
				end
			end
		ensure
			result_set : Result /= Void
		end

end
