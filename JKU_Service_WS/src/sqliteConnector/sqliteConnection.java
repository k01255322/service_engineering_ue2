package sqliteConnector;
import java.sql.*;

public class sqliteConnection {
	static String url = "jdbc:sqlite:C:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2" + 
			"\\ue2.db";
	static String driverName = "org.sqlite.JDBC";
	static Connection conn = null;
	
	public static Connection dbConnector() {
		try {
			Class.forName(driverName);
			conn = DriverManager.getConnection(url);
			return conn;
		} catch(Exception e) {
			e.printStackTrace();
			return null;
		}
	}

}
