<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@page import="java.text.SimpleDateFormat"%>
    <%@ page import="java.sql.*"%>
    <%@ page import="org.sqlite.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Raum buchen</title>
</head>
<body>
<%
boolean raumexists = false;
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

Class.forName("org.sqlite.JDBC");
Connection conn = DriverManager.getConnection(
		"jdbc:sqlite:C:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");
Statement stat = conn.createStatement();
String qRaum = "SELECT * FROM raeume";
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

if (raumexists==false){
	out.println("Dieser Raum existiert nicht. Daher kann kein Termin gebucht werden!");
}else{
	
	try {
		pst = conn.prepareStatement(query);


		if (raum != null) {
			pst.setString(1, raum);
		} else {
			pst.setNull(1, java.sql.Types.VARCHAR);
		}

		if (datum != null) {
			pst.setDate(2, datum);
		} else {
			pst.setNull(2, java.sql.Types.DATE);
		}

		if (von != null) {
			pst.setTime(3, von);
		} else {
			pst.setNull(3, java.sql.Types.TIME);
		}

		if (bis != null) {
			pst.setTime(4, bis);
		} else {
			pst.setNull(4, java.sql.Types.TIME);
		}

		pst.executeUpdate();

		out.println("Der Raum " + raum + " wurde erfolgreich zum angegebenen Termin reserviert!");

	} catch (SQLException e) {
		if(conn!=null)
            conn.rollback();
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