package servlet;

import dao.StatistiqueDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    StatistiqueDAO statsDAO = new StatistiqueDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getSession().getAttribute("login") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = (String) request.getSession().getAttribute("role");

        // Charger les statistiques uniquement pour l'admin
        if ("admin".equals(role)) {
            request.setAttribute("caJour", statsDAO.chiffreAffairesJour());
            request.setAttribute("caMois", statsDAO.chiffreAffairesMois());
            request.setAttribute("caTotal", statsDAO.chiffreAffairesTotal());
            request.setAttribute("ventesJour", statsDAO.nombreVentesJour());
            request.setAttribute("ventesMois", statsDAO.nombreVentesMois());
            request.setAttribute("nombreClients", statsDAO.nombreClients());
            request.setAttribute("nombreMedicaments", statsDAO.nombreMedicaments());
            request.setAttribute("stockFaible", statsDAO.nombreStockFaible());
            request.setAttribute("ventesParJour", statsDAO.ventesParJour());
            request.setAttribute("topMedicaments", statsDAO.topMedicaments());
            request.setAttribute("dernieresVentes", statsDAO.dernieresVentes(5));
            request.setAttribute("repartitionPaiements", statsDAO.repartitionPaiements());
        }

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}