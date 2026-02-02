# Firestoreインデックス作成ガイド

## 🚨 現在の問題

種目の追加・編集・削除ができない原因は、**Firestoreインデックスが作成されていない**ためです。

エラーログ:
```
W/Firestore: The query requires an index.
```

---

## ✅ 解決方法（3つの方法から選択）

### 方法1: URLから直接作成（最も簡単）⭐

1. **ログからURLをコピー**
   
   アプリ実行時のログに表示される以下のようなURLをクリック：
   ```
   https://console.firebase.google.com/v1/r/project/fitapp-4482a/firestore/indexes?create_composite=...
   ```

2. **Firebase Consoleで作成**
   
   - URLをブラウザで開く
   - 「インデックスを作成」ボタンをクリック
   - 作成完了まで待機（通常2-5分）

3. **アプリを再起動**
   
   インデックス作成完了後、アプリを再起動すると正常に動作します。

---

### 方法2: Firebase CLIでデプロイ

1. **Firebase CLIをインストール**（未インストールの場合）
   ```bash
   npm install -g firebase-tools
   ```

2. **Firebaseにログイン**
   ```bash
   firebase login
   ```

3. **プロジェクトを初期化**（初回のみ）
   ```bash
   cd c:\dev\Fit_App
   firebase init firestore
   ```
   
   - プロジェクト選択: `fitapp-4482a`
   - Firestore rulesファイル: `firestore.rules`（既存のまま）
   - Firestore indexesファイル: `firestore.indexes.json`（既存のまま）

4. **インデックスをデプロイ**
   ```bash
   firebase deploy --only firestore:indexes
   ```

5. **完了を待つ**
   
   デプロイが完了するまで2-5分待ちます。

---

### 方法3: Firebase Consoleで手動作成

1. **Firebase Consoleを開く**
   
   https://console.firebase.google.com/project/fitapp-4482a/firestore/indexes

2. **bodyPartsインデックスを作成**
   
   - 「複合インデックスを追加」をクリック
   - コレクションID: `bodyParts`
   - コレクショングループ: ✅ はい
   - フィールド:
     - `isArchived` - 昇順
     - `order` - 昇順
     - `__name__` - 昇順
   - 「作成」をクリック

3. **exercisesインデックスを作成**
   
   - 「複合インデックスを追加」をクリック
   - コレクションID: `exercises`
   - コレクショングループ: ✅ はい
   - フィールド:
     - `isArchived` - 昇順
     - `bodyPartId` - 昇順
     - `order` - 昇順
     - `__name__` - 昇順
   - 「作成」をクリック

4. **作成完了を待つ**
   
   両方のインデックスが「有効」になるまで待ちます（2-5分）。

---

## 📋 インデックス作成状況の確認

Firebase Console → Firestore Database → インデックスタブ

**ステータス**:
- 🔄 作成中（Building）: 待機が必要
- ✅ 有効（Enabled）: 使用可能
- ❌ エラー: 設定を確認

---

## 🎯 作成後の確認

インデックス作成完了後：

1. **アプリを再起動**
   ```bash
   flutter run
   ```

2. **動作確認**
   - ✅ 種目一覧が表示される
   - ✅ 部位一覧が表示される
   - ✅ 種目の追加ができる
   - ✅ 種目の編集ができる
   - ✅ 種目の削除ができる
   - ✅ Firestoreエラーが表示されない

---

## 💡 ヒント

### インデックスが必要な理由

Firestoreでは、複数のフィールドでソートやフィルターを行うクエリには、事前にインデックスを作成する必要があります。

**このアプリで使用しているクエリ**:
```dart
// bodyParts
.where('isArchived', isEqualTo: false)
.orderBy('order')

// exercises
.where('isArchived', isEqualTo: false)
.orderBy('bodyPartId')
.orderBy('order')
```

### トラブルシューティング

**Q: インデックス作成に失敗する**
- A: Firebase Consoleで手動作成を試してください

**Q: インデックス作成後もエラーが出る**
- A: アプリを完全に再起動してください（ホットリロードではなく）

**Q: インデックスが「作成中」のまま**
- A: 通常5分以内に完了します。長時間かかる場合はFirebaseサポートに問い合わせてください

---

## ✅ 完了！

インデックス作成後、アプリが正常に動作するようになります。
