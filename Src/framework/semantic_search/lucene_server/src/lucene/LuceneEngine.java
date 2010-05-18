package lucene;

import org.apache.lucene.analysis.SimpleAnalyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.Fieldable;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.Term;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.search.*;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.store.RAMDirectory;
import server.Message;
import utility.Utility;

import java.io.File;
import java.io.IOException;
import java.io.StringReader;
import java.util.LinkedList;
import java.util.List;
import java.util.logging.Logger;

/**
 * Created by IntelliJ IDEA.
 * User: slucas
 * Date: May 7, 2010
 * Time: 6:08:25 AM
 */
public class LuceneEngine {

    private IndexWriter writer;
    private Directory directory;

    private Logger log = Utility.getLogger();

    /**
     *
     */
    public LuceneEngine() {

        try {
            directory = FSDirectory.open (new File("/tmp/lucene"));

        } catch (IOException e) {
            e.printStackTrace();
            log.severe(e.getMessage());
        }
    }

    /**
     * Examine the message and decide to index or query!
     * @param msg to be indexed
     * @return result of a possible query!
     */

    public List<Message> processMessage (Message msg){
        //create MSG
        //Execute on Lucene
        //Create result MSG
        //Return
        List<Message> results = new LinkedList<Message>();
        log.info("Lucene Engine will process this message! MSG Size = " + msg.getBodyLength());

        if (msg.getRequestType() == Message.INDEX_MSG){
            index(msg);
            Message result = new Message(1,10,1,1);
            result.addLineToBody("++++++++++emptyLine=0++++++++");
            results = new LinkedList<Message>();
            results.add(result);
        }else if(msg.getRequestType() == Message.QUERY_MSG){
            results = query(msg);

        }
        return results;
    }


    /**
     * At the moment index won't check if the document already exists
     * it will add a new document!
     * @param msg to be Indexed
     */
    private void index(Message msg){
        try {
            writer =new IndexWriter(directory, new SimpleAnalyzer(), false, IndexWriter.MaxFieldLength.UNLIMITED);

            log.info("Indexing msg " + msg.getRequestId());

            Document doc = new Document();

            for(String str: msg.getBody()){
                String[] tokens = str.split("\\(=\\)");
                assert (tokens.length == 2): " A body line must/can only have on separator!";
                doc.add(new Field (tokens[0], tokens[1], Field.Store.YES, Field.Index.NOT_ANALYZED, Field.TermVector.NO));
            }

            writer.addDocument(doc);
            writer.commit();
            writer.close();
            log.info("Document " + msg.getRequestId() +" Indexed!");
        } catch (IOException e) {
            e.printStackTrace();
            log.severe(e.getMessage());
        }

    }


    public List<Message> query(Message msg){
        LinkedList<Message> results = new LinkedList<Message>();

        IndexSearcher searcher = null;
        try {
            searcher = new IndexSearcher(directory);

            // Build a Query object
            BooleanQuery query = new BooleanQuery();

            for(String str : msg.getBody()){
                String[] tokens = str.split("\\(=\\)");
                query.add((new TermQuery(new Term(tokens[0], tokens[1]))), BooleanClause.Occur.SHOULD);
            }

            // Search for the query

            TopDocs topDocs = searcher.search(query,msg.getReplyNumber());

            // Examine the Hits object to see if there were any matches
            int hitCount = topDocs.totalHits;
            if (hitCount == 0) {
                System.out.println("No matches were found for");
            }

            else {
                System.out.println("Hits for were found in quotes by:");

                // Iterate over the Documents in the Hits object
                if (hitCount > msg.getReplyNumber()){
                    hitCount = msg.getReplyNumber();
                }
                
                for (int i = 0; i < hitCount; i++) {
                    Document doc = searcher.doc(topDocs.scoreDocs[i].doc) ;
                    Message replyMsg = docToMSG(doc,msg);
                    results.add(replyMsg);


              }
          }
          System.out.println();
            } catch (IOException e) {
            e.printStackTrace();
        }

        return results;
      }


    /**
     *
     * @param doc to convert
     * @param reqMSG request MSG that generated this Doc
     * @return a Message
     */
    private Message docToMSG(Document doc, Message reqMSG){
        List<Fieldable> fields = doc.getFields();

        Message result = new Message(fields.size(), reqMSG.getRequestId(), Message.INDEX_MSG,0);
        for(Fieldable f : fields){
            result.addLineToBody(f.name() +"(=)"+f.stringValue());
        }

        return result;
    }

    public void runTests(){
    
        // Add some Document objects containing quotes
        Document doc = new Document();

		    doc = new Document();
		    
		    doc.add(new Field ("content", "foo", Field.Store.YES, Field.Index.NOT_ANALYZED, Field.TermVector.NO));


        try {
            writer.addDocument(doc);
            // Optimize and close the writer to finish building the index
            writer.optimize();
            writer.close();

        } catch (IOException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }




        

    }
}
