#!/bin/bash
# 📋 Foxglove vs Lichtblick 調査ヘルパースクリプト

set -e  # エラーで停止

# 色付き出力
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ログ関数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Phase 1.1: Examples 分析
analyze_examples() {
    log_info "Phase 1.1: Examples ディレクトリの分析を開始"
    
    local examples=(
        "call-service-panel-example"
        "custom-image-extension"
        "extension-demo"
        "message-converter"
        "monaco-editor-example"
        "panel-settings"
        "topic-aliasing"
        "webworker"
    )
    
    mkdir -p investigation-results/phase1/examples
    
    for example in "${examples[@]}"; do
        log_info "分析中: $example"
        
        # 差分の確認
        if diff -r "create-foxglove-extension/examples/$example" "create-lichtblick-extension/examples/$example" > "investigation-results/phase1/examples/${example}_diff.txt" 2>&1; then
            log_success "$example: 差分なし"
        else
            log_warning "$example: 差分あり - investigation-results/phase1/examples/${example}_diff.txt を確認"
        fi
        
        # 重要ファイルの詳細確認
        if [[ -f "create-foxglove-extension/examples/$example/src/index.ts" ]]; then
            diff -u "create-foxglove-extension/examples/$example/src/index.ts" "create-lichtblick-extension/examples/$example/src/index.ts" > "investigation-results/phase1/examples/${example}_index_diff.txt" 2>&1 || true
        fi
        
        if [[ -f "create-foxglove-extension/examples/$example/package.json" ]]; then
            diff -u "create-foxglove-extension/examples/$example/package.json" "create-lichtblick-extension/examples/$example/package.json" > "investigation-results/phase1/examples/${example}_package_diff.txt" 2>&1 || true
        fi
    done
    
    log_success "Phase 1.1 完了 - 結果は investigation-results/phase1/examples/ に保存"
}

# Phase 1.2: Template 分析
analyze_template() {
    log_info "Phase 1.2: Template ディレクトリの分析を開始"
    
    mkdir -p investigation-results/phase1/template
    
    # 全体の差分
    diff -r create-foxglove-extension/template/ create-lichtblick-extension/template/ > investigation-results/phase1/template/template_diff.txt 2>&1 || true
    
    # 重要ファイルの個別分析
    local important_files=(
        "package.json"
        "src/index.ts"
        "src/ExamplePanel.tsx"
        "tsconfig.json"
    )
    
    for file in "${important_files[@]}"; do
        if [[ -f "create-foxglove-extension/template/$file" && -f "create-lichtblick-extension/template/$file" ]]; then
            diff -u "create-foxglove-extension/template/$file" "create-lichtblick-extension/template/$file" > "investigation-results/phase1/template/${file//\//_}_diff.txt" 2>&1 || true
            log_info "分析完了: $file"
        else
            log_warning "ファイルが見つかりません: $file"
        fi
    done
    
    log_success "Phase 1.2 完了 - 結果は investigation-results/phase1/template/ に保存"
}

# Phase 2.1: CI/CD 分析
analyze_cicd() {
    log_info "Phase 2.1: CI/CD パイプラインの分析を開始"
    
    mkdir -p investigation-results/phase2/cicd
    
    # GitHub Actions の比較
    diff -u create-foxglove-extension/.github/workflows/ci.yml create-lichtblick-extension/.github/workflows/ci.yml > investigation-results/phase2/cicd/ci_workflow_diff.txt 2>&1 || true
    
    diff -u create-foxglove-extension/.github/workflows/npm-publish.yml create-lichtblick-extension/.github/workflows/npm-publish.yml > investigation-results/phase2/cicd/npm_publish_diff.txt 2>&1 || true
    
    # dependabot設定の確認
    diff -u create-foxglove-extension/.github/dependabot.yml create-lichtblick-extension/.github/dependabot.yml > investigation-results/phase2/cicd/dependabot_diff.txt 2>&1 || true
    
    log_success "Phase 2.1 完了 - 結果は investigation-results/phase2/cicd/ に保存"
}

# Phase 2.2: TypeScript 設定分析
analyze_typescript() {
    log_info "Phase 2.2: TypeScript 設定の分析を開始"
    
    mkdir -p investigation-results/phase2/typescript
    
    # tsconfig の比較
    diff -u create-foxglove-extension/tsconfig.json create-lichtblick-extension/tsconfig.json > investigation-results/phase2/typescript/tsconfig_diff.txt 2>&1 || true
    
    diff -u create-foxglove-extension/tsconfig/tsconfig.json create-lichtblick-extension/tsconfig/tsconfig.json > investigation-results/phase2/typescript/tsconfig_base_diff.txt 2>&1 || true
    
    log_success "Phase 2.2 完了 - 結果は investigation-results/phase2/typescript/ に保存"
}

# サマリーレポート生成
generate_summary() {
    log_info "調査結果のサマリーを生成中"
    
    local summary_file="investigation-results/INVESTIGATION_SUMMARY.md"
    
    cat > "$summary_file" << 'EOF'
# 🔍 調査結果サマリー

## 📊 実行済み調査

### ✅ Phase 1: 高優先度調査
- [x] Examples ディレクトリ分析
- [x] Template ディレクトリ分析
- [ ] 実践的動作確認

### ⏳ Phase 2: 中優先度調査
- [x] CI/CD パイプライン比較
- [x] TypeScript 設定分析
- [ ] パフォーマンス比較

### ⏸️ Phase 3: 低優先度調査
- [ ] 外部依存関係の詳細分析
- [ ] セキュリティ監査
- [ ] コミュニティ調査

## 📁 結果ファイル

### Phase 1 結果
EOF
    
    # Phase 1 結果の一覧
    if [[ -d "investigation-results/phase1" ]]; then
        find investigation-results/phase1 -name "*.txt" -type f | sort >> "$summary_file"
    fi
    
    echo "" >> "$summary_file"
    echo "### Phase 2 結果" >> "$summary_file"
    
    # Phase 2 結果の一覧
    if [[ -d "investigation-results/phase2" ]]; then
        find investigation-results/phase2 -name "*.txt" -type f | sort >> "$summary_file"
    fi
    
    echo "" >> "$summary_file"
    echo "**生成日時:** $(date)" >> "$summary_file"
    
    log_success "サマリーレポートを生成: $summary_file"
}

# メイン実行部分
main() {
    case "${1:-all}" in
        "examples"|"1.1")
            analyze_examples
            ;;
        "template"|"1.2")
            analyze_template
            ;;
        "cicd"|"2.1")
            analyze_cicd
            ;;
        "typescript"|"2.2")
            analyze_typescript
            ;;
        "summary")
            generate_summary
            ;;
        "all")
            log_info "全調査を実行します"
            analyze_examples
            analyze_template
            analyze_cicd
            analyze_typescript
            generate_summary
            log_success "全調査完了！"
            ;;
        *)
            echo "使用方法: $0 [examples|template|cicd|typescript|summary|all]"
            exit 1
            ;;
    esac
}

# エラーハンドリング
trap 'log_error "スクリプトが中断されました"' ERR

# メイン実行
main "$@" 