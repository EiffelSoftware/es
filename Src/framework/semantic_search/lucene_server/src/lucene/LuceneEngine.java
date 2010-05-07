package lucene;

import server.Message;
import utility.Utility;

import java.util.logging.Logger;

/**
 * Created by IntelliJ IDEA.
 * User: slucas
 * Date: May 7, 2010
 * Time: 6:08:25 AM
 */
public class LuceneEngine {


    private Logger log = Utility.getLogger();

    public LuceneEngine() {
        
    }

    public Message processMessage (Message msg){
        //create MSG
        //Execute on Lucene
        //Create result MSG
        //Return
        log.info("Lucene ENgine will process this message! MSG Size = " + msg.getBodyLength());


        Message result = new Message("numberOfLines=1;requestId=10;\n");
        result.addLineToBody("emptyLine=0\n");
        return result;
    }
}
