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
// Variablen
boolean exists = false;

//Datenbankverbindung
Class.forName("org.sqlite.JDBC");
Connection conn = DriverManager.getConnection(
		"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");

String ak_nummer = request.getParameter("ak_nummer");

String qAk = "SELECT ak_nummer, nachname FROM lehrende_liste";

String lva_leiter = null;

String qRaum = "SELECT DISTINCT id FROM raeume";

Statement stmt = null;

ResultSet rs = null;

try {
	stmt = conn.createStatement();
	rs = stmt.executeQuery(qAk);

	while (rs.next()) {
		if (rs.getString(1).equals(ak_nummer)) {
			exists = true;
			lva_leiter = rs.getString(2);
			break;
		}
	}
	rs.close();
	
	if (exists == true) {
	
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
		<td>AK-Nummer:</td>
		<td><input type="text" name="ak_nummer" placeholder=<%=ak_nummer %>></td>
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
		<td>Wöchentliche LVA:</td>
		<td><input type="checkbox" name="woechentlich"></td>
		</tr>
		
	</table>
	
	<input type="submit" value="Einfügen">
	</form>
	<%
			
			}else {
				out.println("Bitte eine gültige AK-Nummer eingeben!");
			}
} 
	catch (SQLException e) {
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
	<br>
	<a href="lva_service.html">Zurück</a>
	<a href= "index.html">Hauptmenü</a>





</body>
</html>