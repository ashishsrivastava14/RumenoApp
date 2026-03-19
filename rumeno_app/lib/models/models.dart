enum UserRole { farmer, vet, admin, farmProducts }

class AppUser {
  final String id;
  final String name;
  final String phone;
  final UserRole role;
  final String? farmName;
  final String? specialization;
  final String? licenseNumber;
  final String? referralCode;
  final String? avatarUrl;

  const AppUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    this.farmName,
    this.specialization,
    this.licenseNumber,
    this.referralCode,
    this.avatarUrl,
  });
}

enum Species { cow, buffalo, goat, sheep, pig, horse }

enum AnimalStatus { active, pregnant, dry, sick, underTreatment, quarantine, deceased }

enum Gender { male, female }

enum AnimalPurpose { dairy, meat, breeding, mixed }

class Animal {
  final String id;
  final String tagId;
  final Species species;
  final String breed;
  final DateTime dateOfBirth;
  final Gender gender;
  final AnimalStatus status;
  final AnimalPurpose purpose;
  final double weightKg;
  final double? heightCm;
  final String? color;
  final String? shedNumber;
  final String? fatherId;
  final String? motherId;
  final int? numberOfSiblings;
  final DateTime? purchaseDate;
  final double? purchasePrice;
  final String farmerId;

  // Mortality
  final DateTime? mortalityDate;
  final String? mortalityReason;

  // Castration
  final DateTime? castrationDate;

  // Sale
  final DateTime? saleDate;
  final double? salePrice;
  final String? buyerName;

  const Animal({
    required this.id,
    required this.tagId,
    required this.species,
    required this.breed,
    required this.dateOfBirth,
    required this.gender,
    required this.status,
    required this.purpose,
    required this.weightKg,
    this.heightCm,
    this.color,
    this.shedNumber,
    this.fatherId,
    this.motherId,
    this.numberOfSiblings,
    this.purchaseDate,
    this.purchasePrice,
    required this.farmerId,
    this.mortalityDate,
    this.mortalityReason,
    this.castrationDate,
    this.saleDate,
    this.salePrice,
    this.buyerName,
  });

  int get ageInMonths {
    final now = DateTime.now();
    return (now.year - dateOfBirth.year) * 12 + now.month - dateOfBirth.month;
  }

  String get ageString {
    final months = ageInMonths;
    if (months >= 12) {
      final years = months ~/ 12;
      final rem = months % 12;
      return rem > 0 ? '${years}y ${rem}m' : '${years}y';
    }
    return '${months}m';
  }

  String get speciesName {
    switch (species) {
      case Species.cow:
        return 'Cow';
      case Species.buffalo:
        return 'Buffalo';
      case Species.goat:
        return 'Goat';
      case Species.sheep:
        return 'Sheep';
      case Species.pig:
        return 'Pig';
      case Species.horse:
        return 'Horse';
    }
  }

  String get statusLabel {
    switch (status) {
      case AnimalStatus.active:
        return 'Active';
      case AnimalStatus.pregnant:
        return 'Pregnant';
      case AnimalStatus.dry:
        return 'Dry';
      case AnimalStatus.sick:
        return 'Sick';
      case AnimalStatus.underTreatment:
        return 'Under Treatment';
      case AnimalStatus.quarantine:
        return 'Quarantine';
      case AnimalStatus.deceased:
        return 'Deceased';
    }
  }

  bool get isDead => status == AnimalStatus.deceased;
  bool get isCastrated => castrationDate != null;
  bool get isSold => saleDate != null;

  String? get ageAtDeath {
    if (mortalityDate == null) return null;
    final days = mortalityDate!.difference(dateOfBirth).inDays;
    if (days < 30) return '$days days';
    if (days < 365) return '${days ~/ 30}m ${days % 30}d';
    return '${days ~/ 365}y ${(days % 365) ~/ 30}m';
  }
}

enum VaccinationStatus { due, overdue, done }

class VaccinationRecord {
  final String id;
  final String animalId;
  final String vaccineName;
  final DateTime? dateAdministered;
  final DateTime dueDate;
  final DateTime? nextDueDate;
  final String? vetName;
  final String? dose;
  final String? batchNumber;
  final VaccinationStatus status;
  final String? notes;

  const VaccinationRecord({
    required this.id,
    required this.animalId,
    required this.vaccineName,
    this.dateAdministered,
    required this.dueDate,
    this.nextDueDate,
    this.vetName,
    this.dose,
    this.batchNumber,
    required this.status,
    this.notes,
  });
}

enum TreatmentStatus { active, completed, followUp }

class TreatmentRecord {
  final String id;
  final String animalId;
  final List<String> symptoms;
  final String diagnosis;
  final String treatment;
  final DateTime startDate;
  final DateTime? endDate;
  final String vetName;
  final TreatmentStatus status;
  final int? withdrawalDays;
  final DateTime? followUpDate;
  final String? notes;

  const TreatmentRecord({
    required this.id,
    required this.animalId,
    required this.symptoms,
    required this.diagnosis,
    required this.treatment,
    required this.startDate,
    this.endDate,
    required this.vetName,
    required this.status,
    this.withdrawalDays,
    this.followUpDate,
    this.notes,
  });
}

enum HeatIntensity { mild, moderate, strong }

class BreedingRecord {
  final String id;
  final String animalId;
  final DateTime heatDate;
  final HeatIntensity intensity;
  final bool aiDone;
  final String? bullSemenId;
  final String? technicianName;
  final DateTime? matingDate;
  final bool isPregnant;
  final DateTime? expectedDelivery;
  final DateTime? actualDelivery;
  final int? offspringCount;
  final String? notes;

  const BreedingRecord({
    required this.id,
    required this.animalId,
    required this.heatDate,
    required this.intensity,
    required this.aiDone,
    this.bullSemenId,
    this.technicianName,
    this.matingDate,
    required this.isPregnant,
    this.expectedDelivery,
    this.actualDelivery,
    this.offspringCount,
    this.notes,
  });
}

enum ExpenseCategory { feed, medicine, veterinary, labour, equipment, transport, other }

enum PaymentMode { cash, upi, bank, credit }

class ExpenseRecord {
  final String id;
  final ExpenseCategory category;
  final String? subCategory;
  final double amount;
  final DateTime date;
  final String? vendorName;
  final PaymentMode paymentMode;
  final String? animalId;
  final String? notes;
  final String farmerId;

  const ExpenseRecord({
    required this.id,
    required this.category,
    this.subCategory,
    required this.amount,
    required this.date,
    this.vendorName,
    required this.paymentMode,
    this.animalId,
    this.notes,
    required this.farmerId,
  });

  String get categoryName {
    switch (category) {
      case ExpenseCategory.feed:
        return 'Feed';
      case ExpenseCategory.medicine:
        return 'Medicine';
      case ExpenseCategory.veterinary:
        return 'Veterinary';
      case ExpenseCategory.labour:
        return 'Labour';
      case ExpenseCategory.equipment:
        return 'Equipment';
      case ExpenseCategory.transport:
        return 'Transport';
      case ExpenseCategory.other:
        return 'Other';
    }
  }
}

enum SubscriptionPlan { free, starter, pro, business }

class Farmer {
  final String id;
  final String name;
  final String phone;
  final String farmName;
  final String address;
  final String state;
  final String? gpsLocation;
  final SubscriptionPlan plan;
  final DateTime joinedDate;
  final int animalCount;
  final bool isActive;
  final String? vetId;
  final String? managerName;

  const Farmer({
    required this.id,
    required this.name,
    required this.phone,
    required this.farmName,
    required this.address,
    required this.state,
    this.gpsLocation,
    required this.plan,
    required this.joinedDate,
    required this.animalCount,
    required this.isActive,
    this.vetId,
    this.managerName,
  });

  String get planName {
    switch (plan) {
      case SubscriptionPlan.free:
        return 'Free';
      case SubscriptionPlan.starter:
        return 'Starter';
      case SubscriptionPlan.pro:
        return 'Pro';
      case SubscriptionPlan.business:
        return 'Business';
    }
  }
}

class AlertItem {
  final String id;
  final String message;
  final AlertSeverity severity;
  final DateTime date;
  final String? animalId;

  const AlertItem({
    required this.id,
    required this.message,
    required this.severity,
    required this.date,
    this.animalId,
  });
}

enum AlertSeverity { high, medium, low }

class UpcomingEvent {
  final String id;
  final String title;
  final String eventType;
  final DateTime date;
  final String? animalId;

  const UpcomingEvent({
    required this.id,
    required this.title,
    required this.eventType,
    required this.date,
    this.animalId,
  });
}

enum MilkSession { morning, evening }

class MilkRecord {
  final String id;
  final String animalId;
  final DateTime date;
  final MilkSession session;
  final double quantityLitres;
  final String? notes;

  const MilkRecord({
    required this.id,
    required this.animalId,
    required this.date,
    required this.session,
    required this.quantityLitres,
    this.notes,
  });

  String get sessionLabel => session == MilkSession.morning ? 'Morning' : 'Evening';
}

enum DewormingStatus { due, overdue, done }

class DewormingRecord {
  final String id;
  final String animalId;
  final String medicineName;
  final String? dose;
  final DateTime? dateAdministered;
  final DateTime dueDate;
  final DateTime? nextDueDate;
  final String? vetName;
  final DewormingStatus status;
  final String? notes;

  const DewormingRecord({
    required this.id,
    required this.animalId,
    required this.medicineName,
    this.dose,
    this.dateAdministered,
    required this.dueDate,
    this.nextDueDate,
    this.vetName,
    required this.status,
    this.notes,
  });
}

// ─── Kid Management ───

/// Represents a young goat / lamb (kid) with its care tracking data.
class KidRecord {
  final String id;
  /// Visible tag e.g. K-001
  final String kidId;
  /// Optional link to the mother's animal record
  final String? motherId;
  final DateTime? dateOfBirth;

  // Coccidiostat (anti-coccidiosis medication)
  final String? coccidisostatName;
  final String? coccidisostatSaltName;
  final DateTime? coccidisostatGivenDate;
  final DateTime? coccidisostatNextDate;

  // Weaning
  final DateTime? weaningDate;

  // Weight (average tracked over time)
  final double? averageWeightKg;

  // Milk Replacer
  final DateTime? milkReplacerStartDate;

  final String farmerId;
  final String? notes;

  const KidRecord({
    required this.id,
    required this.kidId,
    this.motherId,
    this.dateOfBirth,
    this.coccidisostatName,
    this.coccidisostatSaltName,
    this.coccidisostatGivenDate,
    this.coccidisostatNextDate,
    this.weaningDate,
    this.averageWeightKg,
    this.milkReplacerStartDate,
    required this.farmerId,
    this.notes,
  });

  /// True if the kid has already been weaned
  bool get isWeaned {
    if (weaningDate == null) return false;
    return DateTime.now().isAfter(weaningDate!);
  }

  /// True if coccidiostat next-dose is due today or overdue
  bool get coccidisostatDue {
    if (coccidisostatNextDate == null) return false;
    return !DateTime.now().isBefore(coccidisostatNextDate!);
  }

  /// Returns a KidRecord with updated fields
  KidRecord copyWith({
    String? kidId,
    String? motherId,
    DateTime? dateOfBirth,
    String? coccidisostatName,
    String? coccidisostatSaltName,
    DateTime? coccidisostatGivenDate,
    DateTime? coccidisostatNextDate,
    DateTime? weaningDate,
    double? averageWeightKg,
    DateTime? milkReplacerStartDate,
    String? notes,
  }) {
    return KidRecord(
      id: id,
      kidId: kidId ?? this.kidId,
      motherId: motherId ?? this.motherId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      coccidisostatName: coccidisostatName ?? this.coccidisostatName,
      coccidisostatSaltName: coccidisostatSaltName ?? this.coccidisostatSaltName,
      coccidisostatGivenDate: coccidisostatGivenDate ?? this.coccidisostatGivenDate,
      coccidisostatNextDate: coccidisostatNextDate ?? this.coccidisostatNextDate,
      weaningDate: weaningDate ?? this.weaningDate,
      averageWeightKg: averageWeightKg ?? this.averageWeightKg,
      milkReplacerStartDate: milkReplacerStartDate ?? this.milkReplacerStartDate,
      farmerId: farmerId,
      notes: notes ?? this.notes,
    );
  }
}

enum LabReportStatus { pending, completed }

class LabReport {
  final String id;
  final String animalId;
  final String testName;
  final DateTime testDate;
  final String? result;
  final String? labName;
  final String? vetName;
  final LabReportStatus status;
  final String? notes;

  const LabReport({
    required this.id,
    required this.animalId,
    required this.testName,
    required this.testDate,
    this.result,
    this.labName,
    this.vetName,
    required this.status,
    this.notes,
  });
}

// ─── Ecommerce Models ───

enum ProductCategory { animalFeed, tonic, supplements, veterinaryMedicines, farmEquipment }

enum ProductAnimal { cattle, goat, sheep, poultry, pig, horse }

enum OrderStatus { pending, confirmed, packed, shipped, delivered, cancelled, returned }

enum VendorStatus { pending, approved, rejected, suspended }

enum DiscountType { percentage, flat }

enum CouponStatus { active, expired, disabled }

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? mrp;
  final ProductCategory category;
  final String vendorId;
  final String vendorName;
  final bool isRumenoOwned;
  final int stockQuantity;
  final String imageUrl;
  final String? youtubeVideoUrl;
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final bool isApproved;
  final String unit;
  final double? weightKg;
  final DateTime createdAt;
  final List<String> tags;
  final List<ProductAnimal> targetAnimals;
  final String? hsnCode;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.mrp,
    required this.category,
    required this.vendorId,
    required this.vendorName,
    this.isRumenoOwned = false,
    required this.stockQuantity,
    required this.imageUrl,
    this.youtubeVideoUrl,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isFeatured = false,
    this.isApproved = true,
    required this.unit,
    this.weightKg,
    required this.createdAt,
    this.tags = const <String>[],
    this.targetAnimals = const <ProductAnimal>[],
    this.hsnCode,
  });

  bool get inStock => stockQuantity > 0;

  double get discountPercent {
    if (mrp == null || mrp! <= price) return 0;
    return ((mrp! - price) / mrp! * 100);
  }

  String get categoryName {
    switch (category) {
      case ProductCategory.animalFeed:
        return 'Animal Feed';
      case ProductCategory.tonic:
        return 'Tonic';
      case ProductCategory.supplements:
        return 'Supplements';
      case ProductCategory.veterinaryMedicines:
        return 'Veterinary Medicines';
      case ProductCategory.farmEquipment:
        return 'Farm Equipment';
    }
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;
}

class ShippingAddress {
  final String id;
  final String name;
  final String phone;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String pincode;
  final bool isDefault;

  const ShippingAddress({
    required this.id,
    required this.name,
    required this.phone,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    this.isDefault = false,
  });

  String get fullAddress =>
      '$addressLine1${addressLine2 != null ? ', $addressLine2' : ''}, $city, $state - $pincode';
}

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final ShippingAddress address;
  final double subtotal;
  final double discount;
  final double deliveryCharge;
  final double totalAmount;
  final OrderStatus status;
  final String? couponCode;
  final String paymentMethod;
  final String? paymentId;
  final String? trackingNumber;
  final DateTime orderDate;
  final DateTime? packedDate;
  final DateTime? shippedDate;
  final DateTime? deliveredDate;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.address,
    required this.subtotal,
    this.discount = 0,
    this.deliveryCharge = 0,
    required this.totalAmount,
    required this.status,
    this.couponCode,
    required this.paymentMethod,
    this.paymentId,
    this.trackingNumber,
    required this.orderDate,
    this.packedDate,
    this.shippedDate,
    this.deliveredDate,
  });

  // ─── Invoice & Tax Computed Fields ───
  String get invoiceNo => 'INV-$id';

  /// Sum of each item's taxable value (price ex-GST × qty)
  double get totalTaxableValue =>
      items.fold(0.0, (sum, item) => sum + item.taxableValue);

  /// CGST = half of each item's GST (intra-state)
  double get totalCgst =>
      items.fold(0.0, (sum, item) => sum + item.cgstAmount);

  /// SGST = same as CGST (intra-state)
  double get totalSgst => totalCgst;

  /// Total GST (CGST + SGST)
  double get totalTaxAmount => totalCgst + totalSgst;

  /// Blended GST % for display (e.g. "12%")
  double get blendedTaxRate {
    if (totalTaxableValue == 0) return 0;
    return totalTaxAmount / totalTaxableValue;
  }

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.packed:
        return 'Packed';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.returned:
        return 'Returned';
    }
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String productDescription;
  final String productImage;
  final double price;
  final int quantity;
  final String vendorId;
  final String? hsnCode;
  final double taxRate; // e.g. 0.05, 0.12, 0.18 — GST rate (tax-inclusive in price)

  const OrderItem({
    required this.productId,
    required this.productName,
    this.productDescription = '',
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.vendorId,
    this.hsnCode,
    this.taxRate = 0.12,
  });

  double get totalPrice => price * quantity;
  double get taxableValue => totalPrice / (1 + taxRate);
  double get cgstAmount => taxableValue * (taxRate / 2);
  double get sgstAmount => taxableValue * (taxRate / 2);
  double get taxAmount => cgstAmount + sgstAmount;
}

class Vendor {
  final String id;
  final String businessName;
  final String ownerName;
  final String phone;
  final String email;
  final String? gstNumber;
  final String? panNumber;
  final String? bankAccountNumber;
  final String? ifscCode;
  final String? bankName;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String? idProofUrl;
  final VendorStatus status;
  final double commissionPercent;
  final double walletBalance;
  final double totalEarnings;
  final int totalProducts;
  final int totalOrders;
  final DateTime joinedDate;

  const Vendor({
    required this.id,
    required this.businessName,
    required this.ownerName,
    required this.phone,
    required this.email,
    this.gstNumber,
    this.panNumber,
    this.bankAccountNumber,
    this.ifscCode,
    this.bankName,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.idProofUrl,
    required this.status,
    this.commissionPercent = 10.0,
    this.walletBalance = 0,
    this.totalEarnings = 0,
    this.totalProducts = 0,
    this.totalOrders = 0,
    required this.joinedDate,
  });

  String get statusLabel {
    switch (status) {
      case VendorStatus.pending:
        return 'Pending';
      case VendorStatus.approved:
        return 'Approved';
      case VendorStatus.rejected:
        return 'Rejected';
      case VendorStatus.suspended:
        return 'Suspended';
    }
  }
}

class Coupon {
  final String id;
  final String code;
  final DiscountType discountType;
  final double discountValue;
  final double? minOrderValue;
  final double? maxDiscount;
  final int usageLimit;
  final int usedCount;
  final DateTime validFrom;
  final DateTime validUntil;
  final CouponStatus status;

  const Coupon({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    this.minOrderValue,
    this.maxDiscount,
    required this.usageLimit,
    this.usedCount = 0,
    required this.validFrom,
    required this.validUntil,
    required this.status,
  });

  bool get isValid =>
      status == CouponStatus.active &&
      DateTime.now().isAfter(validFrom) &&
      DateTime.now().isBefore(validUntil) &&
      usedCount < usageLimit;

  double calculateDiscount(double orderAmount) {
    if (!isValid) return 0;
    if (minOrderValue != null && orderAmount < minOrderValue!) return 0;
    double disc = discountType == DiscountType.percentage
        ? orderAmount * discountValue / 100
        : discountValue;
    if (maxDiscount != null && disc > maxDiscount!) disc = maxDiscount!;
    return disc;
  }
}

class ProductReview {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final double rating;
  final String? comment;
  final DateTime createdAt;

  const ProductReview({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    this.comment,
    required this.createdAt,
  });
}
