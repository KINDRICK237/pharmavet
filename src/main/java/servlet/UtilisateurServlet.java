package servlet;

import dao.UtilisateurDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Utilisateur;

import java.io.IOException;

@WebServlet("/UtilisateurServlet")
public class UtilisateurServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    UtilisateurDAO dao = new UtilisateurDAO();

    // Vérifier si l'utilisateur est admin
    private boolean estAdmin(HttpServletRequest request) {
        String role = (String) request.getSession().getAttribute("role");
        return "admin".equals(role);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Vérifier connexion
        if (request.getSession().getAttribute("login") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Vérifier droits admin
        if (!estAdmin(request)) {
            request.setAttribute("erreur", "Accès refusé ! Seul l'administrateur peut gérer les utilisateurs.");
            request.getRequestDispatcher("accesRefuse.jsp").forward(request, response);
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "liste";

        switch (action) {
            case "liste":
                request.setAttribute("utilisateurs", dao.listerTous());
                request.getRequestDispatcher("utilisateurs.jsp").forward(request, response);
                break;

            case "formulaireAjouter":
                request.getRequestDispatcher("utilisateurForm.jsp").forward(request, response);
                break;

            case "formulaireModifier":
                int id = Integer.parseInt(request.getParameter("id"));
                Utilisateur u = dao.trouverParId(id);
                request.setAttribute("utilisateur", u);
                request.getRequestDispatcher("utilisateurForm.jsp").forward(request, response);
                break;

            case "supprimer":
                int idSupp = Integer.parseInt(request.getParameter("id"));
                // Empêcher suppression de son propre compte
                String loginSession = (String) request.getSession().getAttribute("login");
                Utilisateur uSupp = dao.trouverParId(idSupp);
                if (uSupp != null && uSupp.getLogin().equals(loginSession)) {
                    request.setAttribute("erreur", "Vous ne pouvez pas supprimer votre propre compte !");
                    request.setAttribute("utilisateurs", dao.listerTous());
                    request.getRequestDispatcher("utilisateurs.jsp").forward(request, response);
                    return;
                }
                dao.supprimer(idSupp);
                response.sendRedirect("UtilisateurServlet?action=liste");
                break;

            case "formulaireReinit":
                int idReinit = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("utilisateur", dao.trouverParId(idReinit));
                request.getRequestDispatcher("reinitMotDePasse.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect("UtilisateurServlet?action=liste");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (request.getSession().getAttribute("login") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if (!estAdmin(request)) {
            response.sendRedirect("DashboardServlet");
            return;
        }

        String action = request.getParameter("action");

        if ("reinitialiser".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String nouveauMdp = request.getParameter("nouveauMotDePasse");
            String confirmer = request.getParameter("confirmerMotDePasse");

            if (!nouveauMdp.equals(confirmer)) {
                request.setAttribute("erreur", "Les mots de passe ne correspondent pas !");
                request.setAttribute("utilisateur", dao.trouverParId(id));
                request.getRequestDispatcher("reinitMotDePasse.jsp").forward(request, response);
                return;
            }
            dao.reinitialiserMotDePasse(id, nouveauMdp);
            response.sendRedirect("UtilisateurServlet?action=liste&succes=reinit");
            return;
        }

        Utilisateur u = new Utilisateur();
        u.setNom(request.getParameter("nom"));
        u.setPrenom(request.getParameter("prenom"));
        u.setLogin(request.getParameter("login"));
        u.setRole(request.getParameter("role"));

        if ("ajouter".equals(action)) {
            // Vérifier si login existe
            if (dao.loginExiste(request.getParameter("login"), 0)) {
                request.setAttribute("erreur", "Ce login existe déjà !");
                request.getRequestDispatcher("utilisateurForm.jsp").forward(request, response);
                return;
            }
            u.setMotDePasse(request.getParameter("motDePasse"));
            dao.ajouter(u);
            response.sendRedirect("UtilisateurServlet?action=liste&succes=ajoute");

        } else if ("modifier".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            // Vérifier si login existe pour un autre utilisateur
            if (dao.loginExiste(request.getParameter("login"), id)) {
                request.setAttribute("erreur", "Ce login est déjà utilisé !");
                request.setAttribute("utilisateur", dao.trouverParId(id));
                request.getRequestDispatcher("utilisateurForm.jsp").forward(request, response);
                return;
            }
            u.setId(id);
            dao.modifier(u);
            response.sendRedirect("UtilisateurServlet?action=liste&succes=modifie");
        }
    }
}