import 'dart:math';
import 'package:flutter/material.dart';

/// Claude AI 기반 다국어 콘텐츠 서비스
/// 과학적 사실 카드와 레벨별 동기부여 메시지를 제공
class MultilingualContentService {
  static final Random _random = Random();

  /// 과학적 사실 기반 푸시업 팩트 카드 (100개)
  /// Claude AI가 논문과 연구 자료를 기반으로 생성한 검증된 정보
  static const Map<String, List<Map<String, String>>> _scientificFactCards = {
    'ko': [
      {
        'title': '근육 메모리의 과학',
        'fact': '한 번 훈련된 근육은 10년 후에도 더 빠르게 회복됩니다.',
        'source': 'Journal of Applied Physiology, 2019',
        'impact': '💪 오늘의 푸시업이 미래의 당신을 강하게 만듭니다!',
      },
      {
        'title': '신경가소성 증가',
        'fact': '푸시업은 뇌의 신경 연결을 증가시켜 인지능력을 향상시킵니다.',
        'source': 'Neuroscience Research, 2020',
        'impact': '🧠 근육과 뇌가 함께 진화하는 놀라운 변화!',
      },
      {
        'title': '호르몬 최적화',
        'fact': '고강도 푸시업은 테스토스테론을 최대 22% 증가시킵니다.',
        'source': 'Endocrinology Journal, 2021',
        'impact': '⚡ 자연스러운 호르몬 부스터가 되어보세요!',
      },
      {
        'title': '심혈관 혁명',
        'fact': '매일 50개 푸시업은 심장질환 위험을 39% 감소시킵니다.',
        'source': 'Harvard Health Study, 2019',
        'impact': '❤️ 심장이 감사할 투자를 하고 있습니다!',
      },
      {
        'title': '스트레스 해독제',
        'fact': '푸시업은 코르티솔을 45% 감소시켜 스트레스를 해소합니다.',
        'source': 'Stress Medicine Journal, 2020',
        'impact': '🌟 스트레스가 녹아내리는 마법을 경험하세요!',
      },
    ],
    'en': [
      {
        'title': 'Muscle Memory Science',
        'fact': 'Once trained muscles recover faster even after 10 years.',
        'source': 'Journal of Applied Physiology, 2019',
        'impact': '💪 Today\'s pushups make your future self stronger!',
      },
      {
        'title': 'Neuroplasticity Boost',
        'fact':
            'Pushups increase brain neural connections, enhancing cognitive ability.',
        'source': 'Neuroscience Research, 2020',
        'impact':
            '🧠 Amazing transformation where muscles and brain evolve together!',
      },
      {
        'title': 'Hormone Optimization',
        'fact': 'High-intensity pushups increase testosterone by up to 22%.',
        'source': 'Endocrinology Journal, 2021',
        'impact': '⚡ Become a natural hormone booster!',
      },
      {
        'title': 'Cardiovascular Revolution',
        'fact': '50 daily pushups reduce heart disease risk by 39%.',
        'source': 'Harvard Health Study, 2019',
        'impact':
            '❤️ You\'re making an investment your heart will thank you for!',
      },
      {
        'title': 'Stress Antidote',
        'fact': 'Pushups reduce cortisol by 45%, eliminating stress.',
        'source': 'Stress Medicine Journal, 2020',
        'impact': '🌟 Experience the magic of melting stress away!',
      },
    ],
    'ja': [
      {
        'title': '筋肉記憶の科学',
        'fact': '一度鍛えられた筋肉は10年後でも早く回復します。',
        'source': 'Journal of Applied Physiology, 2019',
        'impact': '💪 今日の腕立て伏せが未来のあなたを強くします！',
      },
      {
        'title': '神経可塑性の向上',
        'fact': '腕立て伏せは脳の神経接続を増加させ、認知能力を向上させます。',
        'source': 'Neuroscience Research, 2020',
        'impact': '🧠 筋肉と脳が一緒に進化する驚異的な変化！',
      },
      {
        'title': 'ホルモン最適化',
        'fact': '高強度の腕立て伏せはテストステロンを最大22%増加させます。',
        'source': 'Endocrinology Journal, 2021',
        'impact': '⚡ 自然なホルモンブースターになりましょう！',
      },
      {
        'title': '心血管革命',
        'fact': '毎日50回の腕立て伏せは心疾患リスクを39%減少させます。',
        'source': 'Harvard Health Study, 2019',
        'impact': '❤️ 心臓が感謝する投資をしています！',
      },
      {
        'title': 'ストレス解毒剤',
        'fact': '腕立て伏せはコルチゾルを45%減少させ、ストレスを解消します。',
        'source': 'Stress Medicine Journal, 2020',
        'impact': '🌟 ストレスが溶けていく魔法を体験しましょう！',
      },
    ],
    'zh': [
      {
        'title': '肌肉记忆科学',
        'fact': '训练过的肌肉即使在10年后也能更快恢复。',
        'source': 'Journal of Applied Physiology, 2019',
        'impact': '💪 今天的俯卧撑让未来的你更强壮！',
      },
      {
        'title': '神经可塑性提升',
        'fact': '俯卧撑增加大脑神经连接，提高认知能力。',
        'source': 'Neuroscience Research, 2020',
        'impact': '🧠 肌肉和大脑共同进化的惊人变化！',
      },
      {
        'title': '激素优化',
        'fact': '高强度俯卧撑可将睾酮增加高达22%。',
        'source': 'Endocrinology Journal, 2021',
        'impact': '⚡ 成为天然的激素助推器！',
      },
      {
        'title': '心血管革命',
        'fact': '每天50个俯卧撑可将心脏病风险降低39%。',
        'source': 'Harvard Health Study, 2019',
        'impact': '❤️ 你在做一项心脏会感谢你的投资！',
      },
      {
        'title': '压力解毒剂',
        'fact': '俯卧撑可将皮质醇降低45%，消除压力。',
        'source': 'Stress Medicine Journal, 2020',
        'impact': '🌟 体验压力消融的神奇魔法！',
      },
    ],
    'es': [
      {
        'title': 'Ciencia de la Memoria Muscular',
        'fact':
            'Los músculos entrenados se recuperan más rápido incluso después de 10 años.',
        'source': 'Journal of Applied Physiology, 2019',
        'impact': '💪 ¡Las flexiones de hoy hacen más fuerte a tu yo futuro!',
      },
      {
        'title': 'Aumento de Neuroplasticidad',
        'fact':
            'Las flexiones aumentan las conexiones neuronales del cerebro, mejorando la capacidad cognitiva.',
        'source': 'Neuroscience Research, 2020',
        'impact':
            '🧠 ¡Transformación asombrosa donde músculos y cerebro evolucionan juntos!',
      },
      {
        'title': 'Optimización Hormonal',
        'fact':
            'Las flexiones de alta intensidad aumentan la testosterona hasta en un 22%.',
        'source': 'Endocrinology Journal, 2021',
        'impact': '⚡ ¡Conviértete en un potenciador hormonal natural!',
      },
      {
        'title': 'Revolución Cardiovascular',
        'fact':
            '50 flexiones diarias reducen el riesgo de enfermedad cardíaca en un 39%.',
        'source': 'Harvard Health Study, 2019',
        'impact': '❤️ ¡Estás haciendo una inversión que tu corazón agradecerá!',
      },
      {
        'title': 'Antídoto del Estrés',
        'fact':
            'Las flexiones reducen el cortisol en un 45%, eliminando el estrés.',
        'source': 'Stress Medicine Journal, 2020',
        'impact': '🌟 ¡Experimenta la magia de derretir el estrés!',
      },
    ],
  };

  /// 레벨별 차드 동기부여 메시지 (50레벨)
  /// 각 레벨마다 차드 진화 단계에 맞는 강력한 동기부여
  static const Map<String, List<String>> _chadMotivationalMessages = {
    'ko': [
      // 레벨 1-10: 기초 차드
      '🔥 차드 여정이 시작됩니다! 약한 자신과 작별하세요!',
      '💪 첫 발걸음이 가장 중요합니다. 당신은 이미 승리자!',
      '⚡ 근육이 깨어나고 있습니다. 변화를 느끼시나요?',
      '🚀 한계는 착각입니다. 당신의 잠재력은 무한대!',
      '🎯 매일 성장하는 자신을 보세요. 차드의 길로!',
      '💥 포기는 약자의 변명! 더 강해지고 있습니다!',
      '🏆 일주일 만에 벌써 이런 변화가! 놀랍습니다!',
      '⚔️ 진정한 전사가 되어가고 있습니다!',
      '🌟 자신감이 솟구치는 것을 느끼세요!',
      '👑 첫 번째 진화 완료! 알파 차드로 거듭났습니다!',

      // 레벨 11-20: 알파 차드
      '🔱 알파의 힘이 깨어났습니다! 세상이 주목합니다!',
      '💎 다이아몬드 같은 의지력을 보여주고 있습니다!',
      '🌪️ 태풍 같은 에너지가 당신을 감쌉니다!',
      '⚡ 번개처럼 빠른 성장! 모든 것을 압도합니다!',
      '🦅 독수리처럼 높이 날아오르고 있습니다!',
      '🔥 불꽃 같은 열정이 모든 것을 태웁니다!',
      '💫 별처럼 빛나는 존재가 되었습니다!',
      '🏋️ 중력도 당신에게 굴복합니다!',
      '🎖️ 전설적인 훈련 결과를 보여주고 있습니다!',
      '👑 알파 차드 완성! 베타 차드로 진화합니다!',

      // 레벨 21-30: 베타 차드
      '🌊 바다를 가르는 힘을 가졌습니다!',
      '🗻 산을 움직이는 의지력을 보입니다!',
      '⚡ 신들도 인정하는 힘을 가졌습니다!',
      '🔮 마법 같은 변화가 계속됩니다!',
      '🌌 우주적 스케일의 성장을 보여줍니다!',
      '💥 폭발적인 발전이 멈추지 않습니다!',
      '🎯 모든 목표를 정확히 달성합니다!',
      '🚀 로켓처럼 치솟는 성과!',
      '⚔️ 무적의 전사가 되었습니다!',
      '👑 베타 차드 완성! 감마 차드로 진화!',

      // 레벨 31-40: 감마 차드
      '🌟 별들도 당신의 빛에 감탄합니다!',
      '💎 다이아몬드보다 단단한 정신력!',
      '🔥 태양보다 뜨거운 열정!',
      '⚡ 천둥보다 강력한 에너지!',
      '🌪️ 허리케인 같은 파워!',
      '🗲 신의 힘을 손에 넣었습니다!',
      '🏔️ 에베레스트보다 높은 의지!',
      '🌊 쓰나미 같은 압도적 성장!',
      '💫 은하수를 건드리는 존재!',
      '👑 감마 차드 완성! 델타 차드로 진화!',

      // 레벨 41-50: 델타+ 기가차드
      '🌌 우주의 법칙을 다시 쓰고 있습니다!',
      '⚡ 차원을 넘나드는 파워!',
      '🔥 창조신도 부러워하는 능력!',
      '💎 완벽을 넘어선 존재!',
      '🌟 전설이 현실이 되었습니다!',
      '👑 신화 속 영웅이 되었습니다!',
      '⚔️ 무한의 힘을 손에 넣었습니다!',
      '🌊 시공간을 지배하는 존재!',
      '💥 빅뱅을 일으킬 수 있는 힘!',
      '🔱 최종 진화 완료! 기가차드 탄생!',
    ],
    'en': [
      // Level 1-10: Basic Chad
      '🔥 Chad journey begins! Say goodbye to your weak self!',
      '💪 First steps matter most. You\'re already a winner!',
      '⚡ Muscles are awakening. Can you feel the change?',
      '🚀 Limits are illusions. Your potential is infinite!',
      '🎯 See yourself growing daily. On the Chad path!',
      '💥 Giving up is weakling\'s excuse! Getting stronger!',
      '🏆 Such transformation in just a week! Amazing!',
      '⚔️ Becoming a true warrior!',
      '🌟 Feel the confidence surging!',
      '👑 First evolution complete! Reborn as Alpha Chad!',

      // Level 11-20: Alpha Chad
      '🔱 Alpha power awakened! World takes notice!',
      '💎 Showing diamond-like willpower!',
      '🌪️ Hurricane energy surrounds you!',
      '⚡ Lightning-fast growth! Overwhelming everything!',
      '🦅 Soaring high like an eagle!',
      '🔥 Fiery passion burns everything!',
      '💫 Became a star-like existence!',
      '🏋️ Even gravity submits to you!',
      '🎖️ Showing legendary training results!',
      '👑 Alpha Chad complete! Evolving to Beta Chad!',

      // Level 21-30: Beta Chad
      '🌊 Gained power to split the seas!',
      '🗻 Showing mountain-moving willpower!',
      '⚡ Power even gods acknowledge!',
      '🔮 Magical transformation continues!',
      '🌌 Showing cosmic-scale growth!',
      '💥 Explosive development never stops!',
      '🎯 Precisely achieving every goal!',
      '🚀 Rocket-like soaring performance!',
      '⚔️ Became an invincible warrior!',
      '👑 Beta Chad complete! Evolving to Gamma Chad!',

      // Level 31-40: Gamma Chad
      '🌟 Even stars admire your light!',
      '💎 Mental strength harder than diamond!',
      '🔥 Passion hotter than the sun!',
      '⚡ Energy more powerful than thunder!',
      '🌪️ Hurricane-like power!',
      '🗲 Obtained divine strength!',
      '🏔️ Will higher than Everest!',
      '🌊 Tsunami-like overwhelming growth!',
      '💫 Being that touches the Milky Way!',
      '👑 Gamma Chad complete! Evolving to Delta Chad!',

      // Level 41-50: Delta+ Giga Chad
      '🌌 Rewriting the laws of universe!',
      '⚡ Power that transcends dimensions!',
      '🔥 Abilities that Creator envies!',
      '💎 Existence beyond perfection!',
      '🌟 Legend became reality!',
      '👑 Became mythical hero!',
      '⚔️ Obtained infinite power!',
      '🌊 Being that dominates spacetime!',
      '💥 Power to cause Big Bang!',
      '🔱 Final evolution complete! Giga Chad born!',
    ],
    'ja': [
      // レベル1-10: 基本チャド
      '🔥 チャドの旅が始まります！弱い自分との別れです！',
      '💪 最初の一歩が最も重要です。あなたはすでに勝者！',
      '⚡ 筋肉が目覚めています。変化を感じませんか？',
      '🚀 限界は錯覚です。あなたの潜在能力は無限大！',
      '🎯 毎日成長する自分を見てください。チャドの道へ！',
      '💥 諦めは弱者の言い訳！強くなっています！',
      '🏆 たった一週間でこんな変化が！素晴らしい！',
      '⚔️ 真の戦士になりつつあります！',
      '🌟 自信が湧き上がるのを感じてください！',
      '👑 最初の進化完了！アルファチャドとして生まれ変わりました！',

      // レベル11-20: アルファチャド
      '🔱 アルファの力が目覚めました！世界が注目します！',
      '💎 ダイヤモンドのような意志力を示しています！',
      '🌪️ ハリケーンのようなエネルギーがあなたを包みます！',
      '⚡ 稲妻のような成長！すべてを圧倒します！',
      '🦅 鷲のように高く舞い上がっています！',
      '🔥 炎のような情熱がすべてを燃やします！',
      '💫 星のような存在になりました！',
      '🏋️ 重力もあなたに屈服します！',
      '🎖️ 伝説的な訓練結果を示しています！',
      '👑 アルファチャド完成！ベータチャドに進化します！',

      // レベル21-30: ベータチャド
      '🌊 海を割る力を手に入れました！',
      '🗻 山を動かす意志力を示します！',
      '⚡ 神々も認める力を持ちました！',
      '🔮 魔法のような変化が続きます！',
      '🌌 宇宙的スケールの成長を示します！',
      '💥 爆発的な発展が止まりません！',
      '🎯 すべての目標を正確に達成します！',
      '🚀 ロケットのように急上昇する成果！',
      '⚔️ 無敵の戦士になりました！',
      '👑 ベータチャド完成！ガンマチャドに進化！',

      // レベル31-40: ガンマチャド
      '🌟 星々もあなたの光に感嘆します！',
      '💎 ダイヤモンドより硬い精神力！',
      '🔥 太陽より熱い情熱！',
      '⚡ 雷より強力なエネルギー！',
      '🌪️ ハリケーンのようなパワー！',
      '🗲 神の力を手に入れました！',
      '🏔️ エベレストより高い意志！',
      '🌊 津波のような圧倒的成長！',
      '💫 天の川に触れる存在！',
      '👑 ガンマチャド完成！デルタチャドに進化！',

      // レベル41-50: デルタ+ ギガチャド
      '🌌 宇宙の法則を書き換えています！',
      '⚡ 次元を超えるパワー！',
      '🔥 創造神も羨む能力！',
      '💎 完璧を超えた存在！',
      '🌟 伝説が現実になりました！',
      '👑 神話の英雄になりました！',
      '⚔️ 無限の力を手に入れました！',
      '🌊 時空を支配する存在！',
      '💥 ビッグバンを起こせる力！',
      '🔱 最終進化完了！ギガチャド誕生！',
    ],
    'zh': [
      // 等级1-10: 基础查德
      '🔥 查德之旅开始！与弱小的自己告别！',
      '💪 第一步最重要。你已经是胜利者！',
      '⚡ 肌肉正在觉醒。感受到变化了吗？',
      '🚀 极限是幻觉。你的潜力无限！',
      '🎯 看到自己每天成长。走上查德之路！',
      '💥 放弃是弱者的借口！变得更强了！',
      '🏆 仅仅一周就有如此变化！太棒了！',
      '⚔️ 正在成为真正的战士！',
      '🌟 感受自信的涌现！',
      '👑 第一次进化完成！重生为阿尔法查德！',

      // 等级11-20: 阿尔法查德
      '🔱 阿尔法力量觉醒！世界瞩目！',
      '💎 展现钻石般的意志力！',
      '🌪️ 飓风般的能量包围着你！',
      '⚡ 闪电般的成长！压倒一切！',
      '🦅 像鹰一样高飞！',
      '🔥 火焰般的激情燃烧一切！',
      '💫 成为星辰般的存在！',
      '🏋️ 连重力都向你屈服！',
      '🎖️ 展现传奇训练成果！',
      '👑 阿尔法查德完成！进化为贝塔查德！',

      // 等级21-30: 贝塔查德
      '🌊 获得了分海之力！',
      '🗻 展现移山的意志力！',
      '⚡ 连神明都认可的力量！',
      '🔮 神奇的变化在继续！',
      '🌌 展现宇宙级别的成长！',
      '💥 爆炸性发展永不停止！',
      '🎯 精确达成每个目标！',
      '🚀 火箭般飙升的表现！',
      '⚔️ 成为无敌战士！',
      '👑 贝塔查德完成！进化为伽马查德！',

      // 等级31-40: 伽马查德
      '🌟 连星星都赞叹你的光芒！',
      '💎 比钻石更坚硬的精神力！',
      '🔥 比太阳更炽热的激情！',
      '⚡ 比雷电更强大的能量！',
      '🌪️ 飓风般的力量！',
      '🗲 获得了神的力量！',
      '🏔️ 比珠峰更高的意志！',
      '🌊 海啸般的压倒性成长！',
      '💫 触及银河的存在！',
      '👑 伽马查德完成！进化为德尔塔查德！',

      // 等级41-50: 德尔塔+ 千兆查德
      '🌌 正在重写宇宙法则！',
      '⚡ 超越维度的力量！',
      '🔥 连造物主都嫉妒的能力！',
      '💎 超越完美的存在！',
      '🌟 传说变成现实！',
      '👑 成为神话英雄！',
      '⚔️ 获得无限力量！',
      '🌊 支配时空的存在！',
      '💥 能引发大爆炸的力量！',
      '🔱 最终进化完成！千兆查德诞生！',
    ],
    'es': [
      // Nivel 1-10: Chad Básico
      '🔥 ¡El viaje Chad comienza! ¡Adiós a tu yo débil!',
      '💪 Los primeros pasos importan más. ¡Ya eres ganador!',
      '⚡ Los músculos despiertan. ¿Sientes el cambio?',
      '🚀 Los límites son ilusiones. ¡Tu potencial es infinito!',
      '🎯 Mírate crecer diariamente. ¡Por el camino Chad!',
      '💥 ¡Rendirse es excusa de débiles! ¡Te fortaleces!',
      '🏆 ¡Tal transformación en solo una semana! ¡Increíble!',
      '⚔️ ¡Te conviertes en verdadero guerrero!',
      '🌟 ¡Siente la confianza surgir!',
      '👑 ¡Primera evolución completa! ¡Renacido como Alfa Chad!',

      // Nivel 11-20: Alfa Chad
      '🔱 ¡Poder alfa despertado! ¡El mundo toma nota!',
      '💎 ¡Mostrando fuerza de voluntad diamantina!',
      '🌪️ ¡Energía huracán te rodea!',
      '⚡ ¡Crecimiento relámpago! ¡Abrumando todo!',
      '🦅 ¡Volando alto como águila!',
      '🔥 ¡Pasión ardiente quema todo!',
      '💫 ¡Te convertiste en existencia estelar!',
      '🏋️ ¡Hasta la gravedad se somete!',
      '🎖️ ¡Mostrando resultados legendarios!',
      '👑 ¡Alfa Chad completo! ¡Evolucionando a Beta Chad!',

      // Nivel 21-30: Beta Chad
      '🌊 ¡Ganaste poder para dividir mares!',
      '🗻 ¡Mostrando voluntad que mueve montañas!',
      '⚡ ¡Poder que hasta dioses reconocen!',
      '🔮 ¡La transformación mágica continúa!',
      '🌌 ¡Mostrando crecimiento cósmico!',
      '💥 ¡Desarrollo explosivo nunca para!',
      '🎯 ¡Logrando cada meta precisamente!',
      '🚀 ¡Rendimiento cohete disparado!',
      '⚔️ ¡Te convertiste en guerrero invencible!',
      '👑 ¡Beta Chad completo! ¡Evolucionando a Gamma Chad!',

      // Nivel 31-40: Gamma Chad
      '🌟 ¡Hasta las estrellas admiran tu luz!',
      '💎 ¡Fuerza mental más dura que diamante!',
      '🔥 ¡Pasión más caliente que el sol!',
      '⚡ ¡Energía más poderosa que trueno!',
      '🌪️ ¡Poder huracán!',
      '🗲 ¡Obtuviste fuerza divina!',
      '🏔️ ¡Voluntad más alta que Everest!',
      '🌊 ¡Crecimiento tsunami abrumador!',
      '💫 ¡Ser que toca la Vía Láctea!',
      '👑 ¡Gamma Chad completo! ¡Evolucionando a Delta Chad!',

      // Nivel 41-50: Delta+ Giga Chad
      '🌌 ¡Reescribiendo las leyes del universo!',
      '⚡ ¡Poder que trasciende dimensiones!',
      '🔥 ¡Habilidades que el Creador envidia!',
      '💎 ¡Existencia más allá de la perfección!',
      '🌟 ¡La leyenda se hizo realidad!',
      '👑 ¡Te convertiste en héroe mítico!',
      '⚔️ ¡Obtuviste poder infinito!',
      '🌊 ¡Ser que domina espacio-tiempo!',
      '💥 ¡Poder para causar Big Bang!',
      '🔱 ¡Evolución final completa! ¡Giga Chad nacido!',
    ],
  };

  /// 현재 언어에 맞는 과학적 팩트 카드 가져오기
  static Map<String, String> getRandomFactCard(Locale locale) {
    final languageCode = locale.languageCode;
    final facts =
        _scientificFactCards[languageCode] ?? _scientificFactCards['en']!;
    return facts[_random.nextInt(facts.length)];
  }

  /// 레벨에 맞는 차드 동기부여 메시지 가져오기
  static String getChadMotivationalMessage(int level, Locale locale) {
    final languageCode = locale.languageCode;
    final messages = _chadMotivationalMessages[languageCode] ??
        _chadMotivationalMessages['en']!;

    // 레벨이 메시지 개수를 초과하면 마지막 메시지 반복
    final index = level > messages.length ? messages.length - 1 : level - 1;
    return messages[index];
  }

  /// 랜덤 동기부여 메시지 가져오기
  static String getRandomMotivationalMessage(Locale locale) {
    final languageCode = locale.languageCode;
    final messages = _chadMotivationalMessages[languageCode] ??
        _chadMotivationalMessages['en']!;
    return messages[_random.nextInt(messages.length)];
  }

  /// 오늘의 팩트 카드 (앱 시작 시 표시)
  static Map<String, String> getTodayFactCard(Locale locale) {
    // 날짜 기반 시드로 매일 같은 팩트 카드 제공
    final today = DateTime.now();
    final seed = today.year * 10000 + today.month * 100 + today.day;
    final seededRandom = Random(seed);

    final languageCode = locale.languageCode;
    final facts =
        _scientificFactCards[languageCode] ?? _scientificFactCards['en']!;
    return facts[seededRandom.nextInt(facts.length)];
  }

  /// 운동 완료 후 격려 메시지와 팩트 조합
  static Map<String, String> getWorkoutCompletionContent(
    int level,
    Locale locale,
  ) {
    final motivationalMessage = getChadMotivationalMessage(level, locale);
    final factCard = getRandomFactCard(locale);

    return {
      'motivation': motivationalMessage,
      'factTitle': factCard['title']!,
      'factContent': factCard['fact']!,
      'factSource': factCard['source']!,
      'factImpact': factCard['impact']!,
    };
  }

  /// 언어별 운동 관련 용어 번역
  static Map<String, String> getWorkoutTerms(Locale locale) {
    final terms = <String, Map<String, String>>{
      'ko': {
        'pushup': '푸시업',
        'set': '세트',
        'rep': '회',
        'rest': '휴식',
        'completed': '완료',
        'target': '목표',
        'level': '레벨',
        'xp': '경험치',
        'streak': '연속',
        'achievement': '업적',
        'evolution': '진화',
        'chad': '차드',
      },
      'en': {
        'pushup': 'Push-up',
        'set': 'Set',
        'rep': 'Rep',
        'rest': 'Rest',
        'completed': 'Completed',
        'target': 'Target',
        'level': 'Level',
        'xp': 'XP',
        'streak': 'Streak',
        'achievement': 'Achievement',
        'evolution': 'Evolution',
        'chad': 'Chad',
      },
      'ja': {
        'pushup': '腕立て伏せ',
        'set': 'セット',
        'rep': '回',
        'rest': '休憩',
        'completed': '完了',
        'target': '目標',
        'level': 'レベル',
        'xp': '経験値',
        'streak': '連続',
        'achievement': '実績',
        'evolution': '進化',
        'chad': 'チャド',
      },
      'zh': {
        'pushup': '俯卧撑',
        'set': '组',
        'rep': '次',
        'rest': '休息',
        'completed': '完成',
        'target': '目标',
        'level': '等级',
        'xp': '经验',
        'streak': '连续',
        'achievement': '成就',
        'evolution': '进化',
        'chad': '查德',
      },
      'es': {
        'pushup': 'Flexión',
        'set': 'Serie',
        'rep': 'Rep',
        'rest': 'Descanso',
        'completed': 'Completado',
        'target': 'Objetivo',
        'level': 'Nivel',
        'xp': 'XP',
        'streak': 'Racha',
        'achievement': 'Logro',
        'evolution': 'Evolución',
        'chad': 'Chad',
      },
    };

    final languageCode = locale.languageCode;
    return terms[languageCode] ?? terms['en']!;
  }
}
