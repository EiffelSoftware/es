/* Select all interface properties with 2 operands for LINKED_LIST.extend. */

SELECT 
p.text, v1.position as "v1.position", v2.position as "v2.position", v1.prop_kind as "v1.prop_kind", v2.prop_kind as "v2.prop_kind", p1.prop_kind as "p1.prop_kind",
CONCAT(CAST(p1.prop_kind AS CHAR(1)), '_', p.text, '_', CAST(v1.position AS CHAR(1)), '_', CAST(v2.position AS CHAR(1))) as "id"   /* Property identifier which includes prop_kind, prop_text, v1_position and v2_position */

FROM
Queryables q, PropertyBindings2 p1, PropertyBindings1 v1, PropertyBindings1 v2, Properties p

WHERE
/* Match feature LINKED_LIST.extend */
q.class = "LINKED_LIST" AND
q.feature = "extend"

/* The first operand v1 */
AND
v1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND   /* Property text */
v1.qry_id = q.qry_id AND 
(v1.position BETWEEN 0 AND q.operand_count - 1)  /* Match v1 iff it is an interface operand. */


/* Operand v2 */
AND
v2.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
v2.qry_id = q.qry_id AND
(v2.position BETWEEN 0 AND q.operand_count - 1)  /* Match v2 iff it is an interface operand. */

/* The property */
AND
p1.qry_id = q.qry_id AND
p1.var1 = v1.var1 AND  /* The first operand of the property must be v1 */
p1.var2 = v2.var1      /* The second operand of the property must be v2 */

AND
p1.prop_id = p.prop_id AND
v1.prop_kind = v2.prop_kind  AND /* v1, v2 must appear in the same zone (precondition, postcondition) */
((v1.prop_kind = 2 AND p1.prop_kind = 2) OR (p1.prop_kind >=3 AND v1.prop_kind = 3))

GROUP BY id




