<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>LVA löschen</title>
</head>
<body>
<% 
//Datenbankverbindung
			Class.forName("org.sqlite.JDBC");
			Connection conn = DriverManager.getConnection(
					"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\ue2.db");

			String query = "DELETE FROM lva_Service WHERE titel=?";

			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			String lva_bezeichnung = request.getParameter("titel");
			
			try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, lva_bezeichnung);
				pstmt.executeUpdate();
				
				out.println("Die LVA " + lva_bezeichnung + " wurde erfolgreich gelöscht!");
			} catch(SQLException e) {
			      out.println("Error: " + e.getMessage());
			      e.printStackTrace();
			    } catch(Exception e) {
			      out.println("Error: " + e.getMessage());
			      e.printStackTrace();
			    } finally {
			 	   // Always make sure result sets and statements are closed,
			 	   // and the connection is returned to the pool
			 	   if (rs != null) {
			 	     try { rs.close(); } catch (SQLException e) { ; }
			 	     rs = null;
			 	   }
			 	   if (pstmt != null) {
			 	     try { pstmt.close(); } catch (SQLException e) { ; }
			 	     pstmt = null;
			 	   }
			 	   if (conn != null) {
			 	     try { conn.close(); } catch (SQLException e) { ; }
			 	     conn = null;
			 	   }
			 	   
			    }
	%>
	
	<br>
	<br>
	<a href="lva_overview">LVA Übersicht</a>
</body>
</html>