/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package Main;
import javax.management.Query;

import org.apache.lucene.*;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.NumericField;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.Term;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TermQuery;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.RAMDirectory;
import org.apache.lucene.util.Version;
import org.apache.lucene.search.*;
import org.apache.lucene.search.BooleanClause.Occur;

/**
 *
 * @author jasonw
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
		try{
		    StandardAnalyzer analyzer = new StandardAnalyzer(Version.LUCENE_30);

		    // Store the index in memory:
		    Directory directory = new RAMDirectory();
		    IndexWriter iwriter = new IndexWriter(directory, analyzer, true, new IndexWriter.MaxFieldLength(25000));

		    // Create a document representing `extend'.
		    Document doc = null;

		    doc = new Document();
		    doc.add(new Field ("post::{LINKED_LIST}.isfirst", "True", Field.Store.NO, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
		    doc.add(new Field ("post::{LINKED_LIST}.is_empty", "False", Field.Store.NO, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
		    doc.add(new Field ("content", "start", Field.Store.YES, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
		    iwriter.addDocument(doc);

		    doc = new Document();
		    doc.add(new Field ("post::{LINKED_LIST}.has({ANY})", "True", Field.Store.NO, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
		    doc.add(new Field ("post::{LINKED_LIST}.is_empty", "False", Field.Store.NO, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
		    doc.add(new Field ("content", "put_first", Field.Store.YES, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
		    iwriter.addDocument(doc);

		    doc = new Document();
		    doc.add(new Field ("post::{LINKED_LIST}.has({ANY})", "True", Field.Store.NO, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
		    doc.add(new Field ("post::{LINKED_LIST}.is_empty", "False", Field.Store.NO, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
		    doc.add(new Field ("post::{LINKED_LIST}.last", "{ANY}", Field.Store.NO, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
		    doc.add(new Field ("content", "extend", Field.Store.YES, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
		    iwriter.addDocument(doc);

		    doc = new Document();
		    doc.add(new Field ("post::{LINKED_LIST}.has({ANY})", "True", Field.Store.NO, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
		    doc.add(new Field ("post::{1}.  has({3})", "True", Field.Store.NO, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
		    doc.add(new Field ("content", "foo", Field.Store.YES, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
		    NumericField nf;
		    nf = new NumericField ("count");
		    nf.setIntValue(1);
		    doc.add(nf);
		    nf = new NumericField ("count");
		    nf.setIntValue(2);
		    doc.add(nf);
		    iwriter.addDocument(doc);

		    iwriter.close();

		    // Query for the document.
		    // Now search the index:
		    IndexSearcher isearcher = new IndexSearcher(directory, true); // read-only=true

		    //Term term1 = new Term("post::{LINKED_LIST}.is_empty", "False");
		    //Term term2 = new Term("post::{LINKED_LIST}.has({ANY})" , "True");
		    //Term term3 = new Term("post::{LINKED_LIST}.last" , "{ANY}");

		    //Term term1 = new Term("post::{LINKED_LIST}.is_empty", "False");
		    //Term term2 = new Term("post::{1}.  has({3})" , "True");
		    Term term2 = new Term("to" , "1");
		    //Term term3 = new Term("post::{LINKED_LIST}.last" , "{ANY}");

		    NumericRangeQuery trq = NumericRangeQuery.newIntRange("count", 2, 2, true, true);

		    TermQuery tq = new TermQuery(term2);

		    BooleanQuery query = new BooleanQuery();
		    //query.add(new BooleanClause(new TermQuery(term1), Occur.SHOULD));
		    //query.add(new BooleanClause(new TermQuery(term2), Occur.SHOULD));
		    //query.add(new BooleanClause(trq, Occur.SHOULD));
		    //query.add(new BooleanClause(new TermQuery(term3), Occur.SHOULD));


		    ScoreDoc[] hits = isearcher.search(trq, null, 5).scoreDocs;
		    System.out.println(hits.length);
		    for (int i = 0; i < hits.length; i++) {
		      Document hitDoc = isearcher.doc(hits[i].doc);
		    }
		    isearcher.close();
		    directory.close();

		}catch(Exception e) {

		}

		System.out.println("Finished. OK");
	}

}
