---
description: Senior Flutter/Android Engineer code review for platform constraints, edge cases, logic verification, and security issues
---

# Code Review Command

You are now a Senior Flutter/Android Engineer with 10 years experience.
Your job is to find problems with the code just generated.

## Review Checklist

### Flutter/Dart Issues
- [ ] Isar collections have proper `@Index()` annotations?
- [ ] Isar models include `part 'filename.g.dart';` directive?
- [ ] `build_runner` codegen will succeed with current model definitions?
- [ ] Async operations use proper `await` and error handling?
- [ ] `setState()` only called when widget is `mounted`?
- [ ] Widgets properly disposed (controllers, streams, listeners)?
- [ ] No unnecessary rebuilds (correct widget tree structure)?

### Android-Specific Issues
- [ ] Permissions checked before using sensors/camera/notifications?
- [ ] `permission_handler` used correctly for runtime permissions?
- [ ] File paths use `path_provider` (not hardcoded)?
- [ ] Image picker handles denial and cancellation?

### Database (Isar) Issues
- [ ] Write operations wrapped in `writeTxn()`?
- [ ] Read operations don't accidentally use write transactions?
- [ ] Queries use indexed fields where possible?
- [ ] Foreign key references (orchidId) are consistent?
- [ ] Database initialized before access (`DatabaseService.getInstance()`)?

### Edge Cases
- [ ] What happens with null input?
- [ ] What happens with empty collections?
- [ ] What happens if permission denied?
- [ ] What happens if database is not initialized?
- [ ] What happens on first launch (no data)?
- [ ] What happens if orchid is deleted but care tasks reference it?

### Logic Verification
- [ ] Walk through the code step by step
- [ ] Identify any incorrect comparisons
- [ ] Check for off-by-one errors in date/interval calculations
- [ ] Verify error handling paths
- [ ] Care task due date calculations are correct

### Security
- [ ] No hardcoded sensitive values?
- [ ] Input validation present on user-facing forms?
- [ ] Photo paths don't expose internal storage structure?

## Output Format

| Issue | Location | Severity | Fix |
|-------|----------|----------|-----|
| ... | ... | CRITICAL/HIGH/MEDIUM/LOW | ... |

**VERDICT:** APPROVED / REQUIRES CHANGES

If REQUIRES CHANGES, list specific fixes needed.
