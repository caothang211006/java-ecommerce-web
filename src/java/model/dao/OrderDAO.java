package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import model.Order;
import model.OrderDetail;
import model.Product;
import util.ConnectDB;

public class OrderDAO {

    // Tạo order mới, trả về orderId
    public int createOrder(String account, String address, String phone, Map<String, Integer> cart) {
        String sql = "INSERT INTO orders(account, address, phone) VALUES(?,?,?)";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, account);
            ps.setString(2, address);
            ps.setString(3, phone);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int orderId = rs.getInt(1);
                    insertOrderDetails(con, orderId, cart);
                    return orderId;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }

    private void insertOrderDetails(Connection con, int orderId, Map<String, Integer> cart) throws Exception {
        String sql = "INSERT INTO orderDetails(orderId, productId, quantity, price, discount) VALUES(?,?,?,?,?)";
        ProductDAO pdao = new ProductDAO();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            for (Map.Entry<String, Integer> entry : cart.entrySet()) {
                Product p = pdao.getObjectById(entry.getKey());
                if (p != null) {
                    ps.setInt(1, orderId);
                    ps.setString(2, entry.getKey());
                    ps.setInt(3, entry.getValue());
                    ps.setInt(4, p.getPrice());
                    ps.setInt(5, p.getDiscount());
                    ps.executeUpdate();
                }
            }
        }
    }

    // Lấy danh sách order theo account
    public List<Order> listByAccount(String account) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE account = ? ORDER BY orderDate DESC";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, account);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapOrder(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Lấy tất cả order (admin)
    public List<Order> listAll() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY orderDate DESC";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapOrder(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Lấy chi tiết order
    public List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT od.*, p.productName, p.productImage FROM orderDetails od "
                + "JOIN products p ON od.productId = p.productId WHERE od.orderId = ?";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail od = new OrderDetail();
                    od.setOrderId(rs.getInt("orderId"));
                    od.setProductId(rs.getString("productId"));
                    od.setProductName(rs.getString("productName"));
                    od.setProductImage(rs.getString("productImage"));
                    od.setQuantity(rs.getInt("quantity"));
                    od.setPrice(rs.getInt("price"));
                    od.setDiscount(rs.getInt("discount"));
                    list.add(od);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Kiểm tra product còn order không
    public List<Order> listByProduct(String productId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.* FROM orders o JOIN orderDetails od ON o.orderId = od.orderId WHERE od.productId = ?";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapOrder(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Cập nhật status đơn hàng (admin)
    public void updateStatus(int orderId, int status) {
        String sql = "UPDATE orders SET status = ? WHERE orderId = ?";
        try (Connection con = new ConnectDB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    private Order mapOrder(ResultSet rs) throws Exception {
        Order o = new Order();
        o.setOrderId(rs.getInt("orderId"));
        o.setAccount(rs.getString("account"));
        o.setOrderDate(rs.getTimestamp("orderDate"));
        o.setAddress(rs.getString("address"));
        o.setPhone(rs.getString("phone"));
        o.setStatus(rs.getInt("status"));
        return o;
    }
}