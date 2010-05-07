import server.Message;

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

            Message testMSG = new Message("numberOfLines=1;requestId=10;");
            testMSG.addLineToBody("body=line0;");

            Message testMSG1 = new Message("numberOfLines=2;requestId=10;");
            testMSG1.addLineToBody("body=line1;");
            testMSG1.addLineToBody("body=line2;");

            Message testMSG2 = new Message("numberOfLines=4;requestId=10;");
            testMSG2.addLineToBody("body=line2;");
            testMSG2.addLineToBody("body=line3;");
            testMSG2.addLineToBody("body=line4;");
            testMSG2.addLineToBody("body=line5;");

            try {
                outWriter.write(testMSG.toString());
                System.out.println("MSG="+ testMSG.toString());
                outWriter.flush();

                Thread.sleep(10000);
                outWriter.write(testMSG1.toString());
                System.out.println("MSG="+ testMSG1.toString());
                outWriter.flush();

                Thread.sleep(10000);
                outWriter.write(testMSG.toString());
                System.out.println("MSG="+ testMSG2.toString());
                outWriter.flush();


                Thread.sleep(100000);
                outWriter.write(testMSG2.toString());
                System.out.println("MSG="+ testMSG.toString());
                outWriter.flush();
            } catch (InterruptedException e) {
                e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            }


            client.close();
            System.out.println("Close connection");


        } catch (IOException e) {
            e.printStackTrace();
        }

    }

}
