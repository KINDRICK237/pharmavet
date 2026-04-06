<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Utilisateur" %>
<%
    if(session.getAttribute("login") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if(!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("DashboardServlet");
        return;
    }
    List<Utilisateur> utilisateurs = (List<Utilisateur>) request.getAttribute("utilisateurs");
    String succes = request.getParameter("succes");
    String loginSession = (String) session.getAttribute("login");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaVet - Utilisateurs</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .navbar { background-color: #1a8a4a; }
        .navbar-brand { color: white !important; }
        .btn-vert { background-color: #1a8a4a; color: white; border: none; }
        .btn-vert:hover { background-color: #0d4f2b; color: white; }
        .table-header { background-color: #1a8a4a; color: white; }
        .card { border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .badge-admin { background-color: #e74c3c; }
        .badge-pharmacien { background-color: #2980b9; }
        .badge-caissier { background-color: #e67e22; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg">
        <div class="container-fluid">
            <span class="navbar-brand fw-bold">🐾 PharmaVet</span>
            <div class="ms-auto d-flex gap-2">
                <a href="DashboardServlet" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-house"></i> Accueil
                </a>
                <a href="LogoutServlet" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-box-arrow-right"></i> Déconnexion
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">

        <!-- Messages de succès -->
        <% if("ajoute".equals(succes)) { %>
        <div class="alert alert-success alert-dismissible fade show">
            ✅ Utilisateur ajouté avec succès !
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } else if("modifie".equals(succes)) { %>
        <div class="alert alert-success alert-dismissible fade show">
            ✅ Utilisateur modifié avec succès !
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } else if("reinit".equals(succes)) { %>
        <div class="alert alert-success alert-dismissible fade show">
            ✅ Mot de passe réinitialisé avec succès !
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <% if(request.getAttribute("erreur") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show">
            ❌ <%= request.getAttribute("erreur") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <!-- Titre -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4><i class="bi bi-people"></i> Gestion des Utilisateurs</h4>
            <a href="UtilisateurServlet?action=formulaireAjouter" class="btn btn-vert">
                <i class="bi bi-plus-circle"></i> Ajouter un utilisateur
            </a>
        </div>

        <!-- Tableau -->
        <div class="card">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead class="table-header">
                        <tr>
                            <th>#</th>
                            <th>Nom &amp; Prénom</th>
                            <th>Login</th>
                            <th>Rôle</th>
                            <th>Date création</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(utilisateurs != null && !utilisateurs.isEmpty()) {
                            for(Utilisateur u : utilisateurs) { %>
                        <tr>
                            <td><%= u.getId() %></td>
                            <td>
                                <strong><%= u.getNom() %> <%= u.getPrenom() %></strong>
                                <% if(u.getLogin().equals(loginSession)) { %>
                                <span class="badge bg-secondary ms-1">Vous</span>
                                <% } %>
                            </td>
                            <td><i class="bi bi-person-badge"></i> <%= u.getLogin() %></td>
                            <td>
                                <% if("admin".equals(u.getRole())) { %>
                                    <span class="badge badge-admin">👑 Admin</span>
                                <% } else if("pharmacien".equals(u.getRole())) { %>
                                    <span class="badge badge-pharmacien">💊 Pharmacien</span>
                                <% } else { %>
                                    <span class="badge badge-caissier">💰 Caissier</span>
                                <% } %>
                            </td>
                            <td><%= u.getDateCreation() %></td>
                            <td>
                                <a href="UtilisateurServlet?action=formulaireModifier&id=<%= u.getId() %>"
                                   class="btn btn-warning btn-sm" title="Modifier">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <a href="UtilisateurServlet?action=formulaireReinit&id=<%= u.getId() %>"
                                   class="btn btn-info btn-sm text-white" title="Réinitialiser mot de passe">
                                    <i class="bi bi-key"></i>
                                </a>
                                <% if(!u.getLogin().equals(loginSession)) { %>
                                <a href="UtilisateurServlet?action=supprimer&id=<%= u.getId() %>"
                                   class="btn btn-danger btn-sm"
                                   title="Supprimer"
                                   onclick="return confirm('Voulez-vous vraiment supprimer cet utilisateur ?')">
                                    <i class="bi bi-trash"></i>
                                </a>
                                <% } %>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr>
                            <td colspan="6" class="text-center text-muted py-4">
                                Aucun utilisateur enregistré
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>