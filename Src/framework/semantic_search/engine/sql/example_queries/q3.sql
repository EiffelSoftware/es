/* 
Check if for HASH_TABLE.replace: t.replace (v, k), there is any test case such that in pre-state:
t.has (k)
*/

SELECT q.feature, q.content, q.qry_id, q.uuid
FROM
Queryables q, PropertyBindings1 t, PropertyBindings1 k, PropertyBindings2 p1
WHERE

/* feature = replace */
q.feature = "replace" AND
q.class = "HASH_TABLE"

/* target t */
AND
t.qry_id = q.qry_id AND
t.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
t.position = 0 AND
t.prop_kind = 2 AND

/* second argument k */
k.qry_id = q.qry_id AND
k.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
k.prop_kind = 2 AND   /* Precondition */
k.position = 2 AND

/* Precondition p1: t.has (k) */
p1.qry_id = q.qry_id AND
p1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.has ($)") AND
p1.var1 = t.var1 AND
p1.var2 = k.var1 AND
p1.value = 1 AND
p1.prop_kind = 2 


