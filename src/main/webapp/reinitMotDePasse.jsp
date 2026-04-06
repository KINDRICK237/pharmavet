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
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaVet - Réinitialiser mot de passe</title>
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
        .user-banner {
            background: linear-gradient(135deg, #1a8a4a, #0d4f2b);
            color: white;
            border-radius: 10px;
            padding: 15px 20px;
            margin-bottom: 25px;
        }
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
            <div class="col-md-6">
                <div class="card p-4">

                    <h4 class="mb-4">
                        <i class="bi bi-key"></i> Réinitialiser le mot de passe
                    </h4>

                    <!-- Info utilisateur -->
                    <div class="user-banner">
                        <strong>👤 <%= u.getNom() %> <%= u.getPrenom() %></strong><br>
                        <small>Login : <%= u.getLogin() %> |
                        Rôle : <%= u.getRole() %></small>
                    </div>

                    <% if(request.getAttribute("erreur") != null) { %>
                    <div class="alert alert-danger">
                        ❌ <%= request.getAttribute("erreur") %>
                    </div>
                    <% } %>

                    <form action="UtilisateurServlet" method="post"
                          onsubmit="return validerMdp()">
                        <input type="hidden" name="action" value="reinitialiser">
                        <input type="hidden" name="id" value="<%= u.getId() %>">

                        <div class="mb-3">
                            <label class="form-label">Nouveau mot de passe *</label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="bi bi-lock"></i>
                                </span>
                                <input type="password" name="nouveauMotDePasse"
                                       id="nouveauMdp" class="form-control"
                                       placeholder="Nouveau mot de passe"
                                       required minlength="4">
                                <button type="button" class="btn btn-outline-secondary"
                                        onclick="toggleMdp('nouveauMdp', 'icon1')">
                                    <i class="bi bi-eye" id="icon1"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Confirmer le mot de passe *</label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="bi bi-lock-fill"></i>
                                </span>
                                <input type="password" name="confirmerMotDePasse"
                                       id="confirmerMdp" class="form-control"
                                       placeholder="Confirmer le mot de passe"
                                       required minlength="4">
                                <button type="button" class="btn btn-outline-secondary"
                                        onclick="toggleMdp('confirmerMdp', 'icon2')">
                                    <i class="bi bi-eye" id="icon2"></i>
                                </button>
                            </div>
                            <div id="mdpErreur" class="text-danger small mt-1"
                                 style="display:none;">
                                ❌ Les mots de passe ne correspondent pas
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-vert">
                                <i class="bi bi-check-circle"></i>
                                Réinitialiser le mot de passe
                            </button>
                            <a href="UtilisateurServlet?action=liste"
                               class="btn btn-secondary">
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
        function toggleMdp(inputId, iconId) {
            const input = document.getElementById(inputId);
            const icon = document.getElementById(iconId);
            if (input.type === "password") {
                input.type = "text";
                icon.className = "bi bi-eye-slash";
            } else {
                input.type = "password";
                icon.className = "bi bi-eye";
            }
        }

        function validerMdp() {
            const mdp = document.getElementById("nouveauMdp").value;
            const conf = document.getElementById("confirmerMdp").value;
            if (mdp !== conf) {
                document.getElementById("mdpErreur").style.display = "block";
                return false;
            }
            document.getElementById("mdpErreur").style.display = "none";
            return true;
        }

        // Vérification en temps réel
        document.getElementById("confirmerMdp").addEventListener("keyup", function() {
            const mdp = document.getElementById("nouveauMdp").value;
            const conf = this.value;
            const erreur = document.getElementById("mdpErreur");
            if (conf.length > 0 && mdp !== conf) {
                erreur.style.display = "block";
            } else {
                erreur.style.display = "none";
            }
        });
    </script>
</body>
</html>