<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@page import="java.time.format.DateTimeFormatter"%>
   <%@page import="java.time.LocalDate"%>
   <%@page import="java.time.LocalTime"%>
    <%@ page import="java.sql.*"%>
    <%@ page import="org.sqlite.*"%>
    <%@ page import="java.util.*"%>
    <%@page import="sqliteConnector.sqliteConnection"%>

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
<title>Raum Suche</title>
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
<table class="table">
            <tr bgcolor = "#949494">
               <th scope="col">Raum</th>
               <th scope="col">max Personen</th>
            </tr>
            <%
            
               boolean frei = false;
               boolean max = false;
               DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");
               LocalDate ldatum = null;
               DateTimeFormatter formatter2 = DateTimeFormatter.ISO_LOCAL_TIME;
               LocalTime von = null;
               LocalTime bis = null;
               String datum = null;
               frei = Boolean.parseBoolean(request.getParameter("frei"));
               max  = Boolean.parseBoolean(request.getParameter("max"));
               int maxanzahl = 0;
               try{
               maxanzahl = Integer.parseInt(request.getParameter("maxanzahl"));}
               catch(Exception e){
            	     maxanzahl = 0;
               }
               Class.forName("org.sqlite.JDBC");
               Connection conn = sqliteConnection.dbConnector();
               Statement stat = conn.createStatement();
               String qRaum = "SELECT * FROM raeume";
               
             
               
               if(frei&max){
            	   ldatum = LocalDate.parse(request.getParameter("datum"), formatter);
            	   datum = ldatum.format(formatter);
            	   von = LocalTime.parse(request.getParameter("von"), formatter2);
            	   bis = LocalTime.parse(request.getParameter("bis"), formatter2);
            	   String service ="SELECT raum FROM raum_service" +
                           " WHERE datum='"+datum+"' and von='"+von+"' and bis='"+bis+"'";
            	   qRaum ="SELECT * FROM raeume Where max_personen >="+maxanzahl;
            	   ResultSet rs1 = stat.executeQuery(service);
            	   
            	   List<String> temp = new ArrayList<String>();
            	   
            	   while(rs1.next()){
            		   String raum = rs1.getString(1);
            		   temp.add(raum);
            	   }
            	   ResultSet rs2 = stat.executeQuery(qRaum);
            	   while (rs2.next()) {
            		   boolean found = false;
            		   for(int i =0;i<temp.size();i++){
            			   if(rs2.getString("ID").equals(temp.get(i))){
            				   found =true;
            			   }
            			   
            		   }
            		   
            		   if(found==false){
 
            			   
            			   String raum = rs2.getString(1).replaceAll(" ", "%20");
            			   out.print("<tr><td>" + rs2.getString(1) + "</td>\n");
            			   out.println("<td> " + rs2.getString(2) + "</td>\n");
            			   out.println("<td> <a href=book_room.jsp?raum="+raum+"&datum="+datum+"&von="+von+"&bis="+bis
            					   +"> Buchen</a></td></tr>\n");
            			   
            			   
            		   }
            			
            		}
            	   
            	   frei= false;
            	   max=false;
            	   
               }
               if(frei){
            	   ldatum = LocalDate.parse(request.getParameter("datum"), formatter);
            	   datum = ldatum.format(formatter);
            	   von = LocalTime.parse(request.getParameter("von"), formatter2);
            	   bis = LocalTime.parse(request.getParameter("bis"), formatter2);
            	   String service ="SELECT DISTINCT raum FROM raum_service" +
                           " WHERE datum='"+datum+"' and von='"+von+"' and bis='"+bis+"'";
            	   ResultSet rs1 = stat.executeQuery(service);
            	   
            	   List<String> temp = new ArrayList<String>();
            	   
            	   while(rs1.next()){
            		   String raum = rs1.getString(1);
            		   temp.add(raum);
            	   }
            	   ResultSet rs2 = stat.executeQuery(qRaum);
            	   while (rs2.next()) {
            		   boolean found = false;
            		   for(int i =0;i<temp.size();i++){
            			   if(rs2.getString(1).equals(temp.get(i))){
            				   
            				   found =true;
            			   }
            			   
            		   }
            		   
            		   if(!found){
            			   out.print("<tr><td>" + rs2.getString(1) + "</td>\n"); 
            			   out.println("<td> " + rs2.getString(2) + "</td></tr>\n");
            		   }
            			
            		}
            	   
            	   
            	   
               }
               if(max){
            	   qRaum ="SELECT * FROM raeume Where max_personen >="+maxanzahl;
            	   ResultSet rs1 = stat.executeQuery(qRaum);
            	   while (rs1.next()) {
            			   out.print("<tr><td>" + rs1.getString(1) + "</td>\n"); 
            			   out.println("<td> " + rs1.getString(2) + "</td></tr>\n");
            			
            		}
               }
               
               
               
            %>
         </table>
 </div>
</body>
</html>