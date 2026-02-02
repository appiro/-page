# ワークアウト画面3画面分割 - 実装完了レポート

## 実装概要

既存の `WorkoutEditorScreen` を3つの独立した画面に分割し、責務を明確化しました。

## 新規作成ファイル

### 1. `lib/screens/today_workout_screen.dart`
**責務**: ワークアウトセッションの概要表示と管理
- ワークアウト名・メモの編集
- 概要統計（種目数、セット数、ボリューム）の表示
- 筋トレ一覧画面への遷移
- ワークアウト完了処理
- 変更保存・破棄の確認ダイアログ

### 2. `lib/screens/workout_exercise_list_screen.dart`
**責務**: 種目一覧の表示と管理
- 種目一覧の表示（簡易カード形式）
- 概要統計ヘッダー（種目数、セット数、ボリューム）
- 種目追加・編集画面への遷移
- ExercisePicker との連携
- Pull-to-refresh による最新データ取得

### 3. `lib/screens/workout_exercise_edit_screen.dart`
**責務**: 単一種目の追加・編集
- セット入力UI（SetInputRow を使用）
- 前回の記録表示・コピー機能
- メモ入力
- 保存・削除機能
- 変更確認ダイアログ

### 4. `lib/widgets/exercise_summary_card.dart`
**責務**: 種目一覧用の簡易表示カード
- 種目名、部位名の表示
- セット数、ボリュームの表示
- タップで編集画面へ遷移

## 修正ファイル

### 1. `lib/screens/home_screen.dart`
- `WorkoutEditorScreen` → `TodayWorkoutScreen` へ遷移を変更
- import 文を更新

### 2. `lib/screens/history_list_screen.dart`
- `WorkoutEditorScreen` → `TodayWorkoutScreen` へ遷移を変更
- import 文を更新

### 3. `lib/screens/calendar_history_screen.dart`
- `WorkoutEditorScreen` → `TodayWorkoutScreen` へ遷移を変更
- import 文を更新

### 4. `lib/screens/search_workouts_screen.dart`
- `WorkoutEditorScreen` → `TodayWorkoutScreen` へ遷移を変更
- import 文を更新

## 画面遷移フロー

```
HomeScreen
    ↓ (今日のワークアウトカードタップ)
TodayWorkoutScreen
    ├─ タイマー画面へ (Timer Icon)
    ├─ 筋トレ一覧へ (Button)
    │   ↓
    │   WorkoutExerciseListScreen
    │       ├─ 種目追加 (Button)
    │       │   ↓
    │       │   ExercisePickerScreen
    │       │       ↓
    │       │       WorkoutExerciseEditScreen (新規)
    │       │           ↓ (保存/削除)
    │       │           WorkoutExerciseListScreen (戻る)
    │       │
    │       └─ 種目タップ
    │           ↓
    │           WorkoutExerciseEditScreen (編集)
    │               ↓ (保存/削除)
    │               WorkoutExerciseListScreen (戻る)
    │
    └─ 保存して完了 (Button)
        ↓
        HomeScreen (戻る)
```

## データフロー

### 状態管理
- `WorkoutProvider` を使用して Workout の状態を一元管理
- 各画面は `context.read<WorkoutProvider>()` でデータを取得・更新
- 画面遷移時は Workout オブジェクトを引数として渡す

### データ更新タイミング
1. **TodayWorkoutScreen**: 
   - タイトル・メモの変更時に isDirty フラグを設定
   - 保存ボタン押下時に WorkoutProvider 経由で更新
   - 筋トレ一覧から戻った時に最新データを再取得

2. **WorkoutExerciseListScreen**: 
   - 表示のみ（直接の更新なし）
   - 編集画面から戻った時に最新データを再取得
   - Pull-to-refresh で最新データを取得

3. **WorkoutExerciseEditScreen**: 
   - 保存ボタン押下時に WorkoutProvider 経由で更新
   - 削除時も WorkoutProvider 経由で削除
   - 戻り値（true/false）で更新有無を通知

### 変更確認ダイアログ
- 各画面で変更があった場合（isDirty フラグ）、戻る時に確認ダイアログを表示
- ユーザーは「保存する」「保存しない」「キャンセル」を選択可能
- PopScope を使用してシステムバックボタンにも対応

## 既存機能の維持

以下の既存機能は全て維持されています：
- ワークアウト完了時のコイン・チケット獲得
- 前回の記録表示・コピー機能
- セット入力UI（SetInputRow）
- ワークアウト名の履歴から選択
- タイマー画面への遷移
- 週次目標のチェック
- 空のワークアウトの自動削除

## 利点

### 1. 責務の明確化
- 各画面が単一の責務を持つようになり、コードの理解が容易に
- 概要表示、一覧表示、詳細編集が明確に分離

### 2. UIの改善
- 一覧画面が簡潔になり、多数の種目がある場合でも見やすい
- 編集画面が独立し、集中して入力できる
- 概要画面で全体像を把握しやすい

### 3. 保守性の向上
- 各画面が独立しているため、個別の修正が容易
- 新機能の追加が容易（例：一覧画面に並び替え機能を追加）
- テストが書きやすい

### 4. パフォーマンス
- 不要な再ビルドを削減
- 画面ごとに必要なデータのみを管理

## 注意事項

### 既存の WorkoutEditorScreen について
- `lib/screens/workout_editor_screen.dart` は残していますが、現在は使用されていません
- 後方互換性のため削除していませんが、必要に応じて削除可能です

### テスト推奨項目
1. ワークアウトの新規作成フロー
2. 既存ワークアウトの編集フロー
3. 種目の追加・編集・削除
4. 変更の保存・破棄
5. ワークアウト完了処理
6. コイン・チケットの獲得
7. 前回の記録のコピー
8. 空のワークアウトの自動削除
9. 各画面での戻るボタンの動作
10. Pull-to-refresh による最新データ取得

## 次のステップ

1. **動作確認**: 全フローをテストして動作を確認
2. **UI調整**: 必要に応じてデザインを微調整
3. **パフォーマンス最適化**: 大量データでの動作確認
4. **ユーザーフィードバック**: 実際の使用感を確認
5. **旧コードの削除**: 問題なければ `workout_editor_screen.dart` を削除
