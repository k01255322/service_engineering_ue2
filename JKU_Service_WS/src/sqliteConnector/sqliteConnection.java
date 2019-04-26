package sqliteConnector;
import java.sql.*;

public class sqliteConnection {
	static String url = "jdbc:sqlite:C:\\Users\\simon\\Documents\\Vorlesungen\\ServiceEngineering\\service_engineering_ue2\\ue2.db";
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
