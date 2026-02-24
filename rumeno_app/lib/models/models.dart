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

enum AnimalStatus { active, pregnant, dry, sick, underTreatment, quarantine }

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
  final DateTime? purchaseDate;
  final double? purchasePrice;
  final String farmerId;

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
    this.purchaseDate,
    this.purchasePrice,
    required this.farmerId,
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
    }
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
