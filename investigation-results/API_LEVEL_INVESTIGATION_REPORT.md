# 🚀 Foxglove vs Lichtblick API レベル詳細調査レポート

## 📋 調査概要

**調査日時**: 2025年7月14日  
**調査対象**: `@foxglove/extension` vs `@lichtblick/suite` APIレベル詳細差分  
**調査方法**: Phase 1（API差分）、Phase 2（ビルドツール差分）、Phase 3（拡張機能型定義差分）を実施  
**調査完了度**: 100%（Phase 1-3 全て完了）

---

## 🔥 重要な発見

### 1. **パッケージ実体の発見**
- **@foxglove/extension**: 833行の巨大なAPIファイル
- **@lichtblick/suite**: 946行の巨大なAPIファイル（約113行多い）
- **両方とも本格的な拡張機能API**を提供

### 2. **バージョン・ライセンス差分**
| パッケージ | バージョン | ライセンス | 管理者 |
|-----------|----------|----------|-------|
| @foxglove/extension | 2.17.0 | MIT | Foxglove Technologies |
| @lichtblick/suite | 1.17.1 | MPL-2.0 | BMW Group |

### 3. **CLIツールの機能差分**
- **publishコマンド**: Foxglove側のみ存在
- **ファイル長**: Foxglove 62行 vs Lichtblick 48行

---

## 📊 Phase 1: API差分の詳細分析

### 1.1 型定義ファイルの比較

#### **create-foxglove-extension/src/index.ts**
```typescript
// 参照: create-foxglove-extension/src/index.ts:1-4
export * from "./build";
export * from "./create";
export * from "./package";
```
**わずか4行** - 単なるビルドツールの再エクスポート

#### **original-lichtblick/packages/suite/src/index.ts**
```typescript
// 参照: original-lichtblick/packages/suite/src/index.ts:1-946
// 946行の巨大なAPIファイル
```

### 1.2 実際のAPI型定義の比較

#### **@foxglove/extension の実体**
```typescript
// 参照: create-foxglove-extension/examples/extension-demo/node_modules/@foxglove/extension/src/index.ts:1-833
// 833行の巨大なAPIファイル
```

#### **パッケージ依存関係差分**
```json
// 参照: create-foxglove-extension/package.json:1-74
{
  "name": "create-foxglove-extension",
  "version": "1.0.4",
  "license": "MIT"
}

// 参照: original-lichtblick/packages/suite/package.json:1-26
{
  "name": "@lichtblick/suite",
  "version": "1.17.1",
  "license": "MPL-2.0"
}
```

### 1.3 実際の使用例比較

#### **ExamplePanel.tsx の差分**
```typescript
// 参照: create-foxglove-extension/template/src/ExamplePanel.tsx:1
- import { Immutable, MessageEvent, PanelExtensionContext, Topic } from "@foxglove/extension";

// 参照: create-lichtblick-extension/template/src/ExamplePanel.tsx:1
+ import { Immutable, MessageEvent, PanelExtensionContext, Topic } from "@lichtblick/suite";
```

#### **package.json スクリプト差分**
```json
// 参照: create-foxglove-extension/template/package.json:12-20
"scripts": {
  "build": "foxglove-extension build",
  "foxglove:prepublish": "foxglove-extension build --mode production",
  "local-install": "foxglove-extension install",
  "package": "foxglove-extension package",
  "pretest": "foxglove-extension pretest"
}

// 参照: create-lichtblick-extension/template/package.json:12-20
"scripts": {
  "build": "lichtblick-extension build",
  "lichtblick:prepublish": "lichtblick-extension build --mode production",
  "local-install": "lichtblick-extension install",
  "package": "lichtblick-extension package",
  "pretest": "lichtblick-extension pretest"
}
```

---

## 📊 Phase 2: ビルドツール差分調査

### 2.1 CLIツール実装差分

#### **重要な発見: publishコマンドの存在差分**
```typescript
// 参照: create-foxglove-extension/src/bin/foxglove-extension.ts:38-53
program
  .command("publish")
  .description("Create an extensions.json entry for a released extension. This can be added to the https://github.com/foxglove/extension-registry repository")
  .option("--foxe <foxe>", "URL of the published .foxe file")
  .option("--cwd [cwd]", "Directory containing the extension package.json file")
  .option("--version [version]", "Version of the published .foxe file")
  .option("--readme [readme]", "URL of the extension README.md file")
  .option("--changelog [changelog]", "URL of the extension CHANGELOG.md file")
  .action((options: PublishOptions) => {
    main(publishCommand(options));
  });
```

**Lichtblick側には存在しない**
```typescript
// 参照: create-lichtblick-extension/src/bin/lichtblick-extension.ts:1-48
// publishコマンドが存在しない（48行で終了）
```

#### **ファイル長の差分**
- **create-foxglove-extension**: 62行（参照: create-foxglove-extension/src/bin/foxglove-extension.ts:1-62）
- **create-lichtblick-extension**: 48行（参照: create-lichtblick-extension/src/bin/lichtblick-extension.ts:1-48）

### 2.2 Webpack設定差分

#### **externals設定の差分**
```typescript
// 参照: create-foxglove-extension/src/webpackConfigExtension.ts:25-27
externals: {
  "@foxglove/extension": "@foxglove/extension",
},

// 参照: create-lichtblick-extension/src/webpackConfigExtension.ts:25-27
externals: {
  "@lichtblick/suite": "@lichtblick/suite",
},
```

#### **コメント内容の差分**
```typescript
// 参照: create-foxglove-extension/src/webpackConfigExtension.ts:21-23
// Because Foxglove _evals_ the extension script to run it

// 参照: create-lichtblick-extension/src/webpackConfigExtension.ts:21-23
// Because Lichtblick _evals_ the extension script to run it
```

### 2.3 build.ts の比較結果

#### **両方とも同一内容**
```typescript
// 参照: create-foxglove-extension/src/build.ts:1-78
// 参照: create-lichtblick-extension/src/build.ts:1-78
// 78行、内容は完全に同じ
```

---

## 📊 Phase 3: 拡張機能型定義の詳細調査

### 3.1 型定義の詳細差分

#### **ライセンスとヘッダー情報**
```typescript
// 参照: original-lichtblick/packages/suite/src/index.ts:1-7
// SPDX-FileCopyrightText: Copyright (C) 2023-2025 Bayerische Motoren Werke Aktiengesellschaft (BMW AG)
// SPDX-License-Identifier: MPL-2.0
```

**Foxglove側にはライセンスヘッダーなし**
```typescript
// 参照: create-foxglove-extension/examples/extension-demo/node_modules/@foxglove/extension/src/index.ts:1
import type { Immutable } from "./immutable";
```

#### **カメラモデル関連APIの差分**
```typescript
// 参照: original-lichtblick/packages/suite/src/index.ts:8-28
import type { RegisterCameraModelArgs } from "./cameraModels";

// Expose all interfaces from about camera models
export type {
  FloatArray,
  DistortionModel,
  CameraInfo,
  Vector2,
  Vector3,
  ICameraModel,
  CameraModelBuilder,
  RegisterCameraModelArgs,
} from "./cameraModels";
```

**Foxglove側にはカメラモデル関連なし**

### 3.2 Topic型の進化

#### **deprecated datatype フィールド**
```typescript
// 参照: create-foxglove-extension/examples/extension-demo/node_modules/@foxglove/extension/src/index.ts:44-47
export type Topic = {
  name: string;
  /**
   * @deprecated Renamed to `schemaName`. `datatype` will be removed in a future release.
   */
  datatype: string;
  schemaName: string;
  convertibleTo?: readonly string[];
};
```

```typescript
// 参照: original-lichtblick/packages/suite/src/index.ts:48-67
export type Topic = {
  name: string;
  schemaName: string;
  convertibleTo?: readonly string[];
};
```

**Lichtblick側では`datatype`フィールドが削除済み**

### 3.3 新しい型とフィールド

#### **Metadata型の追加**
```typescript
// 参照: original-lichtblick/packages/suite/src/index.ts:103-120
export type Metadata = {
  /**
   * The name of the metadata entry.
   */
  readonly name: string;

  /**
   * A key-value object associated with the metadata entry.
   */
  readonly metadata: Record<string, string>;
};
```

**Foxglove側には存在しない**

#### **MessageEvent型の差分**
```typescript
// 参照: create-foxglove-extension/examples/extension-demo/node_modules/@foxglove/extension/src/index.ts:110-112
/**
 * The approximate size of this message event in its deserialized form. This can be
 * useful for statistics tracking and cache eviction.
 */
sizeInBytes: number;

// 参照: original-lichtblick/packages/suite/src/index.ts:148-150
/**
 * The approximate size of this message in its serialized form. This can be
 * useful for statistics tracking and cache eviction.
 */
sizeInBytes: number;
```

**コメント内容の差分**: "deserialized form" vs "serialized form"

#### **topicConfig フィールドの追加**
```typescript
// 参照: original-lichtblick/packages/suite/src/index.ts:159-160
topicConfig?: unknown;
```

**Foxglove側には存在しない**

### 3.4 拡張された機能

#### **PanelSettings インターフェース**
```typescript
// 参照: original-lichtblick/packages/suite/src/index.ts:453-468
export interface PanelSettings<ExtensionSettings> {
  /**
   * @param config value of the custom settings. It's type is the type of the object defined in the *defaultConfig* property
   * @returns
   * a settings tree node defined as it would be defined in an extension.
   * That node will be merged with the node belonging to the concerned topic (path = ["topics", "__topic_name__"])
   */
  settings: (config?: ExtensionSettings) => SettingsTreeNode;
  /**
   * Simple settings handler run right after the default handler for settings.
   * @param config is mutated, modifying it allows the state value to be modified and then sent to the converter
   */
  handler: (action: SettingsTreeAction, config?: ExtensionSettings) => void;
  defaultConfig?: ExtensionSettings;
}
```

**Foxglove側には存在しない**

#### **registerCameraModel メソッド**
```typescript
// 参照: original-lichtblick/packages/suite/src/index.ts:522
registerCameraModel(args: RegisterCameraModelArgs): void;
```

**Foxglove側のExtensionContextには存在しない**

#### **panelSettings フィールド**
```typescript
// 参照: original-lichtblick/packages/suite/src/index.ts:476-478
/**
 * Custom settings for the topics using the schema specified in the *toSchemaName* property
 */
panelSettings?: Record<string, PanelSettings<unknown>>;
```

**RegisterMessageConverterArgs に追加**（Foxglove側には存在しない）

#### **metadata フィールド**
```typescript
// 参照: original-lichtblick/packages/suite/src/index.ts:293-296
/**
 * An array of metadata entries. Each entry includes a name and a map of key-value pairs
 * representing the metadata associated with that name (only avaiable in MCAP files).
 */
readonly metadata?: ReadonlyArray<Readonly<Metadata>>;
```

**PanelExtensionContext に追加**（Foxglove側には存在しない）

---

## 📈 技術的互換性分析

### 破壊的変更
1. **パッケージ名**: `@foxglove/extension` → `@lichtblick/suite`
2. **deprecated datatype**: Foxglove側で非推奨、Lichtblick側で削除済み
3. **カメラモデルAPI**: Lichtblick側で大幅に追加
4. **設定システム**: PanelSettings が Lichtblick側で新規追加

### 後方互換性
- ❌ **API レベル**: パッケージ名変更により完全に非互換
- ❌ **Topic型**: datatype フィールドの削除により非互換
- ❌ **MessageEvent型**: コメント内容とtopicConfig追加により微差
- ❌ **ExtensionContext**: registerCameraModel追加により拡張

### 機能拡張性
- ✅ **Lichtblick側で機能拡張**: カメラモデル、設定システム、メタデータ
- ✅ **型安全性の向上**: deprecated フィールドの削除
- ✅ **BMW固有機能**: ライセンスヘッダー、コピーライト情報

---

## 🎯 マイグレーションへの影響

### 🔥 高複雑度項目
1. **import文の全面書き換え**
   - 影響ファイル: すべてのTypeScriptファイル
   - 対応: `@foxglove/extension` → `@lichtblick/suite`

2. **deprecated datatype フィールド**
   - 影響範囲: Topic型を使用するすべてのコード
   - 対応: `topic.datatype` → `topic.schemaName`

3. **パッケージ依存関係の完全置換**
   - 影響ファイル: package.json
   - 対応: 依存関係とスクリプトの全面更新

### 🔶 中複雑度項目
1. **新機能への対応**
   - カメラモデル関連API（オプション）
   - 設定システム（オプション）
   - メタデータ機能（オプション）

2. **CLIツールの差分**
   - publishコマンドの非存在
   - webpack設定の微調整

### 🔷 低複雑度項目
1. **コメント内容の差分**
   - MessageEvent型のコメント更新
   - ライセンスヘッダーの更新

---

## 📝 推奨対応策

### 1. **段階的マイグレーション**
1. **Phase 1**: パッケージ名変更とimport文修正
2. **Phase 2**: deprecated フィールドの削除対応
3. **Phase 3**: 新機能の活用検討

### 2. **互換性確保**
- TypeScript型チェックによる網羅的な検証
- テストケースの充実
- 段階的なリリース計画

### 3. **新機能活用**
- カメラモデル機能（該当する場合）
- 設定システムの活用
- メタデータ機能の検討

---

## 📞 参考リソース

### ファイル参照一覧
1. **create-foxglove-extension/src/index.ts:1-4**
2. **original-lichtblick/packages/suite/src/index.ts:1-946**
3. **create-foxglove-extension/examples/extension-demo/node_modules/@foxglove/extension/src/index.ts:1-833**
4. **create-foxglove-extension/src/bin/foxglove-extension.ts:1-62**
5. **create-lichtblick-extension/src/bin/lichtblick-extension.ts:1-48**
6. **create-foxglove-extension/src/webpackConfigExtension.ts:1-74**
7. **create-lichtblick-extension/src/webpackConfigExtension.ts:1-74**

### 公式リソース
- **Foxglove Extension**: https://github.com/foxglove/create-foxglove-extension
- **Lichtblick Suite**: https://github.com/lichtblick-suite/lichtblick

---

**作成者**: AI Assistant  
**最終更新**: 2025年7月14日  
**調査信頼度**: 高（実際のファイル内容とdiff結果に基づく）  
**推奨度**: 慎重な段階的マイグレーションを推奨 