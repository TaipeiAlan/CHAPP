-- CHAPP Supabase Schema
-- 在 Supabase SQL Editor 執行此檔案

-- 使用者表
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  username TEXT UNIQUE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 考試記錄
CREATE TABLE quiz_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  local_id TEXT NOT NULL,
  date TEXT NOT NULL,
  score INTEGER,
  total INTEGER,
  quiz_type TEXT,
  entries JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, local_id)
);

-- 音讀錯題本
CREATE TABLE wrong_bank_audio (
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  key TEXT NOT NULL,
  sentence TEXT,
  target_char TEXT,
  correct_pinyin TEXT,
  meaning TEXT,
  wrong_count INTEGER DEFAULT 0,
  first_wrong TEXT,
  last_wrong TEXT,
  last_user_answer TEXT,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (user_id, key)
);

-- 字形錯題本
CREATE TABLE wrong_bank_shape (
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  key TEXT NOT NULL,
  shape_type TEXT,
  sentence TEXT,
  target_char TEXT,
  correct_char TEXT,
  correct_answer TEXT,
  wrong_char TEXT,
  pinyin TEXT,
  meaning TEXT,
  wrong_meaning TEXT,
  wrong_count INTEGER DEFAULT 0,
  first_wrong TEXT,
  last_wrong TEXT,
  last_user_answer TEXT,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (user_id, key)
);

-- RLS（無登入驗證，用 anon key 直接存取）
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE wrong_bank_audio ENABLE ROW LEVEL SECURITY;
ALTER TABLE wrong_bank_shape ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_all" ON users FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON quiz_records FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON wrong_bank_audio FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON wrong_bank_shape FOR ALL USING (true) WITH CHECK (true);
