---
description: Generate code for a specified layer using the dual-phase review process (generate -> senior engineer review -> finalize)
argument-hint: [layer-number] [feature-description]
---

# Layer Development Command

Generate code for the specified layer using the dual-phase process:

## Phase 1: Generate
1. Write the code for the requested feature
2. Document all assumptions
3. List potential failure modes

## Phase 2: Review
1. Switch to Senior Engineer persona
2. Review using /review checklist
3. Identify issues and fix them

## Phase 3: Finalize
1. Present the reviewed/fixed code
2. Provide human test protocol:
   - Exact setup steps
   - Test actions to perform
   - Expected results
   - Pass/fail criteria
   - Diagnostic steps if fails

## Output Structure

### LAYER N: [Name]

#### Generated Code
[code block]

#### Assumptions
1. ...

#### Review Results
| Issue | Severity | Fix Applied |
|-------|----------|-------------|

#### Final Code (after fixes)
[code block]

#### Human Test Protocol
**Device:** [manufacturer/model/Android version]
**Setup:**
1. ...

**Test Steps:**
1. [Action] -> [Expected Result]
2. ...

**Pass Criteria:**
- [ ] ...

**If Fails:**
- Check: ...
- Likely cause: ...
