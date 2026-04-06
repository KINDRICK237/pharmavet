<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaVet - Connexion</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #1a8a4a, #0d4f2b);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            width: 100%;
            max-width: 400px;
        }
        .logo {
            text-align: center;
            margin-bottom: 30px;
        }
        .logo h2 {
            color: #1a8a4a;
            font-weight: bold;
        }
        .logo p {
            color: #666;
            font-size: 14px;
        }
        .btn-connexion {
            background-color: #1a8a4a;
            border: none;
            width: 100%;
            padding: 10px;
            color: white;
            border-radius: 8px;
            font-size: 16px;
        }
        .btn-connexion:hover {
            background-color: #0d4f2b;
            color: white;
        }
        .alert-error {
            background-color: #ffe0e0;
            color: #c0392b;
            border-radius: 8px;
            padding: 10px;
            margin-bottom: 15px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="logo">
            <h2>🐾 PharmaVet</h2>
            <p>Gestion de Pharmacie Vétérinaire</p>
        </div>

        <% if(request.getAttribute("erreur") != null) { %>
            <div class="alert-error">
                ❌ <%= request.getAttribute("erreur") %>
            </div>
        <% } %>

        <form action="LoginServlet" method="post">
            <div class="mb-3">
                <label class="form-label">Login</label>
                <input type="text" name="login" class="form-control" 
                       placeholder="Entrez votre login" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Mot de passe</label>
                <input type="password" name="motDePasse" class="form-control" 
                       placeholder="Entrez votre mot de passe" required>
            </div>
            <button type="submit" class="btn btn-connexion">
                Se connecter
            </button>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>