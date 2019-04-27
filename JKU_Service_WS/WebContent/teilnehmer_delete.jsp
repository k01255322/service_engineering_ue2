<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@page import="sqliteConnector.sqliteConnection"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
	integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
	crossorigin="anonymous">
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta charset="ISO-8859-1">
<title>Teilnehmer Abmelden</title>
</head>
<body>

<div class="container">
		<br>
<% 
//Datenbankverbindung
			Class.forName("org.sqlite.JDBC");
			Connection conn = sqliteConnection.dbConnector();
			String id = request.getParameter("id");
			String query = "DELETE FROM teilnehmer_liste WHERE ID=?";
			PreparedStatement pstmt = null;
			
			try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, id);
				pstmt.executeUpdate();
				
				out.println("Der Teilnehmer wurde erfolgreich abgemeldet!");
			} catch(SQLException e) {
			      out.println("Error: " + e.getMessage());
			      e.printStackTrace();
			    } catch(Exception e) {
			      out.println("Error: " + e.getMessage());
			      e.printStackTrace();
			    } finally {
			 	   // Always make sure result sets and statements are closed,
			 	   // and the connection is returned to the pool
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
	</div>
</body>
</html>