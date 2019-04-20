<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.LocalTime"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>LVA in Datenbank einfügen</title>
</head>
<body>

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
		String leiter = request.getParameter("leiter");
		int max_studierende = Integer.parseInt(request.getParameter("max_studierende"));
		String raum = request.getParameter("raum");

		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDate datum = LocalDate.parse(request.getParameter("datum"), formatter);
		DateTimeFormatter formatter2 = DateTimeFormatter.ISO_LOCAL_TIME;
		LocalTime von = LocalTime.parse(request.getParameter("von"), formatter2);
		LocalTime bis = LocalTime.parse(request.getParameter("bis"), formatter2);

		// Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");
		Statement stat = conn.createStatement();

		String qLva = "SELECT lva_nummer FROM lva_service";

		String qRaum = "SELECT * FROM raeume";

		String qDatum = "SELECT * FROM raum_service";

		String query = "INSERT INTO lva_service(titel, lva_nummer, leiter, max_studierende, raum, datum, von, bis) VALUES (?,?,?,?,?,?,?,?)";
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

		rs = stat.executeQuery(qDatum);
		while (rs.next()) {
			if ((rs.getObject("datum").toString().equals(datum.toString())) && (rs.getString("raum").equals(raum))) {
				// Uhrzeitvergleich

				if (rs.getObject("bis").toString().compareTo(von.toString()) > 0) {

					if ((rs.getObject("von").toString().compareTo(von.toString()) <= 0)
							&& (rs.getObject("von").toString().compareTo(bis.toString()) <= 0)) {
						out.println("Der Raum " + raum + " ist am "  
								+ datum + " von " + rs.getObject("von") + " bis " + rs.getObject("bis") 
								+ " Uhr bereits belegt. Die LVA wurde nicht eingetragen!");
						checkDatum = true;
					}
				}
				if (rs.getObject("von").toString().compareTo(bis.toString()) > 0) {
					if ((rs.getObject("bis").toString().compareTo(bis.toString()) <= 0)
							&& (rs.getObject("bis").toString().compareTo(von.toString()) <= 0)) {
						out.println("Der Raum " + raum + " ist am "  
								+ datum + " von " + rs.getObject("von") + " bis " + rs.getObject("bis") 
								+ " Uhr bereits belegt. Die LVA wurde nicht eingetragen!");
						checkDatum = true;
						;
					}
				}

				if (((rs.getObject("von").toString().compareTo(von.toString()) > 0)
						&& (rs.getObject("bis").toString().compareTo(bis.toString())) > 0)
						&& (rs.getObject("von").toString().compareTo(bis.toString())) < 0) {
					out.println("Der Raum " + raum + " ist am "  
							+ datum + " von " + rs.getObject("von") + " bis " + rs.getObject("bis") 
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

				pst.executeUpdate();
				
				

				out.println("LVA mit der Nummer " + lva_nummer + " und der Bezeichnung " + lva_bezeichnung
						+ " wurde erfolgreich angelegt!");
				
				/**
				response.sendRedirect("raum_service.jsp?raum="+raum 
						+ "&datum=" + datum + "&von="+von + "&bis=" +bis);
				**/

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
	%>
	<br>
	<br>
	<a href="lva_insert.html">Zurück</a>
	<a href="main_page.html">Hauptmenü</a>

</body>
</html>