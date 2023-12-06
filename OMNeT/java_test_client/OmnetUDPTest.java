import java.net.DatagramPacket;
import java.net.InetAddress;
import java.net.MulticastSocket;
import java.net.SocketTimeoutException;

public class OmnetUDPTest {

	private String INET_ADDR = "224.0.0.1";
	private int LOCAL_PORT  = 9875;
	private int DEST_PORT = 9876;

	public OmnetUDPTest() {
		try {
			MulticastSocket socket = new MulticastSocket(LOCAL_PORT);
			InetAddress group = InetAddress.getByName(INET_ADDR);
			socket.joinGroup(group);
			int i =0;
			while(true) {
				try {
					String sendData = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n<posnAdvisory speed=\"0.0\" timestamp=\"Mon Nov 03 05:54:01 GMT 2014\" trainId=\"S1\" x=\"2566.2029194506117\" y=\"23213.515237413856\"/>\n";
					DatagramPacket sendPacket = new DatagramPacket(sendData.getBytes(), sendData.length(), group, DEST_PORT);
					socket.send(sendPacket);
					System.out.println("Sent    : " + new String(sendPacket.getData()).replaceAll("\n", ""));
					
					socket.setSoTimeout(10000);
					byte[] receiveData = new byte[512];
					DatagramPacket receivePacket = new DatagramPacket(receiveData, 512);
					socket.receive(receivePacket);
					System.out.println("Received: " + new String(receivePacket.getData()).replaceAll("\n", ""));
					
					Thread.sleep(1000);
				} catch(SocketTimeoutException e) {
					Thread.sleep(100);
					System.out.println(i++);
				}
				try {
					
					String sendData = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n<movementAuthority zcId=\"ZC[0]\" trainId=\"S1\"/>\n";
					DatagramPacket sendPacket = new DatagramPacket(sendData.getBytes(), sendData.length(), group, DEST_PORT);
					socket.send(sendPacket);
					System.out.println("Sent    : " + new String(sendPacket.getData()).replaceAll("\n", ""));
					socket.setSoTimeout(10000);
					byte[] receiveData = new byte[512];
					DatagramPacket receivePacket = new DatagramPacket(receiveData, 512);
					socket.receive(receivePacket);
					System.out.println("Received: " + new String(receivePacket.getData()).replaceAll("\n", ""));
					
					Thread.sleep(1000);
				} catch(SocketTimeoutException e) {
					Thread.sleep(100);
					System.out.println(i++);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] args) {
		new OmnetUDPTest();
	}

}
