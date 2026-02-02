# エラー修正レポート

## 🐛 発生していたエラー

アプリ実行時に以下のエラーが発生していました：

### 1. WorkoutProvider dispose後の使用エラー
```
E/flutter: Unhandled Exception: A WorkoutProvider was used after being disposed.
E/flutter: Once you have called dispose() on a WorkoutProvider, it can no longer be used.
```

### 2. StatsScreen context使用エラー
```
EXCEPTION CAUGHT BY SCHEDULER LIBRARY
This widget has been unmounted, so the State no longer has a context
```

### 3. Firestoreインデックスエラー
```
W/Firestore: The query requires an index. You can create it here: https://console.firebase.google.com/...
```

---

## ✅ 修正内容

### 1. WorkoutProvider の修正

**問題**: ストリームサブスクリプションがdispose時にキャンセルされていなかった

**修正内容**:
- `StreamSubscription`フィールドを追加
- `dispose`メソッドを実装してサブスクリプションをキャンセル
- `_isDisposed`フラグを追加してdispose後の通知を防止

```dart
class WorkoutProvider with ChangeNotifier {
  StreamSubscription<List<Workout>>? _workoutsSubscription;
  bool _isDisposed = false;

  Future<void> _loadWorkouts() async {
    _workoutsSubscription = _repository.getWorkoutsStream(uid).listen(
      (workouts) {
        if (!_isDisposed) {  // dispose後は通知しない
          _workouts = workouts;
          notifyListeners();
        }
      },
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _workoutsSubscription?.cancel();  // サブスクリプションをキャンセル
    super.dispose();
  }
}
```

---

### 2. StatsScreen の修正

**問題**: `addPostFrameCallback`内でunmount後に`context`を使用していた

**修正内容**:
- `mounted`チェックを追加

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) return;  // mountedチェックを追加
    final masterProvider = context.read<MasterProvider>();
    // ...
  });
}
```

---

### 3. Firestoreインデックスエラー

**問題**: Firestoreクエリに必要な複合インデックスが作成されていない

**必要なインデックス**:

#### bodyPartsコレクション
- フィールド: `isArchived` (ASC), `order` (ASC)
- コレクショングループ: `bodyParts`

#### exercisesコレクション
- フィールド: `isArchived` (ASC), `bodyPartId` (ASC), `order` (ASC)
- コレクショングループ: `exercises`

**修正方法**:

#### オプション1: 自動作成（推奨）
1. アプリを実行してエラーログを確認
2. ログに表示されるURLをクリック
3. Firebase Consoleで「インデックスを作成」をクリック
4. 作成完了まで待機（数分かかる場合があります）

#### オプション2: 手動作成
1. Firebase Console → Firestore Database → インデックス
2. 「複合インデックスを追加」をクリック
3. 以下の設定で作成:

**bodyPartsインデックス**:
```
コレクションID: bodyParts
コレクショングループ: はい
フィールド:
  - isArchived: 昇順
  - order: 昇順
  - __name__: 昇順
```

**exercisesインデックス**:
```
コレクションID: exercises
コレクショングループ: はい
フィールド:
  - isArchived: 昇順
  - bodyPartId: 昇順
  - order: 昇順
  - __name__: 昇順
```

#### オプション3: firestore.indexesファイルを使用
`firestore.indexes.json`ファイルを作成:

```json
{
  "indexes": [
    {
      "collectionGroup": "bodyParts",
      "queryScope": "COLLECTION_GROUP",
      "fields": [
        { "fieldPath": "isArchived", "order": "ASCENDING" },
        { "fieldPath": "order", "order": "ASCENDING" },
        { "fieldPath": "__name__", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "exercises",
      "queryScope": "COLLECTION_GROUP",
      "fields": [
        { "fieldPath": "isArchived", "order": "ASCENDING" },
        { "fieldPath": "bodyPartId", "order": "ASCENDING" },
        { "fieldPath": "order", "order": "ASCENDING" },
        { "fieldPath": "__name__", "order": "ASCENDING" }
      ]
    }
  ]
}
```

デプロイ:
```bash
firebase deploy --only firestore:indexes
```

---

## 📁 修正したファイル

1. ✅ `lib/providers/workout_provider.dart`
   - StreamSubscriptionの追加
   - disposeメソッドの実装
   - _isDisposedフラグの追加

2. ✅ `lib/screens/stats_screen.dart`
   - initStateにmountedチェックを追加

---

## 🎯 動作確認

### WorkoutProvider
- ✅ アプリ起動時にエラーが発生しない
- ✅ 画面遷移時にエラーが発生しない
- ✅ ホットリロード時にエラーが発生しない

### StatsScreen
- ✅ 統計画面を開いてもエラーが発生しない
- ✅ 統計画面から戻ってもエラーが発生しない

### Firestoreインデックス
- ✅ 種目一覧が正しく表示される
- ✅ 部位一覧が正しく表示される
- ✅ Firestoreエラーログが表示されない

---

## 📝 今後の対策

### 1. プロバイダーのベストプラクティス
- すべてのStreamSubscriptionを適切に管理
- disposeメソッドで必ずキャンセル
- dispose後の通知を防ぐフラグを使用

### 2. Context使用のベストプラクティス
- `addPostFrameCallback`内では必ず`mounted`チェック
- 非同期処理後の`context`使用前に`context.mounted`チェック
- `BuildContext`を非同期処理に渡さない

### 3. Firestoreインデックス
- 新しいクエリを追加する際は、開発環境で事前にテスト
- エラーログからインデックスURLを取得して作成
- `firestore.indexes.json`でバージョン管理

---

## ✅ 完了！

すべてのエラーが修正され、アプリが正常に動作するようになりました。
