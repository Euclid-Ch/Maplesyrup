

function ExtendedKeyboardKey.getKeyName(self, key)
  return self.keyNameByCode[key] or ""
end

function ExtendedKeyboardKey.OnBeginPlay(self)
  local keyCode = {
    None = 0,
    Backspace = 8,
    Tab = 9,
    Clear = 12,
    Return = 13,
    Pause = 19,
    Escape = 27,
    Space = 32,
    Exclaim = 33,
    DoubleQuote = 34,
    Hash = 35,
    Dollar = 36,
    Percent = 37,
    Ampersand = 38,
    Quote = 39,
    LeftParen = 40,
    RightParen = 41,
    Asterisk = 42,
    Plus = 43,
    Comma = 44,
    Minus = 45,
    Period = 46,
    Slash = 47,
    Alpha0 = 48,
    Alpha1 = 49,
    Alpha2 = 50,
    Alpha3 = 51,
    Alpha4 = 52,
    Alpha5 = 53,
    Alpha6 = 54,
    Alpha7 = 55,
    Alpha8 = 56,
    Alpha9 = 57,
    Colon = 58,
    Semicolon = 59,
    Less = 60,
    Equals = 61,
    Greater = 62,
    Question = 63,
    At = 64,
    LeftBracket = 91,
    Backslash = 92,
    RightBracket = 93,
    Caret = 94,
    Underscore = 95,
    BackQuote = 96,
    A = 97,
    B = 98,
    C = 99,
    D = 100,
    E = 101,
    F = 102,
    G = 103,
    H = 104,
    I = 105,
    J = 106,
    K = 107,
    L = 108,
    M = 109,
    N = 110,
    O = 111,
    P = 112,
    Q = 113,
    R = 114,
    S = 115,
    T = 116,
    U = 117,
    V = 118,
    W = 119,
    X = 120,
    Y = 121,
    Z = 122,
    LeftCurlyBracket = 123,
    Pipe = 124,
    RightCurlyBracket = 125,
    Tilde = 126,
    Delete = 127,
    Keypad0 = 256,
    Keypad1 = 257,
    Keypad2 = 258,
    Keypad3 = 259,
    Keypad4 = 260,
    Keypad5 = 261,
    Keypad6 = 262,
    Keypad7 = 263,
    Keypad8 = 264,
    Keypad9 = 265,
    KeypadPeriod = 266,
    KeypadDivide = 267,
    KeypadMultiply = 268,
    KeypadMinus = 269,
    KeypadPlus = 270,
    KeypadEnter = 271,
    KeypadEquals = 272,
    UpArrow = 273,
    DownArrow = 274,
    RightArrow = 275,
    LeftArrow = 276,
    Insert = 277,
    Home = 278,
    End = 279,
    PageUp = 280,
    PageDown = 281,
    F1 = 282,
    F2 = 283,
    F3 = 284,
    F4 = 285,
    F5 = 286,
    F6 = 287,
    F7 = 288,
    F8 = 289,
    F9 = 290,
    F10 = 291,
    F11 = 292,
    F12 = 293,
    F13 = 294,
    F14 = 295,
    F15 = 296,
    Numlock = 300,
    CapsLock = 301,
    ScrollLock = 302,
    RightShift = 303,
    LeftShift = 304,
    RightControl = 305,
    LeftControl = 306,
    RightAlt = 307,
    LeftAlt = 308,
    RightCommand = 309,
    RightApple = 309,
    LeftCommand = 310,
    LeftApple = 310,
    LeftWindows = 311,
    RightWindows = 312,
    AltGr = 313,
    Help = 315,
    Print = 316,
    SysReq = 317,
    Break = 318,
    Menu = 319,
    Mouse0 = 323,
    Mouse1 = 324,
    Mouse2 = 325
  }
  self.KeyTable = keyCode
  local keyNames = {}
  for keyName, key in ___MOD.pairs(keyCode) do
    keyNames[key] = keyName
  end
  keyNames[self.RightCommand] = "RightCommand"
  keyNames[self.LeftCommand] = "LeftCommand"
  self.keyNameByCode = keyNames
  local defaultConfig = {
    {
      key = ___MOD._ExtendedKeyboardKey.E,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.EQUIP
    },
    {
      key = ___MOD._ExtendedKeyboardKey.I,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.INVENTORY
    },
    {
      key = ___MOD._ExtendedKeyboardKey.Alpha1,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.TO_ALL
    },
    {
      key = ___MOD._ExtendedKeyboardKey.LeftBracket,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.SHORTCUT
    },
    {
      key = ___MOD._ExtendedKeyboardKey.RightBracket,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.QUICKSLOT
    },
    {
      key = ___MOD._ExtendedKeyboardKey.Quote,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.CHATPLUS
    },
    {
      key = ___MOD._ExtendedKeyboardKey.G,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.GUILD
    },
    {
      key = ___MOD._ExtendedKeyboardKey.Alpha4,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.TO_GUILD
    },
    {
      key = ___MOD._ExtendedKeyboardKey.P,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.PARTY
    },
    {
      key = ___MOD._ExtendedKeyboardKey.S,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.ABILITY
    },
    {
      key = ___MOD._ExtendedKeyboardKey.L,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.NOTIFICATION
    },
    {
      key = ___MOD._ExtendedKeyboardKey.B,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.MONSTERBOOK
    },
    {
      key = ___MOD._ExtendedKeyboardKey.BackQuote,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.CASHSHOP
    },
    {
      key = ___MOD._ExtendedKeyboardKey.K,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.SKILL
    },
    {
      key = ___MOD._ExtendedKeyboardKey.R,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.FRIEND
    },
    {
      key = ___MOD._ExtendedKeyboardKey.W,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.WORLDMAP
    },
    {
      key = ___MOD._ExtendedKeyboardKey.Z,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.LOOT
    },
    {
      key = ___MOD._ExtendedKeyboardKey.X,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.SIT
    },
    {
      key = ___MOD._ExtendedKeyboardKey.H,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.WHISPER
    },
    {
      key = ___MOD._ExtendedKeyboardKey.LeftControl,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.ATTACK
    },
    {
      key = ___MOD._ExtendedKeyboardKey.RightControl,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.ATTACK
    },
    {
      key = ___MOD._ExtendedKeyboardKey.LeftAlt,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.JUMP
    },
    {
      key = ___MOD._ExtendedKeyboardKey.RightAlt,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.JUMP
    },
    {
      key = ___MOD._ExtendedKeyboardKey.Space,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.CHAT_NPC
    },
    {
      key = ___MOD._ExtendedKeyboardKey.Alpha5,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.TO_CHANNEL
    },
    {
      key = ___MOD._ExtendedKeyboardKey.C,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.MESSENGER
    },
    {
      key = ___MOD._ExtendedKeyboardKey.M,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.MINIMAP
    },
    {
      key = ___MOD._ExtendedKeyboardKey.Q,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.QUEST
    },
    {
      key = ___MOD._ExtendedKeyboardKey.Backslash,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.KEYCONFIG
    },
    {
      key = ___MOD._ExtendedKeyboardKey.Alpha2,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.TO_PARTY
    },
    {
      key = ___MOD._ExtendedKeyboardKey.Alpha3,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.TO_FRIEND
    },
    {
      key = ___MOD._ExtendedKeyboardKey.F1,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.EMOTION_1
    },
    {
      key = ___MOD._ExtendedKeyboardKey.F2,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.EMOTION_2
    },
    {
      key = ___MOD._ExtendedKeyboardKey.F3,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.EMOTION_3
    },
    {
      key = ___MOD._ExtendedKeyboardKey.F4,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.EMOTION_4
    },
    {
      key = ___MOD._ExtendedKeyboardKey.F5,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.EMOTION_5
    },
    {
      key = ___MOD._ExtendedKeyboardKey.F6,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.EMOTION_6
    },
    {
      key = ___MOD._ExtendedKeyboardKey.F7,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.EMOTION_7
    },
    {
      key = ___MOD._ExtendedKeyboardKey.F12,
      type = ___MOD._KeyConfigType.ACTION,
      id = ___MOD._KeyConfigActionType.DPS
    }
  }
  self.defaultKeyTable = defaultConfig
end
