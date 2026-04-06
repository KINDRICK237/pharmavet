package servlet;

import dao.MedicamentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Medicament;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/MedicamentServlet")
public class MedicamentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    MedicamentDAO dao = new MedicamentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "liste";

        switch (action) {
            case "liste":
                List<Medicament> liste = dao.listerTous();
                request.setAttribute("medicaments", liste);
                request.setAttribute("stockFaible", dao.stockFaible());
                request.getRequestDispatcher("medicaments.jsp").forward(request, response);
                break;

            case "formulaireAjouter":
                request.getRequestDispatcher("medicamentForm.jsp").forward(request, response);
                break;

            case "formulaireModifier":
                int id = Integer.parseInt(request.getParameter("id"));
                Medicament m = dao.trouverParId(id);
                request.setAttribute("medicament", m);
                request.getRequestDispatcher("medicamentForm.jsp").forward(request, response);
                break;

            case "supprimer":
                int idSupp = Integer.parseInt(request.getParameter("id"));
                dao.supprimer(idSupp);
                response.sendRedirect("MedicamentServlet?action=liste");
                break;

            default:
                response.sendRedirect("MedicamentServlet?action=liste");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        Medicament m = new Medicament();
        m.setNom(request.getParameter("nom"));
        m.setDescription(request.getParameter("description"));
        m.setCategorie(request.getParameter("categorie"));
        m.setUnite(request.getParameter("unite"));
        m.setPrixAchat(Double.parseDouble(request.getParameter("prixAchat")));
        m.setPrixVente(Double.parseDouble(request.getParameter("prixVente")));
        m.setQuantiteStock(Integer.parseInt(request.getParameter("quantiteStock")));
        m.setSeuilAlerte(Integer.parseInt(request.getParameter("seuilAlerte")));
        m.setDateExpiration(Date.valueOf(request.getParameter("dateExpiration")));
        m.setFournisseur(request.getParameter("fournisseur"));

        if ("ajouter".equals(action)) {
            dao.ajouter(m);
        } else if ("modifier".equals(action)) {
            m.setId(Integer.parseInt(request.getParameter("id")));
            dao.modifier(m);
        }

        response.sendRedirect("MedicamentServlet?action=liste");
    }
}