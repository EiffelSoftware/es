/*
 * Class to parse a string based query for semantic document into Lucene query format.
 * The string based query consists of mutliple sections. Different sections are separated
 * by one or more empty lines. Each section has the following five components,
 * each in its own line:
 * Field name: valid field name
 * Field type: INTEGER, STRING
 * Value: When type is STRING, a string; when type is INTEGER, one or two integers, separated by ".."
 * Boost: a float
 * Occur: MUST, MUST_NOT, SHOULD
 */

package SemanticDocument;

import java.io.BufferedReader;
import java.io.StringReader;
import org.apache.lucene.index.Term;
import org.apache.lucene.search.BooleanClause;
import org.apache.lucene.search.BooleanQuery;
import org.apache.lucene.search.NumericRangeQuery;
import org.apache.lucene.search.TermQuery;

/**
 *
 * @author jasonw
 */
public class SemanticQueryTranslator {

    public SemanticQueryTranslator() {
    }

    /*
     * BooleanQuery from aStrQuery representing a query in a string.
     */
    public BooleanQuery booleanQueryFromStrings (String aStrQuery) {
        BooleanQuery query = new BooleanQuery();

        BufferedReader reader = new BufferedReader(new StringReader(aStrQuery));
        String line;
        String[] lines = new String[5];
        int i = 0;
        try {
          while ((line = reader.readLine()) != null) {
            if(line.isEmpty())
            {
                if(i==5) {
                    // We have one complete section.
                    addSectionInBooleanQuery(query, lines);
                    i = 0;
                } else {
                    // We don't have a complete section, ignore all the read lines.
                    i = 0;
                }
            } else {
                lines[i] = new String(line);
                i++;                
            }
          }
        }catch(Exception e) {
          e.printStackTrace();
        }

        return query;
    }

    /*
     * Add a query specified in aLines into aboolQuery.
     */
    private void addSectionInBooleanQuery (BooleanQuery aBoolQuery, String[] aLines) {
        String fieldName = aLines[0];
        String fieldType = aLines[1];
        String fieldValue = aLines[2];
        float fieldBoost = new Float(aLines[3]);
        
        BooleanClause.Occur fieldOccur;
        if(aLines[4].equals("MUST")) {
            fieldOccur = BooleanClause.Occur.MUST;
        } else if (aLines[4].equals("MUST_NOT")) {
            fieldOccur = BooleanClause.Occur.MUST_NOT;
        } else if (aLines[4].equals("SHOULD")) {
            fieldOccur = BooleanClause.Occur.SHOULD;
        } else {
            fieldOccur = BooleanClause.Occur.SHOULD;
        }

        if(fieldType.equals("STRING")) {
            Term term = new Term(fieldName, fieldValue);
            TermQuery termQuery = new TermQuery(term);
            termQuery.setBoost(fieldBoost);
            aBoolQuery.add(termQuery, fieldOccur);
        } else if (fieldType.equals("INTEGER")) {
            String[] values = fieldValue.split("..");
            String lower;
            String upper;
            if(values.length == 1) {
                lower = values[0];
                upper = values [0];
            } else {
                lower = values [0];
                upper = values [1];
            }
            NumericRangeQuery nquery = NumericRangeQuery.newIntRange(fieldName, new Integer (lower), new Integer (upper), true, true);
            nquery.setBoost(fieldBoost);
            aBoolQuery.add(nquery, fieldOccur);
        }        
    }
}
