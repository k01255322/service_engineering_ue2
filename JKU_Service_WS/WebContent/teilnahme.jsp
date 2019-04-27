<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
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
<title>Raum buchen</title>
</head>
<body>
	<%
		boolean vexists = false;
		String vname = request.getParameter("vname");
		String nname = request.getParameter("nname");
		String vid = request.getParameter("vid");
		Class.forName("org.sqlite.JDBC");
		Connection conn = sqliteConnection.dbConnector();
		Statement stat = conn.createStatement();
		String query = "INSERT INTO teilnehmer_liste( vorname, nachname, veranstaltung) VALUES (?,?,?)";
		PreparedStatement pst = null;

			try {
				pst = conn.prepareStatement(query);

				if (vname != null) {
					pst.setString(1, vname);
				} else {
					pst.setNull(1, java.sql.Types.VARCHAR);
				}

				if (nname != null) {
					pst.setString(2, nname);
				} else {
					pst.setNull(2, java.sql.Types.VARCHAR);
				}

				if (vid != null) {
					pst.setObject(3, vid);
				} else {
					pst.setNull(3, java.sql.Types.TIME);
				}

				pst.executeUpdate();

				out.println("Teilnahme vermerkt!");
				out.println("<a href=index.html>Zurück zur Startseite</a>");

			} catch (SQLException e) {
				if (conn != null)
					out.println("Fehler!");
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