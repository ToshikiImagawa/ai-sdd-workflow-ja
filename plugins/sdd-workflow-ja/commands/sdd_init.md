---
description: "現在のプロジェクトにAI-SDDワークフローを初期化する。CLAUDE.mdの設定とドキュメントテンプレートの生成を行う。"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, AskUserQuestion
---

# SDD Init - AI-SDDワークフロー初期化

現在のプロジェクトにAI-SDD（AI駆動仕様駆動開発）ワークフローを初期化します。

## このコマンドの機能

1. **CLAUDE.md設定**: プロジェクトの `CLAUDE.md` にAI-SDD指示を追加
2. **テンプレート生成**: `.sdd/` ディレクトリにドキュメントテンプレートを作成（存在しない場合）

## 前提条件

**実行前に必ず `sdd-workflow-ja:sdd-workflow` エージェントの内容を読み込み、AI-SDDの原則を理解してください。**

このコマンドはsdd-workflowエージェントの原則に従ってプロジェクトを初期化します。

### 設定ファイル（オプション）

プロジェクトルートに `.sdd-config.json` を作成することで、ディレクトリ名をカスタマイズできます。

設定ファイルの詳細は `sdd-workflow-ja:sdd-workflow` エージェントの「プロジェクト設定ファイル」セクションを参照してください。

**注意**: 初期化時にカスタムディレクトリ名を使用する場合は、先に `.sdd-config.json` を作成してください。初期化後にディレクトリ構造とCLAUDE.mdの記載が設定値に基づいて生成されます。

### 使用するスキル

このコマンドは以下のスキルを使用します：

| スキル                             | 用途                                     |
|:--------------------------------|:---------------------------------------|
| `sdd-workflow-ja:sdd-templates` | プロジェクトのコンテキストに基づいてPRD、仕様書、設計書テンプレートを生成 |

## 実行フロー

```
1. 現在のプロジェクト状態を確認
   ├─ CLAUDE.md が存在するか？
   └─ .sdd/ ディレクトリが存在するか？
   ↓
2. CLAUDE.md を設定
   ├─ CLAUDE.md が存在する場合: AI-SDD Instructionsセクションを追加
   └─ 存在しない場合: AI-SDD Instructionsを含む新規CLAUDE.mdを作成
   ↓
3. .sdd/ ディレクトリ構造を作成
   ├─ .sdd/requirement/
   ├─ .sdd/specification/
   └─ .sdd/task/
   ↓
4. 既存テンプレートを確認
   ├─ .sdd/PRD_TEMPLATE.md
   ├─ .sdd/SPECIFICATION_TEMPLATE.md
   └─ .sdd/DESIGN_DOC_TEMPLATE.md
   ↓
5. 不足しているテンプレートを生成
   └─ sdd-workflow-ja:sdd-templates スキルを使用して生成
   ↓
6. 変更をコミット
```

## CLAUDE.md設定

### AI-SDD Instructionsセクション

`CLAUDE.md` に以下のセクションを追加します：

```markdown
## AI-SDD Instructions

このプロジェクトはAI-SDD（AI駆動仕様駆動開発）ワークフローに従います。

### ドキュメント操作

`.sdd/` ディレクトリ配下のファイルを操作する際は、必ず `sdd-workflow-ja:sdd-workflow`
エージェントを使用して、適切なAI-SDDワークフローへの準拠を確保してください。

**トリガー条件**:

- `.sdd/` 配下のファイルの読み込みまたは変更
- 新しい仕様書、設計書、要求仕様書の作成
- `.sdd/` のドキュメントを参照する機能の実装

### ディレクトリ構造

フラット構造と階層構造の両方をサポートします。

**フラット構造（小〜中規模プロジェクト向け）**:

    .sdd/
    ├── PRD_TEMPLATE.md               # このプロジェクト用のPRDテンプレート
    ├── SPECIFICATION_TEMPLATE.md     # 抽象仕様書テンプレート
    ├── DESIGN_DOC_TEMPLATE.md        # 技術設計書テンプレート
    ├── requirement/          # PRD（要求仕様書）
    │   └── {機能名}.md
    ├── specification/                # 仕様書と設計書
    │   ├── {機能名}_spec.md          # 抽象仕様書
    │   └── {機能名}_design.md        # 技術設計書
    └── task/                         # 一時的なタスクログ
        └── {チケット番号}/

**階層構造（中〜大規模プロジェクト向け）**:

    .sdd/
    ├── PRD_TEMPLATE.md               # このプロジェクト用のPRDテンプレート
    ├── SPECIFICATION_TEMPLATE.md     # 抽象仕様書テンプレート
    ├── DESIGN_DOC_TEMPLATE.md        # 技術設計書テンプレート
    ├── requirement/          # PRD（要求仕様書）
    │   ├── {機能名}.md               # トップレベル機能
    │   └── {親機能名}/               # 親機能ディレクトリ
    │       ├── index.md              # 親機能の概要・要求一覧
    │       └── {子機能名}.md         # 子機能の要求仕様
    ├── specification/                # 仕様書と設計書
    │   ├── {機能名}_spec.md          # トップレベル機能
    │   ├── {機能名}_design.md
    │   └── {親機能名}/               # 親機能ディレクトリ
    │       ├── index_spec.md         # 親機能の抽象仕様書
    │       ├── index_design.md       # 親機能の技術設計書
    │       ├── {子機能名}_spec.md    # 子機能の抽象仕様書
    │       └── {子機能名}_design.md  # 子機能の技術設計書
    └── task/                         # 一時的なタスクログ
        └── {チケット番号}/

### コミットメッセージ規約

| プレフィックス | 用途 |
|:---|:---|
| `[docs]` | ドキュメントの追加・更新 |
| `[spec]` | 仕様書の追加・更新（`*_spec.md`） |
| `[design]` | 設計書の追加・更新（`*_design.md`） |
```

### 配置ルール

1. **CLAUDE.md に既に "AI-SDD" セクションがある場合**: スキップ（初期化済み）
2. **CLAUDE.md が存在するが AI-SDD セクションがない場合**: セクションを末尾に追加
3. **CLAUDE.md が存在しない場合**: セクションを含む新規ファイルを作成

## テンプレート生成

### 生成するテンプレートファイル

| テンプレート        | パス                               | 用途            |
|:--------------|:---------------------------------|:--------------|
| **PRDテンプレート** | `.sdd/PRD_TEMPLATE.md`           | SysML形式の要求仕様書 |
| **仕様書テンプレート** | `.sdd/SPECIFICATION_TEMPLATE.md` | 抽象的なシステム仕様    |
| **設計書テンプレート** | `.sdd/DESIGN_DOC_TEMPLATE.md`    | 技術設計書         |

### 生成プロセス

1. **既存テンプレートを確認**: テンプレートが既に存在する場合はスキップ
2. **プロジェクトコンテキストを分析**:
    - 使用されているプログラミング言語を検出
    - プロジェクト構造と規約を特定
    - 既存のドキュメントパターンを確認
3. **カスタマイズされたテンプレートを生成**:
    - `sdd-workflow-ja:sdd-templates` スキルを使用
    - プロジェクトの言語に合わせて型構文をカスタマイズ（TypeScript、Python、Goなど）
    - プロジェクトのドメインに合わせて例を調整

### テンプレートカスタマイズポイント

テンプレート生成時、プロジェクト分析に基づいてカスタマイズ：

| 項目           | カスタマイズ内容                                          |
|:-------------|:--------------------------------------------------|
| **型構文**      | プロジェクトの主要言語に合わせる（例：TypeScriptインターフェース、Python型ヒント） |
| **ディレクトリパス** | 例にプロジェクトの実際の構造を反映                                 |
| **ドメイン例**    | プロジェクトタイプに基づいた関連例を使用（Webアプリ、CLI、ライブラリなど）          |

## 初期化後の検証

初期化後、以下を検証：

1. **CLAUDE.md**: AI-SDD Instructionsセクションが含まれている
2. **ディレクトリ構造**:
    - `.sdd/requirement/` が存在する
    - `.sdd/specification/` が存在する
    - `.sdd/task/` が存在する
3. **テンプレート**: 3つのテンプレートファイルすべてが `.sdd/` に存在する

## 出力

初期化成功時、以下を表示：

```markdown
## AI-SDD初期化完了

### CLAUDE.md

- [x] AI-SDD Instructionsセクションを追加

### ディレクトリ構造

- [x] .sdd/requirement/ を作成
- [x] .sdd/specification/ を作成
- [x] .sdd/task/ を作成

### 生成されたテンプレート

- [x] .sdd/PRD_TEMPLATE.md
- [x] .sdd/SPECIFICATION_TEMPLATE.md
- [x] .sdd/DESIGN_DOC_TEMPLATE.md

### 次のステップ

1. 生成されたテンプレートを確認し、必要に応じてカスタマイズ
2. `/generate_prd` を使用して最初のPRDを作成
3. `/generate_spec` を使用してPRDから仕様書を作成
4. `sdd-workflow` エージェントを開発ガイダンスに使用
```

## コミット

初期化成功後：

```
[docs] AI-SDDワークフローを初期化

- CLAUDE.mdにAI-SDD Instructionsを追加
- .sdd/ディレクトリ構造を作成
- ドキュメントテンプレートを生成
```
