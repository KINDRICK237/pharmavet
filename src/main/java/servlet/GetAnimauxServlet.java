package servlet;

import dao.AnimalDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Animal;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/GetAnimauxServlet")
public class GetAnimauxServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    AnimalDAO animalDAO = new AnimalDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String clientIdStr = request.getParameter("clientId");
        PrintWriter out = response.getWriter();

        if (clientIdStr == null || clientIdStr.isEmpty()) {
            out.print("[]");
            return;
        }

        try {
            int clientId = Integer.parseInt(clientIdStr);
            List<Animal> animaux = animalDAO.listerParClient(clientId);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < animaux.size(); i++) {
                Animal a = animaux.get(i);
                json.append("{")
                    .append("\"id\":").append(a.getId()).append(",")
                    .append("\"nom\":\"").append(a.getNom()).append("\",")
                    .append("\"espece\":\"").append(a.getEspece()).append("\"")
                    .append("}");
                if (i < animaux.size() - 1) json.append(",");
            }
            json.append("]");
            out.print(json.toString());

        } catch (Exception e) {
            out.print("[]");
            e.printStackTrace();
        }
    }
}