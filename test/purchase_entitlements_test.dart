import 'package:flutter_test/flutter_test.dart';
import 'package:game_002_water_sort_universe/monetization/purchase_entitlements.dart';

void main() {
  test('unverified, pending and cancelled purchases grant nothing', () {
    final e = PurchaseEntitlements();
    for (final status in [PurchaseStatus.pending, PurchaseStatus.cancelled, PurchaseStatus.rejected]) {
      expect(e.applyVerifiedPurchase(productId: 'remove_ads', transactionId: status.name,
        status: status, receiptVerified: true), false);
    }
    expect(e.applyVerifiedPurchase(productId: 'remove_ads', transactionId: '1',
      status: PurchaseStatus.verified, receiptVerified: false), false);
    expect(e.adsRemoved, false);
  });
  test('verified restore grants ownership and duplicate transaction is rejected', () {
    final e = PurchaseEntitlements();
    expect(e.applyVerifiedPurchase(productId: 'remove_ads', transactionId: ' 123 ',
      status: PurchaseStatus.restoredVerified, receiptVerified: true), true);
    expect(e.adsRemoved, true);
    expect(e.applyVerifiedPurchase(productId: 'remove_ads', transactionId: '123',
      status: PurchaseStatus.verified, receiptVerified: true), false);
  });
  test('unknown products cannot unlock premium content', () {
    final e = PurchaseEntitlements();
    expect(e.applyVerifiedPurchase(productId: 'unknown', transactionId: 'x',
      status: PurchaseStatus.verified, receiptVerified: true), false);
    expect(e.owns('premium_puzzles'), false);
  });
}
