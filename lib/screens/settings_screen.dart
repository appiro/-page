import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/economy_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final economy = context.watch<EconomyProvider>();
    final profile = economy.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: auth.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildSectionHeader(context, 'アカウント'),
                if (!auth.isAuthenticated)
                  ListTile(
                    leading: const Icon(Icons.account_circle, size: 32, color: Colors.grey),
                    title: const Text('Googleでログイン・データ引き継ぎ'),
                    subtitle: const Text('現在のデータをクラウドに保存し、他の端末でも利用できるようにします'),
                    isThreeLine: true,
                    onTap: () async {
                      final success = await auth.signInWithGoogle();
                      if (context.mounted) {
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('ログインしました')),
                          );
                        } else if (auth.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('ログインエラー: ${auth.errorMessage}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                  )
                else ...[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: auth.user?.photoURL != null ? NetworkImage(auth.user!.photoURL!) : null,
                      child: auth.user?.photoURL == null ? const Icon(Icons.person) : null,
                    ),
                    title: Text(auth.user?.displayName ?? 'ユーザー'),
                    subtitle: Text(auth.user?.email ?? ''),
                    trailing: OutlinedButton(
                      child: const Text('ログアウト'),
                      onPressed: () async {
                        await auth.signOut();
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.cloud_upload_outlined),
                    title: const Text('ゲストデータを引き継ぐ'),
                    subtitle: const Text('端末内のデータを現在のアカウントにコピーします'),
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: const Text('データの引き継ぎ'),
                          content: const Text('現在端末に残っているデータ（ワークアウト履歴など）を、ログイン中のアカウントにコピーします。\n\n※既にデータがある場合、実行するとデータが重複する可能性があります。'),
                          actions: [
                            TextButton(child: const Text('キャンセル'), onPressed: () => Navigator.pop(c, false)),
                            TextButton(child: const Text('実行'), onPressed: () => Navigator.pop(c, true)),
                          ],
                        ),
                      );
                      
                      if (confirm == true && context.mounted) {
                        final success = await auth.syncLocalDataToCloud();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success ? 'データを引き継ぎました' : 'エラーが発生しました: ${auth.errorMessage}'),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],

                const Divider(),
                _buildSectionHeader(context, '一般設定'),
                
                SwitchListTile(
                   title: const Text('通知'),
                   value: profile?.notificationsOn ?? true,
                   onChanged: (val) {
                      economy.updateSettings({'notificationsOn': val});
                   },
                ),
                 SwitchListTile(
                   title: const Text('バイブレーション'),
                   value: profile?.vibrationOn ?? true,
                   onChanged: (val) {
                      economy.updateSettings({'vibrationOn': val});
                   },
                ),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
