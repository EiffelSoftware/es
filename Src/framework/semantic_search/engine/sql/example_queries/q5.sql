/* 
Check if for HASH_TABLE.merge: t.merge(other), there is a test case such that in pre-state:
there exists a key k such that:
t.has (k)
other.has (k)
t.item (k) /= o.item (k)

Result: Yes, there are test cases satisfying such criteria

*/

SELECT q.feature, q.content, q.qry_id, q.uuid, t.var1 as "t_id", t.position as "t_position", other.position as "other_position", other.var1 as "other_id", k.var1 as "k_id", p3.value as "t.item(k)", p4.value as "other.item(k)"
FROM
Queryables q, PropertyBindings1 t, PropertyBindings1 other, PropertyBindings1 k, PropertyBindings2 p1, PropertyBindings2 p2, PropertyBindings2 p3, PropertyBindings2 p4
WHERE

/* feature = merge */
q.feature = "merge" AND
q.class = "HASH_TABLE"

/* target t */
AND
t.qry_id = q.qry_id AND
t.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
t.position = 0 AND
t.prop_kind = 2 

/* argument other */
AND
other.qry_id = q.qry_id AND
other.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
other.position = 1 AND
other.prop_kind = 2 

/* t /= other */
AND
t.value != other.value 

/* Key object k */
AND
k.qry_id = q.qry_id AND
k.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
k.prop_kind = 2 

/* Property p1: t.has (k) */
AND
p1.qry_id = q.qry_id AND
p1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.has ($)") AND
p1.prop_kind = 2 AND
p1.var1 = t.var1 AND
p1.var2 = k.var1 AND
p1.value = 1

/* Property p2: other.has (k) */
AND
p2.qry_id = q.qry_id AND
p2.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.has ($)") AND
p2.prop_kind = 2 AND
p2.var1 = other.var1 AND
p2.var2 = k.var1 AND
p2.value = 1

/* Property p3: t.item (k) */
AND
p3.qry_id = q.qry_id AND
p3.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.item ($)") AND
p3.prop_kind = 2 AND
p3.var1 = t.var1 AND
p3.var2 = k.var1

/* Property p4: other.item (k) */
AND
p4.qry_id = q.qry_id AND
p4.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.item ($)") AND
p4.prop_kind = 2 AND
p4.var1 = other.var1 AND
p4.var2 = k.var1 AND

/* t.item (k) /= other.item (k) */
((p3.value_type_kind != p4.value_type_kind) OR (p3.value_type_kind = p4.value_type_kind AND p3.value != p4.value))



