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
<title>Veranstaltung Overview</title>
</head>
<body>
<h1> Alle Veranstaltungen </h1>
<table width = "100%" border = "1" align = "center">
            <tr bgcolor = "#949494">
               <th>Bezeichnung</th>
               <th>Datum</th>
               <th>Uhrzeit</th>
               <th>Ort</th>
            </tr>
<% 
Class.forName("org.sqlite.JDBC");
Connection conn = DriverManager.getConnection(
		"jdbc:sqlite:C:\\Users\\simon\\Documents\\Vorlesungen\\ServiceEngineering\\service_engineering_ue2\\ue2.db");
Statement stat = conn.createStatement();
String service ="SELECT * from veranstaltung";
ResultSet rs1 = stat.executeQuery(service);


while (rs1.next()) {
		   out.print("<tr><td>" + rs1.getString(2) + "</td>\n");
		   out.print("<td>" + rs1.getString(3) + "</td>\n"); 
		   out.println("<td> " + rs1.getString(4) + "-"+rs1.getString(5)+"</td>\n");
		   out.print("<td>" + rs1.getString(7) + "</td>\n");
		   out.println("<td> <a href=veranstaltung_ändern.jsp?id="+rs1.getString(1)+"> Edit</a></td></tr>\n");
}


%>
</body>
</html>