package servlet;

import dao.VenteDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Vente;

import java.io.IOException;

@WebServlet("/ImprimerFactureServlet")
public class ImprimerFactureServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getSession().getAttribute("login") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        VenteDAO venteDAO = new VenteDAO();
        Vente vente = venteDAO.trouverParId(id);

        request.setAttribute("vente", vente);
        request.getRequestDispatcher("imprimerFacture.jsp").forward(request, response);
    }
}