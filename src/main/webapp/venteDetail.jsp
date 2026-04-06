<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Vente" %>
<%@ page import="model.DetailVente" %>
<%@ page import="java.util.List" %>
<%
    if(session.getAttribute("login") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Vente v = (Vente) request.getAttribute("vente");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaVet - Detail Vente</title>
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
        .info-box {
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
                <a href="VenteServlet?action=liste" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-arrow-left"></i> Retour aux ventes
                </a>
                <a href="LogoutServlet" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-box-arrow-right"></i> Déconnexion
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">

        <!-- En-tête vente -->
        <div class="info-box">
            <div class="row">
                <div class="col-md-6">
                    <h4><i class="bi bi-receipt"></i> Facture <%= v.getNumeroFacture() %></h4>
                    <p class="mb-1"><i class="bi bi-person"></i> Client : <strong><%= v.getNomClient() %> <%= v.getPrenomClient() %></strong></p>
                    <p class="mb-1"><i class="bi bi-github"></i> Animal : <strong><%= v.getNomAnimal() != null ? v.getNomAnimal() : "-" %></strong></p>
                    <p class="mb-0"><i class="bi bi-calendar"></i> Date : <strong><%= v.getDateVente() %></strong></p>
                </div>
                <div class="col-md-6 text-end">
                    <h3 class="mb-2"><%= String.format("%.0f", v.getMontantTotal()) %> FCFA</h3>
                    <p class="mb-2">
                        <% if("Espèces".equals(v.getModePaiement())) { %>
                            <span class="badge bg-light text-dark">💵 Espèces</span>
                        <% } else { %>
                            <span class="badge bg-light text-dark">📱 Mobile Money</span>
                        <% } %>
                    </p>
                    <p class="mb-0">
                        <% if("Payée".equals(v.getStatut())) { %>
                            <span class="badge bg-success fs-6">✅ Payée</span>
                        <% } else if("Annulée".equals(v.getStatut())) { %>
                            <span class="badge bg-danger fs-6">❌ Annulée</span>
                        <% } %>
                    </p>
                </div>
            </div>
        </div>

        <!-- Bouton PDF -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5><i class="bi bi-basket"></i> Détail des médicaments</h5>
           <div class="d-flex gap-2">
    <a href="FacturePDFServlet?id=<%= v.getId() %>" class="btn btn-danger">
        <i class="bi bi-file-earmark-pdf"></i> Télécharger PDF
    </a>
    <a href="ImprimerFactureServlet?id=<%= v.getId() %>" target="_blank" class="btn btn-success">
        <i class="bi bi-printer"></i> Imprimer la facture
    </a>
</div>
        </div>

        <!-- Tableau des détails -->
        <div class="card">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead class="table-header">
                        <tr>
                            <th>#</th>
                            <th>Médicament</th>
                            <th>Unité</th>
                            <th>Prix unitaire</th>
                            <th>Quantité</th>
                            <th>Sous-total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(v.getDetails() != null) {
                            int i = 1;
                            for(DetailVente d : v.getDetails()) { %>
                        <tr>
                            <td><%= i++ %></td>
                            <td><strong><%= d.getNomMedicament() %></strong></td>
                            <td><%= d.getUniteMedicament() %></td>
                            <td><%= String.format("%.0f", d.getPrixUnitaire()) %> FCFA</td>
                            <td><%= d.getQuantite() %></td>
                            <td><strong><%= String.format("%.0f", d.getSousTotal()) %> FCFA</strong></td>
                        </tr>
                        <% }} %>
                    </tbody>
                    <tfoot>
                        <tr class="table-success">
                            <td colspan="5" class="text-end fw-bold">TOTAL :</td>
                            <td class="fw-bold fs-5"><%= String.format("%.0f", v.getMontantTotal()) %> FCFA</td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>

        <% if(v.getObservations() != null && !v.getObservations().isEmpty()) { %>
        <div class="card mt-3 p-3">
            <strong>📝 Observations :</strong> <%= v.getObservations() %>
        </div>
        <% } %>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>