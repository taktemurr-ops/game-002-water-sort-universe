/// Pure purchase entitlement state; no billing SDK or receipt verification.
enum PurchaseStatus { pending, verified, rejected, cancelled, restoredVerified }

class PurchaseEntitlements {
  final Set<String> _verifiedTransactions = {};
  final Set<String> _ownedProducts = {};

  static const supportedProducts = {
    'remove_ads',
    'cosmetic_ocean',
    'premium_puzzles',
  };

  bool owns(String productId) => _ownedProducts.contains(productId);
  bool get adsRemoved => owns('remove_ads');

  /// Must only be called after store/server verification of a real purchase.
  /// This is in-memory only; production requires durable verified entitlements.
  bool applyVerifiedPurchase({
    required String productId,
    required String transactionId,
    required PurchaseStatus status,
    required bool receiptVerified,
  }) {
    final id = transactionId.trim();
    if (!supportedProducts.contains(productId) ||
        id.isEmpty ||
        !receiptVerified ||
        (status != PurchaseStatus.verified &&
         status != PurchaseStatus.restoredVerified) ||
        _verifiedTransactions.contains(id)) {
      return false;
    }
    _verifiedTransactions.add(id);
    _ownedProducts.add(productId);
    return true;
  }
}
