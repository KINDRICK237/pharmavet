<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Vente" %>
<%
    if(session.getAttribute("login") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Vente> ventes = (List<Vente>) request.getAttribute("ventes");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaVet - Ventes</title>
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

        <!-- Titre + bouton -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4><i class="bi bi-cart"></i> Gestion des Ventes</h4>
            <a href="VenteServlet?action=formulaireAjouter" class="btn btn-vert">
                <i class="bi bi-plus-circle"></i> Nouvelle vente
            </a>
        </div>

        <!-- Tableau des ventes -->
        <div class="card">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead class="table-header">
                        <tr>
                            <th>N° Facture</th>
                            <th>Client</th>
                            <th>Animal</th>
                            <th>Mode paiement</th>
                            <th>Montant</th>
                            <th>Statut</th>
                            <th>Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(ventes != null && !ventes.isEmpty()) {
                            for(Vente v : ventes) { %>
                        <tr>
                            <td><strong><%= v.getNumeroFacture() %></strong></td>
                            <td><%= v.getNomClient() %> <%= v.getPrenomClient() %></td>
                            <td><%= v.getNomAnimal() != null ? v.getNomAnimal() : "-" %></td>
                            <td>
                                <% if("Espèces".equals(v.getModePaiement())) { %>
                                    <span class="badge bg-success">💵 Espèces</span>
                                <% } else { %>
                                    <span class="badge bg-warning text-dark">📱 Mobile Money</span>
                                <% } %>
                            </td>
                            <td><strong><%= String.format("%.0f", v.getMontantTotal()) %> FCFA</strong></td>
                            <td>
                                <% if("Payée".equals(v.getStatut())) { %>
                                    <span class="badge bg-success">✅ Payée</span>
                                <% } else if("Annulée".equals(v.getStatut())) { %>
                                    <span class="badge bg-danger">❌ Annulée</span>
                                <% } else { %>
                                    <span class="badge bg-warning text-dark">⏳ En cours</span>
                                <% } %>
                            </td>
                            <td><%= v.getDateVente() %></td>
                            <td>
                                <a href="VenteServlet?action=detail&id=<%= v.getId() %>"
                                   class="btn btn-info btn-sm text-white">
                                    <i class="bi bi-eye"></i>
                                </a>
                                <% if(!"Annulée".equals(v.getStatut())) { %>
                                <a href="VenteServlet?action=annuler&id=<%= v.getId() %>"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Voulez-vous vraiment annuler cette vente ?')">
                                    <i class="bi bi-x-circle"></i>
                                </a>
                                <% } %>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr>
                            <td colspan="8" class="text-center text-muted py-4">
                                Aucune vente enregistrée
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