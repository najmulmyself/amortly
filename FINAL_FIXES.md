# Amortly — Final Fixes Tracker

> Source: REVIEW_REPORT_ROUND2.md  
> Updated in real-time as each fix is applied.

---

## Status Key

- ✅ Done (this session)
- 🔧 In Progress
- ❌ Not Started
- ⚠️ Blocked — needs input from you (see Blockers section)

---

## TONIGHT — Review Blockers

| #   | Item                                                           | Status | Notes                                        |
| --- | -------------------------------------------------------------- | ------ | -------------------------------------------- |
| 1a  | `PurchaseService` subscribe to `purchaseStream` in constructor | ✅     |                                              |
| 1b  | `ProUpgradeRow` — add `onTap` that calls `buyPro()`            | ✅     | GestureDetector wraps entire banner          |
| 1c  | `SettingsScreen` — rebuild reactively when Pro unlocks         | ✅     | `ListenableBuilder` on `PurchaseService`     |
| 1d  | `SavedScreen` banner re-check if Pro bought mid-session        | ✅     | `ListenableBuilder` on `bottomNavigationBar` |
| 2   | Fix 0% rate bug in `MortgageCalculator._monthlyPI`             | ✅     | Returns `principal / n` for 0% rate          |
| 2t  | Fix unit test asserting buggy 0% behavior                      | ✅     | Changed to `closeTo(833.33, 1.0)`            |
| 3   | `AffordabilityCalculator` — include T&I in housing-cost cap    | ✅     | 5-iteration solver; 1% tax + 0.5% insurance  |

---

## THIS WEEK — Functional Gaps

| #   | Item                                                                                                                                  | Status | Notes                                                                |
| --- | ------------------------------------------------------------------------------------------------------------------------------------- | ------ | -------------------------------------------------------------------- |
| 4   | GoRouter redirect — cache `onboardingDone` in `main()` to avoid async SharedPrefs on every route                                      | ✅     |                                                                      |
| 5   | Every-3rd-calculation interstitial in `CalculatorCubit`                                                                               | ✅     |                                                                      |
| 6   | Affordability DTI boundary — use rounded comparison to avoid floating-point flip at exactly 28%/36%                                   | ✅     |                                                                      |
| 7   | `origPayoff` date in `compare_screen.dart` uses `startDate.month + origMonths` without normalization (accidental Dart auto-normalize) | ✅     | Replaced with proper `DateTime` arithmetic                           |
| 8   | `widget_test.dart` still references old counter test                                                                                  | ✅     | Already fixed in prior session — verified                            |
| 9   | `appStoreId: ''` in `InAppReview.openStoreListing`                                                                                    | ⚠️     | **Blocked: need real App Store ID from you**                         |
| 10  | Settings rows (Currency, Date Format, Number Format, Default Loan Term) have no `onTap`                                               | ✅     | Removed visual chevron affordance for v1 to avoid tappable dead rows |
| 11  | "Buy vs Rent" segment still shows "Coming Soon"                                                                                       | ✅     | Removed tab for v1 — avoids App Store Rule 2.3.3 risk                |
| 12  | `maxFreeSavedCalculations = 10` limit not enforced                                                                                    | ❌     | Low priority for now — not a review blocker                          |
| 13  | Compare screen is "With/Without Extra" not "Loan A vs Loan B"                                                                         | ⚠️     | **Blocked: major feature rebuild — needs your go-ahead**             |
| 14  | PDF export not implemented (`pdf` + `printing` packages unused)                                                                       | ⚠️     | **Blocked: significant work — confirm scope for v1**                 |

---

## BEFORE SUBMISSION — Config / Mechanical

| #   | Item                                                               | Status | Notes                                                                   |
| --- | ------------------------------------------------------------------ | ------ | ----------------------------------------------------------------------- |
| 15  | Replace `GADApplicationIdentifier` test ID in `Info.plist`         | ⚠️     | **Blocked: need your production AdMob App ID**                          |
| 16  | Set `_useTestIds = false` in `ad_service.dart`                     | ⚠️     | **Blocked: need production unit IDs**                                   |
| 17  | Host `https://amortly.app/privacy` and `https://amortly.app/terms` | ⚠️     | **Blocked: needs GitHub Pages or hosting**                              |
| 18  | Add full Google SKAdNetworkItems list (~80 entries)                | ⚠️     | **Blocked: confirm you want full list — adds ~200 lines to Info.plist** |
| 19  | Set real `appStoreId` in `InAppReview.openStoreListing`            | ⚠️     | **Blocked: need App Store Connect app ID**                              |
| 20  | Create IAP product `com.amortly.app.pro` in App Store Connect      | ⚠️     | **Blocked: needs App Store Connect access**                             |
| 21  | Set real bundle ID in `Runner.xcodeproj`                           | ⚠️     | **Blocked: confirm bundle ID**                                          |
| 22  | Take real-device screenshots                                       | ⚠️     | **Blocked: needs device + submission prep**                             |

---

## Blockers — What I Need From You

1. **App Store ID** — your numeric App Store Connect app ID (for `InAppReview.openStoreListing` and screenshots)
2. **Production AdMob IDs** — App ID (for Info.plist) + Interstitial unit ID + Banner unit ID
3. **Bundle ID confirmation** — what is your final bundle identifier? (currently `com.yourname.amortly`)
4. **Compare screen direction** — do you want to rebuild as "Loan A vs Loan B" (major work, ~2–3hrs), or keep current "With/Without Extra" and rename it?
5. **PDF export for v1?** — confirm if PDF export is a v1.0 requirement or deferred to v1.1

---

## `flutter analyze` status after this session

**0 errors, 9 warnings/infos** (all unused imports / unused variables — no logic issues).
Last run: May 13, 2026.
