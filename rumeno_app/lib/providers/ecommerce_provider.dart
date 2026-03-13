import 'package:flutter/material.dart';
import '../models/models.dart';
import '../mock/mock_ecommerce.dart';

class EcommerceProvider extends ChangeNotifier {
  // Products
  List<Product> _allProducts = [];
  ProductCategory? _selectedCategory;
  String _searchQuery = '';

  // Cart
  final List<CartItem> _cartItems = [];

  // Wishlist
  final Set<String> _wishlistProductIds = {};

  // Orders
  List<Order> _orders = [];

  // Addresses
  List<ShippingAddress> _addresses = [];

  // Coupons
  Coupon? _appliedCoupon;

  // Vendors
  List<Vendor> _vendors = [];

  EcommerceProvider() {
    _loadMockData();
  }

  void _loadMockData() {
    _allProducts = List.from(mockProducts);
    _orders = List.from(mockOrders);
    _addresses = List.from(mockAddresses);
    _vendors = List.from(mockVendors);
  }

  // ─── Product Getters & Methods ───

  List<Product> get products {
    var list = _allProducts.where((p) => p.isApproved).toList();

    if (_selectedCategory != null) {
      list = list.where((p) => p.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((p) =>
          p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q) ||
          p.vendorName.toLowerCase().contains(q) ||
          p.tags.any((t) => t.toLowerCase().contains(q))).toList();
    }

    // Sort: Rumeno-owned first, then featured, then by rating
    list.sort((a, b) {
      if (a.isRumenoOwned && !b.isRumenoOwned) return -1;
      if (!a.isRumenoOwned && b.isRumenoOwned) return 1;
      if (a.isFeatured && !b.isFeatured) return -1;
      if (!a.isFeatured && b.isFeatured) return 1;
      return b.rating.compareTo(a.rating);
    });

    return list;
  }

  List<Product> get featuredProducts =>
      _allProducts.where((p) => p.isFeatured && p.isApproved).toList()
        ..sort((a, b) {
          if (a.isRumenoOwned && !b.isRumenoOwned) return -1;
          if (!a.isRumenoOwned && b.isRumenoOwned) return 1;
          return b.rating.compareTo(a.rating);
        });

  List<Product> get allProductsUnfiltered => _allProducts;

  ProductCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  void setCategory(ProductCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _allProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Product> getProductsByCategory(ProductCategory category) {
    return _allProducts
        .where((p) => p.category == category && p.isApproved)
        .toList()
      ..sort((a, b) {
        if (a.isRumenoOwned && !b.isRumenoOwned) return -1;
        if (!a.isRumenoOwned && b.isRumenoOwned) return 1;
        return b.rating.compareTo(a.rating);
      });
  }

  List<Product> getProductsByVendor(String vendorId) {
    return _allProducts.where((p) => p.vendorId == vendorId).toList();
  }

  // ─── Cart ───

  List<CartItem> get cartItems => _cartItems;

  int get cartItemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get cartSubtotal => _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  double get cartDiscount =>
      _appliedCoupon?.calculateDiscount(cartSubtotal) ?? 0;

  double get deliveryCharge => cartSubtotal >= 999 ? 0 : 50;

  double get cartTotal => cartSubtotal - cartDiscount + deliveryCharge;

  Coupon? get appliedCoupon => _appliedCoupon;

  void addToCart(Product product, {int quantity = 1}) {
    final existing = _cartItems.indexWhere((c) => c.product.id == product.id);
    if (existing != -1) {
      _cartItems[existing].quantity += quantity;
    } else {
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((c) => c.product.id == productId);
    notifyListeners();
  }

  void updateCartQuantity(String productId, int quantity) {
    final idx = _cartItems.indexWhere((c) => c.product.id == productId);
    if (idx != -1) {
      if (quantity <= 0) {
        _cartItems.removeAt(idx);
      } else {
        _cartItems[idx].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    _appliedCoupon = null;
    notifyListeners();
  }

  bool isInCart(String productId) {
    return _cartItems.any((c) => c.product.id == productId);
  }

  // ─── Coupons ───

  String? applyCoupon(String code) {
    final coupon = mockCoupons.firstWhere(
      (c) => c.code.toUpperCase() == code.toUpperCase(),
      orElse: () => Coupon(
        id: '',
        code: '',
        discountType: DiscountType.flat,
        discountValue: 0,
        usageLimit: 0,
        validFrom: DateTime.now(),
        validUntil: DateTime.now(),
        status: CouponStatus.disabled,
      ),
    );

    if (coupon.id.isEmpty) return 'Invalid coupon code';
    if (!coupon.isValid) return 'Coupon is expired or no longer valid';
    if (coupon.minOrderValue != null && cartSubtotal < coupon.minOrderValue!) {
      return 'Minimum order value ₹${coupon.minOrderValue!.toStringAsFixed(0)} required';
    }

    _appliedCoupon = coupon;
    notifyListeners();
    return null; // success
  }

  void removeCoupon() {
    _appliedCoupon = null;
    notifyListeners();
  }

  // ─── Addresses ───

  List<ShippingAddress> get addresses => _addresses;

  ShippingAddress? get defaultAddress {
    try {
      return _addresses.firstWhere((a) => a.isDefault);
    } catch (_) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  void addAddress(ShippingAddress address) {
    _addresses.add(address);
    notifyListeners();
  }

  // ─── Orders ───

  List<Order> get orders => _orders..sort((a, b) => b.orderDate.compareTo(a.orderDate));

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  Order placeOrder({
    required ShippingAddress address,
    required String paymentMethod,
    String? paymentId,
  }) {
    final order = Order(
      id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
      userId: 'F001',
      items: _cartItems
          .map((c) => OrderItem(
                productId: c.product.id,
                productName: c.product.name,
                productDescription: c.product.description,
                productImage: c.product.imageUrl,
                price: c.product.price,
                quantity: c.quantity,
                vendorId: c.product.vendorId,
              ))
          .toList(),
      address: address,
      subtotal: cartSubtotal,
      discount: cartDiscount,
      deliveryCharge: deliveryCharge,
      totalAmount: cartTotal,
      status: OrderStatus.confirmed,
      couponCode: _appliedCoupon?.code,
      paymentMethod: paymentMethod,
      paymentId: paymentId,
      orderDate: DateTime.now(),
    );

    _orders.add(order);
    clearCart();
    return order;
  }

  // ─── Vendors ───

  List<Vendor> get vendors => _vendors;

  List<Vendor> get approvedVendors =>
      _vendors.where((v) => v.status == VendorStatus.approved).toList();

  List<Vendor> get pendingVendors =>
      _vendors.where((v) => v.status == VendorStatus.pending).toList();

  Vendor? getVendorById(String id) {
    try {
      return _vendors.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }

  // ─── Reviews ───

  List<ProductReview> getReviewsForProduct(String productId) {
    return mockReviews.where((r) => r.productId == productId).toList();
  }

  // ─── Wishlist ───

  Set<String> get wishlistProductIds => _wishlistProductIds;

  List<Product> get wishlistProducts =>
      _allProducts.where((p) => _wishlistProductIds.contains(p.id)).toList();

  bool isInWishlist(String productId) => _wishlistProductIds.contains(productId);

  void toggleWishlist(String productId) {
    if (_wishlistProductIds.contains(productId)) {
      _wishlistProductIds.remove(productId);
    } else {
      _wishlistProductIds.add(productId);
    }
    notifyListeners();
  }
}
