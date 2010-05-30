import server.Message;
import server.Protocol;

import java.io.*;
import java.net.Socket;

/**
 * Created by IntelliJ IDEA.
 * User: slucas
 * Date: May 7, 2010
 * Time: 7:00:13 AM
 * A Client to connect to the server and send MSGS
 */
public class TestClient {

    public static void main(String[] args) {
        try {
            Socket client = new Socket("localhost",10000);
            InputStream in = client.getInputStream();
            OutputStream out = client.getOutputStream();
            BufferedReader inReader = new BufferedReader(new InputStreamReader(in));
            BufferedWriter outWriter = new BufferedWriter(new OutputStreamWriter(out));


            Message testMSG = new Message(4,10,Message.INDEX_MSG,0);
            testMSG.addLineToBody("document_type(=)Object");
            testMSG.addLineToBody("property(=){1}.count2 : 0");
            testMSG.addLineToBody("variables(=){String2};;;{SEQUENCE};;;{ANY}");
            testMSG.addLineToBody("variable_types(=){String2};;;{SEQUENCE};;;{ANY}");


            Message testMSG1 = new Message(4,10,Message.INDEX_MSG,0);
            testMSG1.addLineToBody("document_type(=)Object38");
            testMSG1.addLineToBody("property(=){1}.count3 : 0");
            testMSG1.addLineToBody("variables(=){LIST3};;;{SEQUENCE};;;{ANY}");
            testMSG1.addLineToBody("variable_types(=){LIST};;;{SEQUENCE};;;{ANY}");

            Message testMSG2 = new Message(1,10,Message.QUERY_MSG,3);
            testMSG2.addLineToBody("document_type(=)Object");


            try {
                outWriter.write(testMSG.toString());
                System.out.println("MSG="+ testMSG.toString());
                outWriter.flush();

                Thread.sleep(1000);
                outWriter.write(testMSG1.toString());
                System.out.println("MSG="+ testMSG1.toString());
                outWriter.flush();

                readReply(inReader);
                Thread.sleep(1000);
                outWriter.write(testMSG.toString());
                System.out.println("MSG="+ testMSG2.toString());
                outWriter.flush();
                readReply(inReader);

                Thread.sleep(1000);
                outWriter.write(testMSG2.toString());
                System.out.println("MSG="+ testMSG.toString());
                outWriter.flush();
                readReply(inReader);
            } catch (InterruptedException e) {
                e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            }


            client.close();
            System.out.println("Close connection");


        } catch (IOException e) {
            e.printStackTrace();
        }

    }


    public static void readReply(BufferedReader inReader ){
        String line = null;
        System.out.println("try read Reply!");
        try {
            line = inReader.readLine();

            if (line!=null){
                //This line should be the Header
                //numberOfLines=10;requestID=1;

                line = line.toLowerCase();

                if (Protocol.validateHeader(line)){
                    String[] tokens = line.split(";");
                    Integer numLines = Integer.parseInt(tokens[0].split("=")[1]);
                    Integer reqId = Integer.parseInt(tokens[1].split("=")[1]);
                    Integer reqType = Integer.parseInt(tokens[2].split("=")[1]);
                    Integer repNum = Integer.parseInt(tokens[3].split("=")[1]);

                    Message msg = new Message(numLines,reqId,reqType,repNum);


                    while (!msg.isLengthCorrect()){
                        msg.addLineToBody(inReader.readLine());
                    }

                    System.out.println("Print RESULT MSG " + msg.toString());


                }else{
                    throw new IllegalStateException("The header (" + line + ") of the protocol is invalid!");
                }

            }
        } catch (IOException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.

        }
        System.out.println("Finished read Reply!");
    }

}
