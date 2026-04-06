package servlet;

import dao.AnimalDAO;
import dao.ClientDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Animal;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/AnimalServlet")
public class AnimalServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    AnimalDAO animalDAO = new AnimalDAO();
    ClientDAO clientDAO = new ClientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "liste";

        switch (action) {
            case "liste":
                List<Animal> liste = animalDAO.listerTous();
                request.setAttribute("animaux", liste);
                request.getRequestDispatcher("animaux.jsp").forward(request, response);
                break;

            case "formulaireAjouter":
                request.setAttribute("clients", clientDAO.listerTous());
                request.getRequestDispatcher("animalForm.jsp").forward(request, response);
                break;

            case "formulaireModifier":
                int id = Integer.parseInt(request.getParameter("id"));
                Animal a = animalDAO.trouverParId(id);
                request.setAttribute("animal", a);
                request.setAttribute("clients", clientDAO.listerTous());
                request.getRequestDispatcher("animalForm.jsp").forward(request, response);
                break;

            case "supprimer":
                int idSupp = Integer.parseInt(request.getParameter("id"));
                animalDAO.supprimer(idSupp);
                response.sendRedirect("AnimalServlet?action=liste");
                break;

            default:
                response.sendRedirect("AnimalServlet?action=liste");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        Animal a = new Animal();
        a.setClientId(Integer.parseInt(request.getParameter("clientId")));
        a.setNom(request.getParameter("nom"));
        a.setEspece(request.getParameter("espece"));
        a.setRace(request.getParameter("race"));
        a.setSexe(request.getParameter("sexe"));
        String dateNaissance = request.getParameter("dateNaissance");
        if (dateNaissance != null && !dateNaissance.isEmpty()) {
            a.setDateNaissance(Date.valueOf(dateNaissance));
        }
        String poids = request.getParameter("poids");
        if (poids != null && !poids.isEmpty()) {
            a.setPoids(Double.parseDouble(poids));
        }
        a.setObservations(request.getParameter("observations"));

        if ("ajouter".equals(action)) {
            animalDAO.ajouter(a);
        } else if ("modifier".equals(action)) {
            a.setId(Integer.parseInt(request.getParameter("id")));
            animalDAO.modifier(a);
        }

        response.sendRedirect("AnimalServlet?action=liste");
    }
}