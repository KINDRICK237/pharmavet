package servlet;

import dao.AnimalDAO;
import dao.ClientDAO;
import dao.MedicamentDAO;
import dao.VenteDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DetailVente;
import model.Vente;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/VenteServlet")
public class VenteServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    VenteDAO venteDAO = new VenteDAO();
    ClientDAO clientDAO = new ClientDAO();
    AnimalDAO animalDAO = new AnimalDAO();
    MedicamentDAO medicamentDAO = new MedicamentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "liste";

        switch (action) {
            case "liste":
                request.setAttribute("ventes", venteDAO.listerTous());
                request.getRequestDispatcher("ventes.jsp").forward(request, response);
                break;

            case "formulaireAjouter":
                request.setAttribute("clients", clientDAO.listerTous());
                request.setAttribute("medicaments", medicamentDAO.listerTous());
                request.setAttribute("numeroFacture", venteDAO.genererNumeroFacture());
                request.getRequestDispatcher("venteForm.jsp").forward(request, response);
                break;

            case "detail":
                int id = Integer.parseInt(request.getParameter("id"));
                Vente vente = venteDAO.trouverParId(id);
                request.setAttribute("vente", vente);
                request.getRequestDispatcher("venteDetail.jsp").forward(request, response);
                break;

            case "annuler":
                int idAnnuler = Integer.parseInt(request.getParameter("id"));
                venteDAO.annuler(idAnnuler);
                response.sendRedirect("VenteServlet?action=liste");
                break;

            default:
                response.sendRedirect("VenteServlet?action=liste");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
    
        HttpSession session = request.getSession();

        Vente v = new Vente();
        v.setNumeroFacture(request.getParameter("numeroFacture"));

        // Type de client
        String typeClient = request.getParameter("typeClient");
        if ("nouveau".equals(typeClient)) {
            v.setClientId(0);
            v.setNomClient(request.getParameter("nouveauNom"));
            v.setPrenomClient(request.getParameter("nouveauPrenom"));
            v.setTelephoneClient(request.getParameter("nouveauTelephone"));
        } else {
            String clientIdStr = request.getParameter("clientId");
            if (clientIdStr != null && !clientIdStr.isEmpty()) {
                try { v.setClientId(Integer.parseInt(clientIdStr)); }
                catch (NumberFormatException e) { v.setClientId(0); }
            } else { v.setClientId(0); }
        }

        // Animal
        String animalIdStr = request.getParameter("animalId");
        if (animalIdStr != null && !animalIdStr.isEmpty()) {
            try { v.setAnimalId(Integer.parseInt(animalIdStr)); }
            catch (NumberFormatException e) { v.setAnimalId(0); }
        } else { v.setAnimalId(0); }

        v.setModePaiement(request.getParameter("modePaiement"));
        v.setStatut("Payée");
        v.setObservations(request.getParameter("observations"));

        // Récupérer les lignes du panier
        String[] typeLignes = request.getParameterValues("typeLigne");
        String[] medicamentIds = request.getParameterValues("medicamentId");
        String[] nomLibres = request.getParameterValues("nomLibre");
        String[] quantites = request.getParameterValues("quantite");
        String[] prixUnitaires = request.getParameterValues("prixUnitaire");

        List<DetailVente> details = new ArrayList<>();
        double montantTotal = 0;

        if (typeLignes != null) {
            for (int i = 0; i < typeLignes.length; i++) {
                try {
                    // Vérifier que prix et quantité sont valides
                    if (prixUnitaires[i] == null || prixUnitaires[i].isEmpty()) continue;
                    if (quantites[i] == null || quantites[i].isEmpty()) continue;

                    double prix = Double.parseDouble(prixUnitaires[i]);
                    int qte = Integer.parseInt(quantites[i]);
                    if (qte <= 0) continue;

                    DetailVente d = new DetailVente();
                    d.setQuantite(qte);
                    d.setPrixUnitaire(prix);
                    d.setSousTotal(qte * prix);

                    if ("existant".equals(typeLignes[i])) {
                        if (medicamentIds[i] == null || medicamentIds[i].isEmpty()) continue;
                        d.setMedicamentId(Integer.parseInt(medicamentIds[i]));
                        d.setNomMedicamentLibre("");
                    } else {
                        if (nomLibres[i] == null || nomLibres[i].isEmpty()) continue;
                        d.setMedicamentId(0);
                        d.setNomMedicamentLibre(nomLibres[i]);
                    }

                    montantTotal += d.getSousTotal();
                    details.add(d);

                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        }

        v.setMontantTotal(montantTotal);

        boolean succes = venteDAO.ajouter(v, details);

        if (succes) {
            List<Vente> ventes = venteDAO.listerTous();
            if (!ventes.isEmpty()) {
                int newId = ventes.get(0).getId();
                response.sendRedirect("VenteServlet?action=detail&id=" + newId);
            } else {
                response.sendRedirect("VenteServlet?action=liste");
            }
        } else {
            response.sendRedirect("VenteServlet?action=liste");
        }
    }
}