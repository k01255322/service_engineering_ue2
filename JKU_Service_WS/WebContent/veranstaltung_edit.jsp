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
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
boolean raumexists = false;
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");
String datum = null;
LocalTime von,bis;
von = null;
bis = null;
DateTimeFormatter formatter2 = DateTimeFormatter.ISO_LOCAL_TIME;
try{
LocalDate ldatum = LocalDate.parse(request.getParameter("datum"), formatter);
 datum = ldatum.format(formatter);
 von = LocalTime.parse(request.getParameter("von"), formatter2);
 bis = LocalTime.parse(request.getParameter("bis"), formatter2);
}
catch(Exception e){};
String id = request.getParameter("id");
String bez = request.getParameter("bez");
String ort = request.getParameter("ort");
int maxanzahl = Integer.parseInt(request.getParameter("maxteilnehmer"));
Class.forName("org.sqlite.JDBC");
Connection conn = DriverManager.getConnection(
		"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");
Statement stat = conn.createStatement();
String service ="SELECT * FROM veranstaltung" +
                " WHERE ID='"+id+"'";
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
 if(raumexists==false){
		ort = null;
	}
 if(rs.next())
{
	try {
		String query = "UPDATE veranstaltung SET bez=?,datum=?,von=?, bis=?,max_teilnehmer=?,ort=? WHERE ID='"+id+"'";
		pst = conn.prepareStatement(query);


		if (bez!= null) {
			pst.setString(1, bez);
		} else {
			pst.setString(1,rs.getString(2));
		}

		if (datum != null) {
			pst.setObject(2, datum);
		} else {
			pst.setObject(2, rs.getObject(3));;
		}

		if (von != null) {
			pst.setObject(3, von);
		} else {
			pst.setObject(3, rs.getObject(4));
		}

		if (bis != null) {
			pst.setObject(4, bis);
		} else {
			pst.setObject(4, rs.getObject(5));
		}
		if (maxanzahl>0) {
			pst.setInt(5, maxanzahl);
		} else {
			pst.setInt(5, rs.getInt(6));
		}
		if (ort != null) {
			pst.setString(6, ort);
		} else {
			pst.setString(6, rs.getString(7));
		}

		pst.executeUpdate();

		out.println("Die Veranstaltung wurde erfolgreich ge�ndert");
		out.println("<a href=index.html>Zur�ck zur Startseite</a>");
		

	} catch (SQLException e) {
		e.printStackTrace();
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
else{
	out.println("Veranstaltung existiert nicht!");
}







%>
</body>
</html>