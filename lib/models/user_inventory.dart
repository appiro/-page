class UserInventory {
  final String itemId;
  final int remainingUses; // 残り使用回数
  final DateTime acquiredAt;
  final bool isEquipped; // 釣り竿の場合、装備中かどうか

  const UserInventory({
    required this.itemId,
    required this.remainingUses,
    required this.acquiredAt,
    this.isEquipped = false,
  });

  UserInventory copyWith({
    String? itemId,
    int? remainingUses,
    DateTime? acquiredAt,
    bool? isEquipped,
  }) {
    return UserInventory(
      itemId: itemId ?? this.itemId,
      remainingUses: remainingUses ?? this.remainingUses,
      acquiredAt: acquiredAt ?? this.acquiredAt,
      isEquipped: isEquipped ?? this.isEquipped,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'remainingUses': remainingUses,
      'acquiredAt': acquiredAt.toIso8601String(),
      'isEquipped': isEquipped,
    };
  }

  factory UserInventory.fromJson(Map<String, dynamic> json) {
    return UserInventory(
      itemId: json['itemId'] as String,
      remainingUses: json['remainingUses'] as int,
      acquiredAt: DateTime.parse(json['acquiredAt'] as String),
      isEquipped: json['isEquipped'] as bool? ?? false,
    );
  }
}
