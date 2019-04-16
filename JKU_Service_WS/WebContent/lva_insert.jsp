<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>LVA in Datenbank einfügen</title>
</head>
<body>

<% 
//Datenbankverbindung
			Class.forName("org.sqlite.JDBC");
			Connection conn = DriverManager.getConnection(
					"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\ue2.db");

			String query = "INSERT INTO lva_service WHEREE titel=?, lva_nummer=?, leiter=?, max_studierende=?, raum=?";

			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			String lva_bezeichnung = request.getParameter("titel");
			String lva_nummer = request.getParameter("lva_nummer");
			String lva_leiter = request.getParameter("leiter");
			String max_studierende = request.getParameter("max_studierende");
			String raum = request.getParameter("raum");
			
			try {
				
				
			} catch  {
				
				
			} finally {
				
				
			}
			%>

</body>
</html>