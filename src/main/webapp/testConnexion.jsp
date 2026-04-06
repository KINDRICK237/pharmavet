<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="connexion.ConnexionDB" %>
<%@ page import="java.sql.Connection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test Connexion</title>
</head>
<body>
    <h2>Test de connexion à la base de données</h2>
    <%
        Connection conn = ConnexionDB.getConnexion();
        if(conn != null) {
            out.println("<p style='color:green; font-size:20px;'>✅ Connexion réussie à MySQL !</p>");
            conn.close();
        } else {
            out.println("<p style='color:red; font-size:20px;'>❌ Connexion échouée !</p>");
        }
    %>
</body>
</html>