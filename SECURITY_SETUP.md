# セキュリティ設定ガイド

このプロジェクトでは、APIキーやその他の機密情報を安全に管理するために環境変数を使用しています。

## 初期設定

### 1. 環境変数ファイルの作成

`.env.example`ファイルを`.env`にコピーして、実際の値を設定してください：

```bash
cp .env.example .env
```

### 2. Firebase設定値の取得

以下の手順でFirebaseの設定値を取得してください：

1. [Firebase Console](https://console.firebase.google.com/)にアクセス
2. プロジェクトを選択
3. プロジェクト設定 → 全般 → あなたのアプリ セクションで各プラットフォームの設定を確認
4. 取得した値を`.env`ファイルに記載

### 3. 必要な環境変数

以下の環境変数を`.env`ファイルに設定してください：

```env
# Firebase Web設定
FIREBASE_API_KEY_WEB=your_web_api_key_here
FIREBASE_APP_ID_WEB=your_web_app_id_here

# Firebase Android設定
FIREBASE_API_KEY_ANDROID=your_android_api_key_here
FIREBASE_APP_ID_ANDROID=your_android_app_id_here

# Firebase iOS設定
FIREBASE_API_KEY_IOS=your_ios_api_key_here
FIREBASE_APP_ID_IOS=your_ios_app_id_here
FIREBASE_IOS_CLIENT_ID=your_ios_client_id_here
FIREBASE_IOS_BUNDLE_ID=your_ios_bundle_id_here

# 共通設定
FIREBASE_MESSAGING_SENDER_ID=your_messaging_sender_id_here
FIREBASE_PROJECT_ID=your_project_id_here
FIREBASE_AUTH_DOMAIN=your_auth_domain_here
FIREBASE_STORAGE_BUCKET=your_storage_bucket_here
FIREBASE_MEASUREMENT_ID=your_measurement_id_here

# Google Sign-In
GOOGLE_SIGN_IN_CLIENT_ID=your_google_sign_in_client_id_here
```

## セキュリティ対策

### 実装済みの対策

1. **環境変数の使用**: 機密情報を環境変数で管理
2. **.gitignore設定**: 機密ファイルをGitから除外
3. **設定ファイルの分離**: セキュアなFirebase設定ファイルを作成
4. **バリデーション**: 設定値の検証機能を実装

### 除外されるファイル

以下のファイルはGitリポジトリにコミットされません：

- `.env` (実際の環境変数)
- `google-services.json` (Firebase設定)
- `firebase_options.dart` (元のFirebase設定)
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

### 本番環境での注意点

1. **CI/CDでの環境変数設定**: GitHub ActionsやCI/CDツールで環境変数を設定
2. **サーバーサイドでの検証**: 可能な限りサーバーサイドでAPI呼び出しを検証
3. **Firebase Rulesの設定**: Firestoreセキュリティルールを適切に設定
4. **定期的なキーローテーション**: APIキーを定期的に更新

## トラブルシューティング

### アプリが起動しない場合

1. `.env`ファイルが存在することを確認
2. 必要な環境変数がすべて設定されていることを確認
3. Firebase設定値が正しいことを確認

### デバッグモードでの確認

デバッグモードでは、不足している環境変数に関する警告メッセージがコンソールに表示されます。

## 開発チーム向け

新しい開発者がプロジェクトに参加する際は：

1. この文書を読んでもらう
2. `.env.example`を参考に`.env`ファイルを作成してもらう
3. Firebase設定値を共有（セキュアな方法で）
4. アプリの動作確認を行う

## 参考リンク

- [Flutter環境変数の管理](https://pub.dev/packages/flutter_dotenv)
- [Firebase セキュリティ](https://firebase.google.com/docs/rules)
- [Flutter セキュリティベストプラクティス](https://flutter.dev/docs/development/data-and-backend/security)
