# PixelPlay

![Flutter](https://img.shields.io/badge/Flutter-3-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3-0175C2?logo=dart)
![Android](https://img.shields.io/badge/Android-minSdk%2026-3DDC84?logo=android&logoColor=white)
![WebDAV](https://img.shields.io/badge/WebDAV-supported-4B8BBE)

PixelPlay 是一个基于 Flutter 构建的 Android 视频播放器项目，围绕“本地视频 + WebDAV 远程视频 + 收藏与播放记录”组织体验。项目使用 GetX 管理依赖与状态，使用 Isar 持久化设置、账户、收藏和播放进度，并通过 Pigeon 与 Android 原生层交互来接入 MediaStore 能力。

当前仓库的实现重点是 Android 平台，尤其适合需要浏览本地相册、连接 NAS/WebDAV 目录并统一播放视频的场景。

## 功能概览

- 本地媒体库：扫描 Android 本地视频相册，支持搜索、排序和按相册进入播放。
- WebDAV 云盘：支持添加、编辑、删除多个 WebDAV 账户，按目录浏览、搜索、排序远程视频。
- 网络直链播放：可直接输入视频 URL 播放，支持 `http`、`https`、`rtsp`、`rtmp`、`mms`、`ftp`、`ftps`。
- 收藏夹：将视频保存到收藏夹中，支持默认收藏夹和自定义收藏夹。
- 播放列表入口：可将“本地相册”或“WebDAV 目录”保存成播放列表入口，便于重复访问。
- 观看历史：支持搜索、筛选、批量选择、删除或清空历史记录。
- 播放器设置：支持默认倍速、长按倍速、播放模式、画面比例、滑动快进逻辑、自动播放、续播。
- 外观与动效：支持浅色、深色、跟随系统、主题主色切换，以及多种页面转场动画。
- 缓存管理：支持清理缩略图缓存与播放进度缓存。

## 技术栈

- Flutter / Dart 3
- [GetX](https://pub.dev/packages/get)
- [Isar Community](https://pub.dev/packages/isar_community)
- [media_kit](https://pub.dev/packages/media_kit)
- [webdav_client](https://pub.dev/packages/webdav_client)
- [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
- Pigeon + Kotlin + Android MediaStore

## 环境要求

- Flutter 3.x
- Dart 3.10.x
- Java 17
- Android SDK
- Android 8.0 及以上设备或模拟器（`minSdk = 26`）

当前仓库中的 Android 配置位于 [android/app/build.gradle.kts](android/app/build.gradle.kts)，编译目标为 `compileSdk 36`、`targetSdk 36`。

## 快速开始

### 1. 克隆项目

```bash
git clone https://github.com/Gabrielzw/pixelplay.git
cd pixelplay
```

### 2. 安装依赖

```bash
flutter pub get
```

### 3. 运行应用

```bash
flutter run
```

首次启动后，如果需要浏览本地视频，请按提示授予“视频访问权限”。

## 使用示例

### 浏览本地视频

1. 打开首页。
2. 授予视频访问权限。
3. 点击任意相册进入详情页并播放视频。

### 连接 WebDAV

1. 进入“云盘”页。
2. 添加 WebDAV 账户地址、用户名和密码。
3. 打开目录，选择视频即可播放。

### 添加播放列表入口

1. 进入“收藏”页。
2. 切换到“播放列表”标签。
3. 选择添加“本地相册”或“WebDAV 目录”。

### 直接播放网络视频

1. 在首页点击播放网络视频入口。
2. 输入可直连播放的视频 URL。
3. 确认后进入播放器。

## 开发命令

### 运行测试

```bash
flutter test
```

### 重新生成 Isar 代码

当你修改 [lib/shared/data/isar/schemas](lib/shared/data/isar/schemas) 下的模型后，执行：

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 重新生成 Pigeon 桥接代码

当你修改 [pigeons/media_store_albums_api.dart](pigeons/media_store_albums_api.dart) 后，执行：

```bash
dart run pigeon --input pigeons/media_store_albums_api.dart
```

### 构建 Android Release APK

```bash
flutter build apk --release
```

构建完成后，APK 会输出到 `build/outputs/flutter-apk/`，并按仓库中的 Gradle 任务格式化文件名。

## 项目结构

```text
.
|- lib/
|  |- app/                      # 应用入口、主题、路由、依赖绑定
|  |- features/
|  |  |- media_library/        # 本地媒体库
|  |  |- webdav_client/        # WebDAV 账户与目录浏览
|  |  |- player_core/          # 播放器核心
|  |  |- favorites/            # 收藏夹
|  |  |- playlist_sources/     # 播放列表入口
|  |  |- watch_history/        # 观看历史
|  |  |- settings/             # 设置页与偏好管理
|  |- shared/                  # 通用组件、工具、Isar 基础设施
|- android/                    # Android 原生实现
|- pigeons/                    # Flutter <-> Android 桥接定义
|- test/                       # Widget / Repository / Regression 测试
```

如果你想快速定位代码，可以优先查看：

- [lib/main.dart](lib/main.dart)：应用启动入口
- [lib/app/pixelplay_app.dart](lib/app/pixelplay_app.dart)：应用壳与主题装配
- [lib/app/bindings/app_bindings.dart](lib/app/bindings/app_bindings.dart)：依赖注入
- [lib/features/shell/presentation/pixelplay_shell.dart](lib/features/shell/presentation/pixelplay_shell.dart)：底部主导航
- [lib/features/player_core](lib/features/player_core)：播放器核心功能
- [lib/features/media_library](lib/features/media_library)：本地媒体库
- [lib/features/webdav_client](lib/features/webdav_client)：WebDAV 相关功能

## 获取帮助

- 仓库主页：[Gabrielzw/pixelplay](https://github.com/Gabrielzw/pixelplay)
- 问题反馈：[GitHub Issues](https://github.com/Gabrielzw/pixelplay/issues)
- 功能排查建议：
  - 本地媒体扫描问题先看 [lib/features/media_library](lib/features/media_library)
  - WebDAV 连接或目录问题先看 [lib/features/webdav_client](lib/features/webdav_client)
  - 播放器行为问题先看 [lib/features/player_core](lib/features/player_core)
  - 回归问题可从 [test](test) 中对应测试开始定位

## 维护与贡献

当前仓库未提供独立的 `CONTRIBUTING.md`，默认采用常见的 GitHub Issue / Pull Request 协作方式。

- 维护入口：GitHub 仓库所有者 [@Gabrielzw](https://github.com/Gabrielzw)
- 提交变更前建议至少执行：

```bash
flutter analyze
flutter test
```

- 如果改动涉及 Isar schema 或 Pigeon 接口，请同步重新生成代码并一并提交生成产物。

## 开源许可

本项目基于 `MIT License` 开源，详见 `LICENSE`。
