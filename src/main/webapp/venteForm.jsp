<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Client" %>
<%@ page import="model.Medicament" %>
<%
    if(session.getAttribute("login") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Client> clients = (List<Client>) request.getAttribute("clients");
    List<Medicament> medicaments = (List<Medicament>) request.getAttribute("medicaments");
    String numeroFacture = (String) request.getAttribute("numeroFacture");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaVet - Nouvelle Vente</title>
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
        .total-section {
            background: linear-gradient(135deg, #1a8a4a, #0d4f2b);
            color: white;
            border-radius: 10px;
            padding: 15px;
        }
        .section-client { border-left: 4px solid #1a8a4a; padding-left: 15px; }
        .table-stock { font-size: 13px; }
        .table-stock tbody tr:hover { background-color: #e8f5e9; cursor: pointer; }
        .stock-faible { color: #e74c3c; font-weight: bold; }
        .stock-ok { color: #1a8a4a; font-weight: bold; }
        .thead-vert th { background-color: #1a8a4a; color: white; }
        .panier-table { font-size: 13px; }
        .panier-table th { background-color: #0d4f2b; color: white; }
    </style>

    <%-- Script injecté en HEAD pour être disponible avant tout clic --%>
    <script>
        // Données médicaments injectées depuis Java AVANT le chargement de la page
        const listeMedicaments = [
            <%
            if(medicaments != null) {
                boolean premier = true;
                for(Medicament m : medicaments) {
                    if(m.getQuantiteStock() > 0) {
                        if(!premier) out.print(",");
                        String nomSafe = m.getNom()
                            .replace("\\", "\\\\")
                            .replace("\"", "\\\"")
                            .replace("\n", "")
                            .replace("\r", "");
                        String uniteSafe = m.getUnite()
                            .replace("\\", "\\\\")
                            .replace("\"", "\\\"");
                        String catSafe = m.getCategorie() != null ?
                            m.getCategorie().replace("\"", "\\\"") : "";
            %>
            {"id":<%= m.getId() %>,"nom":"<%= nomSafe %>","prix":<%= m.getPrixVente() %>,"stock":<%= m.getQuantiteStock() %>,"unite":"<%= uniteSafe %>","categorie":"<%= catSafe %>","seuil":<%= m.getSeuilAlerte() %>}
            <%
                        premier = false;
                    }
                }
            }
            %>
        ];
    </script>
</head>
<body>

    <nav class="navbar navbar-expand-lg">
        <div class="container-fluid">
            <span class="navbar-brand fw-bold">🐾 PharmaVet</span>
            <div class="ms-auto">
                <a href="VenteServlet?action=liste" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-arrow-left"></i> Retour aux ventes
                </a>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-4 px-4">
        <h4 class="mb-4"><i class="bi bi-cart-plus"></i> Nouvelle Vente</h4>

        <form action="VenteServlet" method="post" id="formVente">
            <input type="hidden" name="action" value="ajouter">
            <input type="hidden" name="typeClient" id="typeClient" value="existant">
            <div id="champsCaches" style="display:none;"></div>

            <div class="row g-4">

                <!-- Colonne gauche -->
                <div class="col-md-8">

                    <!-- Section Client -->
                    <div class="card p-4 mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="mb-0">👤 Client</h5>
                            <div class="d-flex gap-2">
                                <button type="button" class="btn btn-sm btn-vert"
                                        id="btnExistant" onclick="basculerClient('existant')">
                                    Client existant
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-warning"
                                        id="btnNouveau" onclick="basculerClient('nouveau')">
                                    + Nouveau client
                                </button>
                            </div>
                        </div>

                        <div id="sectionExistant">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Sélectionner un client</label>
                                    <select name="clientId" class="form-select" id="selectClient"
                                            onchange="chargerAnimaux(this.value)">
                                        <option value="">-- Sélectionner --</option>
                                        <% if(clients != null) {
                                            for(Client c : clients) { %>
                                        <option value="<%= c.getId() %>">
                                            <%= c.getNom() %> <%= c.getPrenom() %>
                                        </option>
                                        <% }} %>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Animal</label>
                                    <select name="animalId" class="form-select" id="selectAnimal">
                                        <option value="">-- Sélectionner d'abord un client --</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div id="sectionNouveau" style="display:none;">
                            <div class="section-client">
                                <span class="badge bg-warning text-dark mb-2">Nouveau client</span>
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Nom *</label>
                                        <input type="text" name="nouveauNom" class="form-control"
                                               placeholder="Nom">
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Prénom</label>
                                        <input type="text" name="nouveauPrenom" class="form-control"
                                               placeholder="Prénom">
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Téléphone</label>
                                        <input type="text" name="nouveauTelephone" class="form-control"
                                               placeholder="Ex: 699001122">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Liste médicaments en stock -->
                    <div class="card p-4 mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="mb-0">💊 Médicaments en stock</h5>
                            <input type="text" id="rechercheMed"
                                   class="form-control form-control-sm w-25"
                                   placeholder="🔍 Rechercher..."
                                   onkeyup="filtrerMedicaments()">
                        </div>
                        <div style="max-height: 250px; overflow-y: auto;">
                            <table class="table table-hover table-stock mb-0">
                                <thead class="thead-vert">
                                    <tr>
                                        <th>Médicament</th>
                                        <th>Catégorie</th>
                                        <th>Unité</th>
                                        <th>Prix vente</th>
                                        <th>Stock</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody id="corpsMedicaments">
                                    <!-- Généré par JavaScript -->
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Panier -->
                    <div class="card p-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="mb-0">🛒 Panier</h5>
                            <button type="button" class="btn btn-sm btn-outline-warning"
                                    onclick="ajouterLigneLibre()">
                                <i class="bi bi-pencil"></i> Saisie libre
                            </button>
                        </div>

                        <div id="panierVide" class="text-muted text-center py-3">
                            <i class="bi bi-cart-x fs-4"></i>
                            <p class="mb-0">Panier vide — cliquez sur "Ajouter" dans la liste</p>
                        </div>

                        <table class="table panier-table mb-0" id="tablePanier" style="display:none;">
                            <thead>
                                <tr>
                                    <th>Médicament</th>
                                    <th>Unité</th>
                                    <th>Quantité</th>
                                    <th>Prix unitaire</th>
                                    <th>Total</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody id="corpsPanier"></tbody>
                            <tfoot>
                                <tr style="background-color: #1a8a4a; color: white;">
                                    <td colspan="4" class="text-end fw-bold">TOTAL GÉNÉRAL :</td>
                                    <td class="fw-bold" id="totalTableau">0 FCFA</td>
                                    <td></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>

                <!-- Colonne droite -->
                <div class="col-md-4">
                    <div class="card p-4 sticky-top" style="top: 20px;">
                        <h5 class="mb-3">📋 Informations vente</h5>

                        <div class="mb-3">
                            <label class="form-label">N° Facture</label>
                            <input type="text" name="numeroFacture" class="form-control"
                                   value="<%= numeroFacture %>" readonly>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Mode de paiement</label>
                            <select name="modePaiement" class="form-select">
                                <option value="Espèces">💵 Espèces</option>
                                <option value="Mobile Money">📱 Mobile Money</option>
                            </select>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Observations</label>
                            <textarea name="observations" class="form-control" rows="2"
                                      placeholder="Remarques éventuelles..."></textarea>
                        </div>

                        <div class="total-section mb-4">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="fs-5">Total :</span>
                                <span class="fs-4 fw-bold" id="totalAffiche">0 FCFA</span>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-vert w-100 py-3 fs-5"
                                onclick="return validerFormulaire()">
                            <i class="bi bi-check-circle"></i> Enregistrer la vente
                        </button>
                        <a href="VenteServlet?action=liste" class="btn btn-secondary w-100 mt-2">
                            <i class="bi bi-x-circle"></i> Annuler
                        </a>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let indexLigne = 0;
        let panier = {};

        // Générer tableau médicaments au chargement
        document.addEventListener("DOMContentLoaded", function() {
            const tbody = document.getElementById("corpsMedicaments");
            if (!tbody) return;
            tbody.innerHTML = "";
            listeMedicaments.forEach(function(m) {
                const tr = document.createElement("tr");
                const stockClass = m.stock <= m.seuil ? "stock-faible" : "stock-ok";
                tr.innerHTML =
                    "<td><strong>" + m.nom + "</strong></td>" +
                    "<td>" + m.categorie + "</td>" +
                    "<td>" + m.unite + "</td>" +
                    "<td><strong>" + m.prix.toLocaleString() + " FCFA</strong></td>" +
                    "<td class='" + stockClass + "'>" + m.stock + "</td>" +
                    "<td><button type='button' class='btn btn-vert btn-sm' " +
                    "onclick='ajouterMedicamentStock(" + m.id + ")'>" +
                    "<i class='bi bi-plus-circle'></i> Ajouter</button></td>";
                tbody.appendChild(tr);
            });
        });

        // Ajouter médicament depuis stock par ID
        function ajouterMedicamentStock(id) {
            const m = listeMedicaments.find(function(x) { return x.id === id; });
            if (!m) return;
            const cle = "med_" + id;
            if (panier[cle]) {
                const nouvelleQte = panier[cle].quantite + 1;
                if (nouvelleQte > m.stock) {
                    alert("Stock insuffisant ! Stock disponible : " + m.stock);
                    return;
                }
                panier[cle].quantite = nouvelleQte;
                document.getElementById("qte_" + cle).value = nouvelleQte;
                const st = panier[cle].prix * nouvelleQte;
                document.getElementById("st_" + cle).textContent =
                    st.toLocaleString() + " FCFA";
            } else {
                panier[cle] = {
                    type: "existant",
                    medicamentId: m.id,
                    nomLibre: "",
                    nom: m.nom,
                    unite: m.unite,
                    prix: m.prix,
                    quantite: 1,
                    stock: m.stock
                };
                afficherLignePanier(cle);
            }
            mettreAJourChampsCaches();
            majTotal();
        }

        // Ajouter ligne libre
        function ajouterLigneLibre() {
            const cle = "libre_" + indexLigne;
            panier[cle] = {
                type: "libre",
                medicamentId: "",
                nomLibre: "",
                nom: "",
                unite: "",
                prix: 0,
                quantite: 1
            };
            afficherLignePanierLibre(cle);
            indexLigne++;
            mettreAJourChampsCaches();
            majTotal();
        }

        // Afficher ligne médicament stock
        function afficherLignePanier(cle) {
            afficherTableau();
            const item = panier[cle];
            const tbody = document.getElementById("corpsPanier");
            const tr = document.createElement("tr");
            tr.id = "tr_" + cle;
            tr.innerHTML =
                "<td><strong>" + item.nom + "</strong></td>" +
                "<td>" + item.unite + "</td>" +
                "<td><input type='number' id='qte_" + cle + "' " +
                "class='form-control form-control-sm' value='1' min='1' max='" + item.stock + "' " +
                "style='width:70px' onchange='changerQuantite(\"" + cle + "\", this.value)'></td>" +
                "<td><input type='number' id='prix_" + cle + "' " +
                "class='form-control form-control-sm' value='" + item.prix + "' min='0' " +
                "style='width:110px' onchange='changerPrix(\"" + cle + "\", this.value)'></td>" +
                "<td><strong id='st_" + cle + "'>" + item.prix.toLocaleString() + " FCFA</strong></td>" +
                "<td><button type='button' class='btn btn-danger btn-sm' " +
                "onclick='supprimerLigne(\"" + cle + "\")'>" +
                "<i class='bi bi-trash'></i></button></td>";
            tbody.appendChild(tr);
        }

        // Afficher ligne libre
        function afficherLignePanierLibre(cle) {
            afficherTableau();
            const tbody = document.getElementById("corpsPanier");
            const tr = document.createElement("tr");
            tr.id = "tr_" + cle;
            tr.innerHTML =
                "<td><input type='text' class='form-control form-control-sm' " +
                "placeholder='Nom médicament...' oninput='changerNom(\"" + cle + "\", this.value)'></td>" +
                "<td><input type='text' class='form-control form-control-sm' " +
                "placeholder='ex: Flacon' style='width:80px' oninput='changerUnite(\"" + cle + "\", this.value)'></td>" +
                "<td><input type='number' id='qte_" + cle + "' " +
                "class='form-control form-control-sm' value='1' min='1' " +
                "style='width:70px' onchange='changerQuantite(\"" + cle + "\", this.value)'></td>" +
                "<td><input type='number' id='prix_" + cle + "' " +
                "class='form-control form-control-sm' value='0' min='0' " +
                "style='width:110px' onchange='changerPrix(\"" + cle + "\", this.value)'></td>" +
                "<td><strong id='st_" + cle + "'>0 FCFA</strong></td>" +
                "<td><button type='button' class='btn btn-danger btn-sm' " +
                "onclick='supprimerLigne(\"" + cle + "\")'>" +
                "<i class='bi bi-trash'></i></button></td>";
            tbody.appendChild(tr);
        }

        // Afficher tableau
        function afficherTableau() {
            document.getElementById("panierVide").style.display = "none";
            document.getElementById("tablePanier").style.display = "table";
        }

        // Mettre à jour champs cachés
        function mettreAJourChampsCaches() {
            const div = document.getElementById("champsCaches");
            if (!div) return;
            div.innerHTML = "";
            Object.values(panier).forEach(function(item) {
                div.innerHTML += "<input type='hidden' name='typeLigne' value='" + item.type + "'>";
                div.innerHTML += "<input type='hidden' name='medicamentId' value='" + item.medicamentId + "'>";
                div.innerHTML += "<input type='hidden' name='nomLibre' value='" + item.nomLibre + "'>";
                div.innerHTML += "<input type='hidden' name='quantite' value='" + item.quantite + "'>";
                div.innerHTML += "<input type='hidden' name='prixUnitaire' value='" + item.prix + "'>";
            });
        }

        // Changer quantité
        function changerQuantite(cle, valeur) {
            panier[cle].quantite = parseInt(valeur) || 1;
            const st = panier[cle].prix * panier[cle].quantite;
            document.getElementById("st_" + cle).textContent = st.toLocaleString() + " FCFA";
            mettreAJourChampsCaches();
            majTotal();
        }

        // Changer prix
        function changerPrix(cle, valeur) {
            panier[cle].prix = parseFloat(valeur) || 0;
            const st = panier[cle].prix * panier[cle].quantite;
            document.getElementById("st_" + cle).textContent = st.toLocaleString() + " FCFA";
            mettreAJourChampsCaches();
            majTotal();
        }

        // Changer nom libre
        function changerNom(cle, valeur) {
            panier[cle].nomLibre = valeur;
            panier[cle].nom = valeur;
            mettreAJourChampsCaches();
        }

        // Changer unité libre
        function changerUnite(cle, valeur) {
            panier[cle].unite = valeur;
            mettreAJourChampsCaches();
        }

        // Supprimer ligne
        function supprimerLigne(cle) {
            delete panier[cle];
            const tr = document.getElementById("tr_" + cle);
            if (tr) tr.remove();
            mettreAJourChampsCaches();
            majTotal();
            if (Object.keys(panier).length === 0) {
                document.getElementById("panierVide").style.display = "block";
                document.getElementById("tablePanier").style.display = "none";
            }
        }

        // Calculer total
        function majTotal() {
            let total = 0;
            Object.values(panier).forEach(function(item) {
                total += item.prix * item.quantite;
            });
            document.getElementById("totalAffiche").textContent =
                total.toLocaleString() + " FCFA";
            document.getElementById("totalTableau").textContent =
                total.toLocaleString() + " FCFA";
        }

        // Filtrer médicaments
        function filtrerMedicaments() {
            const recherche = document.getElementById("rechercheMed").value.toLowerCase();
            document.getElementById("corpsMedicaments").querySelectorAll("tr").forEach(function(ligne) {
                ligne.style.display =
                    ligne.textContent.toLowerCase().includes(recherche) ? "" : "none";
            });
        }

        // Charger animaux
        function chargerAnimaux(clientId) {
            const select = document.getElementById("selectAnimal");
            if (!clientId) {
                select.innerHTML =
                    "<option value=''>-- Sélectionner d'abord un client --</option>";
                return;
            }
            fetch("GetAnimauxServlet?clientId=" + clientId)
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    select.innerHTML = "<option value=''>-- Aucun animal --</option>";
                    data.forEach(function(a) {
                        select.innerHTML +=
                            "<option value='" + a.id + "'>" + a.nom + " (" + a.espece + ")</option>";
                    });
                });
        }

        // Basculer client
        function basculerClient(type) {
            document.getElementById("typeClient").value = type;
            if (type === "existant") {
                document.getElementById("sectionExistant").style.display = "block";
                document.getElementById("sectionNouveau").style.display = "none";
                document.getElementById("btnExistant").className = "btn btn-sm btn-vert";
                document.getElementById("btnNouveau").className = "btn btn-sm btn-outline-warning";
            } else {
                document.getElementById("sectionExistant").style.display = "none";
                document.getElementById("sectionNouveau").style.display = "block";
                document.getElementById("btnExistant").className = "btn btn-sm btn-outline-success";
                document.getElementById("btnNouveau").className = "btn btn-sm btn-warning";
            }
        }

        // Valider formulaire
        function validerFormulaire() {
            if (Object.keys(panier).length === 0) {
                alert("Veuillez ajouter au moins un médicament au panier !");
                return false;
            }
            const typeClient = document.getElementById("typeClient").value;
            if (typeClient === "nouveau") {
                const nom = document.querySelector("input[name='nouveauNom']").value;
                if (!nom.trim()) {
                    alert("Veuillez saisir le nom du nouveau client !");
                    return false;
                }
            } else {
                if (!document.getElementById("selectClient").value) {
                    alert("Veuillez sélectionner un client !");
                    return false;
                }
            }
            mettreAJourChampsCaches();
            return true;
        }
    </script>
</body>
</html>