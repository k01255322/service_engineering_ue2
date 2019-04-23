<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@page import="java.time.format.DateTimeFormatter"%>
   <%@page import="java.time.LocalDate"%>
    <%@ page import="java.sql.*"%>
    <%@ page import="org.sqlite.*"%>
    <%@ page import="java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Termin_Übersicht</title>
</head>
<body>
<h1> <%= request.getParameter("datum") %> </h1>
<table width = "100%" border = "1" align = "center">
            <tr bgcolor = "#949494">
               <th>Raum</th>
               <th>Uhrzeit</th>
            </tr>
<% 
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");
LocalDate ldatum = LocalDate.parse(request.getParameter("datum"), formatter);
String datum = ldatum.format(formatter);
String raum = request.getParameter("raum");
Class.forName("org.sqlite.JDBC");
Connection conn = DriverManager.getConnection(
		"jdbc:sqlite:C:\\Users\\simon\\Documents\\Vorlesungen\\ServiceEngineering\\service_engineering_ue2\\ue2.db");
Statement stat = conn.createStatement();
String service ="SELECT raum,von,bis FROM raum_service" +
        " WHERE raum='"+raum+"'"+"and datum='"+datum+"'";
ResultSet rs1 = stat.executeQuery(service);


while (rs1.next()) {
		   out.print("<tr><td>" + rs1.getString(1) + "</td>\n"); 
		   out.println("<td> " + rs1.getString(2) + "-"+rs1.getString(3)+"</td></tr>\n");
}


%>
</body>
</html>