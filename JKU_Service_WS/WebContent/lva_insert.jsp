<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@page import="java.text.SimpleDateFormat"%>
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

		// Abfrage der eingegebenen Daten
		String lva_bezeichnung = request.getParameter("titel");
		String lva_nummer = request.getParameter("lva_nummer");
		String leiter = request.getParameter("leiter");
		int max_studierende = Integer.parseInt(request.getParameter("max_studierende"));
		String raum = null;
		Date datum = null;
		Time von = null;
		Time bis = null;
		SimpleDateFormat formatter = new SimpleDateFormat("dd.MM.yyyy");
		SimpleDateFormat formatter2 = new SimpleDateFormat("HH:mm");

		if (request.getParameter("raum") != null && !request.getParameter("raum").equals("")) {
			raum = request.getParameter("raum");
		}

		if (request.getParameter("datum") != null && !request.getParameter("datum").equals("")) {
			java.util.Date parsedate = formatter.parse(request.getParameter("datum"));
			datum = new java.sql.Date(parsedate.getTime());
		}

		if (request.getParameter("von") != null && !request.getParameter("von").equals("")) {
			long ms = formatter2.parse(request.getParameter("von")).getTime();
			von = new Time(ms);
		}

		if (request.getParameter("bis") != null && !request.getParameter("bis").equals("")) {
			long ms = formatter2.parse(request.getParameter("bis")).getTime();
			bis = new Time(ms);
		}

		// Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:C:\\Users\\simon\\Documents\\Vorlesungen\\ServiceEngineering\\service_engineering_ue2\\ue2.db");
		Statement stat = conn.createStatement();

		String qLva = "SELECT lva_nummer FROM lva_service";

		String qRaum = "SELECT * FROM raeume";

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

		if (raum != null) {
			rs = stat.executeQuery(qRaum);
			while (rs.next()) {
				if (rs.getString("id").equals(raum)) {
					existsRaum = true;
					break;
				}
			}
		}

		if (existsLva == true) {
			out.println("LVA ist bereits vorhanden und wurde nicht erneut angelegt!");
			existsLva = false;
		} else if (existsRaum == false) {
			out.println("Der eingegebene Raum existiert nicht! Die LVA wurde nicht angelegt!");
		} else {
			try {
				pst = conn.prepareStatement(query);

				pst.setString(1, lva_bezeichnung);
				pst.setString(2, lva_nummer);
				pst.setString(3, leiter);
				pst.setInt(4, max_studierende);

				/**
					To-Do: 
						Datums und Zeitformat beim Einfügen in DB
						Abgleich von/bis, damit am selben Datum keine Überschneidungen im Raum sind
				**/

				if (raum != null) {
					pst.setString(5, raum);
				} else {
					pst.setNull(5, java.sql.Types.VARCHAR);
				}

				if (datum != null) {
					pst.setDate(6, datum);
				} else {
					pst.setNull(6, java.sql.Types.DATE);
				}

				if (von != null) {
					pst.setTime(7, von);
				} else {
					pst.setNull(7, java.sql.Types.TIME);
				}

				if (bis != null) {
					pst.setTime(8, bis);
				} else {
					pst.setNull(8, java.sql.Types.TIME);
				}

				pst.executeUpdate();

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
	%>
	<br>
	<br>
	<a href="main_page.html">Hauptmenü</a>

</body>
</html>