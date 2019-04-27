<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.LocalTime"%>
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
		boolean raumexists = false;
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");
		LocalDate ldatum = LocalDate.parse(request.getParameter("datum"), formatter);
		String datum = ldatum.format(formatter);
		DateTimeFormatter formatter2 = DateTimeFormatter.ISO_LOCAL_TIME;
		LocalTime von = LocalTime.parse(request.getParameter("von"), formatter2);
		LocalTime bis = LocalTime.parse(request.getParameter("bis"), formatter2);
		String raum = request.getParameter("raum");
		Class.forName("org.sqlite.JDBC");
		Connection conn = sqliteConnection.dbConnector();
		Statement stat = conn.createStatement();
		String qRaum = "SELECT * FROM raeume";
		String service = "SELECT * FROM raum_service" + " WHERE raum='" + raum + "'" + "and datum='" + datum
				+ "' and von='" + von + "' and bis='" + bis + "'";
		String query = "INSERT INTO raum_service( raum, datum, von, bis) VALUES (?,?,?,?)";
		PreparedStatement pst = null;
		ResultSet rs = stat.executeQuery(qRaum);
		if (raum != null) {
			while (rs.next()) {
				if (rs.getString("id").equals(raum)) {
					raumexists = true;
					break;
				}
			}
		}
		rs = stat.executeQuery(service);
		if (raumexists == false) {
			out.println("Dieser Raum existiert nicht. Daher kann kein Termin gebucht werden!");
		} else if (rs.next()) {
			out.println("Raum bereits gebucht!");
		} else {

			try {
				pst = conn.prepareStatement(query);

				if (raum != null) {
					pst.setString(1, raum);
				} else {
					pst.setNull(1, java.sql.Types.VARCHAR);
				}

				if (datum != null) {
					pst.setObject(2, datum);
				} else {
					pst.setNull(2, java.sql.Types.DATE);
				}

				if (von != null) {
					pst.setObject(3, von);
				} else {
					pst.setNull(3, java.sql.Types.TIME);
				}

				if (bis != null) {
					pst.setObject(4, bis);
				} else {
					pst.setNull(4, java.sql.Types.TIME);
				}

				pst.executeUpdate();

				out.println("Der Raum " + raum + " wurde erfolgreich zum angegebenen Termin reserviert!");
				out.println("<a href=raum_buchen.html>Weiteren Termin buchen</a>");
				out.println("<a href=index.html>Zurück zur Startseite</a>");

			} catch (SQLException e) {
				if (conn != null)
					out.println("Fehler!");
			} catch (Exception e) {
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
		}
	%>
</body>
</html>