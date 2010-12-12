SELECT q.class, q.feature, q.fault_signature, p2.value as "a.lower", p3.value as "a.upper", i.value as "i", q.hit_breakpoints

FROM
Queryables q, PropertyBindings1 a, PropertyBindings1 p1, PropertyBindings1 p2, PropertyBindings1 p3, PropertyBindings1 i

WHERE
q.class = "ARRAY" AND
q.feature = "force"
AND (q.fault_signature = "ARRAY.force.c4.b27" OR q.fault_signature IS NULL)


/* Target v */
AND
a.qry_id = q.qry_id AND
a.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
a.prop_kind = 2 AND
a.position = 0

/* argument i */
AND
i.qry_id = q.qry_id AND
i.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
i.prop_kind = 2 AND
i.position = 2

/* Property in pre-state: p1: v.empty_area */
AND
p1.qry_id = q.qry_id AND
p1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.empty_area") AND
p1.prop_kind = 2 AND
p1.var1 = a.var1 AND
p1.value = 0

/* Property in pre-state: p2: a.lower */
AND
p2.qry_id = q.qry_id AND
p2.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.lower") AND
p2.prop_kind = 2 AND
p2.var1 = a.var1

/* Property in pre-state: p3: a.upper */
AND
p3.qry_id = q.qry_id AND
p3.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.upper") AND
p3.prop_kind = 2 AND
p3.var1 = a.var1