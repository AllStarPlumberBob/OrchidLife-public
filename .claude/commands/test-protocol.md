---
description: Create a comprehensive test protocol for the current layer, including all device states and platform-specific handling
---

# Generate Test Protocol

Create a comprehensive test protocol for the current layer.

## Include:
1. Prerequisites (permissions, settings, demo data state)
2. Device setup steps
3. Numbered test actions
4. Expected observable results
5. Pass/fail checkboxes
6. Failure diagnosis guide
7. Manufacturer-specific notes (Samsung, Xiaomi)

## Test Scenarios Required:
- App fresh install (first launch with demo data)
- App with existing data
- App in foreground
- App in background (home button)
- App killed (swipe away)
- Screen off (Doze mode)
- After device reboot
- Permission denied scenario
- Database empty state
- Database with many orchids (performance)
