/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package Main;
import SemanticDocument.SemanticDocument;
import SemanticDocument.SemanticDocumentLoader;
import SemanticDocument.SemanticIndexWriter;
import SemanticDocument.SemanticToLuceneDocumentTranslator;
import java.io.File;
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
import org.apache.lucene.store.FSDirectory;

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
                    //SemanticIndexWriter sWriter = new SemanticIndexWriter();
                    //sWriter.createIndex("d:\\temp\\transitions", "d:\\temp\\index");

		    StandardAnalyzer analyzer = new StandardAnalyzer(Version.LUCENE_30);

		    // Store the index in memory:
		    Directory directory = FSDirectory.open (new File("d:\\temp\\index"));

//		    IndexWriter iwriter = new IndexWriter(directory, analyzer, true, new IndexWriter.MaxFieldLength(25000));
//
//		    // Create a document representing `extend'.
//		    Document doc = null;
//
//		    doc = new Document();
//		    doc.add(new Field ("post::{LINKED_LIST}.isfirst", "True", Field.Store.NO, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
//		    doc.add(new Field ("post::{LINKED_LIST}.is_empty", "False", Field.Store.NO, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
//		    doc.add(new Field ("content", "start", Field.Store.YES, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
//		    iwriter.addDocument(doc);
//
//		    doc = new Document();
//		    doc.add(new Field ("post::{LINKED_LIST}.has({ANY})", "True", Field.Store.NO, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
//		    doc.add(new Field ("post::{LINKED_LIST}.is_empty", "False", Field.Store.NO, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
//		    doc.add(new Field ("content", "put_first", Field.Store.YES, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
//		    iwriter.addDocument(doc);
//
//		    doc = new Document();
//		    doc.add(new Field ("post::{LINKED_LIST}.has({ANY})", "True", Field.Store.NO, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
//		    doc.add(new Field ("post::{LINKED_LIST}.is_empty", "False", Field.Store.NO, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
//		    doc.add(new Field ("post::{LINKED_LIST}.last", "{ANY}", Field.Store.NO, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
//		    doc.add(new Field ("content", "extend", Field.Store.YES, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
//		    iwriter.addDocument(doc);
//
//		    doc = new Document();
//		    doc.add(new Field ("post::{LINKED_LIST}.has({ANY})", "True", Field.Store.NO, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
//		    doc.add(new Field ("post::{1}.  has({3})", "True", Field.Store.NO, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
//		    doc.add(new Field ("content", "foo", Field.Store.YES, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
//		    NumericField nf;
//		    nf = new NumericField ("count");
//		    nf.setIntValue(1);
//		    doc.add(nf);
//		    nf = new NumericField ("count");
//		    nf.setIntValue(2);
//		    doc.add(nf);
//		    iwriter.addDocument(doc);
//
//		    iwriter.close();
		    // Query for the document.
		    // Now search the index:
		    IndexSearcher isearcher = new IndexSearcher(directory, true); // read-only=true

		    //Term term1 = new Term("post::{LINKED_LIST}.is_empty", "False");
		    //Term term2 = new Term("post::{LINKED_LIST}.has({ANY})" , "True");
		    //Term term3 = new Term("post::{LINKED_LIST}.last" , "{ANY}");

		    //Term term1 = new Term("post::{LINKED_LIST}.is_empty", "False");
		    //Term term2 = new Term("post::{1}.  has({3})" , "True");

                    Term term1 = new Term ("pre::LINKED_LIST [ANY].is_empty", "False");
		    Term term2 = new Term("to::LINKED_LIST [ANY].after" , "True");
                    Term term3 = new Term("pre::LINKED_LIST [ANY].after" , "False");


		    TermQuery tq1 = new TermQuery(term1);
                    TermQuery tq2 = new TermQuery(term2);
                    TermQuery tq3 = new TermQuery(term3);

		    NumericRangeQuery nq = NumericRangeQuery.newIntRange("by::LINKED_LIST [ANY].count", 1, 1, true, true);

		    

		    BooleanQuery query = new BooleanQuery();
                    query.add(new BooleanClause(tq1, Occur.SHOULD));
                    //query.add(new BooleanClause(tq2, Occur.MUST));
                    //query.add(new BooleanClause(tq3, Occur.MUST));
                    query.add(new BooleanClause(nq, Occur.MUST));

                    //query.add(new BooleanClause(new TermQuery(term1), Occur.SHOULD));
		    //query.add(new BooleanClause(new TermQuery(term2), Occur.SHOULD));
		    //query.add(new BooleanClause(trq, Occur.SHOULD));
		    //query.add(new BooleanClause(new TermQuery(term3), Occur.SHOULD));

		    ScoreDoc[] hits = isearcher.search(query, null, 50).scoreDocs;

                    for(int i=0; i < hits.length; i++) {
                        Document hitDoc = isearcher.doc(hits[i].doc);
                        System.out.print(hits[i].score);
                        System.out.print("\t");
                        System.out.println(hitDoc.getField("content").stringValue());
                    }

		    isearcher.close();
		    directory.close();

		}catch(Exception e) {

		}

		System.out.println("Finished. OK");
	}

}
