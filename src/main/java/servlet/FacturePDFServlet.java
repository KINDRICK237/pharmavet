package servlet;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;
import dao.VenteDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DetailVente;
import model.Vente;

import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/FacturePDFServlet")
public class FacturePDFServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final BaseColor VERT_FONCE = new BaseColor(13, 79, 43);
    private static final BaseColor VERT_CLAIR = new BaseColor(26, 138, 74);
    private static final BaseColor GRIS_CLAIR = new BaseColor(245, 245, 245);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        VenteDAO venteDAO = new VenteDAO();
        Vente vente = venteDAO.trouverParId(id);

        if (vente == null) {
            response.sendRedirect("VenteServlet?action=liste");
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
            "attachment; filename=Facture_" + vente.getNumeroFacture() + ".pdf");

        try {
            Document document = new Document(PageSize.A4, 40, 40, 40, 40);
            OutputStream out = response.getOutputStream();
            PdfWriter.getInstance(document, out);
            document.open();

            // ===== EN-TÊTE =====
            PdfPTable headerTable = new PdfPTable(2);
            headerTable.setWidthPercentage(100);
            headerTable.setWidths(new float[]{1, 2});

            // Logo
            try {
                String logoPath = getServletContext().getRealPath("/images/logo.jpg");
                Image logo = Image.getInstance(logoPath);
                logo.scaleToFit(100, 100);
                PdfPCell logoCell = new PdfPCell(logo);
                logoCell.setBorder(Rectangle.NO_BORDER);
                logoCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                headerTable.addCell(logoCell);
            } catch (Exception e) {
                PdfPCell logoCell = new PdfPCell(new Phrase(""));
                logoCell.setBorder(Rectangle.NO_BORDER);
                headerTable.addCell(logoCell);
            }

            // Infos entreprise
            PdfPCell infoCell = new PdfPCell();
            infoCell.setBorder(Rectangle.NO_BORDER);
            infoCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            infoCell.setPadding(5);

            Font fontNomEntreprise = new Font(Font.FontFamily.HELVETICA, 22, Font.BOLD, VERT_FONCE);
            Font fontSlogan = new Font(Font.FontFamily.HELVETICA, 9, Font.ITALIC, VERT_CLAIR);
            Font fontInfo = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, BaseColor.DARK_GRAY);

            Paragraph nomEntreprise = new Paragraph("FOTSVET", fontNomEntreprise);
            nomEntreprise.setAlignment(Element.ALIGN_RIGHT);
            infoCell.addElement(nomEntreprise);

            Paragraph slogan = new Paragraph("Parce que chaque animal mérite le meilleur!!!!", fontSlogan);
            slogan.setAlignment(Element.ALIGN_RIGHT);
            infoCell.addElement(slogan);

            Paragraph veterinaire = new Paragraph("Dr. Wafo Armel", fontInfo);
            veterinaire.setAlignment(Element.ALIGN_RIGHT);
            infoCell.addElement(veterinaire);

            Paragraph contact = new Paragraph("Tél: 696 980 519", fontInfo);
            contact.setAlignment(Element.ALIGN_RIGHT);
            infoCell.addElement(contact);

            headerTable.addCell(infoCell);
            document.add(headerTable);

            // Ligne séparatrice
            LineSeparator separator = new LineSeparator();
            separator.setLineColor(VERT_CLAIR);
            document.add(new Chunk(separator));
            document.add(Chunk.NEWLINE);

            // ===== TITRE FACTURE =====
            Font fontTitre = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, VERT_FONCE);
            Paragraph titre = new Paragraph("FACTURE", fontTitre);
            titre.setAlignment(Element.ALIGN_CENTER);
            titre.setSpacingAfter(5);
            document.add(titre);

            Font fontNumero = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL, BaseColor.DARK_GRAY);
            Paragraph numero = new Paragraph(vente.getNumeroFacture(), fontNumero);
            numero.setAlignment(Element.ALIGN_CENTER);
            numero.setSpacingAfter(10);
            document.add(numero);

            // ===== INFOS CLIENT ET VENTE =====
            PdfPTable infoTable = new PdfPTable(2);
            infoTable.setWidthPercentage(100);
            infoTable.setSpacingBefore(10);
            infoTable.setSpacingAfter(15);

            Font fontLabel = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, VERT_FONCE);
            Font fontValue = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, BaseColor.BLACK);

            // Infos client
            PdfPCell clientCell = new PdfPCell();
            clientCell.setBorder(Rectangle.BOX);
            clientCell.setBorderColor(VERT_CLAIR);
            clientCell.setBackgroundColor(GRIS_CLAIR);
            clientCell.setPadding(10);

            clientCell.addElement(new Paragraph("INFORMATIONS CLIENT", fontLabel));
            clientCell.addElement(new Paragraph(" ", fontValue));

            String nomComplet = "";
            if (vente.getNomClient() != null) nomComplet += vente.getNomClient();
            if (vente.getPrenomClient() != null) nomComplet += " " + vente.getPrenomClient();
            clientCell.addElement(new Paragraph("Nom : " + nomComplet.trim(), fontValue));

            if (vente.getNomAnimal() != null && !vente.getNomAnimal().isEmpty()) {
                clientCell.addElement(new Paragraph("Animal : " + vente.getNomAnimal(), fontValue));
            }
            infoTable.addCell(clientCell);

            // Infos facture
            PdfPCell factureCell = new PdfPCell();
            factureCell.setBorder(Rectangle.BOX);
            factureCell.setBorderColor(VERT_CLAIR);
            factureCell.setBackgroundColor(GRIS_CLAIR);
            factureCell.setPadding(10);

            factureCell.addElement(new Paragraph("INFORMATIONS FACTURE", fontLabel));
            factureCell.addElement(new Paragraph(" ", fontValue));
            factureCell.addElement(new Paragraph("N° Facture : " + vente.getNumeroFacture(), fontValue));
            factureCell.addElement(new Paragraph("Date : " + vente.getDateVente(), fontValue));
            factureCell.addElement(new Paragraph("Mode paiement : " + vente.getModePaiement(), fontValue));
            factureCell.addElement(new Paragraph("Statut : " + vente.getStatut(), fontValue));
            infoTable.addCell(factureCell);

            document.add(infoTable);

            // ===== TABLEAU DES MÉDICAMENTS =====
            Font fontEntete = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, BaseColor.WHITE);
            Font fontLigne = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, BaseColor.BLACK);
            Font fontLigneBold = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, BaseColor.BLACK);

            PdfPTable tableDetails = new PdfPTable(5);
            tableDetails.setWidthPercentage(100);
            tableDetails.setWidths(new float[]{3.5f, 1.5f, 1f, 1.5f, 1.5f});
            tableDetails.setSpacingBefore(5);
            tableDetails.setSpacingAfter(10);

            // En-têtes
            String[] entetes = {"Médicament", "Unité", "Qté", "Prix unitaire", "Sous-total"};
            for (String entete : entetes) {
                PdfPCell cell = new PdfPCell(new Phrase(entete, fontEntete));
                cell.setBackgroundColor(VERT_FONCE);
                cell.setPadding(8);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setBorder(Rectangle.NO_BORDER);
                tableDetails.addCell(cell);
            }

            // Lignes des médicaments
            boolean ligneAlternee = false;
            if (vente.getDetails() != null && !vente.getDetails().isEmpty()) {
                for (DetailVente d : vente.getDetails()) {
                    BaseColor bgColor = ligneAlternee ? GRIS_CLAIR : BaseColor.WHITE;

                    // Nom médicament
                    String nomMed = "-";
                    if (d.getNomMedicament() != null && !d.getNomMedicament().isEmpty()) {
                        nomMed = d.getNomMedicament();
                    }
                    PdfPCell cellNom = new PdfPCell(new Phrase(nomMed, fontLigneBold));
                    cellNom.setBackgroundColor(bgColor);
                    cellNom.setPadding(7);
                    cellNom.setBorder(Rectangle.BOX);
                    cellNom.setBorderColor(new BaseColor(220, 220, 220));
                    tableDetails.addCell(cellNom);

                    // Unité
                    String unite = "-";
                    if (d.getUniteMedicament() != null && !d.getUniteMedicament().isEmpty()) {
                        unite = d.getUniteMedicament();
                    }
                    PdfPCell cellUnite = new PdfPCell(new Phrase(unite, fontLigne));
                    cellUnite.setBackgroundColor(bgColor);
                    cellUnite.setPadding(7);
                    cellUnite.setHorizontalAlignment(Element.ALIGN_CENTER);
                    cellUnite.setBorder(Rectangle.BOX);
                    cellUnite.setBorderColor(new BaseColor(220, 220, 220));
                    tableDetails.addCell(cellUnite);

                    // Quantité
                    PdfPCell cellQte = new PdfPCell(new Phrase(
                        String.valueOf(d.getQuantite()), fontLigne));
                    cellQte.setBackgroundColor(bgColor);
                    cellQte.setPadding(7);
                    cellQte.setHorizontalAlignment(Element.ALIGN_CENTER);
                    cellQte.setBorder(Rectangle.BOX);
                    cellQte.setBorderColor(new BaseColor(220, 220, 220));
                    tableDetails.addCell(cellQte);

                    // Prix unitaire
                    PdfPCell cellPrix = new PdfPCell(new Phrase(
                        String.format("%.0f FCFA", d.getPrixUnitaire()), fontLigne));
                    cellPrix.setBackgroundColor(bgColor);
                    cellPrix.setPadding(7);
                    cellPrix.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cellPrix.setBorder(Rectangle.BOX);
                    cellPrix.setBorderColor(new BaseColor(220, 220, 220));
                    tableDetails.addCell(cellPrix);

                    // Sous-total
                    PdfPCell cellSousTotal = new PdfPCell(new Phrase(
                        String.format("%.0f FCFA", d.getSousTotal()), fontLigneBold));
                    cellSousTotal.setBackgroundColor(bgColor);
                    cellSousTotal.setPadding(7);
                    cellSousTotal.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cellSousTotal.setBorder(Rectangle.BOX);
                    cellSousTotal.setBorderColor(new BaseColor(220, 220, 220));
                    tableDetails.addCell(cellSousTotal);

                    ligneAlternee = !ligneAlternee;
                }
            } else {
                // Aucun détail
                PdfPCell cellVide = new PdfPCell(new Phrase("Aucun médicament enregistré", fontLigne));
                cellVide.setColspan(5);
                cellVide.setPadding(10);
                cellVide.setHorizontalAlignment(Element.ALIGN_CENTER);
                tableDetails.addCell(cellVide);
            }

            // Ligne TOTAL
            Font fontTotal = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.WHITE);

            PdfPCell cellTotalLabel = new PdfPCell(new Phrase("TOTAL", fontTotal));
            cellTotalLabel.setBackgroundColor(VERT_CLAIR);
            cellTotalLabel.setPadding(10);
            cellTotalLabel.setColspan(4);
            cellTotalLabel.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cellTotalLabel.setBorder(Rectangle.NO_BORDER);
            tableDetails.addCell(cellTotalLabel);

            PdfPCell cellTotalVal = new PdfPCell(new Phrase(
                String.format("%.0f FCFA", vente.getMontantTotal()), fontTotal));
            cellTotalVal.setBackgroundColor(VERT_CLAIR);
            cellTotalVal.setPadding(10);
            cellTotalVal.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cellTotalVal.setBorder(Rectangle.NO_BORDER);
            tableDetails.addCell(cellTotalVal);

            document.add(tableDetails);

            // ===== OBSERVATIONS =====
            if (vente.getObservations() != null && !vente.getObservations().isEmpty()) {
                Font fontObs = new Font(Font.FontFamily.HELVETICA, 10, Font.ITALIC, BaseColor.DARK_GRAY);
                Paragraph obs = new Paragraph("Observations : " + vente.getObservations(), fontObs);
                obs.setSpacingBefore(5);
                document.add(obs);
            }

            // ===== PIED DE PAGE =====
            document.add(Chunk.NEWLINE);
            document.add(Chunk.NEWLINE);
            LineSeparator sep2 = new LineSeparator();
            sep2.setLineColor(VERT_CLAIR);
            document.add(new Chunk(sep2));
            document.add(Chunk.NEWLINE);

            Font fontPied = new Font(Font.FontFamily.HELVETICA, 9, Font.ITALIC, VERT_CLAIR);
            Paragraph pied = new Paragraph(
                "FOTSVET - Parce que chaque animal mérite le meilleur!!!! - Dr. Wafo Armel - Tél: 696 980 519",
                fontPied);
            pied.setAlignment(Element.ALIGN_CENTER);
            document.add(pied);

            document.close();

        } catch (DocumentException e) {
            e.printStackTrace();
        }
    }
}