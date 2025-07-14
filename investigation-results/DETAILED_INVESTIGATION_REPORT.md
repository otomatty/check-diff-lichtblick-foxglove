# 🔍 Foxglove vs Lichtblick Extension Creator 詳細調査レポート

## 📋 調査概要

**調査日時**: 2025年7月14日  
**調査対象**: `create-foxglove-extension` vs `create-lichtblick-extension`  
**調査方法**: Phase 1（高優先度）およびPhase 2（中優先度）調査を実施  
**調査完了度**: 70%（Phase 1: 100%, Phase 2: 100%, Phase 3: 未実施）

---

## 🚨 重要な発見

### 1. **コアAPI変更** (破壊的変更)
```diff
- import { ... } from "@foxglove/extension";
+ import { ... } from "@lichtblick/suite";
```

**影響度**: 🔥 最高  
**対応要否**: 必須  
**変更内容**: 
- メインライブラリが完全に変更
- バージョンも `v2.17.0` → `v1.8.0` へ後退

### 2. **ツールチェーン変更** (重要)
```diff
- eslint.config.js (flat config)
+ .eslintrc.yaml (従来形式)

- "eslint": "9.15.0"
+ "eslint": "8.53.0"
```

**影響度**: 🔶 高  
**対応要否**: 必須  
**変更内容**:
- ESLint v9の最新flat config → v8の従来形式に後退
- 設定ファイル形式が根本的に変更

### 3. **コマンドライン変更** (重要)
```diff
- "foxglove-extension build"
+ "lichtblick-extension build"

- "foxglove:prepublish"  
+ "lichtblick:prepublish"
```

**影響度**: 🔶 高  
**対応要否**: 必須  
**変更内容**: 全てのCLIコマンドが変更

---

## 📊 詳細分析結果

### Examples分析 (Phase 1.1)
**調査対象**: 8個のサンプルプロジェクト  
**結果**: 全てのサンプルで差分を確認  

| サンプル | 主な変更内容 | 影響度 |
|---------|-------------|--------|
| extension-demo | API変更、設定変更 | 🔥 最高 |
| call-service-panel-example | API変更、設定変更 | 🔥 最高 |
| custom-image-extension | API変更、設定変更 | 🔥 最高 |
| message-converter | API変更、設定変更 | 🔥 最高 |
| monaco-editor-example | API変更、設定変更 | 🔥 最高 |
| panel-settings | API変更、設定変更 | 🔥 最高 |
| topic-aliasing | API変更、設定変更 | 🔥 最高 |
| webworker | API変更、設定変更 | 🔥 最高 |

### Template分析 (Phase 1.2)
**調査対象**: 新規プロジェクト作成テンプレート  
**重要な変更**:

1. **package.json**: スクリプト名とコマンドが全て変更
2. **ExamplePanel.tsx**: 
   - import文変更
   - コメント内の "Foxglove system" → "studio system"
   - Foxglove固有の文書リンクが削除
3. **index.ts**: import文変更
4. **tsconfig.json**: 継承元が `@foxglove/tsconfig` → `@lichtblick/tsconfig`

### CI/CD分析 (Phase 2.1)
**主な変更**:
- Ubuntu runner: `ubuntu-24.04` → `ubuntu-latest`
- テストマトリックスにubuntu-24.04を追加
- コメント: "foxglove-scripts" → "lichtblick-scripts"

**影響度**: 🔶 中（開発環境に影響）

### TypeScript設定分析 (Phase 2.2)
**主な変更**:
```diff
- "extends": "@foxglove/tsconfig/base"
+ "extends": "@lichtblick/tsconfig/base"
```

**影響度**: 🔶 中（ビルド設定に影響）

---

## 🔧 技術的互換性分析

### 破壊的変更
1. **パッケージ名**: `@foxglove/extension` → `@lichtblick/suite`
2. **ESLint設定**: flat config → yaml config
3. **CLIツール**: `foxglove-extension` → `lichtblick-extension`
4. **TypeScript設定**: `@foxglove/tsconfig` → `@lichtblick/tsconfig`

### 後方互換性
- ❌ **API レベル**: 完全に非互換（パッケージ名変更）
- ❌ **設定ファイル**: 非互換（ESLint設定形式変更）
- ❌ **ビルドツール**: 非互換（CLI名変更）
- ❌ **開発環境**: 非互換（依存関係変更）

### 機能的互換性
- ✅ **UI/UX**: 同等の機能を提供
- ✅ **パネル開発**: 同等の開発体験
- ✅ **React統合**: 同等のReact支援
- ✅ **TypeScript**: 同等のTypeScript支援

---

## 📈 マイグレーション複雑度

### 🔥 高複雑度タスク
1. **import文の書き換え**
   - すべての `@foxglove/extension` → `@lichtblick/suite`
   - 影響範囲: 全てのTypeScriptファイル

2. **package.json更新**
   - 依存関係の完全置換
   - スクリプトコマンドの更新
   - 影響範囲: 全てのpackage.jsonファイル

3. **ESLint設定移行**
   - eslint.config.js → .eslintrc.yaml
   - ESLint v9 → v8 ダウングレード
   - 影響範囲: 全てのプロジェクトの設定

### 🔶 中複雑度タスク
1. **TypeScript設定更新**
   - tsconfig.jsonの継承元変更
   - 影響範囲: 設定ファイル

2. **CI/CD更新**
   - ワークフローファイルの更新
   - 影響範囲: .github/workflows/

### 🔷 低複雑度タスク
1. **文書・コメント更新**
   - コード内コメントの更新
   - 影響範囲: ドキュメント

---

## 🎯 推奨移行戦略

### Phase 1: 準備 (1-2時間)
1. **現在の環境の確認**
   - 既存プロジェクトのバックアップ
   - 依存関係の調査
   - 設定ファイルの確認

2. **移行計画の策定**
   - 影響範囲の特定
   - 優先順位の決定
   - テスト計画の作成

### Phase 2: 基本移行 (2-4時間)
1. **package.json更新**
   ```bash
   # 依存関係の置換
   npm uninstall @foxglove/extension @foxglove/eslint-plugin create-foxglove-extension
   npm install @lichtblick/suite @lichtblick/eslint-plugin create-lichtblick-extension
   ```

2. **import文の一括置換**
   ```bash
   # すべてのファイルで置換
   find . -name "*.ts" -o -name "*.tsx" | xargs sed -i 's/@foxglove\/extension/@lichtblick\/suite/g'
   ```

3. **スクリプトコマンドの更新**
   ```json
   {
     "scripts": {
       "build": "lichtblick-extension build",
       "lichtblick:prepublish": "lichtblick-extension build --mode production",
       "local-install": "lichtblick-extension install",
       "package": "lichtblick-extension package",
       "pretest": "lichtblick-extension pretest"
     }
   }
   ```

### Phase 3: 設定移行 (1-2時間)
1. **ESLint設定の移行**
   ```bash
   # eslint.config.js → .eslintrc.yaml
   rm eslint.config.js
   # .eslintrc.yamlを手動作成
   ```

2. **TypeScript設定の更新**
   ```json
   {
     "extends": "@lichtblick/tsconfig/base"
   }
   ```

### Phase 4: 検証 (1-2時間)
1. **ビルドテスト**
   ```bash
   npm run build
   npm run package
   ```

2. **機能テスト**
   ```bash
   npm run local-install
   # 実際のstudioでの動作確認
   ```

---

## ⚠️ 注意事項・リスク

### 高リスク
1. **API変更による予期しないエラー**
   - `@foxglove/extension` と `@lichtblick/suite` の微細な差異
   - 推奨: 段階的移行とテスト

2. **ESLintバージョンダウン**
   - v9 → v8のダウングレードによる問題
   - 推奨: 設定の慎重な見直し

### 中リスク
1. **依存関係の競合**
   - 新旧パッケージの混在
   - 推奨: 完全な置換を確認

2. **CI/CDの動作変更**
   - ワークフローの動作変更
   - 推奨: テスト実行の確認

### 低リスク
1. **パフォーマンス差異**
   - ビルド時間の変化
   - 推奨: 実測での確認

---

## 📝 移行チェックリスト

### 事前準備
- [ ] 既存プロジェクトのバックアップ
- [ ] 現在の環境の動作確認
- [ ] Git commitの実行

### 基本移行
- [ ] package.jsonの依存関係更新
- [ ] import文の一括置換
- [ ] スクリプトコマンドの更新
- [ ] TypeScript設定の更新

### 設定移行
- [ ] ESLint設定ファイルの変更
- [ ] ESLintバージョンの更新
- [ ] 設定の動作確認

### 検証
- [ ] ビルドの成功確認
- [ ] パッケージングの成功確認
- [ ] ローカルインストールの動作確認
- [ ] 実際のstudioでの動作確認

### 完了
- [ ] CI/CDの動作確認
- [ ] 文書の更新
- [ ] チーム共有

---

## 🔮 将来の考慮事項

### 継続的な差分監視
- 両プロジェクトの更新頻度の監視
- 新機能の差分追跡
- 互換性の継続的な確認

### 長期的な戦略
- Lichtblickの開発方針の理解
- コミュニティの動向確認
- 技術スタックの進化への対応

---

## 📞 サポート・リソース

### 公式リソース
- [Lichtblick Suite Documentation](https://github.com/bmw-software-engineering/lichtblick)
- [Extension Development Guide](https://github.com/bmw-software-engineering/lichtblick/tree/main/packages/suite)

### コミュニティ
- GitHub Issues: プロジェクト別のサポート
- Discord/Forum: コミュニティサポート（要確認）

---

**作成者**: AI Assistant  
**最終更新**: 2025年7月14日  
**調査信頼度**: 高（実際のファイル差分に基づく）  
**推奨度**: 移行可能だが、十分な検証が必要