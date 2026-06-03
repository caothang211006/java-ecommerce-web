package model;

import java.sql.Timestamp;

public class Order {
    private int orderId;
    private String account;
    private Timestamp orderDate;
    private String address;
    private String phone;
    private int status; // 0: chờ xử lý, 1: đang giao, 2: hoàn thành, 3: hủy

    public Order() {}

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public String getAccount() { return account; }
    public void setAccount(String account) { this.account = account; }
    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public String getStatusLabel() {
        switch (status) {
            case 0: return "Chờ xử lý";
            case 1: return "Đang giao";
            case 2: return "Hoàn thành";
            case 3: return "Đã hủy";
            default: return "Không xác định";
        }
    }
}
