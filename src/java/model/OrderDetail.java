package model;

public class OrderDetail {
    private int orderId;
    private String productId;
    private String productName;
    private String productImage;
    private int quantity;
    private int price;
    private int discount;

    public OrderDetail() {}

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public String getProductId() { return productId; }
    public void setProductId(String productId) { this.productId = productId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public int getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }
    public int getDiscount() { return discount; }
    public void setDiscount(int discount) { this.discount = discount; }

    public long getFinalPrice() {
        return (long)(price - (price * discount / 100.0)) * quantity;
    }
}
