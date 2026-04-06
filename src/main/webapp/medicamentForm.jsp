<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Medicament" %>
<%
    if(session.getAttribute("login") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Medicament m = (Medicament) request.getAttribute("medicament");
    boolean isModif = (m != null);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaVet - <%= isModif ? "Modifier" : "Ajouter" %> Médicament</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .navbar { background-color: #1a8a4a; }
        .navbar-brand { color: white !important; }
        .card {
            border-radius: 15px;
            border: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
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
            <div class="ms-auto d-flex gap-2">
                <a href="MedicamentServlet?action=liste" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-arrow-left"></i> Retour à la liste
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card p-4">

                    <h4 class="mb-4">
                        <i class="bi bi-capsule"></i>
                        <%= isModif ? "✏️ Modifier le médicament" : "➕ Ajouter un médicament" %>
                    </h4>

                    <form action="MedicamentServlet" method="post">
                        <input type="hidden" name="action" value="<%= isModif ? "modifier" : "ajouter" %>">
                        <% if(isModif) { %>
                            <input type="hidden" name="id" value="<%= m.getId() %>">
                        <% } %>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Nom du médicament *</label>
                                <input type="text" name="nom" class="form-control"
                                       value="<%= isModif ? m.getNom() : "" %>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Catégorie</label>
                                <select name="categorie" class="form-select">
                                    <option value="Antibiotique" <%= isModif && "Antibiotique".equals(m.getCategorie()) ? "selected" : "" %>>Antibiotique</option>
                                    <option value="Antiparasitaire" <%= isModif && "Antiparasitaire".equals(m.getCategorie()) ? "selected" : "" %>>Antiparasitaire</option>
                                    <option value="Vitamine" <%= isModif && "Vitamine".equals(m.getCategorie()) ? "selected" : "" %>>Vitamine</option>
                                    <option value="Analgésique" <%= isModif && "Analgésique".equals(m.getCategorie()) ? "selected" : "" %>>Analgésique</option>
                                    <option value="Anti-inflammatoire" <%= isModif && "Anti-inflammatoire".equals(m.getCategorie()) ? "selected" : "" %>>Anti-inflammatoire</option>
                                    <option value="Vaccin" <%= isModif && "Vaccin".equals(m.getCategorie()) ? "selected" : "" %>>Vaccin</option>
                                    <option value="Autre" <%= isModif && "Autre".equals(m.getCategorie()) ? "selected" : "" %>>Autre</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea name="description" class="form-control" rows="2"><%= isModif ? m.getDescription() : "" %></textarea>
                        </div>

                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Unité</label>
                                <select name="unite" class="form-select">
                                    <option value="Comprimé" <%= isModif && "Comprimé".equals(m.getUnite()) ? "selected" : "" %>>Comprimé</option>
                                    <option value="Flacon" <%= isModif && "Flacon".equals(m.getUnite()) ? "selected" : "" %>>Flacon</option>
                                    <option value="Ampoule" <%= isModif && "Ampoule".equals(m.getUnite()) ? "selected" : "" %>>Ampoule</option>
                                    <option value="Sachet" <%= isModif && "Sachet".equals(m.getUnite()) ? "selected" : "" %>>Sachet</option>
                                    <option value="Tube" <%= isModif && "Tube".equals(m.getUnite()) ? "selected" : "" %>>Tube</option>
                                    <option value="Litre" <%= isModif && "Litre".equals(m.getUnite()) ? "selected" : "" %>>Litre</option>
                                    <option value="Millilitre" <%= isModif && "Millilitre".equals(m.getUnite()) ? "selected" : "" %>>Millilitre (ml)</option>
                                    <option value="Kilogramme" <%= isModif && "Kilogramme".equals(m.getUnite()) ? "selected" : "" %>>Kilogramme (kg)</option>
                                    <option value="Gramme" <%= isModif && "Gramme".equals(m.getUnite()) ? "selected" : "" %>>Gramme (g)</option>
                                    <option value="Milligramme" <%= isModif && "Milligramme".equals(m.getUnite()) ? "selected" : "" %>>Milligramme (mg)</option>
                                    <option value="Autre" <%= isModif && "Autre".equals(m.getUnite()) ? "selected" : "" %>>Autre</option>
                                </select>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Prix d'achat (FCFA) *</label>
                                <input type="number" name="prixAchat" class="form-control" step="0.01"
                                       value="<%= isModif ? m.getPrixAchat() : "" %>" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Prix de vente (FCFA) *</label>
                                <input type="number" name="prixVente" class="form-control" step="0.01"
                                       value="<%= isModif ? m.getPrixVente() : "" %>" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Quantité en stock *</label>
                                <input type="number" name="quantiteStock" class="form-control"
                                       value="<%= isModif ? m.getQuantiteStock() : "0" %>" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Seuil d'alerte *</label>
                                <input type="number" name="seuilAlerte" class="form-control"
                                       value="<%= isModif ? m.getSeuilAlerte() : "10" %>" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Date d'expiration</label>
                                <input type="date" name="dateExpiration" class="form-control"
                                       value="<%= isModif ? m.getDateExpiration() : "" %>">
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Fournisseur</label>
                            <input type="text" name="fournisseur" class="form-control"
                                   value="<%= isModif ? m.getFournisseur() : "" %>">
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-vert">
                                <i class="bi bi-check-circle"></i>
                                <%= isModif ? "Enregistrer les modifications" : "Ajouter le médicament" %>
                            </button>
                            <a href="MedicamentServlet?action=liste" class="btn btn-secondary">
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