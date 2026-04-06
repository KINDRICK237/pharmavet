<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.Medicament"%>
<%
    if(session.getAttribute("login") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Medicament> medicaments = (List<Medicament>) request.getAttribute("medicaments");
    List<Medicament> stockFaible = (List<Medicament>) request.getAttribute("stockFaible");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaVet - Médicaments</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .navbar { background-color: #1a8a4a; }
        .navbar-brand, .nav-link { color: white !important; }
        .btn-vert { background-color: #1a8a4a; color: white; border: none; }
        .btn-vert:hover { background-color: #0d4f2b; color: white; }
        .table-header { background-color: #1a8a4a; color: white; }
        .badge-alerte { background-color: #e74c3c; }
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
            <h4><i class="bi bi-capsule"></i> Gestion des Médicaments</h4>
            <a href="MedicamentServlet?action=formulaireAjouter" class="btn btn-vert">
                <i class="bi bi-plus-circle"></i> Ajouter un médicament
            </a>
        </div>

        <!-- Alerte stock faible -->
        <% if(stockFaible != null && !stockFaible.isEmpty()) { %>
        <div class="alert alert-danger d-flex align-items-center mb-4" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            <div>
                <strong>⚠️ Stock faible !</strong>
                <% for(Medicament m : stockFaible) { %>
                    <span class="badge badge-alerte ms-1"><%= m.getNom() %> (<%= m.getQuantiteStock() %>)</span>
                <% } %>
            </div>
        </div>
        <% } %>

        <!-- Tableau des médicaments -->
        <div class="card">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead class="table-header">
                        <tr>
                            <th>#</th>
                            <th>Nom</th>
                            <th>Catégorie</th>
                            <th>Unité</th>
                            <th>Prix Achat</th>
                            <th>Prix Vente</th>
                            <th>Stock</th>
                            <th>Expiration</th>
                            <th>Fournisseur</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(medicaments != null && !medicaments.isEmpty()) {
                            for(Medicament m : medicaments) { %>
                        <tr>
                            <td><%= m.getId() %></td>
                            <td><strong><%= m.getNom() %></strong></td>
                            <td><%= m.getCategorie() %></td>
                            <td><%= m.getUnite() %></td>
                            <td><%= m.getPrixAchat() %> FCFA</td>
                            <td><%= m.getPrixVente() %> FCFA</td>
                            <td>
                                <% if(m.getQuantiteStock() <= m.getSeuilAlerte()) { %>
                                    <span class="badge bg-danger"><%= m.getQuantiteStock() %></span>
                                <% } else { %>
                                    <span class="badge bg-success"><%= m.getQuantiteStock() %></span>
                                <% } %>
                            </td>
                            <td><%= m.getDateExpiration() %></td>
                            <td><%= m.getFournisseur() %></td>
                            <td>
                                <a href="MedicamentServlet?action=formulaireModifier&id=<%= m.getId() %>"
                                   class="btn btn-warning btn-sm">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <a href="MedicamentServlet?action=supprimer&id=<%= m.getId() %>"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Voulez-vous vraiment supprimer ce médicament ?')">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr>
                            <td colspan="10" class="text-center text-muted py-4">
                                Aucun médicament enregistré
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