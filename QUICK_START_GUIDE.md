# 🚀 調査クイックスタートガイド

## 📋 3分で調査開始

### 1. 事前準備 ✅
すでに準備完了：
- [x] 2つのリポジトリが統合済み
- [x] `investigation-results/` ディレクトリ作成済み
- [x] `investigation-helper.sh` スクリプト実行可能

### 2. 調査開始 🔍

#### 最も重要な調査から始める
```bash
# Phase 1の重要な調査を一気に実行
./investigation-helper.sh examples
./investigation-helper.sh template
```

#### 個別に調査する場合
```bash
# Examples分析のみ
./investigation-helper.sh examples

# Template分析のみ  
./investigation-helper.sh template

# CI/CD分析のみ
./investigation-helper.sh cicd

# TypeScript設定分析のみ
./investigation-helper.sh typescript
```

#### 全調査を一気に実行
```bash
# すべての調査を実行（時間がかかる）
./investigation-helper.sh all
```

### 3. 結果確認 📊

#### 調査結果の一覧
```bash
# 生成されたファイルの一覧
find investigation-results -name "*.txt" -type f

# サマリーレポートの生成
./investigation-helper.sh summary
```

#### 重要な差分の確認
```bash
# Template のpackage.json差分
cat investigation-results/phase1/template/package.json_diff.txt

# Examples の ExamplePanel.tsx差分
cat investigation-results/phase1/examples/extension-demo_diff.txt
```

---

## 🎯 推奨調査順序

### 1️⃣ **まず最初に実行**
```bash
./investigation-helper.sh template
```
**理由**: 新規プロジェクトの差分が最も重要

### 2️⃣ **次に実行**
```bash
./investigation-helper.sh examples
```
**理由**: 実際のAPI使用例の差分を確認

### 3️⃣ **時間があれば実行**
```bash
./investigation-helper.sh cicd
./investigation-helper.sh typescript
```

### 4️⃣ **最後にまとめ**
```bash
./investigation-helper.sh summary
```

---

## 📁 調査結果の見方

### ディレクトリ構造
```
investigation-results/
├── phase1/
│   ├── examples/
│   │   ├── extension-demo_diff.txt
│   │   ├── extension-demo_index_diff.txt
│   │   └── ...
│   └── template/
│       ├── package.json_diff.txt
│       ├── src_ExamplePanel.tsx_diff.txt
│       └── ...
├── phase2/
│   ├── cicd/
│   └── typescript/
└── INVESTIGATION_SUMMARY.md
```

### 差分ファイルの読み方
- `+` : lichtblick側で追加された行
- `-` : foxglove側で削除された行
- 空のファイル: 差分なし

---

## 🔧 トラブルシューティング

### よくある問題と解決法

#### 1. スクリプトが実行できない
```bash
chmod +x investigation-helper.sh
```

#### 2. 差分ファイルが空
→ 差分がない場合は正常（同じファイル）

#### 3. エラーが発生
```bash
# エラーログを確認
./investigation-helper.sh template 2>&1 | tee error.log
```

#### 4. 結果が見つからない
```bash
# 結果ディレクトリを確認
ls -la investigation-results/
```

---

## 📊 期待される調査時間

| 調査項目 | 実行時間 | 重要度 |
|---------|----------|--------|
| Template分析 | 30秒 | 🔥 最高 |
| Examples分析 | 2分 | 🔥 最高 |
| CI/CD分析 | 30秒 | 🔶 中 |
| TypeScript分析 | 30秒 | 🔶 中 |
| サマリー生成 | 10秒 | 🔷 低 |

**合計時間**: 約5分で主要な調査完了

---

## 🎉 調査完了後の次のステップ

### 1. 結果のレビュー
- [ ] `investigation-results/INVESTIGATION_SUMMARY.md` を確認
- [ ] 重要な差分ファイルを確認
- [ ] 互換性問題を特定

### 2. 報告書の更新
- [ ] `DIFF_ANALYSIS_REPORT.md` に新しい発見を追記
- [ ] 発見した問題を整理

### 3. 実践テスト（Phase 1.3）
- [ ] 実際に両方のツールでextensionを作成
- [ ] ビルド・パッケージングをテスト
- [ ] 動作確認

### 4. 移行ガイドの作成
- [ ] `MIGRATION_GUIDE.md` の作成
- [ ] 具体的な移行手順の文書化

---

**🎯 今すぐ開始**: `./investigation-helper.sh template`

**💡 ヒント**: 各調査は独立しているので、並列実行も可能！ 