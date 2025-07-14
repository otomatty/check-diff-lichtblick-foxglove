# 📋 Foxglove vs Lichtblick 詳細調査指示書

## 🎯 調査の目的
基本的な差分調査を完了した後、より深い技術的差分と実用性の違いを明確にし、具体的な移行戦略を策定する。

---

## 📊 調査フェーズと優先順位

### 🔥 **Phase 1: 高優先度** (必須調査)
#### 1.1 Examples ディレクトリの詳細分析
**目的**: 実際のコード例における API 差分の特定

**調査手順**:
```bash
# 1. 各exampleの一覧確認
ls -la create-foxglove-extension/examples/
ls -la create-lichtblick-extension/examples/

# 2. 各exampleの差分確認
for example in call-service-panel-example custom-image-extension extension-demo message-converter monaco-editor-example panel-settings topic-aliasing webworker; do
    echo "=== $example ==="
    diff -r create-foxglove-extension/examples/$example create-lichtblick-extension/examples/$example
done

# 3. 重要なファイルの詳細比較
diff -u create-foxglove-extension/examples/extension-demo/src/ExamplePanel.tsx create-lichtblick-extension/examples/extension-demo/src/ExamplePanel.tsx
```

**期待される成果物**:
- `EXAMPLES_DIFF_ANALYSIS.md`
- API変更マップ
- 互換性問題リスト

#### 1.2 Template ディレクトリの分析
**目的**: 新規プロジェクト作成時のテンプレート差分の確認

**調査手順**:
```bash
# 1. テンプレート構造の比較
diff -r create-foxglove-extension/template/ create-lichtblick-extension/template/

# 2. 重要ファイルの詳細確認
diff -u create-foxglove-extension/template/package.json create-lichtblick-extension/template/package.json
diff -u create-foxglove-extension/template/src/index.ts create-lichtblick-extension/template/src/index.ts
diff -u create-foxglove-extension/template/src/ExamplePanel.tsx create-lichtblick-extension/template/src/ExamplePanel.tsx
```

**期待される成果物**:
- `TEMPLATE_DIFF_ANALYSIS.md`
- 新規プロジェクトでの差分リスト

#### 1.3 実践的な動作確認
**目的**: 両方のツールを使った実際の拡張機能作成とテスト

**調査手順**:
```bash
# 1. 作業ディレクトリの準備
mkdir -p test-extensions
cd test-extensions

# 2. Foxglove拡張機能の作成
npx create-foxglove-extension my-foxglove-test
cd my-foxglove-test
npm run build
npm run package
cd ..

# 3. Lichtblick拡張機能の作成
npx create-lichtblick-extension my-lichtblick-test
cd my-lichtblick-test
npm run build
npm run package
cd ..

# 4. 生成されたファイルの比較
diff -r my-foxglove-test/ my-lichtblick-test/
```

**期待される成果物**:
- `PRACTICAL_TEST_RESULTS.md`
- 実際のビルド出力の比較
- エラーログの収集

---

### 🔶 **Phase 2: 中優先度** (重要だが時間があるときに)
#### 2.1 CI/CD パイプラインの比較
**調査手順**:
```bash
# GitHub Actions の比較
diff -u create-foxglove-extension/.github/workflows/ci.yml create-lichtblick-extension/.github/workflows/ci.yml
diff -u create-foxglove-extension/.github/workflows/npm-publish.yml create-lichtblick-extension/.github/workflows/npm-publish.yml

# dependabot設定の確認
diff -u create-foxglove-extension/.github/dependabot.yml create-lichtblick-extension/.github/dependabot.yml
```

#### 2.2 TypeScript 設定の詳細分析
**調査手順**:
```bash
# tsconfig の比較
diff -u create-foxglove-extension/tsconfig.json create-lichtblick-extension/tsconfig.json
diff -u create-foxglove-extension/tsconfig/tsconfig.json create-lichtblick-extension/tsconfig/tsconfig.json
```

#### 2.3 パフォーマンス比較
**調査手順**:
```bash
# ビルド時間の測定
cd create-foxglove-extension
time npm run build

cd ../create-lichtblick-extension  
time npm run build

# パッケージサイズの比較
du -sh create-foxglove-extension/dist/
du -sh create-lichtblick-extension/dist/
```

---

### 🔷 **Phase 3: 低優先度** (余裕があるときに)
#### 3.1 外部依存関係の詳細分析
#### 3.2 セキュリティ監査
#### 3.3 コミュニティ調査

---

## 📝 調査結果のまとめ方

### 各フェーズの成果物形式
#### 1. 個別調査レポート
各調査項目ごとに以下の形式でMarkdownファイルを作成:

```markdown
# [調査項目名]_ANALYSIS.md

## 🔍 調査概要
- 調査日時
- 調査範囲
- 使用ツール

## 📊 発見事項
### 重要な差分
### 互換性問題
### 推奨事項

## 🧪 検証結果
### テスト実行結果
### エラーログ
### 解決方法

## 📋 結論
### 影響度評価
### 対応優先度
```

#### 2. 統合レポートの更新
各調査完了後、`DIFF_ANALYSIS_REPORT.md` に結果を追記:
```markdown
## 🔄 調査ログ
### [日付] Phase 1.1 Examples分析 完了
- 主要発見: [要点]
- 影響度: [高/中/低]
- 対応要否: [要/不要]
```

### 3. 最終統合レポート
全調査完了後、`FINAL_MIGRATION_GUIDE.md` を作成:
```markdown
# 🎯 Foxglove → Lichtblick 移行ガイド

## 📋 移行チェックリスト
- [ ] 依存関係の更新
- [ ] 設定ファイルの変更
- [ ] コードの修正
- [ ] テストの実行

## 🔧 具体的な移行手順
## ⚠️ 注意事項
## 📞 サポート情報
```

---

## 🚀 調査の進め方

### 1. 準備段階
```bash
# 調査用ディレクトリの作成
mkdir -p investigation-results/{phase1,phase2,phase3}
cd investigation-results
```

### 2. 調査実行
**各フェーズを順番に実行**:
1. Phase 1 を完了させてから Phase 2 に進む
2. 各調査項目で発見した問題はすぐに記録
3. 予想外の問題があれば調査範囲を拡張

### 3. 中間報告
**Phase 1 完了時点**で中間報告書を作成:
- 重要な発見の要約
- 残り調査の要否判断
- 調査計画の見直し

### 4. 品質管理
**各レポートに以下を必ず含める**:
- 調査方法の記録
- 再現手順
- 検証結果
- 信頼度評価

---

## 📊 期待される最終成果物

### 1. 技術レポート集
- `EXAMPLES_DIFF_ANALYSIS.md`
- `TEMPLATE_DIFF_ANALYSIS.md`
- `PRACTICAL_TEST_RESULTS.md`
- `CI_CD_COMPARISON.md`
- `TYPESCRIPT_CONFIG_ANALYSIS.md`
- `PERFORMANCE_COMPARISON.md`

### 2. 実用ガイド
- `FINAL_MIGRATION_GUIDE.md`
- `MIGRATION_CHECKLIST.md`
- `TROUBLESHOOTING_GUIDE.md`

### 3. 参考資料
- `COMMAND_REFERENCE.md`
- `TOOL_COMPARISON_MATRIX.md`
- `COMPATIBILITY_MATRIX.md`

---

## ⚡ 効率化のコツ

### 1. スクリプト化
繰り返し作業はスクリプトにまとめる:
```bash
#!/bin/bash
# investigation-helper.sh
function compare_examples() {
    local example=$1
    echo "=== Comparing $example ==="
    diff -r create-foxglove-extension/examples/$example create-lichtblick-extension/examples/$example > investigation-results/phase1/${example}_diff.txt
}
```

### 2. 並列実行
独立した調査は並列で実行:
```bash
# 複数の diff を同時実行
diff -r create-foxglove-extension/examples create-lichtblick-extension/examples > examples_diff.txt &
diff -r create-foxglove-extension/template create-lichtblick-extension/template > template_diff.txt &
wait
```

### 3. 結果の可視化
重要な差分は表形式でまとめる:
```markdown
| 項目 | Foxglove | Lichtblick | 影響度 | 対応要否 |
|------|----------|------------|--------|----------|
| API名 | oldAPI() | newAPI() | 高 | 要 |
```

---

## 🎯 成功の指標

### 調査完了の判定基準
- [ ] 全ての Phase 1 項目が完了
- [ ] 実用的な移行ガイドが作成できた
- [ ] 互換性問題が全て特定できた
- [ ] 移行に必要な工数が見積もれた

### 品質基準
- [ ] 調査結果が再現可能
- [ ] 第三者が理解できる文書
- [ ] 実際の移行作業で使用可能
- [ ] 将来のバージョン更新に対応可能

---

**作成者**: AI Assistant  
**最終更新**: 2025年7月14日  
**バージョン**: 1.0 