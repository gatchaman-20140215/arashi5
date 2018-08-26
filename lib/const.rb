# 根拠地種別
BASE_TYPE = %w(通常 重要 出現 連合 日本)

# 工場種別
FACTORY_TYPE = %w(無し 重要 製鉄 製油 人造石油 航空機 弾薬 造船 運河 核兵器)

# 資源
resource = %w(原油 鉄鉱石 石炭 鉄礬土 食糧)
resource[13] = '無し'
RESOURCE = resource

# 製造会社
MAKER_JP = %w(三菱 中島 愛知 川西 九州 川崎 立川 昭和 空廠 航廠)
MAKER_US = %w(ブリュスター グラマン ヴォート ライアン マクドネル グッドイヤー ダグラス カーチス ロッキード コンソリデーテッド
              マーチン ベル リパブリック ノースアメリカン ノースロップ ボーイング フェアリー スーパーマリン ホーカー ブリストル
              ブラックバーン デハビランド アブロ ポリカルポフ イリューシン ツポレフ スホーイ ミグ ヤコブレフ ラボチキン
              ペトリャコフ)

# 航空機種別
airplane_type = Array.new
airplane_type[33] = '艦上戦闘機'
airplane_type[1] = '戦闘機'
airplane_type[17] = '重戦闘機'
airplane_type[51] = '軽爆撃機'
airplane_type[67] = '重爆撃機'
airplane_type[83] = '艦上爆撃機'
airplane_type[99] = '偵察機'
airplane_type[115] = '艦上偵察機'
airplane_type[131] = '水上偵察機'
airplane_type[147] = '小型水上偵察機'
airplane_type[163] = '飛行艇'
airplane_type[179] = '輸送機'
airplane_type[195] = '艦上攻撃機'
AIRPLANE_TYPE = airplane_type

# 艦船種別
ship_type = Array.new
ship_type[1] = '装甲空母'
ship_type[17] = '空母'
ship_type[33] = '軽空母'
ship_type[49] = '護衛空母'
ship_type[67] = '戦艦'
ship_type[83] = '航空戦艦'
ship_type[99] = '重巡洋艦'
ship_type[121] = '軽巡洋艦'
ship_type[131] = '航空巡洋艦'
ship_type[153] = '駆逐艦'
ship_type[169] = '海防艦'
ship_type[181] = '輸送船'
ship_type[197] = 'タンカー'
SHIP_TYPE = ship_type

# 国名（基地用）
COUNTRY_BASE = %w(大日本帝國 ダミー アメリカ オーストラリア イギリス ソビエト 中国 オランダ)
# 国名（艦船用）
COUNTRY_SHIP = %w(大日本帝國 ダミー ダミー オーストラリア イギリス ソビエト 中国 オランダ アメリカ)
