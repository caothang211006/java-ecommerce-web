package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.ConnectDB;

public class ViewHistoryDAO {

    private static final Logger LOGGER = Logger.getLogger(ViewHistoryDAO.class.getName());

    public List<String> loadViewHistory(String account) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT productId FROM viewhistory WHERE account = ? ORDER BY viewedAt DESC";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, account);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getString("productId"));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "ViewHistoryDAO.loadViewHistory failed", e);
        }
        return list;
    }

    public void saveView(String account, String productId) {
        String sql = "INSERT INTO viewhistory(account, productId, viewedAt) VALUES(?, ?, CURRENT_TIMESTAMP) "
                + "ON DUPLICATE KEY UPDATE viewedAt = CURRENT_TIMESTAMP";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, account);
            ps.setString(2, productId);
            ps.executeUpdate();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "ViewHistoryDAO.saveView failed", e);
        }
    }

    public void saveAllViewed(String account, List<String> viewedIds) {
        if (viewedIds == null || viewedIds.isEmpty()) {
            return;
        }
        for (String pid : viewedIds) {
            saveView(account, pid);
        }
    }
}
