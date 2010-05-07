package server;

/**
 * Created by IntelliJ IDEA.
 * User: slucas
 * Date: May 7, 2010
 * Time: 6:43:03 AM
 * This class validates the protocol 
 */
public class Protocol {

    /*
       HEADER =  numberOfLines=N;requestId=N
       BODY =  TODO
     */


    /**
     * HEADER FORMAT
     *
     * @param line is the header
     * @return true if header is valid
     */
    public static boolean validateHeader(String line){
        line = line.toLowerCase();
        return line.contains("numberoflines") && line.contains("requestid");
    }

    

}
