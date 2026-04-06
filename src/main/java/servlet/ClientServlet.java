package servlet;

import dao.AnimalDAO;
import dao.ClientDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Client;

import java.io.IOException;
import java.util.List;

@WebServlet("/ClientServlet")
public class ClientServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    ClientDAO clientDAO = new ClientDAO();
    AnimalDAO animalDAO = new AnimalDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "liste";

        switch (action) {
            case "liste":
                List<Client> liste = clientDAO.listerTous();
                request.setAttribute("clients", liste);
                request.getRequestDispatcher("clients.jsp").forward(request, response);
                break;

            case "formulaireAjouter":
                request.getRequestDispatcher("clientForm.jsp").forward(request, response);
                break;

            case "formulaireModifier":
                int id = Integer.parseInt(request.getParameter("id"));
                Client c = clientDAO.trouverParId(id);
                request.setAttribute("client", c);
                request.getRequestDispatcher("clientForm.jsp").forward(request, response);
                break;

            case "supprimer":
                int idSupp = Integer.parseInt(request.getParameter("id"));
                clientDAO.supprimer(idSupp);
                response.sendRedirect("ClientServlet?action=liste");
                break;

            case "detail":
                int idDetail = Integer.parseInt(request.getParameter("id"));
                Client client = clientDAO.trouverParId(idDetail);
                request.setAttribute("client", client);
                request.setAttribute("animaux", animalDAO.listerParClient(idDetail));
                request.getRequestDispatcher("clientDetail.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect("ClientServlet?action=liste");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        Client c = new Client();
        c.setNom(request.getParameter("nom"));
        c.setPrenom(request.getParameter("prenom"));
        c.setTelephone(request.getParameter("telephone"));
        c.setEmail(request.getParameter("email"));
        c.setAdresse(request.getParameter("adresse"));

        if ("ajouter".equals(action)) {
            clientDAO.ajouter(c);
        } else if ("modifier".equals(action)) {
            c.setId(Integer.parseInt(request.getParameter("id")));
            clientDAO.modifier(c);
        }

        response.sendRedirect("ClientServlet?action=liste");
    }
}