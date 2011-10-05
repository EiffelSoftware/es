class
  SSA_GET_SUPPLIERS

inherit
  SSA_SHARED

feature
  fetch_suppliers (a_class: CLASS_C): ARRAYED_LIST [CLASS_C]
    local
      seen: ARRAYED_SET [CLASS_C]
      sorter: DS_TOPOLOGICAL_SORTER [CLASS_C]
    do
      create sorter.make_default
      create seen.make (10)
      seen.compare_objects

      sorter.put (a_class)
      sort_supplier (a_class, seen, sorter)
      sorter.sort

      create Result.make_from_array (seen.to_array) -- sorter.sorted_items.to_array)
    end

feature {NONE} -- Implementation
  sort_supplier (a_class: CLASS_C;
                 seen: ARRAYED_SET [CLASS_C];
                 sorter: DS_TOPOLOGICAL_SORTER [CLASS_C]
                 )
    local
      s: SUPPLIER_INFO
      supps: SUPPLIER_LIST
    do
      if not seen.has (a_class) then
        seen.extend (a_class)

        from
          supps := a_class.suppliers
          supps.start
        until
          supps.after
        loop
          s := supps.item
          if not s.supplier.is_basic and
             not ignored_class (s.supplier) and
             not s.supplier.is_equal (a_class) then
            sorter.force_relation (s.supplier, a_class)
            sort_supplier (s.supplier, seen, sorter)
          end
          supps.forth
        end
      end
    end
end
