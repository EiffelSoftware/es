/* 
Check if for HASH_TABLE.merge: t.merge(other), there is a test case such that in pre-state:
t = other

Result: No, there is no such test case.

*/

SELECT q.feature, q.content, q.qry_id, q.uuid, t.var1 as "t_id", other.var1 as "other_id"
FROM
Queryables q, PropertyBindings1 t, PropertyBindings1 other, PropertyBindings1 k
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

/* t = other */
AND
t.var1 = other.var1
