<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Student in DB einfügen</title>
</head>
<body>

<%
// Variablen
boolean existsMatr = false;
boolean bereitsAng = false;

		//Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");

		String lva_nummer = request.getParameter("lva_nummer");
		String matrikelnummer = request.getParameter("matrikelnummer");

		String query = "SELECT matrikelnummer FROM studenten_liste";
		
		String qAnm = "SELECT matrikelnummer, lva_nummer FROM studenten_lva_anmeldungen";
		
		String qInsert = "INSERT INTO studenten_lva_anmeldungen(matrikelnummer, lva_nummer) VALUES (?,?)";

		Statement stm = null;
		PreparedStatement pstm = null;
		ResultSet rs = null;

		try {
			
			stm = conn.createStatement();
			rs = stm.executeQuery(query);
			while (rs.next()) {
				if (rs.getString(1).equals(matrikelnummer)) {
					existsMatr = true;
					break;
				}
			}
			rs.close();
			rs = stm.executeQuery(qAnm);
			while(rs.next()) {
				if (rs.getString(1).equals(matrikelnummer) && rs.getString(2).equals(lva_nummer)) {
					bereitsAng = true;
					out.println("Du bist bereits für diese LVA angemeldet.");
					break;
				}
			}
			
			if(existsMatr == true && bereitsAng == false) {
			
				pstm = conn.prepareStatement(qInsert);
				pstm.setString(1, matrikelnummer);
				pstm.setString(2, lva_nummer);
				pstm.executeUpdate();

				out.println("Anmeldung wurde durchgeführt!");
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			
			if (pstm != null) {
				try {
					pstm.close();
				} catch (SQLException e) {
					;
				}
				pstm = null;
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
	<a href="index.html">Hauptmenü</a>

</body>
</html>