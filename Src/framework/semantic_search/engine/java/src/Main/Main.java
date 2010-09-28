/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package Main;
import java.io.File;

import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.Term;
import org.apache.lucene.store.Directory;
import org.apache.lucene.util.Version;
import org.apache.lucene.search.*;
import org.apache.lucene.search.Sort;
import org.apache.lucene.search.SortField;
import org.apache.lucene.search.BooleanClause.Occur;
import org.apache.lucene.store.FSDirectory;

public class Main {

    public Directory directory;
    public Main(String indexDir) {
        try {
         directory = FSDirectory.open (new File(indexDir));
        } catch (Exception e) {
            
        }
    }
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
            try{
                // Initialize the index.
                Main m = new Main("D:\\apps\\solr\\example\\solr\\data\\index");

                // Query for LINKED_LIST objects whose count is larger than 8, and whose cursor is_before
                BooleanQuery query1 = new BooleanQuery();
                query1.add(new BooleanClause(new TermQuery (new Term ("document_type", "object")), Occur.MUST));
                query1.add(new BooleanClause(new TermQuery (new Term (m.escapedString("b_prop_{LINKED_LIST [ANY]}.before"), "T")), Occur.MUST));
                query1.add(new BooleanClause(NumericRangeQuery.newIntRange(m.escapedString ("i_prop_{LINKED_LIST [ANY]}.count"), 2, 20, true, true), Occur.MUST));
                m.executeQuery(query1);

                // Query for LINKED_LIST objects whose count is larger than 8, and whose cursor is_before
                BooleanQuery query2 = new BooleanQuery();
                query2.add(new BooleanClause(new TermQuery (new Term ("document_type", "transition")), Occur.MUST));
                query2.add(new BooleanClause(NumericRangeQuery.newIntRange(m.escapedString ("i_by_{LINKED_LIST [ANY]}.count"), 1, 1, true, true), Occur.MUST));
                m.executeQuery(query2);
            }catch(Exception e) {
            }
	}

    // Execute query.
    public void executeQuery (BooleanQuery query) {
	try{

            IndexSearcher isearcher = new IndexSearcher(directory, true); // read-only=true

            ScoreDoc[] hits = isearcher.search(query, null, 5000).scoreDocs;
            System.out.println("-----------------------------------------------------------------------------------------");
            for(int i=0; i < hits.length; i++) {
                Document hitDoc = isearcher.doc(hits[i].doc);
                System.out.print(hits[i].score);
                System.out.print("\t");
                System.out.println(hitDoc.getField("content").stringValue());
            }
            System.out.println(hits.length);
            isearcher.close();

        }catch(Exception e) {
            System.out.println("Error");
            System.out.println (e.getMessage());
        }

        System.out.println("Finished. OK");
    }

    public String escapedString (String s) {
        String r1 = s.replaceAll(" ", "%20").
                      replaceAll("\\[", "%5B").
                      replaceAll("\\]", "%5D").
                      replaceAll("\\{", "%7B").
                      replaceAll("\\}", "%7D").
                      replaceAll("<", "%%3C").
                      replaceAll(">", "%%3E").
                      replaceAll("/", "%%2F").
                      replaceAll("\\+", "%%2B").
                      replaceAll("\\-", "%%2D").
                      replaceAll("~", "%%7E");
        System.out.println(r1);
        return r1;
    }
}
