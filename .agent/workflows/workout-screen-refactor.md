---
description: ワークアウト画面の3画面分割リファクタリング計画
---

# ワークアウト画面の3画面分割リファクタリング

## 目的
現在の `WorkoutEditorScreen` を3つの画面に分割し、責務を明確化する。

## 新しい画面構成

### 1. TodayWorkoutScreen（今日のワークアウト画面）
**責務**: ワークアウトセッションの概要表示
**ファイル**: `lib/screens/today_workout_screen.dart`

**表示内容**:
- 日付
- ワークアウト名（編集可能）
- 合計種目数
- 合計セット数
- 合計ボリューム
- メモ（編集可能）

**アクション**:
- 「筋トレ一覧へ」ボタン → WorkoutExerciseListScreen へ遷移
- 「保存して完了」ボタン → 保存 + 完了処理 + ホームへ戻る
- 戻るボタン → 変更確認ダイアログ → ホームへ戻る

**引数**:
- `Workout workout` (必須)

---

### 2. WorkoutExerciseListScreen（筋トレ一覧画面）
**責務**: 種目一覧の表示と管理
**ファイル**: `lib/screens/workout_exercise_list_screen.dart`

**表示内容**:
- 種目一覧（カード形式、編集UIなし）
  - 種目名
  - 部位名
  - セット数
  - 合計ボリューム

**アクション**:
- 種目カードタップ → WorkoutExerciseEditScreen へ遷移（編集モード）
- 「種目を追加」ボタン → ExercisePickerScreen → WorkoutExerciseEditScreen へ遷移（新規モード）
- 戻るボタン → TodayWorkoutScreen へ戻る

**引数**:
- `Workout workout` (必須)

---

### 3. WorkoutExerciseEditScreen（種目編集画面）
**責務**: 単一種目の追加・編集
**ファイル**: `lib/screens/workout_exercise_edit_screen.dart`

**表示内容**:
- 種目名・部位名（ヘッダー）
- 前回の記録（該当する場合）
- セット入力UI（既存の SetInputRow を使用）
- メモ入力

**アクション**:
- 「セットを追加」ボタン
- 「前回の記録をコピー」ボタン
- 「保存」ボタン → WorkoutExerciseListScreen へ戻る
- 「削除」ボタン → 確認ダイアログ → WorkoutExerciseListScreen へ戻る
- 戻るボタン → 変更確認ダイアログ → WorkoutExerciseListScreen へ戻る

**引数**:
- `Workout workout` (必須)
- `int? exerciseIndex` (null = 新規追加、値あり = 編集)
- `WorkoutItem? newItem` (新規追加時の初期アイテム)

---

## 画面遷移図

```
HomeScreen
    ↓ (今日のワークアウトカードタップ)
TodayWorkoutScreen
    ↓ (筋トレ一覧へボタン)
WorkoutExerciseListScreen
    ↓ (種目カードタップ or 追加ボタン)
    ↓ (追加の場合は ExercisePickerScreen 経由)
WorkoutExerciseEditScreen
    ↓ (保存/削除/キャンセル)
WorkoutExerciseListScreen (最新データで更新)
    ↓ (戻る)
TodayWorkoutScreen (最新データで更新)
    ↓ (保存して完了 or 戻る)
HomeScreen
```

---

## データフロー

### 状態管理
- `WorkoutProvider` を使用して Workout の状態を管理
- 各画面は `context.read<WorkoutProvider>()` でデータを取得・更新
- 画面遷移時は Workout オブジェクトを引数として渡す

### データ更新タイミング
1. **TodayWorkoutScreen**: タイトル・メモの変更時に即座に保存
2. **WorkoutExerciseListScreen**: 表示のみ（更新なし）
3. **WorkoutExerciseEditScreen**: 保存ボタン押下時に WorkoutProvider 経由で更新

### 画面間データ受け渡し
```dart
// HomeScreen → TodayWorkoutScreen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => TodayWorkoutScreen(workout: workout),
  ),
);

// TodayWorkoutScreen → WorkoutExerciseListScreen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => WorkoutExerciseListScreen(workout: currentWorkout),
  ),
);

// WorkoutExerciseListScreen → WorkoutExerciseEditScreen (編集)
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => WorkoutExerciseEditScreen(
      workout: currentWorkout,
      exerciseIndex: index,
    ),
  ),
);

// WorkoutExerciseListScreen → WorkoutExerciseEditScreen (新規)
final exercise = await Navigator.push(...); // ExercisePicker
if (exercise != null) {
  final newItem = WorkoutItem(...);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => WorkoutExerciseEditScreen(
        workout: currentWorkout,
        newItem: newItem,
      ),
    ),
  );
}
```

---

## 実装の変更点

### 新規作成ファイル

1. **lib/screens/today_workout_screen.dart**
   - WorkoutEditorScreen からタイトル・メモ・概要表示部分を移動
   - 完了処理ロジックを移動
   - 筋トレ一覧への遷移ボタンを追加

2. **lib/screens/workout_exercise_list_screen.dart**
   - WorkoutEditorScreen から種目一覧表示部分を移動
   - ExerciseCard を簡易版に変更（表示のみ）
   - 種目追加・編集への遷移ロジックを実装

3. **lib/screens/workout_exercise_edit_screen.dart**
   - ExerciseCard の編集機能を画面レベルに昇格
   - SetInputRow を使用したセット入力UI
   - 前回の記録表示・コピー機能
   - 保存・削除ロジック

### 修正ファイル

1. **lib/screens/home_screen.dart**
   - WorkoutEditorScreen → TodayWorkoutScreen への遷移に変更

2. **lib/screens/workout_editor_screen.dart**
   - 削除（または非推奨化）

3. **lib/widgets/exercise_card.dart**
   - 表示専用版を作成（exercise_summary_card.dart）
   - 既存の ExerciseCard は WorkoutExerciseEditScreen で使用

### 削除可能なファイル
- なし（既存ファイルは後方互換性のため残す）

---

## 実装順序

### Phase 1: WorkoutExerciseEditScreen の作成
1. 新規ファイル作成
2. ExerciseCard のロジックを移植
3. 保存・削除機能の実装
4. 前回の記録表示機能の実装

### Phase 2: WorkoutExerciseListScreen の作成
1. 新規ファイル作成
2. 種目一覧表示（簡易カード）
3. WorkoutExerciseEditScreen への遷移実装
4. ExercisePicker 連携

### Phase 3: TodayWorkoutScreen の作成
1. 新規ファイル作成
2. 概要表示の実装
3. タイトル・メモ編集機能
4. 完了処理の実装
5. WorkoutExerciseListScreen への遷移

### Phase 4: 統合とテスト
1. HomeScreen の遷移先を変更
2. 全体フローのテスト
3. データ永続化の確認
4. エラーハンドリングの確認

---

## 注意事項

### データ整合性
- 各画面で Workout オブジェクトを更新する際は、必ず WorkoutProvider 経由で行う
- 画面遷移時に最新の Workout を取得し直す

### ユーザー体験
- 各画面で変更があった場合、戻る時に確認ダイアログを表示
- 自動保存を適切に実装し、データ損失を防ぐ
- ローディング状態を適切に表示

### パフォーマンス
- 不要な再ビルドを避けるため、適切に Provider を使用
- 大量の種目がある場合でもスムーズにスクロールできるよう最適化

### エラーハンドリング
- ネットワークエラー時の挙動
- データ保存失敗時の挙動
- 不正な状態での画面遷移の防止
