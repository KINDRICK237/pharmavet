<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Client" %>
<%@ page import="model.Animal" %>
<%
    if(session.getAttribute("login") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Client c = (Client) request.getAttribute("client");
    List<Animal> animaux = (List<Animal>) request.getAttribute("animaux");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaVet - Detail Client</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .navbar { background-color: #1a8a4a; }
        .navbar-brand { color: white !important; }
        .card { border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .btn-vert { background-color: #1a8a4a; color: white; border: none; }
        .btn-vert:hover { background-color: #0d4f2b; color: white; }
        .table-header { background-color: #1a8a4a; color: white; }
        .info-label { font-weight: 600; color: #444; }
        .client-header {
            background: linear-gradient(135deg, #1a8a4a, #0d4f2b);
            color: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg">
        <div class="container-fluid">
            <span class="navbar-brand fw-bold">🐾 PharmaVet</span>
            <div class="ms-auto d-flex gap-2">
                <a href="ClientServlet?action=liste" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-arrow-left"></i> Retour à la liste
                </a>
                <a href="LogoutServlet" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-box-arrow-right"></i> Déconnexion
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">

        <!-- En-tête client -->
        <div class="client-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h4><i class="bi bi-person-circle"></i> <%= c.getNom() %> <%= c.getPrenom() %></h4>
                    <p class="mb-1"><i class="bi bi-telephone"></i> <%= c.getTelephone() %></p>
                    <p class="mb-1"><i class="bi bi-envelope"></i> <%= c.getEmail() %></p>
                    <p class="mb-0"><i class="bi bi-geo-alt"></i> <%= c.getAdresse() %></p>
                </div>
                <div class="text-end">
                    <a href="ClientServlet?action=formulaireModifier&id=<%= c.getId() %>"
                       class="btn btn-warning btn-sm">
                        <i class="bi bi-pencil"></i> Modifier
                    </a>
                </div>
            </div>
        </div>

        <!-- Animaux du client -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5><i class="bi bi-github"></i> Animaux de <%= c.getPrenom() %></h5>
            <a href="AnimalServlet?action=formulaireAjouter" class="btn btn-vert btn-sm">
                <i class="bi bi-plus-circle"></i> Ajouter un animal
            </a>
        </div>

        <div class="card">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead class="table-header">
                        <tr>
                            <th>#</th>
                            <th>Nom</th>
                            <th>Espèce</th>
                            <th>Race</th>
                            <th>Sexe</th>
                            <th>Date naissance</th>
                            <th>Poids</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(animaux != null && !animaux.isEmpty()) {
                            for(Animal a : animaux) { %>
                        <tr>
                            <td><%= a.getId() %></td>
                            <td><strong><%= a.getNom() %></strong></td>
                            <td><%= a.getEspece() %></td>
                            <td><%= a.getRace() %></td>
                            <td><%= a.getSexe() %></td>
                            <td><%= a.getDateNaissance() %></td>
                            <td><%= a.getPoids() %> kg</td>
                            <td>
                                <a href="AnimalServlet?action=formulaireModifier&id=<%= a.getId() %>"
                                   class="btn btn-warning btn-sm">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <a href="AnimalServlet?action=supprimer&id=<%= a.getId() %>"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Voulez-vous vraiment supprimer cet animal ?')">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr>
                            <td colspan="8" class="text-center text-muted py-4">
                                Aucun animal enregistré pour ce client
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