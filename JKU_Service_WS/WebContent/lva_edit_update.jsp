<%@page import="sqliteConnector.sqliteConnection"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.LocalTime"%>
<%@page import="java.time.format.DateTimeParseException"%>
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
<title>Bearbeitete LVA updaten</title>
</head>
<body>
	<div class="container">


		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<a class="navbar-brand" href="lva_service.html">LVA Service</a> <a
				class="navbar-brand" href="prüfungsservice.html">Prüfungsservice</a>
			<a class="navbar-brand" href="raumservice.html">Raumservice</a> <a
				class="navbar-brand" href="veranstaltungsservice.html">Veranstaltungsservice</a>
		</nav>

		<%
			// Variablen
			boolean existsRaum = false;
			boolean checkGroesse = false;
			boolean checkDatum = false;
			int raumgroesse = 0;

			//Datenbankverbindung
			Connection conn = sqliteConnection.dbConnector();

			String qRaum = "SELECT * FROM raeume";

			String qDatum = "SELECT * FROM raum_service";

			String query = "UPDATE lva_service SET titel =?, lva_nummer=?, leiter=?, max_studierende=?, raum=?, datum=?, von=?, bis=? WHERE lva_nummer=?";

			String inRaum = "INSERT INTO raum_service(raum, datum, von, bis, lva_nummer) VALUES (?,?,?,?,?)";

			Statement stm = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			String lva_titel = request.getParameter("titel");
			String lva_nummer = request.getParameter("lva_nummer");
			String leiter = request.getParameter("leiter");
			int max_studierende = Integer.parseInt(request.getParameter("max_studierende"));
			String raum = request.getParameter("raum");

			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");
			try {
				LocalDate tempDatum = LocalDate.parse(request.getParameter("datum"), formatter);
				String datum = tempDatum.format(formatter);
				DateTimeFormatter formatter2 = DateTimeFormatter.ISO_LOCAL_TIME;
				LocalTime von = LocalTime.parse(request.getParameter("von"), formatter2);
				LocalTime bis = LocalTime.parse(request.getParameter("bis"), formatter2);

				stm = conn.createStatement();

				rs = stm.executeQuery(qRaum);
				while (rs.next()) {
					if (rs.getString("id").equals(raum)) {
						existsRaum = true;

						if (rs.getInt("max_personen") < max_studierende) {
							checkGroesse = true;
							raumgroesse = rs.getInt("max_personen");
							break;
						}
						break;
					}
				}
				rs.close();

				rs = stm.executeQuery(qDatum);
				while (rs.next()) {
					if (rs.getObject("datum").toString().equals(datum)
							&& rs.getObject("bis").toString().equals(bis.toString())
							&& rs.getObject("von").toString().equals(von.toString())
							&& rs.getString("raum").equals(raum)) {
						break;

					}

					if ((rs.getObject("datum").toString().equals(datum.toString()))
							&& (rs.getString("raum").equals(raum))) {
						// Uhrzeitvergleich
						if (rs.getObject("bis").toString().compareTo(von.toString()) > 0) {

							if ((rs.getObject("von").toString().compareTo(von.toString()) <= 0)
									&& (rs.getObject("von").toString().compareTo(bis.toString()) <= 0)) {
								out.println("Der Raum " + raum + " ist am " + datum + " von " + rs.getObject("von")
										+ " bis " + rs.getObject("bis")
										+ " Uhr bereits belegt. Die LVA wurde nicht eingetragen!");
								checkDatum = true;
								break;
							}
						}
						if (rs.getObject("von").toString().compareTo(bis.toString()) > 0) {
							if ((rs.getObject("bis").toString().compareTo(bis.toString()) <= 0)
									&& (rs.getObject("bis").toString().compareTo(von.toString()) <= 0)) {
								out.println("Der Raum " + raum + " ist am " + datum + " von " + rs.getObject("von")
										+ " bis " + rs.getObject("bis")
										+ " Uhr bereits belegt. Die LVA wurde nicht eingetragen!");
								checkDatum = true;
								break;
							}
						}

						if (((rs.getObject("von").toString().compareTo(von.toString()) > 0)
								&& (rs.getObject("bis").toString().compareTo(bis.toString())) >= 0)
								&& (rs.getObject("von").toString().compareTo(bis.toString())) < 0) {
							out.println("Der Raum " + raum + " ist am " + datum + " von " + rs.getObject("von")
									+ " bis " + rs.getObject("bis")
									+ " Uhr bereits belegt. Die LVA wurde nicht eingetragen!");
							checkDatum = true;
							break;
						}
					}
				}

				rs.close();

				try {
					rs = stm.executeQuery(qRaum);

					while (rs.next()) {
						if (rs.getString(1).equals(raum)) {
							existsRaum = true;
						}
					}

					if (existsRaum == false) {
						out.println("Der eingegebene Raum existiert nicht! Die LVA wurde nicht angelegt!");
					} else if (checkGroesse == true) {
						out.println("Die maximale Raumkapazität beträgt " + raumgroesse
								+ ". Bitte geben Sie eine passende Größe an!");
					} else if (checkDatum == false) {
						pstmt = conn.prepareStatement(query);
						pstmt.setString(1, lva_titel);
						pstmt.setString(2, lva_nummer);
						pstmt.setString(3, leiter);
						pstmt.setInt(4, max_studierende);
						pstmt.setString(5, raum);
						pstmt.setObject(6, datum);
						pstmt.setObject(7, von);
						pstmt.setObject(8, bis);
						pstmt.setString(9, lva_nummer);

						pstmt.executeUpdate();

						pstmt.close();

						pstmt = conn.prepareStatement(inRaum);
						// LVA in DB-Tabelle raum_service eintragen

						pstmt.setString(1, raum);
						pstmt.setObject(2, datum);
						pstmt.setObject(3, von);
						pstmt.setObject(4, bis);
						pstmt.setString(5, lva_nummer);

						pstmt.executeUpdate();

						out.println("LVA wurde erfolgreich aktualisiert!");
						existsRaum = false;
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
					if (rs != null) {
						try {
							rs.close();
						} catch (SQLException e) {
							;
						}
						rs = null;
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
			} catch (DateTimeParseException ex) {
				out.println("ERROR: Bitte auf Datums- (dd.mm.yyyy) und Zeitformat (HH:MM) achten!");
			}
		%>

	</div>

</body>
</html>