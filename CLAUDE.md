# CLAUDE.md — CHAPP 專案說明

## 專案概述

CHAPP 是一個純前端的國中國語會考所需的字音、字型、字義測驗系統，所有功能封裝在單一 HTML 檔案中，不依賴任何外部框架或建置工具。

## 檔案結構

```
CHAPP/
├── CQuiz.html        # 主程式所在
├── CQBank.csv        # 初始題庫來源 CSV 檔案，格式請參考此檔案
├── CLAUDE.md         # 本說明檔
├── CHANGELOG.md      # 變更日誌（記錄每次的變更指示，以及變更結果）
├── Introduction.md   # 整體功能簡介（根據當下開發方向，整理最新的功能介紹在此檔案中）
├── VERSION           # 當前版本狀態（由 bump_version.sh 維護）
├── bump_version.sh   # 版本升版腳本
└── README.md         # GitHub README
```

## 技術架構

- **語言**: 純 HTML + CSS + JavaScript（ES6），零依賴
- **資料持久化**: `localStorage`（瀏覽器本地，無伺服器）
  - `Cquiz_banks` — 所有題庫資料（JSON 格式）
  - `Cquiz_active_bank` — 目前作答中的題庫 ID
  - `Cquiz_progress` — 作答進度
- **預設題庫**: 以 pipe-separated 字串嵌入 JS，透過 `parsePipeData()` 解析

## 關鍵常數與設定

### CQuiz.html

| 常數 / 變數 | 位置 | 說明 |
|---|---|---|
| `SPLIT_OPTIONS` | script 頂端 | 出題數選擇器的選項，例如 `[50, 100]`，可自由調整 |

## 核心狀態變數（quiz2.html）

| 變數 | 說明 |
|---|---|
| `Cbanks` | 所有題庫物件（`{ [id]: { name, data[] } }`） |
| `activeBankId` | 目前**作答**的題庫 ID |
| `editorBankId` | 目前**編輯區**正在編輯的題庫 ID（與 activeBankId 獨立） |
| `quizData` | 本次測驗的題目陣列（已隨機排序） |
| `quizGraded` | 是否已批改 |
| `quizStarted` | 是否已明確點選題庫開始測驗 |

## 重要函式說明

### 出題流程
1. `switchBank(id)` / `startNewQuiz()` — 啟動流程入口
2. `showCountSelector()` — 若題數 > `SPLIT_OPTIONS[0]`，顯示出題數選擇 UI
3. `doStartQuiz(n)` — 取前 n 題並隨機排序；若有剩餘則自動建立新題庫
4. `renderQuiz()` — 渲染題目卡片

### 批改流程
1. `finishQuiz()` / `fabFinish()` — 檢查是否全部作答（空白欄位 = 未作答；輸入空格 = 已作答）
2. `gradeQuiz()` — 批改、顯示統計、自動建立錯題題庫

### 題庫自動命名規則
```
原題庫名稱_YYYYMMDD
範例: V2000_20260310
```


## 安全注意事項

- **不要將管理密碼記錄在此檔案或任何版本控制檔案中**。密碼儲存在 JS 原始碼內，為客戶端可見的明文，適合個人使用情境，不適用於多人共用或公開部署的環境。
- `localStorage` 資料存在使用者的瀏覽器中，無加密保護，不應儲存敏感個人資料。
- 本系統不包含任何伺服器端邏輯，無 API 呼叫，無跨站風險。

## 開發慣例

- 所有修改以 **單一 HTML 檔案為單位**，不引入外部 JS/CSS 檔案
- 新增功能優先考慮是否影響 `localStorage` 結構（升版時需注意向下相容）
- 自動建立題庫（拆分、錯題）只增加，不修改既有題庫資料
- Git branch 命名規則：`claude/功能描述-sessionId`

## 版本管理（必須遵守）

每次完成任何修改任務後，**必須**執行以下步驟：

1. 執行版本升版腳本：
   ```bash
   bash /home/user/CHAPP/bump_version.sh
   ```
2. 在回覆結尾加上版本變更說明，格式如下：
   ```
   **版本更新：{舊版本} → {新版本}**
   ```

### 版本格式規則

```
v年月日_時分_次
範例：v20260320_1540_1
```

- **年月日**：8 位數日期（YYYYMMDD）
- **時分**：4 位數時間（HHMM，24 小時制）
- **次**：當天的第幾次版本，每天從 1 重新計算

### 相關檔案

| 檔案 | 說明 |
|------|------|
| `VERSION` | 儲存當前版本狀態（日期、次數、版本字串），每次 bump 自動更新 |
| `bump_version.sh` | 版本升版腳本，輸出「舊版本 → 新版本」字串 |
