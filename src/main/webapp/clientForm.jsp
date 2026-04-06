<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Client" %>
<%
    if(session.getAttribute("login") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Client c = (Client) request.getAttribute("client");
    boolean isModif = (c != null);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaVet - <%= isModif ? "Modifier" : "Ajouter" %> Client</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .navbar { background-color: #1a8a4a; }
        .navbar-brand { color: white !important; }
        .card { border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .btn-vert { background-color: #1a8a4a; color: white; border: none; }
        .btn-vert:hover { background-color: #0d4f2b; color: white; }
        .form-label { font-weight: 600; color: #444; }
    </style>
</head>
<body>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg">
        <div class="container-fluid">
            <span class="navbar-brand fw-bold">🐾 PharmaVet</span>
            <div class="ms-auto">
                <a href="ClientServlet?action=liste" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-arrow-left"></i> Retour à la liste
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-7">
                <div class="card p-4">

                    <h4 class="mb-4">
                        <i class="bi bi-person"></i>
                        <%= isModif ? "✏️ Modifier le client" : "➕ Ajouter un client" %>
                    </h4>

                    <form action="ClientServlet" method="post">
                        <input type="hidden" name="action" value="<%= isModif ? "modifier" : "ajouter" %>">
                        <% if(isModif) { %>
                            <input type="hidden" name="id" value="<%= c.getId() %>">
                        <% } %>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Nom *</label>
                                <input type="text" name="nom" class="form-control"
                                       value="<%= isModif ? c.getNom() : "" %>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Prénom *</label>
                                <input type="text" name="prenom" class="form-control"
                                       value="<%= isModif ? c.getPrenom() : "" %>" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Téléphone</label>
                                <input type="text" name="telephone" class="form-control"
                                       value="<%= isModif ? c.getTelephone() : "" %>">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" name="email" class="form-control"
                                       value="<%= isModif ? c.getEmail() : "" %>">
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Adresse</label>
                            <textarea name="adresse" class="form-control" rows="2"><%= isModif ? c.getAdresse() : "" %></textarea>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-vert">
                                <i class="bi bi-check-circle"></i>
                                <%= isModif ? "Enregistrer les modifications" : "Ajouter le client" %>
                            </button>
                            <a href="ClientServlet?action=liste" class="btn btn-secondary">
                                <i class="bi bi-x-circle"></i> Annuler
                            </a>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>