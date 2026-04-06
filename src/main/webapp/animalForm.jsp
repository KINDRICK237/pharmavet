<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Animal" %>
<%@ page import="model.Client" %>
<%@ page import="java.util.List" %>
<%
    if(session.getAttribute("login") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Animal a = (Animal) request.getAttribute("animal");
    List<Client> clients = (List<Client>) request.getAttribute("clients");
    boolean isModif = (a != null);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaVet - <%= isModif ? "Modifier" : "Ajouter" %> Animal</title>
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
                <a href="AnimalServlet?action=liste" class="btn btn-outline-light btn-sm">
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
                        <i class="bi bi-github"></i>
                        <%= isModif ? "✏️ Modifier l'animal" : "➕ Ajouter un animal" %>
                    </h4>

                    <form action="AnimalServlet" method="post">
                        <input type="hidden" name="action" value="<%= isModif ? "modifier" : "ajouter" %>">
                        <% if(isModif) { %>
                            <input type="hidden" name="id" value="<%= a.getId() %>">
                        <% } %>

                        <div class="mb-3">
                            <label class="form-label">Propriétaire *</label>
                            <select name="clientId" class="form-select" required>
                                <option value="">-- Sélectionner un client --</option>
                                <% if(clients != null) {
                                    for(Client c : clients) { %>
                                <option value="<%= c.getId() %>"
                                    <%= isModif && a.getClientId() == c.getId() ? "selected" : "" %>>
                                    <%= c.getNom() %> <%= c.getPrenom() %>
                                </option>
                                <% }} %>
                            </select>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Nom de l'animal *</label>
                                <input type="text" name="nom" class="form-control"
                                       value="<%= isModif ? a.getNom() : "" %>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Espèce</label>
                                <select name="espece" class="form-select">
                                    <option value="Chien" <%= isModif && "Chien".equals(a.getEspece()) ? "selected" : "" %>>Chien</option>
                                    <option value="Chat" <%= isModif && "Chat".equals(a.getEspece()) ? "selected" : "" %>>Chat</option>
                                    <option value="Lapin" <%= isModif && "Lapin".equals(a.getEspece()) ? "selected" : "" %>>Lapin</option>
                                    <option value="Oiseau" <%= isModif && "Oiseau".equals(a.getEspece()) ? "selected" : "" %>>Oiseau</option>
                                    <option value="Reptile" <%= isModif && "Reptile".equals(a.getEspece()) ? "selected" : "" %>>Reptile</option>
                                    <option value="Bovin" <%= isModif && "Bovin".equals(a.getEspece()) ? "selected" : "" %>>Bovin</option>
                                    <option value="Ovin" <%= isModif && "Ovin".equals(a.getEspece()) ? "selected" : "" %>>Ovin</option>
                                    <option value="Caprin" <%= isModif && "Caprin".equals(a.getEspece()) ? "selected" : "" %>>Caprin</option>
                                    <option value="Porcin" <%= isModif && "Porcin".equals(a.getEspece()) ? "selected" : "" %>>Porcin</option>
                                    <option value="Volaille" <%= isModif && "Volaille".equals(a.getEspece()) ? "selected" : "" %>>Volaille</option>
                                    <option value="Autre" <%= isModif && "Autre".equals(a.getEspece()) ? "selected" : "" %>>Autre</option>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Race</label>
                                <input type="text" name="race" class="form-control"
                                       value="<%= isModif ? a.getRace() : "" %>">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Sexe</label>
                                <select name="sexe" class="form-select">
                                    <option value="Mâle" <%= isModif && "Mâle".equals(a.getSexe()) ? "selected" : "" %>>Mâle</option>
                                    <option value="Femelle" <%= isModif && "Femelle".equals(a.getSexe()) ? "selected" : "" %>>Femelle</option>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Date de naissance</label>
                                <input type="date" name="dateNaissance" class="form-control"
                                       value="<%= isModif && a.getDateNaissance() != null ? a.getDateNaissance() : "" %>">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Poids (kg)</label>
                                <input type="number" name="poids" class="form-control" step="0.01"
                                       value="<%= isModif ? a.getPoids() : "" %>">
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Observations</label>
                            <textarea name="observations" class="form-control" rows="3"><%= isModif && a.getObservations() != null ? a.getObservations() : "" %></textarea>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-vert">
                                <i class="bi bi-check-circle"></i>
                                <%= isModif ? "Enregistrer les modifications" : "Ajouter l'animal" %>
                            </button>
                            <a href="AnimalServlet?action=liste" class="btn btn-secondary">
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