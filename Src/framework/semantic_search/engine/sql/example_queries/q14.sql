SELECT q.class, q.feature
FROM Queryables q, PropertyBindings1 p1

WHERE 
q.class = "LINKED_LIST"

AND
p1.qry_id = q.qry_id AND
p1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.is_empty") AND   /* Property text */
p1.prop_kind = 4 AND
p1.value = 1