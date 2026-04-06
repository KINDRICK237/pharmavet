package servlet;

import connexion.ConnexionDB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String login = request.getParameter("login");
        String motDePasse = request.getParameter("motDePasse");

        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT * FROM utilisateurs WHERE login = ? AND mot_de_passe = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, login);
            ps.setString(2, motDePasse);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Connexion réussie
                HttpSession session = request.getSession();
                session.setAttribute("login", rs.getString("login"));
                session.setAttribute("nom", rs.getString("nom"));
                session.setAttribute("role", rs.getString("role"));
                response.sendRedirect("DashboardServlet");
            } else {
                // Echec connexion
                request.setAttribute("erreur", "Login ou mot de passe incorrect !");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            request.setAttribute("erreur", "Erreur serveur : " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}