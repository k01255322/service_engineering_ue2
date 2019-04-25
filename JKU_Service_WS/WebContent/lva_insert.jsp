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
<title>LVA in Datenbank einfügen</title>
</head>
<body>

	<%
		String ak_nummer = request.getParameter("ak_nummer");
	%>

	<div class="container">

		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<a class="navbar-brand" href="index.html">Hauptmenü</a> <a
				class="navbar-brand" href="lva_service.html">LVA Service</a> <a
				class="navbar-brand" href="prüfungsservice.html">Prüfungsservice</a>
			<a class="navbar-brand" href="raumservice.html">Raumservice</a> <a
				class="navbar-brand" href="veranstaltungsservice.html">Veranstaltungsservice</a>
			<a class="navbar-brand"
				href="lva_input.jsp?ak_nummer=<%=ak_nummer%>">Weitere LVA
				anlegen</a>
		</nav>

		<br>


		<%
			// Variablen
			boolean existsLva = false;
			boolean existsRaum = false;
			boolean checkGroesse = false;
			boolean checkDatum = false;
			int raumgroesse = 0;

			// Abfrage der eingegebenen Daten

			String lva_bezeichnung = request.getParameter("titel");
			String lva_nummer = request.getParameter("lva_nummer");
			String leiter = null;
			try {
				int max_studierende = Integer.parseInt(request.getParameter("max_studierende"));
				String raum = request.getParameter("raum");

				String woechentlich = request.getParameter("woechentlich"); // value = on wenn angekreuzt

				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");
				LocalDate tempDatum = LocalDate.parse(request.getParameter("datum"), formatter);
				String datum = tempDatum.format(formatter);

				DateTimeFormatter formatter2 = DateTimeFormatter.ISO_LOCAL_TIME;
				LocalTime von = LocalTime.parse(request.getParameter("von"), formatter2);
				LocalTime bis = LocalTime.parse(request.getParameter("bis"), formatter2);

				// Datenbankverbindung
				Connection conn = sqliteConnection.dbConnector();
				Statement stat = conn.createStatement();

				String qLva = "SELECT lva_nummer FROM lva_service";

				String qLeiter = "SELECT nachname FROM lehrende_liste WHERE ak_nummer=?";

				String qRaum = "SELECT * FROM raeume";

				String qDatum = "SELECT * FROM raum_service";

				String query = "INSERT INTO lva_service(titel, lva_nummer, leiter, max_studierende, raum, datum, von, bis, ak_nummer) VALUES (?,?,?,?,?,?,?,?,?)";
				PreparedStatement pst = null;

				// Prüfung, ob LVA bereits vorhanden	
				ResultSet rs = stat.executeQuery(qLva);
				while (rs.next()) {
					if (rs.getString("lva_nummer").equals(lva_nummer)) {
						existsLva = true;
						break;
					}
				}

				rs = stat.executeQuery(qRaum);
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

				pst = conn.prepareStatement(qLeiter);
				pst.setString(1, ak_nummer);
				rs = pst.executeQuery();
				leiter = rs.getString(1);

				rs.close();
				pst.close();

				rs = stat.executeQuery(qDatum);
				while (rs.next()) {
					if ((rs.getObject("datum").toString().equals(datum.toString()))
							&& (rs.getString("raum").equals(raum))) {

						if (rs.getObject("bis").toString().compareTo(von.toString()) > 0) {

							if ((rs.getObject("von").toString().compareTo(von.toString()) <= 0)
									&& (rs.getObject("von").toString().compareTo(bis.toString()) <= 0)) {
								out.println("Der Raum " + raum + " ist am " + datum + " von " + rs.getObject("von")
										+ " bis " + rs.getObject("bis")
										+ " Uhr bereits belegt. Die LVA wurde nicht eingetragen!");
								checkDatum = true;
							}
						}
						if (rs.getObject("von").toString().compareTo(bis.toString()) > 0) {
							if ((rs.getObject("bis").toString().compareTo(bis.toString()) <= 0)
									&& (rs.getObject("bis").toString().compareTo(von.toString()) <= 0)) {
								out.println("Der Raum " + raum + " ist am " + datum + " von " + rs.getObject("von")
										+ " bis " + rs.getObject("bis")
										+ " Uhr bereits belegt. Die LVA wurde nicht eingetragen!");
								checkDatum = true;
								;
							}
						}

						if (((rs.getObject("von").toString().compareTo(von.toString()) > 0)
								&& (rs.getObject("bis").toString().compareTo(bis.toString())) > 0)
								&& (rs.getObject("von").toString().compareTo(bis.toString())) < 0) {
							out.println("Der Raum " + raum + " ist am " + datum + " von " + rs.getObject("von")
									+ " bis " + rs.getObject("bis")
									+ " Uhr bereits belegt. Die LVA wurde nicht eingetragen!");
							checkDatum = true;
						}
					}
				}

				rs.close();

				if (existsLva == true) {
					out.println("LVA ist bereits vorhanden und wurde nicht erneut angelegt!");
					existsLva = false;
				} else if (existsRaum == false) {
					out.println("Der eingegebene Raum existiert nicht! Die LVA wurde nicht angelegt!");
				} else if (checkGroesse == true) {
					out.println("Die maximale Raumkapazität beträgt " + raumgroesse
							+ ". Bitte geben Sie eine passende Größe an!");
				} else if (checkDatum == false) {
					try {
						pst = conn.prepareStatement(query);

						pst.setString(1, lva_bezeichnung);
						pst.setString(2, lva_nummer);
						pst.setString(3, leiter);
						pst.setInt(4, max_studierende);
						pst.setString(5, raum);
						pst.setObject(6, datum);
						pst.setObject(7, von);
						pst.setObject(8, bis);
						pst.setString(9, ak_nummer);

						pst.executeUpdate();

						// LVA in DB-Tabelle raum_service eintragen
						response.sendRedirect("book_room.jsp?raum=" + raum + "&datum=" + datum.toString() + "&von="
								+ von.toString() + "&bis=" + bis.toString());

						out.println("LVA mit der Nummer " + lva_nummer + " und der Bezeichnung " + lva_bezeichnung
								+ " wurde erfolgreich angelegt!");

					} catch (SQLException e) {
						e.printStackTrace();
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
			} catch (DateTimeParseException ex) {
				out.println("ERROR: Bitte auf Datums- (dd.mm.yyyy) und Zeitformat (HH:MM) achten!");
			}
		%>
		<br> <br>
</body>
</html>