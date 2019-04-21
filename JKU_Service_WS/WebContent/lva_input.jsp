<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>LVA anlegen</title>
</head>
<body>


<%
//Datenbankverbindung
Class.forName("org.sqlite.JDBC");
Connection conn = DriverManager.getConnection(
		"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");

String qRaum = "SELECT DISTINCT id FROM raeume";

Statement stmt = null;

ResultSet rs = null;

try {
	stmt = conn.createStatement();
	rs = stmt.executeQuery(qRaum);



%>
<h1>Formular zum erstellen einer LVA</h1>



<form action="lva_insert.jsp" method="post">
	<table border=0>
		<tr>
		<td>LVA-Bezeichnung:</td>
		<td><input type="text" name="titel" placeholder="z.B. Service Engineering"></td>
		</tr>
		<tr>
		<td>LVA-Nummer:</td>
		<td><input type="text" name="lva_nummer" placeholder="z.B. 255.255"></td>
		</tr>
		<tr>
		<td>LVA-Leiter:</td>
		<td><input type="text" name="leiter" placeholder="Vorname Nachname"></td>
		</tr>
		<tr>
		<td>Max. Anzahl Studierender:</td>
		<td><input type="text" name="max_studierende" placeholder="z.B. 100"></td>
		</tr>
		<tr>
		<td>Raum:</td>
		<td><input type="text" name="raum" list="raum" placeholder ="z.B. HS 1">
		<datalist id="raum">
					<%while (rs.next()) {%>
					<option value="<%=rs.getString(1)%>"></option>
					<%} %>
					</datalist></td>
		</tr>
		<tr>
		<td>Datum:</td>
		<td><input type="text" name="datum" placeholder="z.B. 31.12.2019"></td>
		</tr>
		<tr>
		<td>Uhrzeit von:</td>
		<td><input type="text" name="von" placeholder="z.B. 13:30"></td>
		</tr>
		<tr>
		<td>Uhrzeit bis:</td>
		<td><input type="text" name="bis" placeholder="z.B. 14:45"></td>
		</tr>
		
	</table>
	
	<input type="submit" value="Einfügen">
	</form>
	<%
			
			} catch (SQLException e) {
				e.printStackTrace();
			} 
			finally {
				if (rs != null) {
					try {
						rs.close();
					} catch (SQLException e) {
						;
					}
					rs = null;
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
	
	<br>
	<a href= "main_page.html">Hauptmenü</a>





</body>
</html>