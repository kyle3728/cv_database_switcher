# Context Engineering for LLM Agents: The Definitive Guide

**Transform your AI interactions from 30% to 85% first-pass success rate**

This guide provides **practical techniques** for writing better prompts and PRPs (Product Requirements Prompts) that consistently deliver superior results from LLM coding agents.

## Table of Contents

1. [Core Principles](#core-principles)
2. [The 5-Layer Context Framework](#the-5-layer-context-framework)
3. [Context Structures & Patterns](#context-structures--patterns)
4. [PRP Templates](#prp-templates)
5. [Real-World Examples](#real-world-examples)
6. [Troubleshooting & Optimization](#troubleshooting--optimization)
7. [Daily Workflows & Team Collaboration](#daily-workflows--team-collaboration)

---

## Core Principles

### The Fundamental Truth

> *"The context window is your primary interface with the LLM—own it."*

Context engineering transforms AI interactions from hoping for good results to **designing for guaranteed success**.

### Three Core Principles

#### 1. **Active Context Design**
Don't accept default formats. Design custom structures optimized for your specific task:
- **Bug Fix**: Error-first, pattern-reference structure
- **Feature**: Requirements-driven, integration-focused structure
- **Optimization**: Metrics-based, constraint-aware structure

#### 2. **Information Density Optimization**
Every token counts. Apply the 80/20 rule - 80% of success comes from 20% of context:
```
Tech: React 18.2 + TS 5.0.4 (strict) + RTK + styled-components
Pattern: Follow UserList.tsx:45-89 for data fetching
Constraint: Bundle <500KB, WCAG 2.1, 2s load time
```

#### 3. **Dynamic Context Management**
Context adapts to task type:
```javascript
const contextRules = {
  'debug': { include: ['error_details', 'recent_changes'], maxTokens: 800 },
  'feature': { include: ['requirements', 'patterns'], maxTokens: 1200 },
  'review': { include: ['standards', 'checklist'], maxTokens: 600 }
}
```

### The Token Economy

**What goes in your context window**:
- **Instructions** (15%): Clear task definition
- **Technical Context** (40%): Code, patterns, configurations
- **State/History** (20%): Previous actions, current situation
- **Constraints** (15%): Requirements, limitations
- **Output Format** (10%): Expected structure

---

## Context Structures & Patterns

### Essential Context Structures

Choose the structure that best fits your task:

#### **1. Layered Structure** (Most Versatile)
```markdown
## L1: IMMEDIATE CONTEXT
Task: Fix login form validation
Error: "Cannot read property 'email' of undefined"
File: src/components/LoginForm.tsx:42

## L2: PROJECT CONTEXT  
Framework: React 18.2 + TypeScript 5.0
Validation: react-hook-form + Yup schemas
Pattern: See UserRegistration.tsx for reference

## L3: SOLUTION CONSTRAINTS
Must: Maintain existing UX, pass TypeScript strict mode
Avoid: Adding new dependencies, breaking existing tests
Test: Verify with npm run validate-all
```

#### **2. Timeline Structure** (For Complex Flows)
```markdown
## Session Timeline
[PAST] Previous implementation used local state
[CHANGED] Migrated to SWR for server state
[CURRENT] Data not updating after mutations
[NEXT] Need to implement cache invalidation
```

#### **3. Decision Tree Structure** (For Conditional Logic)
```markdown
IF bug fix → Include: Error details, reproduction steps
IF feature → Include: Requirements, integration points
IF optimization → Include: Performance metrics, constraints

CURRENT: Bug fix
INCLUDE: Stack trace, recent changes, expected behavior
```

### Information Density Techniques

**1. Structured Abbreviations**
```
// 75 tokens → 15 tokens
Tech: React 18.2 + TS 5.0.4 (strict) + RTK + styled-components
```

**2. Reference Compression**
```
// 50+ lines → 2 lines
Pattern: Follow UserList.tsx:45-89 (SWR + error handling)
```

**3. Hierarchical Context**
```
src/
├─ components/UserCard/  # Target location
├─ hooks/useAuth.ts      # Auth pattern
└─ types/User.ts         # Type definitions
```

**4. Flow Notation**
```
Auth: JWT httpOnly cookies (24h + refresh)
Flow: login → validate → token → cookie → /dashboard
```

### Progressive Context Loading

Load context in phases based on task complexity:

```markdown
Phase 1: Core Context (Always Include)
- Task definition
- Key constraints
- Success criteria

Phase 2: Pattern Context (If Needed)
- Reference implementations
- Integration points
- Existing patterns

Phase 3: Detailed Context (Complex Tasks)
- Edge cases
- Background information
- Alternative approaches
```

---

## The 5-Layer Context Framework

Transform any request into production-ready code with these five layers:

### Layer 1: Task Definition
Be specific about what you want:
```
❌ "Add authentication"
✅ "Add JWT authentication with login/logout, protected routes, and auto-refresh"
```

### Layer 2: Technical Context
Include exact versions and setup:
```
❌ "React app"
✅ "React 18.2 + TypeScript 5.0 + Redux Toolkit + Express backend"
```

### Layer 3: Existing Patterns
Reference your codebase patterns:
```
❌ "Follow our style"
✅ "Pattern: See UserList.tsx for data fetching, use SWR hooks, async/await"
```

### Layer 4: Constraints
Define boundaries and requirements:
```
❌ "Make it work"
✅ "Must: Use existing auth system, <500KB bundle, WCAG 2.1 compliant"
```

### Layer 5: Validation
Specify success criteria:
```
❌ "Should work properly"
✅ "Pass: npm test, npm run type-check | Load <2s | Mobile responsive"
```

### Example: Complete 5-Layer Prompt

```
"Add JWT authentication to my React 18 + TypeScript app:

L1 TASK: Login/logout, protected routes, token refresh
L2 TECH: Redux Toolkit state, Express backend, TypeScript strict
L3 PATTERN: Follow UserProfile.tsx structure, use SWR for data
L4 CONSTRAINTS: Reuse existing User type, max 100KB bundle increase
L5 VALIDATION: All tests pass, <200ms auth check, works offline"
```

---

## PRP Templates

Product Requirements Prompts (PRPs) are comprehensive context documents that ensure first-pass success. **A PRP is an executable prompt** - it must contain everything needed for an LLM to complete the task without asking questions during execution.

**Golden Rule**: If you find yourself writing "you should", "you need to", or "your-domain.com" - STOP. You're writing instructions for a human, not an executable prompt.

Use the **SPACE** framework:

- **S**ituation: Current state and context
- **P**roblem: What needs to be solved
- **A**pproach: How to solve it (concrete steps, not suggestions)
- **C**onstraints: Limitations and requirements (hard rules, not preferences)
- **E**xpected outcome: Success criteria (measurable, not subjective)

### PRP Template for Feature Implementation

```markdown
# PRP: [Feature Name]

## Situation (Current State)
**Project**: [Brief description]
**Framework**: [Exact versions - React 18.2.0, Next.js 14.1.0]
**Current Features**: [What exists now]
**File Structure**: 
```
src/
├── components/
│   ├── [Relevant existing components]
├── hooks/
│   ├── [Current custom hooks]
└── types/
    └── [Current TypeScript interfaces]
```

**Existing Patterns**: 
- Authentication: [How it's currently handled]
- State Management: [Redux/Zustand/Context pattern]
- API Layer: [How API calls are structured]
- Styling: [CSS/Tailwind/Styled-components approach]

## Problem (What Needs Solving)
**User Story**: "As a [user type], I want [capability] so that [benefit]"
**Current Pain Points**: 
- [Specific issues]
- [Performance problems]
- [User experience gaps]

## Approach (Implementation Strategy)
**Implementation Steps**:
1. [First concrete step with exact commands/code]
2. [Second step with specific files and line numbers]
3. [Third step with integration points and validation]

**❌ BAD (Written for a human)**:
```
1. Set up authentication (you'll need to configure OAuth)
2. Add the feature if time permits
3. Test it properly with your domain
4. Consider adding caching for performance
```

**✅ GOOD (Written for execution)**:
```
1. Execute setup script: `./auth-setup.sh`
2. Add OAuth middleware to server.js:123 after `app.use(cors())`
3. Run integration tests: `npm run test:auth`
4. Deploy to staging: `./scripts/deploy-staging.sh`
```

**How to transform BAD to GOOD**:
- "you'll need to configure" → Create setup script
- "if time permits" → Move to Deferred section
- "your domain" → Use `${API_DOMAIN}` 
- "Consider adding" → Make decision: include or defer

**Component Architecture**:
```
NewFeature/
├── NewFeatureContainer.tsx    # Main logic
├── NewFeatureView.tsx         # Presentation
├── hooks/
│   └── useNewFeature.ts       # Custom hook
├── types/
│   └── newFeature.types.ts    # TypeScript
└── __tests__/
    └── NewFeature.test.tsx    # Tests
```

**Data Flow**: [How data moves through the system]
**Integration Points**: [What existing code this touches]

## Constraints (Limitations & Requirements)
**Technical Constraints**:
- Must work with existing auth system
- Bundle size increase < 100KB
- Performance: Page load < 2s

**Business Constraints**:
- Launch deadline: [Date]
- User permissions: [Who can access]
- Compliance: [GDPR/WCAG requirements]

**Code Quality**:
- Test coverage > 80%
- TypeScript strict mode
- ESLint/Prettier compliance

## Expected Outcome (Success Criteria)
**Functional Requirements**:
- [ ] Feature works as described in user story
- [ ] All edge cases handled gracefully
- [ ] Error states provide clear user feedback

**Technical Requirements**:
- [ ] All tests pass: `npm test`
- [ ] Type check passes: `npm run type-check`
- [ ] Linting passes: `npm run lint`
- [ ] Build succeeds: `npm run build`

**Performance Requirements**:
- [ ] Lighthouse score > 90
- [ ] Page load time < 2s
- [ ] No console errors or warnings

**Integration Requirements**:
- [ ] Works with existing user permissions
- [ ] Maintains current accessibility standards
- [ ] Mobile responsive (tested on iPhone/Android)
```

### PRP Template for Bug Fixes

```markdown
# PRP: Bug Fix - [Issue Description]

## Situation (Current Problem)
**Bug Report**: [Link to issue or description]
**Affected Users**: [Who experiences this]
**Frequency**: [How often it occurs]
**Environment**: [Browser/device where it happens]

**Current Behavior**: 
1. User does [action]
2. System shows [incorrect result]
3. Expected: [what should happen]

**Error Details**:
```
[Console errors, stack traces, error messages]
```

**Affected Files**: 
- [List of files involved]
- [Dependencies that might be related]

## Problem (Root Cause Analysis)
**Hypothesis**: [What you think is causing it]
**Investigation Steps**: 
1. [How to reproduce the bug]
2. [What to check in the code]
3. [What to verify in the data]

**Related Code**:
```typescript
// Current problematic code
[Code snippet that's causing issues]
```

## Approach (Fix Strategy)
**Solution**: [Specific fix approach]
**Files to Modify**: 
- [Exact file paths]
- [What changes to make]

**Testing Strategy**:
1. [How to verify the fix works]
2. [How to ensure no regression]
3. [What edge cases to test]

## Constraints
**Risk Level**: [High/Medium/Low]
**Deployment**: [Can this be hotfixed or needs full release?]
**Backwards Compatibility**: [Will this break existing functionality?]

## Expected Outcome
**Success Criteria**:
- [ ] Bug no longer reproduces
- [ ] All existing functionality still works
- [ ] Performance impact is negligible
- [ ] Code review approved
```

### PRP Best Practices

**The 80/20 Rule**: 80% of success comes from 20% of context

**Always Include**:
- Exact framework versions
- Specific file paths
- Pattern references with line numbers
- Clear success criteria
- Critical constraints
- Concrete implementation steps
- Environment setup scripts

**Never Include in PRPs**:
- Questions to the implementor ("should we...?", "you need to decide...")
- Placeholder values ("your-domain.com", "your-api-key")
- Conditional execution ("if time permits", "optionally")
- Ambiguous requirements ("should work", "properly configured")
- User-directed content ("you can", "you should")
- External decisions needed during execution

**Usually Skip**:
- General best practices
- Theoretical explanations
- Business history
- Alternative approaches

**Power Techniques**:
1. **Front-load critical info**: `CRITICAL: React 18 + RTK (not Redux)`
2. **Reference > Explanation**: `Pattern: See UserList.tsx:45-67`
3. **Compress context**: `Auth: JWT httpOnly (24h + refresh)`
4. **Use environment variables**: `API_KEY=${API_KEY}` not `API_KEY=your-key-here`
5. **Make decisions upfront**: Create separate decision doc for pre-execution

### Pre-PRP Checklist for Authors

**Before finalizing your PRP, check for these red flags**:

✅ **Replace ALL placeholders** with environment variables:
- ❌ `domain: "your-domain.com"`
- ✅ `domain: "${API_DOMAIN}"`

✅ **Make ALL decisions** before writing:
- ❌ "Use PostgreSQL or MySQL for the database"
- ✅ "Use PostgreSQL 14 for the database"

✅ **Remove ALL conditional language**:
- ❌ "If time permits, add caching"
- ✅ Move to "Deferred Enhancements" section

✅ **Include configuration setup**:
```bash
# Start every PRP with environment setup
#!/bin/bash
export REQUIRED_VAR="${REQUIRED_VAR}"  # Document what's needed
```

✅ **Test your PRP mentally**: Could an LLM execute this without stopping to ask questions? If no, revise it.

**PRP Author's Mantra**: "I am writing a script for a robot, not instructions for a colleague."

### Handling Configuration & Decisions

**Pattern for Configuration**:
```bash
# Start PRP with environment setup script
#!/bin/bash
# setup-env.sh - Required configuration
export API_DOMAIN="${API_DOMAIN:-api.example.com}"  # Set before execution
export API_KEY="$(openssl rand -hex 32)"  # Generated
export DB_PASSWORD="${DB_PASSWORD}"  # Must be provided
```

**Pattern for Deferred Features**:
```markdown
## Approach
1. Core implementation (2 hours)
2. Testing and validation (1 hour)

## Deferred Enhancements (Post-MVP)
- Advanced feature X
- Optional optimization Y
```

**Decision Documentation Pattern**:

When you have decisions or user-specific content, create a SEPARATE document:

```markdown
# DECISIONS_NEEDED.md

## Pre-Execution Requirements

### Configuration Values
- API_DOMAIN: Your API domain (e.g., api.example.com)
- STRIPE_KEY: Production Stripe API key
- DB_PASSWORD: Database password

### Business Decisions
1. **Pricing Tiers**: 
   - Free: ? transactions/month
   - Pro: $?/month
   
2. **Feature Flags**:
   - Enable OAuth: yes/no
   - Enable webhooks: yes/no

### Manual Steps Required
1. Configure DNS for API_DOMAIN
2. Create OAuth app in Google Console
3. Set up Stripe products
```

This keeps your PRP clean and executable while documenting what needs to be decided BEFORE execution.


---

## Advanced Techniques

### The FOCUS Method

Systematically optimize your context:

**F**ilter - Remove irrelevant information  
**O**rganize - Structure information logically  
**C**ompress - Maximize information density  
**U**nify - Create coherent narrative flow  
**S**pecify - Define exact expectations

### Context Quality Validation

**The 5-Question Test**:
1. **Clarity**: Could a teammate understand this?
2. **Completeness**: Is everything needed included?
3. **Conciseness**: Can anything be removed?
4. **Correctness**: Is the information accurate?
5. **Actionability**: Does it lead to next steps?

**Quick Debugging**:
```
If response is:
☐ Too generic → Add specific examples
☐ Wrong pattern → Include explicit references
☐ Missing requirements → Front-load critical info
☐ Off-topic → Improve task clarity
☐ Incomplete → Add success criteria
```

### Multi-Turn Context Management

Build on previous context effectively:

```
Turn 1: "Analyze UserCard for performance issues"
Turn 2: "Fix the re-render issue you found (expensive calculations)"
Turn 3: "Validate the memoization approach works"
```

Each turn references the previous, maintaining context continuity.

---

## Quick Templates

### Task Templates

**Debug**: `Problem + Context + Expected vs Current + Code`  
**Feature**: `Requirements + Integration + Patterns + Constraints`  
**Review**: `Focus areas + Standards + Code + Questions`

### Reusable Context Blocks

Save these for your project:

```markdown
## Project Context
Tech: React 18.2 + TS 5.0 + RTK + MUI
Patterns: SWR data fetching, functional components
Structure: src/{components,hooks,types,utils}
Standards: 80% coverage, WCAG 2.1, TypeScript strict
```

---

## Real-World Examples

### Example 1: Debugging a React Hook

#### **❌ Before (Ineffective Prompt)**
```
"This hook isn't working, can you fix it?

[dumps 100 lines of code]
```

**Problems**:
- No description of what "isn't working" means
- Too much code without context
- No information about expected behavior
- Missing environment details

#### **✅ After (Effective Prompt)**
```
"Debug React hook - data not updating after user action:

**Problem**: useUserPreferences hook returns stale data after user saves preferences
**Expected**: Hook should return updated preferences immediately after save
**Current**: Takes 5-10 seconds to update, sometimes doesn't update at all
**Environment**: React 18.2 + SWR 2.1.0 for data fetching

**Hook code**:
```typescript
export const useUserPreferences = () => {
  const { data, mutate } = useSWR('/api/user/preferences', fetcher)
  
  const updatePreferences = async (newPrefs) => {
    await fetch('/api/user/preferences', {
      method: 'PUT',
      body: JSON.stringify(newPrefs)
    })
    // This might be the issue - not calling mutate?
  }
  
  return { preferences: data, updatePreferences }
}
```

**Similar working pattern**: useUserProfile hook handles updates correctly
**Context**: Called from SettingsPage component when user clicks Save"
```

**Result**: AI immediately identifies the missing `mutate()` call and provides the exact fix with explanation.

### Example 2: Implementing a New Component

#### **❌ Before (Ineffective Prompt)**
```
"Create a user card component"
```

**Problems**:
- No specifications for what the component should do
- Missing design requirements
- No integration context
- Unclear success criteria

#### **✅ After (Effective Prompt)**
```
"Create UserCard component for our admin dashboard:

**Requirements**:
- Display: user avatar, name, email, role, last login
- Actions: Edit user, Delete user (with confirmation)
- States: Loading, error, and success states

**Design**: 
- Follow Material-UI pattern (see ExistingCard.tsx)
- Responsive: Card layout on desktop, list item on mobile
- Accessibility: Proper ARIA labels, keyboard navigation

**Integration**:
- Data: Receives User type from our API (see types/User.ts)
- Actions: Uses useUsers hook for CRUD operations
- Navigation: Edit button navigates to /users/:id/edit

**Technical**:
- TypeScript with strict mode
- Styled with emotion (our standard)
- Tests with React Testing Library
- Storybook story for design system

**File location**: src/components/UserCard/

**Success criteria**:
- [ ] Renders correctly with mock user data
- [ ] Edit/delete actions work as expected
- [ ] Passes accessibility audit
- [ ] All tests pass
```

**Result**: AI creates a complete, production-ready component that integrates perfectly with the existing codebase.

### Example 3: API Integration

#### **❌ Before (Ineffective Prompt)**
```
"Help me call an API"
```

#### **✅ After (Effective Prompt)**
```
"Integrate new notifications API into our React app:

**API Details**:
- Endpoint: GET /api/v2/notifications
- Authentication: Bearer token (we have useAuth hook)
- Response: { notifications: NotificationItem[], unreadCount: number }
- Rate limit: 100 requests/minute

**Current Pattern** (follow this):
```typescript
// See useUserData.ts for our standard API hook pattern
const useApiHook = () => {
  const { token } = useAuth()
  const { data, error, isLoading } = useSWR(
    token ? ['/api/endpoint', token] : null,
    ([url, token]) => fetchWithAuth(url, token)
  )
  return { data, error, isLoading }
}
```

**Requirements**:
- Hook: useNotifications() following our pattern
- Error handling: Show error toast (useToast hook)
- Auto-refresh: Every 30 seconds when tab is active
- TypeScript: Create NotificationItem interface
- Integration: Add to HeaderNotifications component

**Testing**: Include tests for loading, success, and error states"
```

**Result**: AI creates the hook, types, integration, and tests all following existing patterns.

### Key Improvements in "After" Examples

1. **Specific problem description**
2. **Expected vs. current behavior**
3. **Relevant context only**
4. **Existing patterns to follow**
5. **Clear success criteria**
6. **Technical constraints**
7. **Integration points**

### Key Improvements in "After" Examples

1. **Specific problem description**
2. **Expected vs. current behavior**
3. **Relevant context only**
4. **Existing patterns to follow**
5. **Clear success criteria**
6. **Technical constraints**
7. **Integration points**

---

## Troubleshooting & Optimization

### Common Problems & Solutions

| Problem | Diagnosis | Solution |
|---------|-----------|----------|
| **Generic responses** | Missing framework versions or patterns | Add specific versions and pattern references |
| **Multiple iterations** | Unclear requirements or constraints | Front-load critical info, include examples |
| **Wrong patterns** | Vague pattern references | Include exact code examples with line numbers |
| **Too verbose** | Using standard templates | Create compressed, project-specific blocks |
| **Wrong assumptions** | AI filling in gaps | Explicitly state what you DON'T use |

### Quick Fixes

```markdown
# When response is too generic:
CRITICAL: React 18.2 + RTK (not Redux) + functional only
Pattern: Exact match UserList.tsx:45-89

# When AI ignores patterns:
"Follow this EXACT structure from UserList.tsx:
[paste actual code]
Apply same pattern to ProductList"

# When context too long:
Use layered approach:
L1: Task + constraints (always)
L2: Patterns + tech (if needed)
L3: Background (rarely)
```

### Measuring Success

Track your improvement:
- **Week 1**: 30% first-pass success → **Week 4**: 85% success
- **Before**: 4-5 iterations → **After**: 1-2 iterations
- **Before**: 45min integration → **After**: 10min integration

---

## Daily Workflows & Team Collaboration

### The CLAUDE.md File

Your project's context bible:

```markdown
# Project Context

## Quick Reference
Tech: React 18.2 + TS 5.0 + RTK + MUI
Patterns: SWR hooks, functional components
Commands: npm test, npm run type-check

## Current State
Feature: User dashboard
Branch: feature/dashboard-v2
Blockers: API rate limiting

## Established Patterns
- Forms: react-hook-form + Yup (see UserForm.tsx)
- Data: SWR with mutate (see useUsers.ts)
- Errors: Toast component (see ErrorBoundary.tsx)
```

### Daily Workflow

**Morning (2 min)**:
- Check git status and TODO.md
- Load CLAUDE.md context

**During dev**:
- Use 5-layer framework for prompts
- Update patterns as you discover them

**End of day (3 min)**:
- Document new patterns
- Update CLAUDE.md with learnings

### Team Handoffs

```markdown
## Handoff: Auth Feature
Status: JWT refresh implemented
Next: Add auto-refresh logic
Pattern: Follow AuthProvider.tsx
Start: src/auth/refreshToken.ts:45
```

---

*Transform your AI interactions from 30% to 85% first-pass success rate with proven context engineering techniques.*

*Last Updated: July 2025*