<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
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
		// Variablen
		boolean exists = false;
		boolean existsPr�fung = false;
		//Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\ue2.db");

		String query = "INSERT INTO pruefungs_service (lva_titel, lva_nummer, datum, zeit, ort, anzahl_plaetze, anmeldungen) VALUES(?,?,?,?,?,?,0)";
		String qRaum = "SELECT ID FROM raeume";
		String qPr�fung = "SELECT lva_nummer FROM pruefungs_service";

		PreparedStatement pstmt = null;
		Statement st = null;
		ResultSet rs = null;

		String lva_bezeichnung = request.getParameter("titel");
		String lva_nummer = request.getParameter("lva_nummer");
		String termin = request.getParameter("termin");
		String zeit = request.getParameter("zeit");
		String raum = request.getParameter("raum");
		int plaetze = Integer.parseInt(request.getParameter("plaetze"));

		try {
			st = conn.createStatement();
			rs = st.executeQuery(qRaum);

			while (rs.next()) {
				if (rs.getString("id").equals(raum)) {
					exists = true;
					break;
				}
			}

			rs.close();

			rs = st.executeQuery(qPr�fung);
			while (rs.next()) {
				if (rs.getString(1).equals(lva_nummer)) {
					existsPr�fung = true;
					break;
				}
			}

			if (exists == true && existsPr�fung == false) {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, lva_bezeichnung);
				pstmt.setString(2, lva_nummer);
				pstmt.setString(3, termin);
				pstmt.setString(4, zeit);
				pstmt.setString(5, raum);
				pstmt.setInt(6, plaetze);

				pstmt.executeUpdate();

				out.println("Pr�fung f�r die LVA " + lva_bezeichnung + " (" + lva_nummer
						+ ") wurde erfolgreich angelegt!");
			} else if (exists == false) {
				out.println("Der eingegebene Raum (" + raum + ") existiert nicht!");
			} else {
				out.println("F�r diese LVA (" + lva_nummer + ") wurde bereits eine Pr�fung angelegt!");

			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (pstmt != null) {
				try {
					pstmt.close();
				} catch (SQLException e) {
					;
				}
				pstmt = null;
			}
			if (st != null) {
				try {
					st.close();
				} catch (SQLException e) {
					;
				}
				pstmt = null;
			}
			if (rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
					;
				}
				pstmt = null;
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
	<a href="lva_overview.jsp">LVA �bersicht</a>

</body>
</html>