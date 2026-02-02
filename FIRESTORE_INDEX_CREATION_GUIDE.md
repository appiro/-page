# Firestoreインデックス作成手順（詳細版）

## 🎯 目的

種目と部位のデータを取得するために、Firestoreインデックスを作成します。

---

## 📋 必要なインデックス

### 1. bodyPartsインデックス
- コレクション: `bodyParts`
- フィールド: `isArchived`, `order`, `__name__`

### 2. exercisesインデックス
- コレクション: `exercises`
- フィールド: `isArchived`, `bodyPartId`, `order`, `__name__`

---

## ✅ 作成手順（最も簡単な方法）

### ステップ1: アプリを実行してURLを取得

1. **アプリを実行**
   ```bash
   flutter run
   ```

2. **ログからURLをコピー**
   
   以下のようなログが表示されます：
   ```
   W/Firestore: The query requires an index. You can create it here:
   https://console.firebase.google.com/v1/r/project/fitapp-4482a/firestore/indexes?create_composite=...
   ```

3. **2つのURLをコピー**
   - bodyPartsのURL
   - exercisesのURL

---

### ステップ2: URLから直接作成

#### bodyPartsインデックス

1. **URLをブラウザで開く**
   ```
   https://console.firebase.google.com/v1/r/project/fitapp-4482a/firestore/indexes?create_composite=Ck5wcm9qZWN0cy9maXRhcHAtNDQ4MmEvZGF0YWJhc2VzLyhkZWZhdWx0KS9jb2xsZWN0aW9uR3JvdXBzL2JvZHlQYXJ0cy9pbmRleGVzL18QARoOCgppc0FyY2hpdmVkEAEaCQoFb3JkZXIQARoMCghfX25hbWVfXxAB
   ```

2. **Googleアカウントでログイン**（必要な場合）

3. **インデックス設定を確認**
   - コレクションID: `bodyParts`
   - コレクショングループ: ✅ はい
   - フィールド:
     - `isArchived` - 昇順
     - `order` - 昇順
     - `__name__` - 昇順

4. **「インデックスを作成」ボタンをクリック**

5. **作成完了を待つ**（2-5分）

---

#### exercisesインデックス

1. **URLをブラウザで開く**
   ```
   https://console.firebase.google.com/v1/r/project/fitapp-4482a/firestore/indexes?create_composite=Ck5wcm9qZWN0cy9maXRhcHAtNDQ4MmEvZGF0YWJhc2VzLyhkZWZhdWx0KS9jb2xsZWN0aW9uR3JvdXBzL2V4ZXJjaXNlcy9pbmRleGVzL18QARoOCgppc0FyY2hpdmVkEAEaDgoKYm9keVBhcnRJZBABGgkKBW9yZGVyEAEaDAoIX19uYW1lX18QAQ
   ```

2. **インデックス設定を確認**
   - コレクションID: `exercises`
   - コレクショングループ: ✅ はい
   - フィールド:
     - `isArchived` - 昇順
     - `bodyPartId` - 昇順
     - `order` - 昇順
     - `__name__` - 昇順

3. **「インデックスを作成」ボタンをクリック**

4. **作成完了を待つ**（2-5分）

---

### ステップ3: 作成状況を確認

1. **Firebase Consoleを開く**
   ```
   https://console.firebase.google.com/project/fitapp-4482a/firestore/indexes
   ```

2. **インデックスタブを確認**
   
   **ステータス**:
   - 🔄 **作成中（Building）**: まだ使用できません。待機してください。
   - ✅ **有効（Enabled）**: 使用可能です！
   - ❌ **エラー**: 設定を確認してください。

3. **両方のインデックスが「有効」になるまで待つ**

---

### ステップ4: アプリを再起動

インデックスが「有効」になったら：

1. **アプリを停止**
   - ターミナルで `q` を押す

2. **アプリを再起動**
   ```bash
   flutter run
   ```

3. **動作確認**
   - ✅ Firestoreエラーが表示されない
   - ✅ 種目一覧が表示される
   - ✅ 部位一覧が表示される
   - ✅ 種目の追加・編集・削除が即座に反映される

---

## 🖼️ スクリーンショット付き手順

### 1. Firebase Consoleにアクセス

![Firebase Console](https://console.firebase.google.com/project/fitapp-4482a/firestore/indexes)

### 2. インデックスタブを開く

左メニュー → Firestore Database → インデックス

### 3. URLから作成

ログのURLをクリックすると、自動的に設定が入力されます。

### 4. 作成ボタンをクリック

「インデックスを作成」ボタンをクリックするだけです。

### 5. 完了を待つ

ステータスが「作成中」→「有効」に変わるまで待ちます。

---

## 🔧 代替方法: Firebase CLIを使用

Firebase CLIがインストールされている場合：

### 1. Firebase CLIをインストール（未インストールの場合）

```bash
npm install -g firebase-tools
```

### 2. Firebaseにログイン

```bash
firebase login
```

### 3. プロジェクトを初期化

```bash
cd c:\dev\Fit_App
firebase init firestore
```

プロンプトで以下を選択：
- プロジェクト: `fitapp-4482a`
- Firestore rules: `firestore.rules`（既存）
- Firestore indexes: `firestore.indexes.json`（既存）

### 4. インデックスをデプロイ

```bash
firebase deploy --only firestore:indexes
```

### 5. 完了を待つ

デプロイが完了するまで2-5分待ちます。

---

## ❓ トラブルシューティング

### Q: URLが見つからない

**A**: アプリを実行して、種目選択画面を開いてください。ログに自動的にURLが表示されます。

### Q: インデックス作成に失敗する

**A**: 
1. Firebaseプロジェクトの権限を確認
2. 手動作成を試す
3. Firebase Consoleで直接作成

### Q: インデックスが「作成中」のまま

**A**: 
1. 通常5分以内に完了します
2. 10分以上かかる場合は、ページを更新
3. それでも解決しない場合は、Firebaseサポートに問い合わせ

### Q: インデックス作成後もエラーが出る

**A**: 
1. アプリを完全に再起動（ホットリロードではなく）
2. ブラウザのキャッシュをクリア
3. インデックスが「有効」になっているか確認

---

## ✅ 完了チェックリスト

- [ ] bodyPartsインデックスを作成
- [ ] exercisesインデックスを作成
- [ ] 両方のインデックスが「有効」になった
- [ ] アプリを再起動
- [ ] Firestoreエラーが表示されない
- [ ] 種目一覧が表示される
- [ ] 種目の追加・編集・削除が即座に反映される

---

## 🎉 完了！

インデックス作成が完了すると、アプリが正常に動作します。
