<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Utilisateur" %>
<%
    if(session.getAttribute("login") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if(!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("DashboardServlet");
        return;
    }
    Utilisateur u = (Utilisateur) request.getAttribute("utilisateur");
    boolean isModif = (u != null);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaVet - <%= isModif ? "Modifier" : "Ajouter" %> Utilisateur</title>
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
        .role-card {
            border: 2px solid #ddd;
            border-radius: 10px;
            padding: 15px;
            cursor: pointer;
            transition: all 0.2s;
            text-align: center;
        }
        .role-card:hover { border-color: #1a8a4a; background-color: #f0fff4; }
        .role-card.selected { border-color: #1a8a4a; background-color: #d4edda; }
        .role-card .icon { font-size: 30px; margin-bottom: 5px; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg">
        <div class="container-fluid">
            <span class="navbar-brand fw-bold">🐾 PharmaVet</span>
            <div class="ms-auto">
                <a href="UtilisateurServlet?action=liste" class="btn btn-outline-light btn-sm">
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
                        <i class="bi bi-person-plus"></i>
                        <%= isModif ? "✏️ Modifier l'utilisateur" : "➕ Ajouter un utilisateur" %>
                    </h4>

                    <% if(request.getAttribute("erreur") != null) { %>
                    <div class="alert alert-danger">
                        ❌ <%= request.getAttribute("erreur") %>
                    </div>
                    <% } %>

                    <form action="UtilisateurServlet" method="post">
                        <input type="hidden" name="action"
                               value="<%= isModif ? "modifier" : "ajouter" %>">
                        <% if(isModif) { %>
                        <input type="hidden" name="id" value="<%= u.getId() %>">
                        <% } %>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Nom *</label>
                                <input type="text" name="nom" class="form-control"
                                       value="<%= isModif ? u.getNom() : "" %>"
                                       placeholder="Nom" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Prénom *</label>
                                <input type="text" name="prenom" class="form-control"
                                       value="<%= isModif ? u.getPrenom() : "" %>"
                                       placeholder="Prénom" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Login *</label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="bi bi-person-badge"></i>
                                </span>
                                <input type="text" name="login" class="form-control"
                                       value="<%= isModif ? u.getLogin() : "" %>"
                                       placeholder="Identifiant de connexion" required>
                            </div>
                            <small class="text-muted">
                                Le login doit être unique et sans espaces
                            </small>
                        </div>

                        <% if(!isModif) { %>
                        <div class="mb-3">
                            <label class="form-label">Mot de passe *</label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="bi bi-lock"></i>
                                </span>
                                <input type="password" name="motDePasse" id="motDePasse"
                                       class="form-control"
                                       placeholder="Mot de passe" required>
                                <button type="button" class="btn btn-outline-secondary"
                                        onclick="toggleMdp()">
                                    <i class="bi bi-eye" id="iconMdp"></i>
                                </button>
                            </div>
                        </div>
                        <% } %>

                        <!-- Sélection du rôle -->
                        <div class="mb-4">
                            <label class="form-label">Rôle *</label>
                            <input type="hidden" name="role" id="roleInput"
                                   value="<%= isModif ? u.getRole() : "pharmacien" %>">
                            <div class="row g-3">
                                <div class="col-md-4">
                                    <div class="role-card <%= isModif && "admin".equals(u.getRole()) ? "selected" : (!isModif ? "" : "") %>"
                                         id="card-admin" onclick="selectionnerRole('admin')">
                                        <div class="icon">👑</div>
                                        <strong>Admin</strong>
                                        <p class="text-muted small mb-0">
                                            Accès complet
                                        </p>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="role-card <%= isModif && "pharmacien".equals(u.getRole()) ? "selected" : (!isModif ? "selected" : "") %>"
                                         id="card-pharmacien" onclick="selectionnerRole('pharmacien')">
                                        <div class="icon">💊</div>
                                        <strong>Pharmacien</strong>
                                        <p class="text-muted small mb-0">
                                            Gestion médicaments
                                        </p>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="role-card <%= isModif && "caissier".equals(u.getRole()) ? "selected" : "" %>"
                                         id="card-caissier" onclick="selectionnerRole('caissier')">
                                        <div class="icon">💰</div>
                                        <strong>Caissier</strong>
                                        <p class="text-muted small mb-0">
                                            Gestion ventes
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-vert">
                                <i class="bi bi-check-circle"></i>
                                <%= isModif ? "Enregistrer les modifications" : "Ajouter l'utilisateur" %>
                            </button>
                            <a href="UtilisateurServlet?action=liste" class="btn btn-secondary">
                                <i class="bi bi-x-circle"></i> Annuler
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function selectionnerRole(role) {
            document.getElementById("roleInput").value = role;
            document.querySelectorAll(".role-card").forEach(c => c.classList.remove("selected"));
            document.getElementById("card-" + role).classList.add("selected");
        }

        function toggleMdp() {
            const input = document.getElementById("motDePasse");
            const icon = document.getElementById("iconMdp");
            if (input.type === "password") {
                input.type = "text";
                icon.className = "bi bi-eye-slash";
            } else {
                input.type = "password";
                icon.className = "bi bi-eye";
            }
        }
    </script>
</body>
</html>