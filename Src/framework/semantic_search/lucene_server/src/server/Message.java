package server;

import java.util.Vector;

/**
 * Created by IntelliJ IDEA.
 * User: slucas
 * Date: May 7, 2010
 * Time: 6:24:06 AM
  */
public class Message {

    public static int QUERY_MSG = 0;
    public static int INDEX_MSG = 1;

    private String header;
    private int headerLength;
    private int requestId;
    private int requestType;
    private int replyNumber;
    private Vector<String> body;


  

    public Message(Integer numLines, Integer reqId, Integer reqType, Integer repNumber) {
        body = new Vector<String>();

        headerLength = numLines;
        requestId = reqId;
        requestType = reqType;
        replyNumber = repNumber;


        this.header = "numberOfLines="+numLines.toString()+";requestId="+reqId.toString()+";requestType="+
                reqType.toString()+";maxResult="+repNumber.toString()+";";
    }


    /**
     * @param line to be added to the message
     */
    public void addLineToBody (String line){
        //Future do some validity check here
        body.add(line);
    }

    /**
     * @return the body of the message!
     */
    public Vector<String> getBody() {
        return body;
    }

    public int getBodyLength(){
        return body.size();
    }


    /**
     * @return the request ID
     */
    public int getRequestId() {
        return requestId;
    }

    /**
     * @return the request type
     */
    public int getRequestType() {
        return requestType;
    }

    /**
     * @return the number of possible reply
     */
    public int getReplyNumber() {
        return replyNumber;
    }

    

    @Override
    public String toString() {
        String result = header +"\n" ;
        for (String s : body){
            result = result + s + "\n";
        }
        return result;
    }

    public boolean isLengthCorrect() {
        return (getBodyLength() == headerLength);
    }
}
