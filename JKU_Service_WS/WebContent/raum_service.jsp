<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.LocalTime"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<% 

		String raum = request.getParameter("raum");
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");
		LocalDate datum = LocalDate.parse(request.getParameter("datum"), formatter);
		DateTimeFormatter formatter2 = DateTimeFormatter.ISO_LOCAL_TIME;
		LocalTime von = LocalTime.parse(request.getParameter("von"), formatter2);
		LocalTime bis = LocalTime.parse(request.getParameter("bis"), formatter2);

		// Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");
		Statement stat = conn.createStatement();
		
		String query = "INSERT INTO raum_service(raum, datum, von, bis) VALUES (?,?,?,?)";
		PreparedStatement pst = null;
		
		try {
			pst = conn.prepareStatement(query);

			pst.setString(1, raum);
			pst.setObject(2, datum);
			pst.setObject(3, von);
			pst.setObject(4, bis);
			
			pst.executeUpdate();

			out.println("Eingefügt!");

		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			
			if (pst != null) {
				try {
					pst.close();
				} catch (SQLException e) {
					;
				}
				pst = null;
			}
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					;
				}
				conn = null;
			}
		}
	
		%>

</body>
</html>