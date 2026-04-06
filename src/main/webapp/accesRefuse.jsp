<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("login") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaVet - Accès refusé</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #1a8a4a, #0d4f2b);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .card {
            border-radius: 20px;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            max-width: 500px;
            width: 100%;
            padding: 40px;
            text-align: center;
        }
        .icon-refus { font-size: 80px; color: #e74c3c; }
        .btn-vert { background-color: #1a8a4a; color: white; border: none; }
        .btn-vert:hover { background-color: #0d4f2b; color: white; }
    </style>
</head>
<body>
    <div class="card">
        <div class="icon-refus mb-3">🚫</div>
        <h3 class="text-danger fw-bold">Accès Refusé</h3>
        <p class="text-muted mt-3">
            <%= request.getAttribute("erreur") != null ?
                request.getAttribute("erreur") :
                "Vous n'avez pas les droits nécessaires pour accéder à cette page." %>
        </p>
        <div class="d-flex gap-2 justify-content-center mt-4">
            <a href="DashboardServlet" class="btn btn-vert">
                <i class="bi bi-house"></i> Retour au tableau de bord
            </a>
        </div>
    </div>
</body>
</html>