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
<title>Prüfung einfügen</title>
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
			// Variablen
			boolean exists = false;
			boolean existsPrüfung = false;
			boolean checkDatum = false;

			//Datenbankverbindung
			Connection conn = sqliteConnection.dbConnector();

			String query = "INSERT INTO pruefungs_service (lva_titel, lva_nummer, datum, von, bis, ort, anzahl_plaetze, anmeldungen) VALUES(?,?,?,?,?, ?,?,0)";
			String qRaum = "SELECT ID FROM raeume";
			String qPrüfung = "SELECT lva_nummer FROM pruefungs_service";
			String qDatum = "SELECT * FROM raum_service";
			String inRaum = "INSERT INTO raum_service(raum, datum, von, bis, lva_nummer) VALUES (?,?,?,?,?)";

			PreparedStatement pstmt = null;
			Statement st = null;
			ResultSet rs = null;

			String lva_bezeichnung = request.getParameter("titel");
			String lva_nummer = request.getParameter("lva_nummer");
			DateTimeFormatter formatter2 = DateTimeFormatter.ISO_LOCAL_TIME;
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");
			try {
				LocalTime von = LocalTime.parse(request.getParameter("von"), formatter2);
				LocalTime bis = LocalTime.parse(request.getParameter("bis"), formatter2);
				LocalDate tempDatum = LocalDate.parse(request.getParameter("datum"), formatter);
				String datum = tempDatum.format(formatter);

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

					rs = st.executeQuery(qPrüfung);
					while (rs.next()) {
						if (rs.getString(1).equals(lva_nummer)) {
							existsPrüfung = true;
							break;
						}
					}

					rs.close();

					rs = st.executeQuery(qDatum);
					while (rs.next()) {
						if ((rs.getObject("datum").toString().equals(datum.toString()))
								&& (rs.getString("raum").equals(raum))) {

							if (rs.getObject("bis").toString().compareTo(von.toString()) > 0) {

								if ((rs.getObject("von").toString().compareTo(von.toString()) <= 0)
										&& (rs.getObject("von").toString().compareTo(bis.toString()) <= 0)) {
									out.println("Der Raum " + raum + " ist am " + datum + " von " + rs.getObject("von")
											+ " bis " + rs.getObject("bis")
											+ " Uhr bereits belegt. Die Prüfung wurde nicht eingetragen!");
									checkDatum = true;
									break;
								}
							}
							if (rs.getObject("von").toString().compareTo(bis.toString()) > 0) {
								if ((rs.getObject("bis").toString().compareTo(bis.toString()) <= 0)
										&& (rs.getObject("bis").toString().compareTo(von.toString()) <= 0)) {
									out.println("Der Raum " + raum + " ist am " + datum + " von " + rs.getObject("von")
											+ " bis " + rs.getObject("bis")
											+ " Uhr bereits belegt. Die Prüfung wurde nicht eingetragen!");
									checkDatum = true;
									break;
								}
							}

							if (((rs.getObject("von").toString().compareTo(von.toString()) > 0)
									&& (rs.getObject("bis").toString().compareTo(bis.toString())) >= 0)
									&& (rs.getObject("von").toString().compareTo(bis.toString())) < 0) {
								out.println("Der Raum " + raum + " ist am " + datum + " von " + rs.getObject("von")
										+ " bis " + rs.getObject("bis")
										+ " Uhr bereits belegt. Die Prüfung wurde nicht eingetragen!");
								checkDatum = true;
								break;
							}
						}
					}

					rs.close();

					if (exists == true && existsPrüfung == false && checkDatum == false) {
						pstmt = conn.prepareStatement(query);
						pstmt.setString(1, lva_bezeichnung);
						pstmt.setString(2, lva_nummer);
						pstmt.setObject(3, datum);
						pstmt.setObject(4, von);
						pstmt.setObject(5, bis);
						pstmt.setString(6, raum);
						pstmt.setInt(7, plaetze);

						pstmt.executeUpdate();

						pstmt.close();

						pstmt = conn.prepareStatement(inRaum);
						// Prüfung in DB-Tabelle raum_service eintragen

						pstmt.setString(1, raum);
						pstmt.setObject(2, datum);
						pstmt.setObject(3, von);
						pstmt.setObject(4, bis);
						pstmt.setString(5, lva_nummer);

						pstmt.executeUpdate();

						out.println("Prüfung für die LVA " + lva_bezeichnung + " (" + lva_nummer
								+ ") wurde erfolgreich angelegt!");


					} else if (exists == false) {
						out.println("Der eingegebene Raum (" + raum + ") existiert nicht!");
					} else {
						out.println("Für diese LVA (" + lva_nummer + ") wurde bereits eine Prüfung angelegt!");
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
			} catch (DateTimeParseException ex) {
				out.println("ERROR: Bitte auf Datums- (dd.mm.yyyy) und Zeitformat (HH:MM) achten!");
			}
		%>
	</div>
	<br>
	<br>

</body>
</html>