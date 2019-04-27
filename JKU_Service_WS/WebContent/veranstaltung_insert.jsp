<%@page import="sqliteConnector.sqliteConnection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@page import="java.time.format.DateTimeFormatter"%>
   <%@page import="java.time.LocalDate"%>
   <%@page import="java.time.LocalTime"%>
    <%@ page import="java.sql.*"%>
    <%@ page import="org.sqlite.*"%>
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
<title>Insert title here</title>
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
String bez = request.getParameter("bez");
String ort = request.getParameter("ort");
int maxanzahl = Integer.parseInt(request.getParameter("maxteilnehmer"));
Connection conn = sqliteConnection.dbConnector();
Statement stat = conn.createStatement();
String service ="SELECT * FROM veranstaltung" +
                " WHERE bez='"+bez+"'"+"and datum='"+datum+"' and von='"+von+"' and bis='"+bis+"'and ort='"+ort+"'";
String query = "INSERT INTO veranstaltung( bez, datum, von, bis,max_teilnehmer,ort) VALUES (?,?,?,?,?,?)";
PreparedStatement pst = null;
String qRaum = "SELECT * FROM raeume";
ResultSet rs = stat.executeQuery(qRaum);
if (ort != null) {
	while (rs.next()) {
		if (rs.getString("id").equals(ort)) {
			raumexists = true;
			break;
		}
	}
 }
 rs = stat.executeQuery(service);
if(rs.next())
{
	out.println("Veranstaltung existiert bereits!");
}else if(raumexists==false){
	out.print("Der Ort an dem die Veranstaltung stattfindet existiert nicht!");
}
else{
	
	try {
		pst = conn.prepareStatement(query);


		if (bez!= null) {
			pst.setString(1, bez);
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
		if (maxanzahl>0) {
			pst.setInt(5, maxanzahl);
		} else {
			pst.setInt(5, 0);
		}
		if (ort != null) {
			pst.setString(6, ort);
		} else {
			pst.setNull(6, java.sql.Types.VARCHAR);
		}

		pst.executeUpdate();

		out.println("Die Veranstaltung wurde erfolgreich angelegt");
		out.println("<a href=index.html>Zurück zur Startseite</a>");
		

	} catch (SQLException e) {
		if(conn!=null)
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