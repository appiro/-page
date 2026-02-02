# ワークアウト画面の3画面分割 - 実装ガイド

## 📋 概要

既存の `WorkoutEditorScreen` を3つの独立した画面に分割し、UIとロジックの責務を明確化しました。

---

## 🎯 新しい画面構成

### 1️⃣ TodayWorkoutScreen（今日のワークアウト画面）
**ファイル**: `lib/screens/today_workout_screen.dart`

**表示内容**:
```
┌─────────────────────────────────┐
│ ← 今日のワークアウト        ⏱  │
│   2026年1月27日                 │
├─────────────────────────────────┤
│ ワークアウト名: [胸トレ    ] 📜│
├─────────────────────────────────┤
│ ┌─ 概要 ─────────────────────┐ │
│ │  💪 種目   📋 セット  ⚖️ ボリューム│
│ │    3        12      1,200kg │
│ └─────────────────────────────┘ │
├─────────────────────────────────┤
│ [📝 筋トレ一覧へ]               │
├─────────────────────────────────┤
│ メモ:                           │
│ ┌─────────────────────────────┐ │
│ │ 感想や体調など...           │ │
│ └─────────────────────────────┘ │
├─────────────────────────────────┤
│ [✅ 保存して完了]               │
└─────────────────────────────────┘
```

**主な機能**:
- ワークアウト名・メモの編集
- 概要統計の表示
- 筋トレ一覧画面への遷移
- 完了処理（コイン・チケット獲得）

---

### 2️⃣ WorkoutExerciseListScreen（筋トレ一覧画面）
**ファイル**: `lib/screens/workout_exercise_list_screen.dart`

**表示内容**:
```
┌─────────────────────────────────┐
│ ← 筋トレ一覧                    │
├─────────────────────────────────┤
│ 💪 種目: 3  📋 セット: 12  ⚖️ 1,200kg│
├─────────────────────────────────┤
│ ┌─────────────────────────────┐ │
│ │ ベンチプレス          →     │ │
│ │ 胸                          │ │
│ │ 💪 4セット  ⚖️ 400kg         │ │
│ └─────────────────────────────┘ │
│ ┌─────────────────────────────┐ │
│ │ ダンベルフライ        →     │ │
│ │ 胸                          │ │
│ │ 💪 4セット  ⚖️ 320kg         │ │
│ └─────────────────────────────┘ │
│ ┌─────────────────────────────┐ │
│ │ ケーブルクロス        →     │ │
│ │ 胸                          │ │
│ │ 💪 4セット  ⚖️ 480kg         │ │
│ └─────────────────────────────┘ │
├─────────────────────────────────┤
│ [➕ 種目を追加]                 │
└─────────────────────────────────┘
```

**主な機能**:
- 種目一覧の表示（簡易カード）
- 種目タップで編集画面へ
- 種目追加ボタン
- Pull-to-refresh

---

### 3️⃣ WorkoutExerciseEditScreen（種目編集画面）
**ファイル**: `lib/screens/workout_exercise_edit_screen.dart`

**表示内容**:
```
┌─────────────────────────────────┐
│ ← 種目を編集              🗑️    │
├─────────────────────────────────┤
│ ベンチプレス                    │
│ 胸                              │
├─────────────────────────────────┤
│ 📊 前回の記録:                  │
│ 1: 60kg × 10回                  │
│ 2: 60kg × 8回                   │
│ 3: 60kg × 6回                   │
│ [📋 コピー]                     │
├─────────────────────────────────┤
│ セット                    4セット│
├─────────────────────────────────┤
│ 1  [60] kg × [10] 回  [補助] 🗑│
│ 2  [60] kg × [ 8] 回  [補助] 🗑│
│ 3  [60] kg × [ 6] 回  [補助] 🗑│
│ 4  [55] kg × [ 8] 回  [補助] 🗑│
├─────────────────────────────────┤
│ [➕ セットを追加]               │
├─────────────────────────────────┤
│ メモ:                           │
│ ┌─────────────────────────────┐ │
│ │ 種目についてのメモ...       │ │
│ └─────────────────────────────┘ │
├─────────────────────────────────┤
│ [✅ 保存]                       │
└─────────────────────────────────┘
```

**主な機能**:
- セット入力UI
- 前回の記録表示・コピー
- メモ入力
- 保存・削除

---

## 🔄 画面遷移フロー

```
HomeScreen
    │
    │ タップ: 今日のワークアウトカード
    ↓
┌─────────────────────────────────┐
│ TodayWorkoutScreen              │
│ (今日のワークアウト画面)        │
├─────────────────────────────────┤
│ • ワークアウト名・メモ編集      │
│ • 概要統計表示                  │
│ • 筋トレ一覧へボタン            │
│ • 保存して完了ボタン            │
└─────────────────────────────────┘
    │
    │ タップ: 筋トレ一覧へ
    ↓
┌─────────────────────────────────┐
│ WorkoutExerciseListScreen       │
│ (筋トレ一覧画面)                │
├─────────────────────────────────┤
│ • 種目一覧表示                  │
│ • 種目追加ボタン                │
│ • 種目タップで編集              │
└─────────────────────────────────┘
    │
    │ タップ: 種目追加 or 種目カード
    │ (追加の場合は ExercisePicker 経由)
    ↓
┌─────────────────────────────────┐
│ WorkoutExerciseEditScreen       │
│ (種目編集画面)                  │
├─────────────────────────────────┤
│ • セット入力                    │
│ • 前回の記録表示・コピー        │
│ • メモ入力                      │
│ • 保存・削除                    │
└─────────────────────────────────┘
    │
    │ 保存 or 削除
    ↓
WorkoutExerciseListScreen (戻る)
    │
    │ 戻るボタン
    ↓
TodayWorkoutScreen (戻る)
    │
    │ 保存して完了 or 戻る
    ↓
HomeScreen (戻る)
```

---

## 📊 データフロー

### WorkoutProvider を中心とした状態管理

```
┌─────────────────────────────────┐
│      WorkoutProvider            │
│  (Workout の一元管理)           │
├─────────────────────────────────┤
│ • getTodayWorkout()             │
│ • updateCurrentWorkout()        │
│ • completeWorkout()             │
│ • deleteWorkout()               │
└─────────────────────────────────┘
         ↑         ↑         ↑
         │         │         │
    read/update  read/update  read/update
         │         │         │
    ┌────┴────┐ ┌─┴──────┐ ┌┴─────────┐
    │ Today   │ │ List   │ │ Edit     │
    │ Workout │ │ Screen │ │ Screen   │
    └─────────┘ └────────┘ └──────────┘
```

### 画面間のデータ受け渡し

```dart
// HomeScreen → TodayWorkoutScreen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => TodayWorkoutScreen(
      workout: workout,  // Workout オブジェクトを渡す
    ),
  ),
);

// TodayWorkoutScreen → WorkoutExerciseListScreen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => WorkoutExerciseListScreen(
      workout: _currentWorkout,  // 最新の Workout を渡す
    ),
  ),
);

// WorkoutExerciseListScreen → WorkoutExerciseEditScreen (編集)
final result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => WorkoutExerciseEditScreen(
      workout: _currentWorkout,
      exerciseIndex: index,  // 編集する種目のインデックス
    ),
  ),
);

// WorkoutExerciseListScreen → WorkoutExerciseEditScreen (新規)
final result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => WorkoutExerciseEditScreen(
      workout: _currentWorkout,
      newItem: newItem,  // 新規種目アイテム
    ),
  ),
);

// 戻り値で更新有無を判定
if (result == true) {
  await _refreshWorkout();  // 最新データを再取得
}
```

---

## ✅ 実装完了チェックリスト

### 新規ファイル作成
- [x] `lib/screens/today_workout_screen.dart`
- [x] `lib/screens/workout_exercise_list_screen.dart`
- [x] `lib/screens/workout_exercise_edit_screen.dart`
- [x] `lib/widgets/exercise_summary_card.dart`

### 既存ファイル修正
- [x] `lib/screens/home_screen.dart`
- [x] `lib/screens/history_list_screen.dart`
- [x] `lib/screens/calendar_history_screen.dart`
- [x] `lib/screens/search_workouts_screen.dart`

### ドキュメント作成
- [x] `.agent/workflows/workout-screen-refactor.md` (計画書)
- [x] `REFACTORING_REPORT.md` (完了レポート)
- [x] `IMPLEMENTATION_GUIDE.md` (このファイル)

---

## 🧪 テスト項目

### 基本フロー
- [ ] ホーム画面から今日のワークアウトを開く
- [ ] ワークアウト名・メモを編集して保存
- [ ] 筋トレ一覧画面へ遷移
- [ ] 種目を追加（ExercisePicker 経由）
- [ ] 種目を編集（セット追加・削除）
- [ ] 前回の記録をコピー
- [ ] 種目を削除
- [ ] ワークアウトを完了（コイン・チケット獲得確認）

### エッジケース
- [ ] 空のワークアウトで戻る（自動削除確認）
- [ ] 変更を保存せずに戻る（確認ダイアログ）
- [ ] 変更を保存して戻る
- [ ] システムバックボタンでの動作
- [ ] Pull-to-refresh での最新データ取得

### データ整合性
- [ ] 種目追加後、一覧に反映される
- [ ] 種目編集後、一覧に反映される
- [ ] 種目削除後、一覧から消える
- [ ] ワークアウト完了後、ホームに反映される

---

## 🎨 UI/UX の改善点

### Before (WorkoutEditorScreen)
- 1画面に全ての機能が詰め込まれている
- 種目が多いとスクロールが長くなる
- 編集UIが常に表示されて煩雑

### After (3画面分割)
- 各画面が単一の責務を持つ
- 一覧画面が簡潔で見やすい
- 編集画面で集中して入力できる
- 概要画面で全体像を把握しやすい

---

## 🚀 次のステップ

1. **動作確認**: 全フローをテストして動作を確認
2. **UI調整**: 必要に応じてデザインを微調整
3. **パフォーマンス最適化**: 大量データでの動作確認
4. **ユーザーフィードバック**: 実際の使用感を確認
5. **旧コードの削除**: 問題なければ `workout_editor_screen.dart` を削除

---

## 📝 備考

- 既存の `WorkoutEditorScreen` は後方互換性のため残していますが、現在は使用されていません
- 全ての既存機能（コイン獲得、前回の記録コピーなど）は維持されています
- 各画面で変更確認ダイアログが適切に表示されます
