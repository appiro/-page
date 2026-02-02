# 🔥 Firestoreインデックス作成 - 簡単3ステップ

## 📋 必要な作業

以下の2つのインデックスを作成します：
1. **bodyParts**インデックス
2. **exercises**インデックス

---

## ✅ 作成手順（3ステップ）

### ステップ1️⃣: bodyPartsインデックスを作成

1. **以下のURLをブラウザで開く**
   
   ```
   https://console.firebase.google.com/v1/r/project/fitapp-4482a/firestore/indexes?create_composite=Ck5wcm9qZWN0cy9maXRhcHAtNDQ4MmEvZGF0YWJhc2VzLyhkZWZhdWx0KS9jb2xsZWN0aW9uR3JvdXBzL2JvZHlQYXJ0cy9pbmRleGVzL18QARoOCgppc0FyY2hpdmVkEAEaCQoFb3JkZXIQARoMCghfX25hbWVfXxAB
   ```

2. **Googleアカウントでログイン**（必要な場合）

3. **設定を確認**
   - コレクションID: `bodyParts`
   - コレクショングループ: ✅ はい
   - フィールド:
     - `isArchived` - 昇順
     - `order` - 昇順
     - `__name__` - 昇順

4. **「インデックスを作成」ボタンをクリック**

5. **ステータスが「作成中」になることを確認**

---

### ステップ2️⃣: exercisesインデックスを作成

1. **以下のURLをブラウザで開く**
   
   ```
   https://console.firebase.google.com/v1/r/project/fitapp-4482a/firestore/indexes?create_composite=Ck5wcm9qZWN0cy9maXRhcHAtNDQ4MmEvZGF0YWJhc2VzLyhkZWZhdWx0KS9jb2xsZWN0aW9uR3JvdXBzL2V4ZXJjaXNlcy9pbmRleGVzL18QARoOCgppc0FyY2hpdmVkEAEaDgoKYm9keVBhcnRJZBABGgkKBW9yZGVyEAEaDAoIX19uYW1lX18QAQ
   ```

2. **設定を確認**
   - コレクションID: `exercises`
   - コレクショングループ: ✅ はい
   - フィールド:
     - `isArchived` - 昇順
     - `bodyPartId` - 昇順
     - `order` - 昇順
     - `__name__` - 昇順

3. **「インデックスを作成」ボタンをクリック**

4. **ステータスが「作成中」になることを確認**

---

### ステップ3️⃣: 作成完了を待つ

1. **Firebase Consoleで確認**
   
   ```
   https://console.firebase.google.com/project/fitapp-4482a/firestore/indexes
   ```

2. **両方のインデックスのステータスを確認**
   
   | インデックス | ステータス | 説明 |
   |------------|----------|------|
   | bodyParts | 🔄 作成中 | 待機してください（2-5分） |
   | exercises | 🔄 作成中 | 待機してください（2-5分） |
   | bodyParts | ✅ 有効 | 使用可能！ |
   | exercises | ✅ 有効 | 使用可能！ |

3. **両方が「✅ 有効」になるまで待つ**

---

## 🎯 完了後の確認

インデックスが「有効」になったら：

### 1. アプリを再起動

```bash
# ターミナルで 'q' を押してアプリを停止
q

# アプリを再起動
flutter run
```

### 2. 動作確認

以下が正常に動作することを確認：

- ✅ **Firestoreエラーが表示されない**
  ```
  ❌ W/Firestore: The query requires an index
  ✅ エラーなし
  ```

- ✅ **種目一覧が表示される**
  - 部位別に種目が表示される
  - お気に入りセクションが表示される

- ✅ **種目の追加が即座に反映される**
  - 種目を追加
  - すぐに一覧に表示される

- ✅ **種目の編集が即座に反映される**
  - 種目名や部位を変更
  - すぐに一覧に反映される

- ✅ **種目の削除が即座に反映される**
  - 種目を削除
  - すぐに一覧から消える

---

## 📱 URLのコピー方法

### Windows

1. URLを選択
2. `Ctrl + C` でコピー
3. ブラウザのアドレスバーに `Ctrl + V` で貼り付け
4. `Enter` キーで開く

### Mac

1. URLを選択
2. `Cmd + C` でコピー
3. ブラウザのアドレスバーに `Cmd + V` で貼り付け
4. `Enter` キーで開く

---

## ❓ よくある質問

### Q: URLをクリックしても何も起こらない

**A**: URLをコピーして、ブラウザのアドレスバーに直接貼り付けてください。

### Q: ログインを求められる

**A**: Firebaseプロジェクトにアクセス権限のあるGoogleアカウントでログインしてください。

### Q: インデックスが「作成中」のまま

**A**: 通常2-5分で完了します。10分以上かかる場合は、ページを更新してください。

### Q: インデックス作成後もエラーが出る

**A**: 
1. アプリを完全に再起動（ホットリロードではなく）
2. インデックスが「有効」になっているか再確認
3. 数分待ってから再試行

---

## 🔧 手動作成（URLが使えない場合）

URLが使えない場合は、手動で作成できます：

### bodyPartsインデックス

1. Firebase Console → Firestore Database → インデックス
2. 「複合インデックスを追加」をクリック
3. 以下を入力：
   - コレクションID: `bodyParts`
   - コレクショングループ: ✅ はい
   - フィールド1: `isArchived` - 昇順
   - フィールド2: `order` - 昇順
   - フィールド3: `__name__` - 昇順
4. 「作成」をクリック

### exercisesインデックス

1. 「複合インデックスを追加」をクリック
2. 以下を入力：
   - コレクションID: `exercises`
   - コレクショングループ: ✅ はい
   - フィールド1: `isArchived` - 昇順
   - フィールド2: `bodyPartId` - 昇順
   - フィールド3: `order` - 昇順
   - フィールド4: `__name__` - 昇順
3. 「作成」をクリック

---

## ✅ チェックリスト

作業完了の確認：

- [ ] bodyPartsインデックスのURLを開いた
- [ ] 「インデックスを作成」をクリックした
- [ ] exercisesインデックスのURLを開いた
- [ ] 「インデックスを作成」をクリックした
- [ ] 両方のインデックスが「有効」になった
- [ ] アプリを再起動した
- [ ] Firestoreエラーが表示されなくなった
- [ ] 種目の追加・編集・削除が即座に反映される

---

## 🎉 完了！

インデックス作成が完了すると、アプリが完全に動作します！

**所要時間**: 約5-10分（インデックス作成待ち時間を含む）
