package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.ConnectDB;

public class CartDAO {

    private static final Logger LOGGER = Logger.getLogger(CartDAO.class.getName());

    public Map<String, Integer> loadCart(String account) {
        Map<String, Integer> cart = new HashMap<>();
        String sql = "SELECT productId, quantity FROM cart WHERE account = ?";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, account);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    cart.put(rs.getString("productId"), rs.getInt("quantity"));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "CartDAO.loadCart failed", e);
        }
        return cart;
    }

    public void saveCart(String account, Map<String, Integer> cart) {
        String deleteSql = "DELETE FROM cart WHERE account = ?";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(deleteSql)) {
            ps.setString(1, account);
            ps.executeUpdate();

            if (cart != null && !cart.isEmpty()) {
                String insertSql = "INSERT INTO cart(account, productId, quantity) VALUES(?,?,?)";
                try (PreparedStatement ps2 = con.prepareStatement(insertSql)) {
                    for (Map.Entry<String, Integer> entry : cart.entrySet()) {
                        ps2.setString(1, account);
                        ps2.setString(2, entry.getKey());
                        ps2.setInt(3, entry.getValue());
                        ps2.executeUpdate();
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "CartDAO.saveCart failed", e);
        }
    }
}
