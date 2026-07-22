package model;

import java.sql.Timestamp;

public class Order {
    private int orderId;
    private String account;
    private Timestamp orderDate;
    private String address;
    private String phone;
    private int status; // 0: pending, 1: shipping, 2: completed, 3: canceled

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
            case 0: return "Pending";
            case 1: return "Shipping";
            case 2: return "Completed";
            case 3: return "Canceled";
            default: return "Unknown";
        }
    }
}
