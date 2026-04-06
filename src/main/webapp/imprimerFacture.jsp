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
    <title>Facture <%= v.getNumeroFacture() %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: white;
            font-family: Arial, sans-serif;
            font-size: 13px;
        }
        .facture-container {
            max-width: 800px;
            margin: 20px auto;
            padding: 30px;
            border: 1px solid #ddd;
        }
        .entete {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 3px solid #1a8a4a;
            padding-bottom: 15px;
        }
        .logo-section img {
            max-height: 80px;
        }
        .entreprise-info {
            text-align: right;
        }
        .entreprise-info h2 {
            color: #1a8a4a;
            font-size: 24px;
            font-weight: bold;
            margin: 0;
        }
        .entreprise-info .slogan {
            color: #666;
            font-style: italic;
            font-size: 11px;
        }
        .titre-facture {
            text-align: center;
            margin: 20px 0;
        }
        .titre-facture h3 {
            color: #1a8a4a;
            font-size: 22px;
            font-weight: bold;
            letter-spacing: 3px;
            margin: 0;
        }
        .titre-facture .numero {
            color: #666;
            font-size: 14px;
        }
        .info-boxes {
            display: flex;
            gap: 20px;
            margin: 20px 0;
        }
        .info-box {
            flex: 1;
            background-color: #f8f9fa;
            border-left: 4px solid #1a8a4a;
            padding: 12px;
            border-radius: 5px;
        }
        .info-box h6 {
            color: #1a8a4a;
            font-weight: bold;
            margin-bottom: 8px;
            font-size: 12px;
            text-transform: uppercase;
        }
        .info-box p { margin: 2px 0; }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table thead tr {
            background-color: #1a8a4a;
            color: white;
        }
        table thead th {
            padding: 10px;
            text-align: left;
            font-size: 12px;
        }
        table tbody tr:nth-child(even) {
            background-color: #f5f5f5;
        }
        table tbody td {
            padding: 9px 10px;
            border-bottom: 1px solid #eee;
        }
        .total-row {
            background-color: #1a8a4a !important;
            color: white;
            font-weight: bold;
        }
        .total-row td { padding: 12px 10px; }
        .pied-page {
            margin-top: 30px;
            border-top: 2px solid #1a8a4a;
            padding-top: 10px;
            text-align: center;
            color: #666;
            font-size: 11px;
            font-style: italic;
        }
        .signature-section {
            display: flex;
            justify-content: space-between;
            margin-top: 40px;
        }
        .signature-box {
            text-align: center;
            width: 200px;
        }
        .signature-box .ligne-signature {
            border-top: 1px solid #333;
            margin-top: 50px;
            padding-top: 5px;
            font-size: 12px;
        }
        .btn-imprimer {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
        }
        @media print {
            .btn-imprimer { display: none !important; }
            body { margin: 0; }
            .facture-container {
                border: none;
                margin: 0;
                padding: 20px;
            }
        }
    </style>
</head>
<body>

    <!-- Bouton imprimer (caché à l'impression) -->
    <div class="btn-imprimer d-flex gap-2">
        <button onclick="window.print()" class="btn btn-success">
            <i class="bi bi-printer"></i> Imprimer
        </button>
        <a href="venteDetail.jsp" onclick="window.close()" class="btn btn-secondary">
            <i class="bi bi-x"></i> Fermer
        </a>
    </div>

    <div class="facture-container">

        <!-- En-tête -->
        <div class="entete">
            <div class="logo-section">
                <img src="images/logo.jpg" alt="Logo FOTSVET"
                     onerror="this.style.display='none'">
            </div>
            <div class="entreprise-info">
                <h2>FOTSVET</h2>
                <div class="slogan">Parce que chaque animal mérite le meilleur!!!!</div>
                <div>Dr. Wafo Armel</div>
                <div>📞 696 980 519</div>
            </div>
        </div>

        <!-- Titre facture -->
        <div class="titre-facture">
            <h3>FACTURE</h3>
            <div class="numero"><%= v.getNumeroFacture() %></div>
        </div>

        <!-- Infos client et vente -->
        <div class="info-boxes">
            <div class="info-box">
                <h6>Informations client</h6>
                <p><strong>Nom :</strong>
                    <%= v.getNomClient() != null ? v.getNomClient() : "" %>
                    <%= v.getPrenomClient() != null ? v.getPrenomClient() : "" %>
                </p>
                <% if(v.getNomAnimal() != null && !v.getNomAnimal().isEmpty()) { %>
                <p><strong>Animal :</strong> <%= v.getNomAnimal() %></p>
                <% } %>
            </div>
            <div class="info-box">
                <h6>Informations facture</h6>
                <p><strong>N° Facture :</strong> <%= v.getNumeroFacture() %></p>
                <p><strong>Date :</strong> <%= v.getDateVente() %></p>
                <p><strong>Paiement :</strong> <%= v.getModePaiement() %></p>
                <p><strong>Statut :</strong> <%= v.getStatut() %></p>
            </div>
        </div>

        <!-- Tableau des médicaments -->
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Médicament</th>
                    <th>Unité</th>
                    <th>Quantité</th>
                    <th>Prix unitaire</th>
                    <th>Sous-total</th>
                </tr>
            </thead>
            <tbody>
                <% if(v.getDetails() != null && !v.getDetails().isEmpty()) {
                    int i = 1;
                    for(DetailVente d : v.getDetails()) { %>
                <tr>
                    <td><%= i++ %></td>
                    <td><strong><%= d.getNomMedicament() != null ? d.getNomMedicament() : "-" %></strong></td>
                    <td><%= d.getUniteMedicament() != null ? d.getUniteMedicament() : "-" %></td>
                    <td><%= d.getQuantite() %></td>
                    <td><%= String.format("%.0f", d.getPrixUnitaire()) %> FCFA</td>
                    <td><strong><%= String.format("%.0f", d.getSousTotal()) %> FCFA</strong></td>
                </tr>
                <% }} %>
                <tr class="total-row">
                    <td colspan="5" style="text-align:right;">TOTAL</td>
                    <td><%= String.format("%.0f", v.getMontantTotal()) %> FCFA</td>
                </tr>
            </tbody>
        </table>

        <% if(v.getObservations() != null && !v.getObservations().isEmpty()) { %>
        <div style="margin-top:15px; padding:10px; background:#f8f9fa; border-radius:5px;">
            <strong>Observations :</strong> <%= v.getObservations() %>
        </div>
        <% } %>

        <!-- Section signature -->
        <div class="signature-section">
            <div class="signature-box">
                <div class="ligne-signature">Signature du client</div>
            </div>
            <div class="signature-box">
                <div class="ligne-signature">Dr. Wafo Armel</div>
            </div>
        </div>

        <!-- Pied de page -->
        <div class="pied-page">
            FOTSVET — Parce que chaque animal mérite le meilleur!!!!
            — Dr. Wafo Armel — Tél: 696 980 519
        </div>

    </div>

    <script>
        // Imprimer automatiquement à l'ouverture
        window.onload = function() {
            // Petit délai pour laisser le temps à la page de charger
            setTimeout(function() {
                window.print();
            }, 500);
        };
    </script>
</body>
</html>