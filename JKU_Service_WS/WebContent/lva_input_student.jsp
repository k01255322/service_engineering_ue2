<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Student einfügen</title>


<%
	// Variablen
	boolean existsMatr = false;
	boolean existsLva = false;

	// Datenbankverbindung
	Class.forName("org.sqlite.JDBC");
	Connection conn = DriverManager.getConnection(
			"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");

	String query = "SELECT matrikelnummer FROM studenten_liste";

	String qLva = "SELECT lva_nummer FROM lva_service";

	String qInsert = "INSERT INTO studenten_lva_anmeldungen(matrikelnummer, lva_nummer) VALUES (?,?)";

	String matrikelnummer = request.getParameter("matrikelnummer");
	String lva_nummer = request.getParameter("lva_nummer");

	Statement stm = null;
	PreparedStatement pstmt = null;
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
		rs = stm.executeQuery(qLva);
		while (rs.next()) {
			if (rs.getString(1).equals(lva_nummer)) {
				existsLva = true;
				break;
			}
		}

		rs.close();

		if (existsMatr == true && existsLva == true) {
			pstmt = conn.prepareStatement(qInsert);
			pstmt.setString(1, matrikelnummer);
			pstmt.setString(2, lva_nummer);
			pstmt.executeUpdate();
			out.println("Anmeldung wurde durchgeführt.");
		}

	} catch (SQLException e) {
		e.printStackTrace();
	} finally {
		if (rs != null) {
			try {
				rs.close();
			} catch (SQLException e) {
				;
			}
			rs = null;
		}
		if (pstmt != null) {
			try {
				pstmt.close();
			} catch (SQLException e) {
				;
			}
			pstmt = null;
		}
		if (stm != null) {
			try {
				stm.close();
			} catch (SQLException e) {
				;
			}
			stm = null;
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
</table>
<br>
<br>
<a href="main_page.html">Hauptmenü</a>


</head>
<body>

</body>
</html>