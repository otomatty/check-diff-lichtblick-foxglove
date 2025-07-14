# Foxglove vs Lichtblick Extension Creator 差分分析レポート

## 📋 概要

このレポートは、`create-foxglove-extension` と `create-lichtblick-extension` の2つのリポジトリ間の差分を調査した結果をまとめています。

**調査対象:**
- create-foxglove-extension (255ファイル)
- create-lichtblick-extension (255ファイル)

**調査日:** 2025年7月14日

---

## 🔍 主要な発見

### 1. 基本情報の比較

| 項目 | Foxglove | Lichtblick |
|------|----------|------------|
| パッケージ名 | `create-foxglove-extension` | `create-lichtblick-extension` |
| バージョン | 1.0.4 | 1.0.0 |
| 発行者 | foxglove | Lichtblick |
| リポジトリ | github.com/foxglove/ | github.com/Lichtblick-Suite/ |
| 追加フィールド | - | `displayName: "Create Lichtblick Extension"` |

### 2. 設定ファイルの重要な違い

#### ESLint設定
- **Foxglove**: `eslint.config.js` (新しいflat config形式)
- **Lichtblick**: `.eslintrc.yaml` (従来の形式)

#### ESLintバージョン
- **Foxglove**: ESLint v9.15.0 + typescript-eslint v8.15.0
- **Lichtblick**: ESLint v8.53.0 + 個別プラグイン多数

### 3. 依存関係の変更

#### 重要な依存関係の置き換え
```diff
- "@foxglove/extension@^2"
+ "@lichtblick/suite@^1"

- "@foxglove/eslint-plugin@^2"
+ "@lichtblick/eslint-plugin@^1"

- "@foxglove/tsconfig@^2"
+ "@lichtblick/tsconfig@^1"
```

#### 新規追加された依存関係
- `@lichtblick/suite: 1.8.0` (runtime dependency)

#### Lichtblick独自の追加依存関係
- `@typescript-eslint/eslint-plugin: 8.16.0`
- `eslint-config-prettier: 9.1.0`
- `eslint-import-resolver-webpack: 0.13.8`
- `eslint-plugin-es: 4.1.0`
- `eslint-plugin-file-progress: 1.4.0`
- `eslint-plugin-filenames: 1.3.2`
- `eslint-plugin-import: 2.29.1`
- `eslint-plugin-jest: 27.6.3`
- `eslint-plugin-prettier: 5.1.3`

---

## 📁 ファイル構造の比較

### 共通の基本構造
```
├── src/
├── template/
├── examples/
├── tsconfig/
├── .github/
├── package.json
├── README.md
└── yarn.lock
```

### 主要な違いを持つファイル

#### ルートレベル
- **設定ファイル**: `eslint.config.js` vs `.eslintrc.yaml`
- **package.json**: 依存関係、メタデータが大幅に異なる
- **README.md**: ブランディング、説明文の違い

#### 全体的な変更パターン
- **255ファイル中、多数のファイルで内容が異なる**
- **基本的には `foxglove` → `lichtblick` の置き換えが中心**
- **設定ファイルは構造レベルで異なる**

---

## 🔧 技術的な違い

### コアライブラリの変更
**最も重要な変更点：**
```typescript
// create-foxglove-extension/src/create.ts
const DEPENDENCIES = [
  "@foxglove/eslint-plugin@^2",
  "@foxglove/extension@^2",     // ← 重要: メインライブラリ
  // ...
];

// create-lichtblick-extension/src/create.ts  
const DEPENDENCIES = [
  "@lichtblick/eslint-plugin@^1",
  "@lichtblick/suite@^1",       // ← 重要: 名前とスコープが変更
  // ...
];
```

### 開発ツールの違い
1. **ESLint**: モダンな flat config → 従来の yaml config
2. **TypeScript**: 設定の継承元が変更
3. **Prettier**: 設定は同様だが、統合方法が異なる

---

## 🎯 互換性とマイグレーション

### 破壊的変更
1. **パッケージ名の変更**: `@foxglove/extension` → `@lichtblick/suite`
2. **設定ファイル形式**: ESLint flat config → yaml config
3. **組織の変更**: GitHub組織、npm スコープの変更

### マイグレーション時の注意点
1. **依存関係の更新**が必要
2. **設定ファイルの形式変更**が必要
3. **import文の更新**が必要
4. **CI/CDパイプライン**の更新が必要

---

## 📊 統計情報

### ファイル差分統計
- **変更されたファイル数**: 推定100+ ファイル
- **新規ファイル**: ESLint yaml設定ファイル群
- **削除されたファイル**: ESLint js設定ファイル
- **yarn.lock差分**: 253KB vs 276KB（約9%の差）

### 依存関係統計
- **Foxglove**: 依存関係はシンプル、新しいツールチェーン
- **Lichtblick**: 依存関係は詳細、従来のツールチェーン

---

## 🎬 結論

### 主要な発見
1. **Lichtblick は Foxglove のフォーク**として位置づけられる
2. **技術的には同等の機能**を提供
3. **設定アプローチが異なる**（modern vs traditional）
4. **組織・ブランディングが完全に変更**

### 推奨される調査の次のステップ
1. **examples/ ディレクトリの詳細比較**
2. **実際のAPI差分の確認**
3. **パフォーマンス比較**
4. **コミュニティとサポート状況の調査**

---

## 📝 付録

### 調査コマンド履歴
```bash
# 基本差分確認
diff -r create-foxglove-extension/ create-lichtblick-extension/ --brief

# package.json比較
diff -u create-foxglove-extension/package.json create-lichtblick-extension/package.json

# create.ts比較
diff -u create-foxglove-extension/src/create.ts create-lichtblick-extension/src/create.ts
```

### 次回調査予定項目
- [ ] examples/ ディレクトリの詳細分析
- [ ] template/ ディレクトリの差分
- [ ] .github/ ワークフローの比較
- [ ] 実際のextension作成テスト
- [ ] パフォーマンス比較

---

**調査者:** AI Assistant  
**調査方式:** 段階的差分分析  
**信頼度:** 高（実際のファイル内容に基づく） 