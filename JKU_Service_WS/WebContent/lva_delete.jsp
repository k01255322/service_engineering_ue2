<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
<title>LVA löschen</title>
</head>
<body>

<div class="container">

		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<a class="navbar-brand" href="index.html">Hauptmenü</a> <a
				class="navbar-brand" href="lva_service.html">LVA Service</a> <a
				class="navbar-brand" href="prüfungsservice.html">Prüfungsservice</a>
			<a class="navbar-brand" href="raumservice.html">Raumservice</a> <a
				class="navbar-brand" href="veranstaltungsservice.html">Veranstaltungsservice</a>

		</nav>
		
		<br>
<% 
//Datenbankverbindung
			Class.forName("org.sqlite.JDBC");
			Connection conn = DriverManager.getConnection(
					"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");

			String query = "DELETE FROM lva_service WHERE lva_nummer=?";

			PreparedStatement pstmt = null;
			
			String lva_bezeichnung = request.getParameter("titel");
			String lva_nummer = request.getParameter("lva_nummer");
			
			try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, lva_nummer);
				pstmt.executeUpdate();
				
				out.println("Die LVA " + lva_bezeichnung + " mit der Nummer " + lva_nummer + " wurde erfolgreich gelöscht!");
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