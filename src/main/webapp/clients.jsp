<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Client" %>
<%
    if(session.getAttribute("login") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Client> clients = (List<Client>) request.getAttribute("clients");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaVet - Clients</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .navbar { background-color: #1a8a4a; }
        .navbar-brand, .nav-link { color: white !important; }
        .btn-vert { background-color: #1a8a4a; color: white; border: none; }
        .btn-vert:hover { background-color: #0d4f2b; color: white; }
        .table-header { background-color: #1a8a4a; color: white; }
        .card { border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
    </style>
</head>
<body>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg">
        <div class="container-fluid">
            <span class="navbar-brand fw-bold">🐾 PharmaVet</span>
            <div class="ms-auto d-flex gap-2">
                <a href="dashboard.jsp" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-house"></i> Accueil
                </a>
                <a href="LogoutServlet" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-box-arrow-right"></i> Déconnexion
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">

        <!-- Titre + bouton ajouter -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4><i class="bi bi-people"></i> Gestion des Clients</h4>
            <div class="d-flex gap-2">
                <a href="AnimalServlet?action=liste" class="btn btn-outline-success">
                    <i class="bi bi-github"></i> Voir les animaux
                </a>
                <a href="ClientServlet?action=formulaireAjouter" class="btn btn-vert">
                    <i class="bi bi-plus-circle"></i> Ajouter un client
                </a>
            </div>
        </div>

        <!-- Tableau des clients -->
        <div class="card">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead class="table-header">
                        <tr>
                            <th>#</th>
                            <th>Nom &amp; Prénom</th>
                            <th>Téléphone</th>
                            <th>Email</th>
                            <th>Adresse</th>
                            <th>Date inscription</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(clients != null && !clients.isEmpty()) {
                            for(Client c : clients) { %>
                        <tr>
                            <td><%= c.getId() %></td>
                            <td>
                                <strong><%= c.getNom() %> <%= c.getPrenom() %></strong>
                            </td>
                            <td><i class="bi bi-telephone"></i> <%= c.getTelephone() %></td>
                            <td><%= c.getEmail() %></td>
                            <td><%= c.getAdresse() %></td>
                            <td><%= c.getDateInscription() %></td>
                            <td>
                                <a href="ClientServlet?action=detail&id=<%= c.getId() %>"
                                   class="btn btn-info btn-sm text-white">
                                    <i class="bi bi-eye"></i>
                                </a>
                                <a href="ClientServlet?action=formulaireModifier&id=<%= c.getId() %>"
                                   class="btn btn-warning btn-sm">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <a href="ClientServlet?action=supprimer&id=<%= c.getId() %>"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Voulez-vous vraiment supprimer ce client ?')">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr>
                            <td colspan="7" class="text-center text-muted py-4">
                                Aucun client enregistré
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