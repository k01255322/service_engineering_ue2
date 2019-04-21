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
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

	<%
		// Variablen
		boolean exists = false;
		boolean existsPrüfung = false;
		boolean checkDatum = false;

		//Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");

		String query = "INSERT INTO pruefungs_service (lva_titel, lva_nummer, datum, von, bis, ort, anzahl_plaetze, anmeldungen) VALUES(?,?,?,?,?, ?,?,0)";
		String qRaum = "SELECT ID FROM raeume";
		String qPrüfung = "SELECT lva_nummer FROM pruefungs_service";
		String qDatum = "SELECT * FROM raum_service";

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
			LocalDate datum = LocalDate.parse(request.getParameter("datum"), formatter);
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
						// Uhrzeitvergleich

						if (rs.getObject("bis").toString().compareTo(von.toString()) > 0) {

							if ((rs.getObject("von").toString().compareTo(von.toString()) <= 0)
									&& (rs.getObject("von").toString().compareTo(bis.toString()) <= 0)) {
								out.println("Der Raum " + raum + " ist am " + datum + " von " + rs.getObject("von")
										+ " bis " + rs.getObject("bis")
										+ " Uhr bereits belegt. Die Prüfung wurde nicht eingetragen!");
								checkDatum = true;
							}
						}
						if (rs.getObject("von").toString().compareTo(bis.toString()) > 0) {
							if ((rs.getObject("bis").toString().compareTo(bis.toString()) <= 0)
									&& (rs.getObject("bis").toString().compareTo(von.toString()) <= 0)) {
								out.println("Der Raum " + raum + " ist am " + datum + " von " + rs.getObject("von")
										+ " bis " + rs.getObject("bis")
										+ " Uhr bereits belegt. Die Prüfung wurde nicht eingetragen!");
								checkDatum = true;
								;
							}
						}

						if (((rs.getObject("von").toString().compareTo(von.toString()) > 0)
								&& (rs.getObject("bis").toString().compareTo(bis.toString())) > 0)
								&& (rs.getObject("von").toString().compareTo(bis.toString())) < 0) {
							out.println("Der Raum " + raum + " ist am " + datum + " von " + rs.getObject("von")
									+ " bis " + rs.getObject("bis")
									+ " Uhr bereits belegt. Die Prüfung wurde nicht eingetragen!");
							checkDatum = true;
						}
					}
				}

				rs.close();

				/**
				To-Do --> Eintragen in die Tabelle raum_service
				**/

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

	<br>
	<br>
	<a href="lva_overview.jsp">LVA Übersicht</a>

</body>
</html>