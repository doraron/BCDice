#--*-coding:utf-8-*--

class ParasiteBlood < DemonParasite
  def gameName
    'パラサイトブラッド'
    end

  def gameType
    "ParasiteBlood"
  end
  
  def prefixs
     ['(N|A|M|U|C|)?URGE\d+']
  end
  
  def getHelpMessage
    info = <<INFO_MESSAGE_TEXT
・衝動表　(URGEx)
　"URGE衝動レベル"の形で指定します。
　衝動表に従って自動でダイスロールを行い、結果を表示します。
　ダイスロールと同様に、他のプレイヤーに隠れてロールすることも可能です。
　頭に識別文字を追加して、デフォルト以外の衝動表もロールできます。
　・AURGEx　頭に「A」を付けると「誤作動表」。
例）URGE1　　　urge5　　　Aurge2
・D66ダイスあり
INFO_MESSAGE_TEXT
  end
  
  
  def get_urge(string)    # パラサイトブラッドの衝動表
    urge = []

    unless(/(\w*)URGE\s*(\d+)/i =~ string)
      return '1'
    end
    
    initialWord = $1
    urgelv = $2.to_i
    
    case initialWord
    when ""
      urge_type = 1;
    when /A/i    # 誤作動表
      urge_type = 2;
    else         # あり得ない文字
      urge_type = 1;
    end
    
    if((urgelv < 1) or (urgelv > 5))
      return '衝動段階は1から5です';
    end

    if(urge_type == 0)
      return '1';
    end
    
    dice_now, dice_str = roll(2, 6);
    urge = get_pb_urge_table(urgelv, dice_now, urge_type)
    resultText = "#{urgelv}-#{dice_now}:#{urge}"
    if(urge_type <= 1)
      output = "衝動表#{resultText}"
    elsif(urge_type <= 2)
      output = "誤作動表#{resultText}"
    else
      output = '1'
    end
    
    return output;
  end
  
  
  def get_pb_urge_table(level, dice, urge_type)
    table = nil
    
    if(urge_type <= 1)  # 衝動表
      table =  get_pb_normal_urge_table;
    elsif(urge_type <= 2)  # AASとサイボーグの誤作動表
      table = get_pb_aas_urge_table;
    else   # エラートラップ
      table = get_pb_normal_urge_table;
    end
    
    return table[level - 1 ][dice - 2];
  end
  
  def get_pb_normal_urge_table
    return [[
        '『怒り/20』突然強い怒りに駆られる。最も近い対象を罵倒し、そのターンの終了まで[行動不能]となる。',
        '『暗闇/20』視神経に悪影響が出て、24時間[暗闇]になる。',
        '『悲哀/10』突然の悲みに動きが止まる。そのターンの終了まで[行動不能]となる。',
        '『微笑/10』可笑しくてしょうがない。笑いが止まらず、そのターンの終了まで[行動不能]となる。',
        '『鈍感/ 0』衝動に気が付かない。影響なし。',
        '『抑制/ 0』衝動を抑制した。影響なし。',
        '『我慢/ 0』衝動を我慢した。影響なし。',
        '『前兆/10』悪魔的特徴が1ターン(10秒)目立つ。〈悪魔化〉時は影響なし。',
        '『変化/10』利き腕や前脚のみ、2ターン(20秒)かけて〈悪魔化〉する。〈悪魔化〉時は影響なし。',
        '『拒絶/10』〈悪魔化〉が解除される。通常時は影響なし。',
        '『定着/20』通常時であれば、即座に〈悪魔化〉する。肉体が〈悪魔化〉に馴染み、24時間通常時に戻れない。',
        ],
      [
        '『賛美/20』最も近くの対象を主と思いこむ。1時間または自身か対象が[気絶・戦闘不能・死亡]するまで、対象のあらゆる命令を聞く。',
        '『茫然/20』思考が停止。そのターンの終了まで[タイミング:攻撃]を行えない。',
        '『苦痛/20』"悪魔寄生体"が体内で暴れる。苦痛を感じ、【エナジー】を10消費。',
        '『落涙/10』過去の悲しい想い出が去来し、涙が溢れる。そのターンの終了まで[タイミング:準備]を行えない。',
        '『限界/10』溢れる力が限界を超え、全身の血管が破裂。【エナジー】を5消費。',
        '『辛抱/10』突如全身が〈悪魔化〉しようとしたが、意思の力で抑制。【エナジー】を5消費。〈悪魔化〉時は影響なし。',
        '『忍耐/ 0』衝動に耐えた。影響なし。',
        '『抑制/ 0』衝動を抑制した。影響なし。',
        '『我慢/ 0』衝動を我慢した。影響なし。',
        '『嫉妬/10』最も近くの対象に猛烈な嫉妬を感じ、[距離:移動10m/対象:1体]に通常肉弾攻撃を行う。',
        '『変貌/20』〈悪魔化〉する。その際、特異な外見が目立つ。〈悪魔化〉時は影響なし。',
      ],
      [
        '『異貌/20』3ターンかけて、顔のみが〈悪魔化〉する。〈悪魔化〉時は影響なし。',
        '『解放/20』衝動に耐えきれず3ターンかけて〈悪魔化〉する。〈悪魔化〉時は影響なし。',
        '『発露/20』全身を駆け抜ける衝動により力が溢れる。次のターンの終了まで、ダメージに+5。',
        '『渇望/10』攻撃衝動を抑えられない。次のターンの終了まで、命中判定の達成値に+5。',
        '『絶叫/10』あらん限りの声で叫び、力が増す。次のターンの終了まで、ダメージに+1d。',
        '『我慢/ 0』衝動を我慢した。影響なし。',
        '『憤怒/10』全身に怒りが満ちて攻撃力上昇。次のターンの終了まで、ダメージに+1d。',
        '『加速/10』全身を駆け抜ける衝動により速度上昇。次のターンの終了まで【行動値】が2倍。',
        '『嫌悪/20』最も近くの対象に嫌悪を感じ、[距離:移動10m/対象:1体]に通常肉弾攻撃を行う。',
        '『保身/20』突如として防御能力が高まる。次のターンの終了まで、防御力に+5。',
        '『救済/20』"悪魔寄生体"が危機を察知し、【エナジー】を20回復。',
      ],
      [
        '『転倒/20』踏み込んだ瞬間、あまりの衝撃に地面をえぐり[転倒]してしまう。',
        '『脱力/20』急に力が抜ける。そのターンの終了まで、判定の達成値に-5。',
        '『困惑/20』精神に変調があらわれ、空間認識能力が狂う。次のターンの終了まで、[タイミング:瞬間]の《特殊能力》を行えない。',
        '『全力/20』激しい躁状態。次のターンの終了まで、命中判定に+10。加えて[タイミング:ターン開始]の《特殊能力》を使用できなくなる。',
        '『咆吼/10』大声で叫び、意味のある言葉を話せなくなる。１時間持続する。',
        '『狂気/10』心が狂気に満たされ、強いストレスを感じる。【衝動】を2蓄積させる。',
        '『本能/20』"悪魔寄生体"の生存本能が自我を支配。次のターンの終了まで、ダメージに+5。',
        '『治癒/20』衝動を1蓄積させ、《肉体修復》を行う。',
        '『敵意/20』最も近い対象に強い敵意を抱く。[距離:移動10m/対象:1体]に通常肉弾攻撃を行い、クリティカルとなる。',
        '『自虐/20』自分が許せず自虐行為を行う。【エナジー】を10消費するが、次のターンの終了までダメージに+10。',
        '『自浄/20』少し我に返る。【衝動】が2回復。',
      ],
      [
        '『睡眠/30』猛烈な睡魔に襲われ意識を失う。そのターンの終了まで[気絶]となる。',
        '『飢餓/30』猛烈な飢餓感。20m以内の最も近い[気絶・戦闘不能・死亡]の対象へ移動し、喰らう。次のターンの終了まで、対象は【エナジー】を1dずつ消費。',
        '『激怒/20』突如として強い怒りが湧き、周囲が見えなくなる。次のターンの終了まで、[タイミング:瞬間]の《特殊能力》を行えない。',
        '『顕現/20』利き腕や前脚がさらに外骨格化し、肉体に強い負荷がかかる。【衝動】を3蓄積',
        '『好機/20』チャンスに本能が素早く反応。即座に[タイミング:攻撃]の行動を1回だけ行える。',
        '『狂化/20』精神に変調、心が強い狂気で満たされ、自虐行為に走る。【エナジー】を20消費する。',
        '『混乱/20』精神に変調が現れ、肉体を意のままに動かせない。次のターンの終了まで、判定の達成値に-5。',
        '『暴君/20』自分が最強に思えてしょうがない。60ターン(10分)の間、【行動値】とダメージに+5。',
        '『無双/20』達人の感覚が目覚める。60ターン(10分)の間、命中判定と回避判定の達成値に+5。',
        '『発現/30』通常時であれば、即座に《悪魔化》する。特異な外見が60ターン(10分)目立ち、その間、命中判定とダメージに+5。',
        '『絶望/30』全身が絶望に満たされ、全てを破壊したくなる。次のターンの終了まで、ダメージに+15。',
      ]]
  end
  

  #**パラサイトブラッドの誤作動表(2d6)
  def get_pb_aas_urge_table
    return [[
        #**第１段階
        '『緊急停止/20』機能異常の警報と共に、機能が緊急停止。次のターンのターン終了時まで［行動不能］となる。' ,
        '『動作不調/10』駆動系に異常発生。このターンのターン終了まで［行動不能］となる。' ,
        '『腕部停止/10』腕部機能に異常発生。このターンのターン終了まで［タイミング：攻撃］を失う。' ,
        '『視覚異常/10』センサー系に異常。60ターン（10分）の間、［暗闇］となる。' ,
        '『機能制動/0』機能が一瞬停止するが、以後正常に動作。影響なし。' ,
        '『機能安定/0』機能がむしろ安定した。影響なし。' ,
        '『不良調整/0』機能に違和感を覚えるが誤差の範囲内。影響なし。' ,
        '『機能暴発/10』兵装の調子が悪化。次のターンのターン終了まで、［タイミング：準備］の《兵装》が使用できない。' ,
        '『離脱機能/10』異常発生。即座に［戦闘移動］を行い、最も近い敵から遠ざかるように移動する。' ,
        '『排熱暴走/10』排熱機能に異常。次のターンのターン終了まで［着火］状態となる。特殊ダメージは本人のものを使用する。' ,
        '『電装異常/20』電装系に異常。即座に【負荷】が2点蓄積する。',
        ],
      
      #**第２段階
      [
        '『安全機能/20』セーフティが誤動作。このターンのターン終了まで判定の達成値に-5。' ,
        '『筋肉萎縮/20』人工筋肉に異常発生。60ターン（10分）の間、【肉体】判定の達成値に-2。' ,
        '『出力低下/20』駆動部に異常発生。60ターン（10分）の間、【機敏】判定の達成値に-2。' ,
        '『感覚異常/10』感覚機能に異常発生。60ターン（10分）の間、【感覚】判定の達成値に-2。' ,
        '『視界不良/10』視覚機能に異常発生。60ターン（10分）の間、【幸運】判定の達成値に-2。' ,
        '『機能安定/0』機能がむしろ安定した。影響なし。' ,
        '『不良調整/0』機能に違和感を覚えるが誤差の範囲内。影響なし。',
        '『援護不通/10』援護ソフトが誤作動。60ターン（10分）の間、【知力】判定の達成値に-2。' ,
        '『発声不調/20』通話機能に異常。60ターン（10分）の間、声を出しても雑音だらけになって意味が通じず、さらに【精神】判定の達成値に-2。' ,
        '『装甲軟化/20』防御機能に異常。次のターンのターン終了まで、防御力に-5。' ,
        '『装備異常/20』精密動作に異常発生。装備している［通常アイテム］の武器がランダムでひとつ、［装備］から外れる。' ,
      ],
      
      #**第３段階
      [
        '『動力漏電/20』動力が漏電し始める。【負荷】が2点蓄積する。' ,
        '『脚部異常/20』脚部に異常発生。次のターンのターン終了まで［戦闘移動］［全力移動］の距離が半分になる。' ,
        '『足下転倒/20』バランサーに異常発生。［転倒］状態となる。' ,
        '『出力向上/20』突然出力が上昇する。次のターンのターン終了まで、特殊ダメージに+1d。' ,
        '『機能制動/10』一瞬違和感を覚えるが、以後正常に動作。影響なし。' ,
        '『障壁減衰/10』電力が減衰する。【電力】を5消費する。' ,
        '『身体向上/10』格闘機能が向上。次のターンのターン終了まで、肉弾ダメージに+1d。' ,
        '『精度向上/20』火器管制機能が向上。次のターンのターン終了まで、射撃ダメージに+1d。' ,
        '『反射鋭化/20』反応速度が加速した。次のターンのターン終了まで、【行動値】に+5。' ,
        '『友軍誤認/20』警戒装置が誤動。最も近い［距離：移動10m/対象：1体］に通常肉弾攻撃を行う。' ,
        '『電子賦活/20』電磁障壁が突如復帰。【電力】が10回復する。' ,
        ],
      
      #**第４段階
      [
        '『照準誤認/20』照準機能に異常発生。最も近い［距離：移動10m/対象：1体］に通常肉弾攻撃を行う。判定は自動的にクリティカルとなる。' ,
        '『攻撃特化/20』攻撃機能が異常動作。次のターンのターン終了まで、ダメージに+2d。ただし、その間［タイミング：瞬間］を行えない。' ,
        '『機内窒息/20』呼吸機能に異常。次のターンのターン終了まで［窒息］状態となる。' ,
        '『自動援護/20』援護機能が自動的に作動する。即座に［タイミング：準備］を1回行う。',
        '『音声遮断/10』聴覚機能に異常発生。次のターンのターン終了まで一切の物音が聞こえず、回避判定の達成値に-5。' ,
        '『電流加速/10』突然電磁障壁が効率的に流れる。【電力】が10回復。' ,
        '『精密射撃/20』照準機能が向上。60ターン（10分間）の間、ダメージに+5。' ,
        '『緊急措置/20』突然、緊急時の対策機能が発動する。【負荷】が2蓄積し、【電力】が20回復する。' ,
        '『荷電暴走/20』電流の流れに異常が発生。【HP】を10消費し、次のターンのターン終了までダメージに+10。' ,
        '『状況分析/20』周辺解析ソフトが高速で動作。60ターン（10分間）の間、命中判定の達成値に+5。' ,
        '『機能再生/20』兵装に誤作動。取得済みの使用不能になった《兵装》を1つ指定し、再び使用できるようになる。' ,
        ],
      
      #**第５段階
      [
        '『機能停止/30』機能が作動しなくなる。このターンのターン終了まで、【負荷】を蓄積させる行動が取れなくなる。' ,
        '『機関暴走/30』放熱機関が暴走する。本人を中心として［対象：半径5m全て］が次のターンのターン終了まで［着火］状態となる。特殊ダメージはこの表を振ったPCのものを使用する。' ,
        '『電力低下/20』出力が上がらない。【電力】が20減少する。' ,
        '『急速修復/20』電磁障壁と生命維持装置が高速処理を始める。【HP】が20回復。' ,
        '『駆動不調/20』駆動系に動作不良。次のターンのターン終了まで、判定の達成値に-5。' ,
        '『機体清冽/20』機能が初期化され、異常から復帰。［気絶・死亡・戦闘不能］以外の状態変化がすべて解除される。' ,
        '『機体減速/20』運動機能が暴走。次のターンのターン終了まで【行動値】に-10（最低1）。' ,
        '『排毒噴出/20』排気機構が誤作動。［対象：半径5m全て］が次のターンのターン終了まで［猛毒］状態となる。' ,
        '『緊急駆動/20』機動性が向上。次のターンのターン終了まで判定の達成値に+5。' ,
        '『負荷軽減/30』急激に負荷が解消される。【負荷】が2点回復する。' ,
        '『出力過剰/30』全出力が過剰なまでに上昇する。次のターンのターン終了までダメージに+10。' ,
      ]]
  end
end
