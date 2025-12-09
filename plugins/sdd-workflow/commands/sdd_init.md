---
description: "Initialize AI-SDD workflow in the current project. Sets up CLAUDE.md and generates document templates."
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, AskUserQuestion
---

# SDD Init - AI-SDD Workflow Initializer

Initializes the AI-SDD (AI-driven Specification-Driven Development) workflow in the current project.

## What This Command Does

1. **CLAUDE.md Configuration**: Adds AI-SDD instructions to the project's `CLAUDE.md` file
2. **Template Generation**: Creates document templates in `.sdd/` directory (if not exist)

## Prerequisites

**Before execution, you must read `sdd-workflow:sdd-workflow` agent content to understand AI-SDD principles.**

This command follows the sdd-workflow agent principles for project initialization.

### Configuration File (Optional)

You can customize directory names by creating `.sdd-config.json` at project root.

For configuration file details, refer to the "Project Configuration File" section in the `sdd-workflow:sdd-workflow` agent.

**Note**: If you want to use custom directory names during initialization, create `.sdd-config.json` first. The directory structure and CLAUDE.md content will be generated based on the configuration values.

### Skills Used

This command uses the following skills:

| Skill                        | Purpose                                                                        |
|:-----------------------------|:-------------------------------------------------------------------------------|
| `sdd-workflow:sdd-templates` | Generate PRD, Specification, and Design Doc templates based on project context |

## Execution Flow

```
1. Check current project state
   ├─ Does CLAUDE.md exist?
   └─ Does .sdd/ directory exist?
   ↓
2. Configure CLAUDE.md
   ├─ If CLAUDE.md exists: Add AI-SDD Instructions section
   └─ If not exists: Create new CLAUDE.md with AI-SDD Instructions
   ↓
3. Create .sdd/ directory structure
   ├─ .sdd/requirement/
   ├─ .sdd/specification/
   └─ .sdd/task/
   ↓
4. Check for existing templates
   ├─ .sdd/PRD_TEMPLATE.md
   ├─ .sdd/SPECIFICATION_TEMPLATE.md
   └─ .sdd/DESIGN_DOC_TEMPLATE.md
   ↓
5. Generate missing templates
   └─ Use sdd-workflow:sdd-templates skill to generate
   ↓
6. Commit changes
```

## CLAUDE.md Configuration

### AI-SDD Instructions Section

Add the following section to `CLAUDE.md`:

```markdown
## AI-SDD Instructions

This project follows the AI-SDD (AI-driven Specification-Driven Development) workflow.

### Document Operations

When working with files under `.sdd/` directory, you MUST use the `sdd-workflow:sdd-workflow` agent to ensure proper
AI-SDD workflow compliance.

**Trigger Conditions**:

- Reading or modifying any file under `.sdd/`
- Creating new specifications, designs, or requirements documents
- Implementing features that reference documents in `.sdd/`

### Directory Structure

Both flat and hierarchical structures are supported.

**Flat Structure (for small to medium projects)**:

    .sdd/
    ├── PRD_TEMPLATE.md               # PRD template for this project
    ├── SPECIFICATION_TEMPLATE.md     # Abstract specification template
    ├── DESIGN_DOC_TEMPLATE.md        # Technical design document template
    ├── requirement/          # PRD (Requirements Specification)
    │   └── {feature-name}.md
    ├── specification/                # Specifications and Design Documents
    │   ├── {feature-name}_spec.md    # Abstract specification
    │   └── {feature-name}_design.md  # Technical design document
    └── task/                         # Temporary task logs
        └── {ticket-number}/

**Hierarchical Structure (for medium to large projects)**:

    .sdd/
    ├── PRD_TEMPLATE.md               # PRD template for this project
    ├── SPECIFICATION_TEMPLATE.md     # Abstract specification template
    ├── DESIGN_DOC_TEMPLATE.md        # Technical design document template
    ├── requirement/          # PRD (Requirements Specification)
    │   ├── {feature-name}.md         # Top-level feature
    │   └── {parent-feature}/         # Parent feature directory
    │       ├── index.md              # Parent feature overview and requirements list
    │       └── {child-feature}.md    # Child feature requirements
    ├── specification/                # Specifications and Design Documents
    │   ├── {feature-name}_spec.md    # Top-level feature
    │   ├── {feature-name}_design.md
    │   └── {parent-feature}/         # Parent feature directory
    │       ├── index_spec.md         # Parent feature abstract specification
    │       ├── index_design.md       # Parent feature technical design document
    │       ├── {child-feature}_spec.md   # Child feature abstract specification
    │       └── {child-feature}_design.md # Child feature technical design document
    └── task/                         # Temporary task logs
        └── {ticket-number}/

### Commit Message Convention

| Prefix | Usage |
|:---|:---|
| `[docs]` | Add/update documentation |
| `[spec]` | Add/update specifications (`*_spec.md`) |
| `[design]` | Add/update design documents (`*_design.md`) |
```

### Placement Rules

1. **If CLAUDE.md already has an "AI-SDD" section**: Skip (already initialized)
2. **If CLAUDE.md exists without AI-SDD section**: Append the section at the end
3. **If CLAUDE.md does not exist**: Create new file with the section

## Template Generation

### Template Files to Generate

| Template                   | Path                             | Purpose                                    |
|:---------------------------|:---------------------------------|:-------------------------------------------|
| **PRD Template**           | `.sdd/PRD_TEMPLATE.md`           | Requirements specification in SysML format |
| **Specification Template** | `.sdd/SPECIFICATION_TEMPLATE.md` | Abstract system specification              |
| **Design Doc Template**    | `.sdd/DESIGN_DOC_TEMPLATE.md`    | Technical design document                  |

### Generation Process

1. **Check existing templates**: Skip if template already exists
2. **Analyze project context**:
    - Detect programming language(s) used
    - Identify project structure and conventions
    - Check for existing documentation patterns
3. **Generate customized templates**:
    - Use `sdd-workflow:sdd-templates` skill
    - Customize type syntax for project's language (TypeScript, Python, Go, etc.)
    - Adjust examples to match project domain

### Template Customization Points

When generating templates, customize based on project analysis:

| Aspect              | Customization                                                                     |
|:--------------------|:----------------------------------------------------------------------------------|
| **Type Syntax**     | Match project's primary language (e.g., TypeScript interfaces, Python type hints) |
| **Directory Paths** | Reflect project's actual structure in examples                                    |
| **Domain Examples** | Use relevant examples based on project type (web app, CLI, library, etc.)         |

## Post-Initialization Verification

After initialization, verify:

1. **CLAUDE.md**: Contains AI-SDD Instructions section
2. **Directory Structure**:
    - `.sdd/requirement/` exists
    - `.sdd/specification/` exists
    - `.sdd/task/` exists
3. **Templates**: All three template files exist in `.sdd/`

## Output

Upon successful initialization, display:

```markdown
## AI-SDD Initialization Complete

### CLAUDE.md

- [x] AI-SDD Instructions section added

### Directory Structure

- [x] .sdd/requirement/ created
- [x] .sdd/specification/ created
- [x] .sdd/task/ created

### Templates Generated

- [x] .sdd/PRD_TEMPLATE.md
- [x] .sdd/SPECIFICATION_TEMPLATE.md
- [x] .sdd/DESIGN_DOC_TEMPLATE.md

### Next Steps

1. Review generated templates and customize as needed
2. Use `/generate_prd` to create your first PRD
3. Use `/generate_spec` to create specifications from PRD
4. Use the `sdd-workflow` agent for development guidance
```

## Commit

After successful initialization:

```
[docs] Initialize AI-SDD workflow

- Add AI-SDD Instructions to CLAUDE.md
- Create .sdd/ directory structure
- Generate document templates
```
