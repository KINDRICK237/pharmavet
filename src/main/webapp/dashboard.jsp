<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="model.Vente" %>
<%
    if(session.getAttribute("login") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String nom = (String) session.getAttribute("nom");
    String role = (String) session.getAttribute("role");
    boolean isAdmin = "admin".equals(role);

    double caJour = request.getAttribute("caJour") != null ? (double) request.getAttribute("caJour") : 0;
    double caMois = request.getAttribute("caMois") != null ? (double) request.getAttribute("caMois") : 0;
    double caTotal = request.getAttribute("caTotal") != null ? (double) request.getAttribute("caTotal") : 0;
    int ventesJour = request.getAttribute("ventesJour") != null ? (int) request.getAttribute("ventesJour") : 0;
    int ventesMois = request.getAttribute("ventesMois") != null ? (int) request.getAttribute("ventesMois") : 0;
    int nombreClients = request.getAttribute("nombreClients") != null ? (int) request.getAttribute("nombreClients") : 0;
    int nombreMedicaments = request.getAttribute("nombreMedicaments") != null ? (int) request.getAttribute("nombreMedicaments") : 0;
    int stockFaible = request.getAttribute("stockFaible") != null ? (int) request.getAttribute("stockFaible") : 0;

    Map<String, Double> ventesParJour = (Map<String, Double>) request.getAttribute("ventesParJour");
    List<Map<String, Object>> topMedicaments = (List<Map<String, Object>>) request.getAttribute("topMedicaments");
    List<Vente> dernieresVentes = (List<Vente>) request.getAttribute("dernieresVentes");
    Map<String, Integer> repartitionPaiements = (Map<String, Integer>) request.getAttribute("repartitionPaiements");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaVet - Tableau de bord</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <% if(isAdmin) { %>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <% } %>
    <style>
        body { background-color: #f4f6f9; }
        .navbar { background-color: #1a8a4a; }
        .navbar-brand, .nav-link, .navbar-text { color: white !important; }
        .card { border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .card-stat {
            border-radius: 15px;
            color: white;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }
        .card-stat .icon {
            font-size: 50px;
            opacity: 0.3;
            position: absolute;
            right: 15px;
            top: 10px;
        }
        .card-stat h3 { font-size: 28px; font-weight: bold; margin: 0; }
        .card-stat p { margin: 0; font-size: 13px; opacity: 0.9; }
        .card-stat small { font-size: 11px; opacity: 0.8; }
        .bg-vert { background: linear-gradient(135deg, #1a8a4a, #0d4f2b); }
        .bg-bleu { background: linear-gradient(135deg, #2980b9, #1a5276); }
        .bg-orange { background: linear-gradient(135deg, #e67e22, #d35400); }
        .bg-rouge { background: linear-gradient(135deg, #e74c3c, #c0392b); }
        .bg-violet { background: linear-gradient(135deg, #8e44ad, #6c3483); }
        .bg-cyan { background: linear-gradient(135deg, #16a085, #0e6655); }
        .welcome-banner {
            background: linear-gradient(135deg, #1a8a4a, #0d4f2b);
            color: white;
            border-radius: 15px;
            padding: 20px 25px;
            margin-bottom: 25px;
        }
        .badge-paye { background-color: #1a8a4a; }
        .badge-annule { background-color: #e74c3c; }
        .module-card {
            border-radius: 15px;
            border: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.2s;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
            display: block;
        }
        .module-card:hover { transform: translateY(-5px); color: inherit; }
        .card-stock { border-top: 5px solid #1a8a4a; }
        .card-ventes { border-top: 5px solid #e67e22; }
        .card-clients { border-top: 5px solid #2980b9; }
        .card-users { border-top: 5px solid #16a085; }
    </style>
</head>
<body>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg">
        <div class="container-fluid">
            <span class="navbar-brand fw-bold">🐾 PharmaVet</span>
            <div class="ms-auto d-flex align-items-center gap-3">
                <span class="navbar-text">
                    👤 <%= nom %> |
                    <span class="badge bg-light text-dark"><%= role %></span>
                </span>
                <a href="LogoutServlet" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-box-arrow-right"></i> Déconnexion
                </a>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-4 px-4">

        <!-- Bannière de bienvenue -->
        <div class="welcome-banner d-flex justify-content-between align-items-center">
            <div>
                <h4 class="mb-1">👋 Bonjour, <%= nom %> !</h4>
                <p class="mb-0">Bienvenue sur votre tableau de bord — FOTSVET</p>
            </div>
            <div class="text-end">
                <small>Aujourd'hui</small><br>
                <strong id="dateHeure"></strong>
            </div>
        </div>

        <!-- Alerte stock faible - ADMIN seulement -->
        <% if(isAdmin && stockFaible > 0) { %>
        <div class="alert alert-danger d-flex align-items-center mb-4" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
            <div>
                <strong>⚠️ Alerte stock !</strong>
                <%= stockFaible %> médicament(s) ont un stock faible.
                <a href="MedicamentServlet?action=liste" class="alert-link">
                    Voir les médicaments
                </a>
            </div>
        </div>
        <% } %>

        <!-- ===== SECTION ADMIN UNIQUEMENT ===== -->
        <% if(isAdmin) { %>

        <!-- Statistiques -->
        <div class="row g-3 mb-4">
            <div class="col-md-2 col-sm-6">
                <div class="card-stat bg-vert">
                    <div class="icon"><i class="bi bi-cash-coin"></i></div>
                    <p>CA Aujourd'hui</p>
                    <h3><%= String.format("%.0f", caJour) %></h3>
                    <small>FCFA</small>
                </div>
            </div>
            <div class="col-md-2 col-sm-6">
                <div class="card-stat bg-bleu">
                    <div class="icon"><i class="bi bi-calendar-month"></i></div>
                    <p>CA Ce mois</p>
                    <h3><%= String.format("%.0f", caMois) %></h3>
                    <small>FCFA</small>
                </div>
            </div>
            <div class="col-md-2 col-sm-6">
                <div class="card-stat bg-cyan">
                    <div class="icon"><i class="bi bi-graph-up"></i></div>
                    <p>CA Total</p>
                    <h3><%= String.format("%.0f", caTotal) %></h3>
                    <small>FCFA</small>
                </div>
            </div>
            <div class="col-md-2 col-sm-6">
                <div class="card-stat bg-orange">
                    <div class="icon"><i class="bi bi-cart-check"></i></div>
                    <p>Ventes Aujourd'hui</p>
                    <h3><%= ventesJour %></h3>
                    <small>Ce mois: <%= ventesMois %></small>
                </div>
            </div>
            <div class="col-md-2 col-sm-6">
                <div class="card-stat bg-violet">
                    <div class="icon"><i class="bi bi-people"></i></div>
                    <p>Clients</p>
                    <h3><%= nombreClients %></h3>
                    <small>Total enregistrés</small>
                </div>
            </div>
            <div class="col-md-2 col-sm-6">
                <div class="card-stat bg-rouge">
                    <div class="icon"><i class="bi bi-capsule"></i></div>
                    <p>Médicaments</p>
                    <h3><%= nombreMedicaments %></h3>
                    <small><%= stockFaible %> en stock faible</small>
                </div>
            </div>
        </div>

        <!-- Graphiques -->
        <div class="row g-4 mb-4">
            <div class="col-md-8">
                <div class="card p-4">
                    <h5 class="mb-3">📈 Ventes des 7 derniers jours</h5>
                    <canvas id="graphiqueVentes" height="100"></canvas>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-4">
                    <h5 class="mb-3">💳 Mode de paiement</h5>
                    <canvas id="graphiquePaiements" height="200"></canvas>
                </div>
            </div>
        </div>

        <!-- Top médicaments + Dernières ventes -->
        <div class="row g-4 mb-4">
            <div class="col-md-5">
                <div class="card p-4">
                    <h5 class="mb-3">🏆 Top 5 médicaments vendus</h5>
                    <% if(topMedicaments != null && !topMedicaments.isEmpty()) { %>
                    <table class="table table-hover mb-0">
                        <thead style="background-color: #1a8a4a; color: white;">
                            <tr>
                                <th>#</th>
                                <th>Médicament</th>
                                <th>Qté</th>
                                <th>Montant</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% int rang = 1;
                               for(Map<String, Object> med : topMedicaments) { %>
                            <tr>
                                <td>
                                    <% if(rang == 1) { %>
                                        <span class="badge bg-warning text-dark">🥇</span>
                                    <% } else if(rang == 2) { %>
                                        <span class="badge bg-secondary">🥈</span>
                                    <% } else if(rang == 3) { %>
                                        <span class="badge bg-danger">🥉</span>
                                    <% } else { %>
                                        <span class="badge bg-light text-dark"><%= rang %></span>
                                    <% } %>
                                </td>
                                <td><strong><%= med.get("nom") %></strong></td>
                                <td><%= med.get("quantite") %></td>
                                <td><%= String.format("%.0f", (double)med.get("montant")) %> F</td>
                            </tr>
                            <% rang++; } %>
                        </tbody>
                    </table>
                    <% } else { %>
                    <p class="text-muted text-center py-3">Aucune vente enregistrée</p>
                    <% } %>
                </div>
            </div>

            <div class="col-md-7">
                <div class="card p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0">🕐 Dernières ventes</h5>
                        <a href="VenteServlet?action=liste"
                           class="btn btn-sm btn-outline-success">Voir tout</a>
                    </div>
                    <% if(dernieresVentes != null && !dernieresVentes.isEmpty()) { %>
                    <table class="table table-hover mb-0">
                        <thead style="background-color: #1a8a4a; color: white;">
                            <tr>
                                <th>N° Facture</th>
                                <th>Client</th>
                                <th>Montant</th>
                                <th>Statut</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(Vente v : dernieresVentes) { %>
                            <tr>
                                <td>
                                    <a href="VenteServlet?action=detail&id=<%= v.getId() %>">
                                        <strong><%= v.getNumeroFacture() %></strong>
                                    </a>
                                </td>
                                <td>
                                    <%= v.getNomClient() != null ?
                                        v.getNomClient() + " " + v.getPrenomClient() : "-" %>
                                </td>
                                <td>
                                    <strong>
                                        <%= String.format("%.0f", v.getMontantTotal()) %> F
                                    </strong>
                                </td>
                                <td>
                                    <% if("Payée".equals(v.getStatut())) { %>
                                        <span class="badge badge-paye">✅ Payée</span>
                                    <% } else { %>
                                        <span class="badge badge-annule">❌ Annulée</span>
                                    <% } %>
                                </td>
                                <td><small><%= v.getDateVente() %></small></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <% } else { %>
                    <p class="text-muted text-center py-3">Aucune vente enregistrée</p>
                    <% } %>
                </div>
            </div>
        </div>

        <% } else { %>
        <!-- ===== SECTION NON-ADMIN ===== -->
        <div class="row g-3 mb-4">
            <div class="col-md-12">
                <div class="card p-4 text-center">
                    <h5 class="text-muted">
                        <i class="bi bi-info-circle"></i>
                        Bienvenue <%= nom %> ! Utilisez les modules ci-dessous pour travailler.
                    </h5>
                </div>
            </div>
        </div>
        <% } %>

        <!-- ===== MODULES DE NAVIGATION ===== -->
        <h5 class="mb-3">🗂️ Modules</h5>
        <div class="row g-3 mb-4">

            <!-- Modules accessibles à tous -->
            <div class="col-md-2 col-sm-4">
                <a href="VenteServlet?action=formulaireAjouter"
                   class="module-card card card-ventes text-center p-3">
                    <div style="font-size:35px;">➕</div>
                    <p class="mb-0 small fw-bold">Nouvelle vente</p>
                </a>
            </div>
            <div class="col-md-2 col-sm-4">
                <a href="VenteServlet?action=liste"
                   class="module-card card card-ventes text-center p-3">
                    <div style="font-size:35px;">🛒</div>
                    <p class="mb-0 small fw-bold">Ventes</p>
                </a>
            </div>
            <div class="col-md-2 col-sm-4">
                <a href="ClientServlet?action=liste"
                   class="module-card card card-clients text-center p-3">
                    <div style="font-size:35px;">🐶</div>
                    <p class="mb-0 small fw-bold">Clients</p>
                </a>
            </div>
            <div class="col-md-2 col-sm-4">
                <a href="MedicamentServlet?action=liste"
                   class="module-card card card-stock text-center p-3">
                    <div style="font-size:35px;">💊</div>
                    <p class="mb-0 small fw-bold">Stock</p>
                </a>
            </div>

            <!-- Modules réservés à l'admin -->
            <% if(isAdmin) { %>
            <div class="col-md-2 col-sm-4">
                <a href="MedicamentServlet?action=formulaireAjouter"
                   class="module-card card card-stock text-center p-3">
                    <div style="font-size:35px;">📦</div>
                    <p class="mb-0 small fw-bold">Ajouter médicament</p>
                </a>
            </div>
            <div class="col-md-2 col-sm-4">
                <a href="ClientServlet?action=formulaireAjouter"
                   class="module-card card card-clients text-center p-3">
                    <div style="font-size:35px;">👤</div>
                    <p class="mb-0 small fw-bold">Ajouter client</p>
                </a>
            </div>
            <div class="col-md-2 col-sm-4">
                <a href="UtilisateurServlet?action=liste"
                   class="module-card card card-users text-center p-3">
                    <div style="font-size:35px;">👥</div>
                    <p class="mb-0 small fw-bold">Utilisateurs</p>
                </a>
            </div>
            <% } %>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Afficher date et heure
        function majDateHeure() {
            const now = new Date();
            const options = {
                weekday: "long", year: "numeric",
                month: "long", day: "numeric",
                hour: "2-digit", minute: "2-digit"
            };
            document.getElementById("dateHeure").textContent =
                now.toLocaleDateString("fr-FR", options);
        }
        majDateHeure();
        setInterval(majDateHeure, 60000);

        <% if(isAdmin) { %>
        // Données graphique ventes 7 jours
        const labelsVentes = [
            <% if(ventesParJour != null) {
                boolean first = true;
                for(String jour : ventesParJour.keySet()) {
                    if(!first) out.print(",");
                    out.print("\"" + jour + "\"");
                    first = false;
                }
            } %>
        ];
        const dataVentes = [
            <% if(ventesParJour != null) {
                boolean first = true;
                for(Double val : ventesParJour.values()) {
                    if(!first) out.print(",");
                    out.print(val);
                    first = false;
                }
            } %>
        ];

        // Graphique ventes
        new Chart(document.getElementById("graphiqueVentes"), {
            type: "bar",
            data: {
                labels: labelsVentes,
                datasets: [{
                    label: "Ventes (FCFA)",
                    data: dataVentes,
                    backgroundColor: "rgba(26, 138, 74, 0.7)",
                    borderColor: "#1a8a4a",
                    borderWidth: 2,
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(val) {
                                return val.toLocaleString() + " F";
                            }
                        }
                    }
                }
            }
        });

        // Données répartition paiements
        const labelsPaiements = [
            <% if(repartitionPaiements != null) {
                boolean first = true;
                for(String mode : repartitionPaiements.keySet()) {
                    if(!first) out.print(",");
                    out.print("\"" + mode + "\"");
                    first = false;
                }
            } %>
        ];
        const dataPaiements = [
            <% if(repartitionPaiements != null) {
                boolean first = true;
                for(Integer val : repartitionPaiements.values()) {
                    if(!first) out.print(",");
                    out.print(val);
                    first = false;
                }
            } %>
        ];

        // Graphique paiements
        new Chart(document.getElementById("graphiquePaiements"), {
            type: "doughnut",
            data: {
                labels: labelsPaiements,
                datasets: [{
                    data: dataPaiements,
                    backgroundColor: ["#1a8a4a", "#e67e22", "#2980b9"],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { position: "bottom" } }
            }
        });
        <% } %>
    </script>
</body>
</html>