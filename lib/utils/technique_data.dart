/// Technique Data - DreamFlow (Lucid Dream 100)
/// 자각몽 기법 데이터
/// Generated from app config YAML
import 'package:flutter/material.dart';
import '../models/technique.dart';

/// DreamFlow 앱의 자각몽 기법 데이터
class TechniqueData {
  /// 모든 기법 목록
  static List<Technique> get allTechniques => [
    mildTechnique,
    wildTechnique,
    fildTechnique,
    ssildTechnique,
    realityCheck,
    dreamSigns,
    wbtbTechnique,
    dreamJournal,
    dreamStabilization,
    dreamControl,
  ];

  /// MILD (Mnemonic Induction of Lucid Dreams)
  static const mildTechnique = Technique(
    id: 'mild',
    name: 'MILD Technique',
    nameKo: 'MILD 기법',
    shortDescription: 'Mnemonic Induction of Lucid Dreams',
    shortDescriptionKo: '기억 유도 자각몽 기법',
    fullDescription: '''MILD (Mnemonic Induction of Lucid Dreams) was developed by Dr. Stephen LaBerge at Stanford University. It's one of the most effective and beginner-friendly lucid dreaming techniques.

The technique works by setting a strong intention to remember that you're dreaming. By repeating a mantra and visualizing yourself becoming lucid, you program your mind to recognize when you're in a dream.

Best practiced after 5-6 hours of sleep during a WBTB (Wake Back To Bed) session.''',
    fullDescriptionKo: '''MILD(Mnemonic Induction of Lucid Dreams)는 스탠포드 대학의 스티븐 라버지 박사가 개발한 기법입니다. 가장 효과적이고 초보자에게 친화적인 자각몽 기법 중 하나입니다.

이 기법은 꿈속에서 꿈을 꾸고 있다는 것을 기억하겠다는 강한 의도를 설정하는 방식으로 작동합니다. 주문을 반복하고 자각몽을 꾸는 자신을 시각화함으로써, 꿈속에 있다는 것을 인식하도록 마음을 프로그래밍합니다.

5-6시간 수면 후 WBTB(Wake Back To Bed) 세션 중에 연습하면 가장 좋습니다.''',
    category: TechniqueCategory.induction,
    totalDurationSeconds: 600,
    recommendedTime: 'After 5-6 hours of sleep',
    recommendedTimeKo: '5-6시간 수면 후',
    isInteractive: true,
    steps: [
      TechniqueStep(
        title: 'Set your alarm',
        titleKo: '알람 설정하기',
        description: 'Set an alarm for 5-6 hours after going to sleep. This is when REM sleep is most active.',
        descriptionKo: '잠든 후 5-6시간 뒤에 알람을 설정하세요. 이때 REM 수면이 가장 활발합니다.',
        durationSeconds: 0,
        icon: Icons.alarm,
      ),
      TechniqueStep(
        title: 'Recall your dream',
        titleKo: '꿈 회상하기',
        description: 'When you wake up, stay still and recall the dream you just had. Remember as many details as possible.',
        descriptionKo: '깨어났을 때 움직이지 말고 방금 꾼 꿈을 회상하세요. 최대한 많은 세부사항을 기억하세요.',
        durationSeconds: 120,
        icon: Icons.psychology,
      ),
      TechniqueStep(
        title: 'Set your intention',
        titleKo: '의도 설정하기',
        description: 'As you fall back asleep, repeat: "Next time I\'m dreaming, I will remember that I\'m dreaming."',
        descriptionKo: '다시 잠들면서 반복하세요: "다음에 꿈을 꿀 때, 나는 꿈을 꾸고 있다는 것을 기억할 것이다."',
        durationSeconds: 180,
        icon: Icons.record_voice_over,
      ),
      TechniqueStep(
        title: 'Visualize becoming lucid',
        titleKo: '자각 시각화하기',
        description: 'Imagine yourself back in the dream you just had, but this time recognizing that you\'re dreaming.',
        descriptionKo: '방금 꾼 꿈 속으로 돌아가는 상상을 하되, 이번에는 꿈이라는 것을 인식하는 장면을 그려보세요.',
        durationSeconds: 300,
        icon: Icons.nightlight_round,
      ),
    ],
    tips: [
      TechniqueTip(
        text: 'Really believe and feel the intention - don\'t just repeat words',
        textKo: '단순히 말을 반복하지 말고, 진심으로 믿고 의도를 느끼세요',
        icon: Icons.favorite,
      ),
      TechniqueTip(
        text: 'Combine with WBTB for best results',
        textKo: 'WBTB와 함께 사용하면 최상의 결과를 얻을 수 있습니다',
        icon: Icons.tips_and_updates,
      ),
      TechniqueTip(
        text: 'Practice consistently every night for at least 2 weeks',
        textKo: '최소 2주 동안 매일 밤 꾸준히 연습하세요',
        icon: Icons.calendar_today,
      ),
    ],
    researchNote: 'Developed by Dr. Stephen LaBerge at Stanford. 60%+ success rate with proper practice.',
    researchNoteKo: '스탠포드의 스티븐 라버지 박사가 개발. 올바른 연습으로 60% 이상의 성공률.',
  );

  /// WILD (Wake Initiated Lucid Dream)
  static const wildTechnique = Technique(
    id: 'wild',
    name: 'WILD Technique',
    nameKo: 'WILD 기법',
    shortDescription: 'Wake Initiated Lucid Dream',
    shortDescriptionKo: '각성 유도 자각몽',
    fullDescription: '''WILD (Wake Initiated Lucid Dream) is an advanced technique where you transition directly from waking consciousness into a lucid dream without losing awareness.

This technique requires practice and patience. You maintain consciousness while your body falls asleep, allowing you to enter the dream state fully lucid.

It's considered more challenging than MILD but offers the most vivid and controlled lucid dreams.''',
    fullDescriptionKo: '''WILD(Wake Initiated Lucid Dream)는 의식을 잃지 않고 깨어있는 상태에서 직접 자각몽으로 전환하는 고급 기법입니다.

이 기법은 연습과 인내가 필요합니다. 몸이 잠드는 동안 의식을 유지하여 완전히 자각한 상태로 꿈의 세계에 들어갑니다.

MILD보다 어렵지만, 가장 생생하고 통제된 자각몽을 경험할 수 있습니다.''',
    category: TechniqueCategory.induction,
    totalDurationSeconds: 1200,
    recommendedTime: 'After 5-6 hours of sleep (WBTB)',
    recommendedTimeKo: '5-6시간 수면 후 (WBTB)',
    isInteractive: true,
    steps: [
      TechniqueStep(
        title: 'Relax completely',
        titleKo: '완전히 이완하기',
        description: 'Lie still in bed. Relax every muscle from head to toe. Don\'t move.',
        descriptionKo: '침대에 가만히 누우세요. 머리부터 발끝까지 모든 근육을 이완하세요. 움직이지 마세요.',
        durationSeconds: 300,
        icon: Icons.airline_seat_flat,
      ),
      TechniqueStep(
        title: 'Focus on hypnagogic images',
        titleKo: '입면 환각에 집중하기',
        description: 'Watch the patterns and images behind your closed eyes. Don\'t interact, just observe.',
        descriptionKo: '눈을 감은 상태에서 보이는 패턴과 이미지를 관찰하세요. 개입하지 말고 그냥 지켜보세요.',
        durationSeconds: 300,
        icon: Icons.visibility,
      ),
      TechniqueStep(
        title: 'Experience sleep paralysis',
        titleKo: '수면 마비 경험하기',
        description: 'You may feel vibrations, heaviness, or floating. This is normal - stay calm.',
        descriptionKo: '진동, 무거움, 또는 떠다니는 느낌을 경험할 수 있습니다. 정상입니다 - 침착하세요.',
        durationSeconds: 300,
        icon: Icons.waves,
      ),
      TechniqueStep(
        title: 'Enter the dream',
        titleKo: '꿈에 진입하기',
        description: 'The images will become a full dream scene. Step into it consciously.',
        descriptionKo: '이미지가 완전한 꿈 장면이 됩니다. 의식적으로 그 안으로 들어가세요.',
        durationSeconds: 300,
        icon: Icons.nightlight_round,
      ),
    ],
    tips: [
      TechniqueTip(
        text: 'Don\'t panic during sleep paralysis - it\'s a gateway to lucid dreaming',
        textKo: '수면 마비 중 당황하지 마세요 - 자각몽으로 가는 관문입니다',
        icon: Icons.self_improvement,
      ),
      TechniqueTip(
        text: 'Practice meditation regularly to improve focus',
        textKo: '집중력 향상을 위해 명상을 정기적으로 연습하세요',
        icon: Icons.spa,
      ),
      TechniqueTip(
        text: 'Keep your mind awake but your body relaxed',
        textKo: '마음은 깨어있게, 몸은 이완된 상태로 유지하세요',
        icon: Icons.psychology,
      ),
    ],
    researchNote: 'Advanced technique with direct dream entry. Requires practice with relaxation and focus.',
    researchNoteKo: '직접 꿈에 진입하는 고급 기법. 이완과 집중 연습이 필요합니다.',
  );

  /// FILD (Finger Induced Lucid Dream)
  static const fildTechnique = Technique(
    id: 'fild',
    name: 'FILD Technique',
    nameKo: 'FILD 기법',
    shortDescription: 'Finger Induced Lucid Dream',
    shortDescriptionKo: '손가락 유도 자각몽',
    fullDescription: '''FILD (Finger Induced Lucid Dream) is a simple and quick technique that uses subtle finger movements to maintain awareness while falling asleep.

By gently moving your fingers as if playing piano keys, you keep a small part of your mind awake while the rest falls asleep, allowing you to enter directly into a lucid dream.

This technique works best when you're already very tired, typically after waking up in the middle of the night.''',
    fullDescriptionKo: '''FILD(Finger Induced Lucid Dream)는 잠들면서 의식을 유지하기 위해 미세한 손가락 움직임을 사용하는 간단하고 빠른 기법입니다.

피아노 건반을 누르듯이 손가락을 부드럽게 움직여 마음의 일부를 깨어있게 유지하면서 나머지는 잠들게 하여 직접 자각몽에 들어갈 수 있습니다.

이 기법은 이미 매우 피곤할 때, 특히 한밤중에 깬 후에 가장 잘 작동합니다.''',
    category: TechniqueCategory.induction,
    totalDurationSeconds: 180,
    recommendedTime: 'When naturally waking at night',
    recommendedTimeKo: '밤에 자연스럽게 깼을 때',
    isInteractive: true,
    steps: [
      TechniqueStep(
        title: 'Wake up at night',
        titleKo: '밤에 일어나기',
        description: 'Wake up after 4-6 hours of sleep, either naturally or with a gentle alarm.',
        descriptionKo: '4-6시간 수면 후 자연스럽게 또는 부드러운 알람으로 깨세요.',
        durationSeconds: 0,
        icon: Icons.alarm,
      ),
      TechniqueStep(
        title: 'Position your fingers',
        titleKo: '손가락 위치 잡기',
        description: 'Place your hand flat. Focus on your index and middle finger.',
        descriptionKo: '손을 편평하게 놓으세요. 검지와 중지에 집중하세요.',
        durationSeconds: 10,
        icon: Icons.pan_tool,
      ),
      TechniqueStep(
        title: 'Tiny movements',
        titleKo: '미세한 움직임',
        description: 'Alternate pressing down very slightly with each finger, like playing soft piano keys. The movement should be barely noticeable.',
        descriptionKo: '부드러운 피아노 건반을 누르듯이 각 손가락을 아주 살짝 번갈아 누르세요. 움직임은 거의 눈에 띄지 않아야 합니다.',
        durationSeconds: 120,
        icon: Icons.piano,
      ),
      TechniqueStep(
        title: 'Reality check',
        titleKo: '현실 확인',
        description: 'After 30 seconds to 2 minutes, do a reality check. Try to push your finger through your palm.',
        descriptionKo: '30초에서 2분 후, 현실 확인을 하세요. 손가락으로 손바닥을 관통해 보세요.',
        durationSeconds: 10,
        icon: Icons.check_circle,
      ),
    ],
    tips: [
      TechniqueTip(
        text: 'The finger movements must be extremely subtle - almost imagined',
        textKo: '손가락 움직임은 극도로 미세해야 합니다 - 거의 상상하는 정도로',
        icon: Icons.touch_app,
      ),
      TechniqueTip(
        text: 'Don\'t open your eyes to check - just do a reality check',
        textKo: '확인하려고 눈을 뜨지 마세요 - 그냥 현실 확인을 하세요',
        icon: Icons.visibility_off,
      ),
      TechniqueTip(
        text: 'Works best when you\'re already very sleepy',
        textKo: '이미 매우 졸릴 때 가장 잘 작동합니다',
        icon: Icons.bedtime,
      ),
    ],
    researchNote: 'Quick induction technique. Success depends on timing and subtlety of movements.',
    researchNoteKo: '빠른 유도 기법. 성공은 타이밍과 움직임의 섬세함에 달려 있습니다.',
  );

  /// SSILD (Senses Initiated Lucid Dream)
  static const ssildTechnique = Technique(
    id: 'ssild',
    name: 'SSILD Technique',
    nameKo: 'SSILD 기법',
    shortDescription: 'Senses Initiated Lucid Dream',
    shortDescriptionKo: '감각 유도 자각몽',
    fullDescription: '''SSILD (Senses Initiated Lucid Dream) is a modern technique that cycles through your senses to induce lucid dreams. It was developed by a Chinese lucid dreaming community.

The technique involves repeatedly focusing on sight, hearing, and touch in cycles. This creates a state that's highly conducive to lucid dreaming and often produces results quickly.

It's especially effective for beginners due to its simple, structured approach.''',
    fullDescriptionKo: '''SSILD(Senses Initiated Lucid Dream)는 감각을 순환하며 자각몽을 유도하는 현대적인 기법입니다. 중국의 자각몽 커뮤니티에서 개발되었습니다.

이 기법은 시각, 청각, 촉각을 반복적으로 순환하며 집중합니다. 이것은 자각몽에 매우 유리한 상태를 만들고 종종 빠른 결과를 가져옵니다.

간단하고 구조화된 접근 방식으로 특히 초보자에게 효과적입니다.''',
    category: TechniqueCategory.induction,
    totalDurationSeconds: 600,
    recommendedTime: 'After 4-5 hours of sleep',
    recommendedTimeKo: '4-5시간 수면 후',
    isInteractive: true,
    steps: [
      TechniqueStep(
        title: 'Wake up after sleep',
        titleKo: '수면 후 기상',
        description: 'Set an alarm for 4-5 hours after going to sleep. Stay awake for 5-10 minutes.',
        descriptionKo: '잠든 후 4-5시간에 알람을 설정하세요. 5-10분 동안 깨어 있으세요.',
        durationSeconds: 0,
        icon: Icons.alarm,
      ),
      TechniqueStep(
        title: 'Focus on sight',
        titleKo: '시각에 집중',
        description: 'Close your eyes and focus on the darkness. Notice any colors, patterns, or light.',
        descriptionKo: '눈을 감고 어둠에 집중하세요. 색상, 패턴, 또는 빛을 관찰하세요.',
        durationSeconds: 20,
        icon: Icons.visibility,
      ),
      TechniqueStep(
        title: 'Focus on sound',
        titleKo: '청각에 집중',
        description: 'Shift attention to your hearing. Listen for any sounds, even imagined ones.',
        descriptionKo: '청각으로 주의를 옮기세요. 상상의 소리라도 어떤 소리든 들어보세요.',
        durationSeconds: 20,
        icon: Icons.hearing,
      ),
      TechniqueStep(
        title: 'Focus on touch',
        titleKo: '촉각에 집중',
        description: 'Notice physical sensations - heaviness, tingling, floating, or warmth.',
        descriptionKo: '신체 감각을 알아차리세요 - 무거움, 저림, 떠다님, 또는 따뜻함.',
        durationSeconds: 20,
        icon: Icons.touch_app,
      ),
      TechniqueStep(
        title: 'Repeat cycles',
        titleKo: '순환 반복',
        description: 'Repeat the sight-sound-touch cycle 4-6 times. Then relax and fall asleep.',
        descriptionKo: '시각-청각-촉각 순환을 4-6회 반복하세요. 그런 다음 이완하고 잠드세요.',
        durationSeconds: 300,
        icon: Icons.repeat,
      ),
    ],
    tips: [
      TechniqueTip(
        text: 'Don\'t try too hard - just passively observe each sense',
        textKo: '너무 열심히 하지 마세요 - 각 감각을 수동적으로 관찰만 하세요',
        icon: Icons.self_improvement,
      ),
      TechniqueTip(
        text: 'The cycles should be quick - about 20 seconds per sense',
        textKo: '순환은 빠르게 - 각 감각당 약 20초',
        icon: Icons.timer,
      ),
      TechniqueTip(
        text: 'Many people have success within the first week',
        textKo: '많은 사람들이 첫 주 내에 성공합니다',
        icon: Icons.star,
      ),
    ],
    researchNote: 'Modern technique with high success rate. Works by priming the mind for dream awareness.',
    researchNoteKo: '높은 성공률의 현대적 기법. 꿈 인식을 위해 마음을 준비시키는 방식으로 작동합니다.',
  );

  /// Reality Check
  static const realityCheck = Technique(
    id: 'reality_check',
    name: 'Reality Checks',
    nameKo: '리얼리티 체크',
    shortDescription: 'Test if you\'re dreaming throughout the day',
    shortDescriptionKo: '하루 종일 꿈인지 확인하기',
    fullDescription: '''Reality checks are simple tests you perform throughout the day to determine whether you're dreaming or awake. By making this a habit, you'll eventually do them in your dreams and realize you're dreaming.

The key is to genuinely question your reality each time, not just go through the motions. Really expect that you might be dreaming.

Common reality checks include looking at your hands, trying to push a finger through your palm, or reading text twice.''',
    fullDescriptionKo: '''리얼리티 체크는 꿈인지 깨어있는지를 확인하기 위해 하루 종일 수행하는 간단한 테스트입니다. 이것을 습관으로 만들면, 결국 꿈에서도 하게 되고 꿈이라는 것을 깨닫게 됩니다.

핵심은 단순히 동작을 수행하는 것이 아니라 매번 진정으로 현실에 의문을 제기하는 것입니다. 정말로 꿈일 수 있다고 기대하세요.

일반적인 리얼리티 체크에는 손 보기, 손가락으로 손바닥 관통 시도, 또는 텍스트를 두 번 읽기가 있습니다.''',
    category: TechniqueCategory.awareness,
    totalDurationSeconds: 30,
    recommendedTime: 'Every 1-2 hours throughout the day',
    recommendedTimeKo: '하루 종일 1-2시간마다',
    isInteractive: true,
    steps: [
      TechniqueStep(
        title: 'Stop and question',
        titleKo: '멈추고 질문하기',
        description: 'Pause what you\'re doing. Ask yourself seriously: "Am I dreaming right now?"',
        descriptionKo: '하던 일을 멈추세요. 진지하게 자문하세요: "지금 꿈을 꾸고 있나?"',
        durationSeconds: 5,
        icon: Icons.pause,
      ),
      TechniqueStep(
        title: 'Finger through palm',
        titleKo: '손바닥 관통',
        description: 'Try to push your finger through your palm. In dreams, it often goes through.',
        descriptionKo: '손가락으로 손바닥을 관통해 보세요. 꿈에서는 종종 통과합니다.',
        durationSeconds: 5,
        icon: Icons.pan_tool,
      ),
      TechniqueStep(
        title: 'Check your hands',
        titleKo: '손 확인하기',
        description: 'Look at your hands closely. In dreams, they often look distorted or have wrong number of fingers.',
        descriptionKo: '손을 자세히 보세요. 꿈에서는 종종 왜곡되어 보이거나 손가락 수가 다릅니다.',
        durationSeconds: 10,
        icon: Icons.back_hand,
      ),
      TechniqueStep(
        title: 'Read text twice',
        titleKo: '텍스트 두 번 읽기',
        description: 'Read some text, look away, read again. In dreams, text changes.',
        descriptionKo: '텍스트를 읽고, 눈을 돌리고, 다시 읽으세요. 꿈에서는 텍스트가 바뀝니다.',
        durationSeconds: 10,
        icon: Icons.text_fields,
      ),
    ],
    tips: [
      TechniqueTip(
        text: 'Set reminders on your phone to do reality checks',
        textKo: '리얼리티 체크를 위한 알림을 핸드폰에 설정하세요',
        icon: Icons.notifications,
      ),
      TechniqueTip(
        text: 'Do them whenever something strange happens',
        textKo: '이상한 일이 일어날 때마다 하세요',
        icon: Icons.help_outline,
      ),
      TechniqueTip(
        text: 'Aim for 10-20 reality checks per day',
        textKo: '하루에 10-20회의 리얼리티 체크를 목표로 하세요',
        icon: Icons.trending_up,
      ),
    ],
    researchNote: 'Foundation of lucid dreaming practice. Creates habit that transfers to dream state.',
    researchNoteKo: '자각몽 연습의 기초. 꿈 상태로 전이되는 습관을 만듭니다.',
  );

  /// Dream Signs Recognition
  static const dreamSigns = Technique(
    id: 'dream_signs',
    name: 'Dream Signs Recognition',
    nameKo: '드림 사인 인식',
    shortDescription: 'Learn your personal dream patterns',
    shortDescriptionKo: '개인적인 꿈 패턴 학습하기',
    fullDescription: '''Dream signs are recurring themes, characters, locations, or events that appear frequently in your dreams. By identifying your personal dream signs, you can recognize when you're dreaming.

Keep a dream journal and look for patterns. Common categories include:
- Action: Doing something unusual (flying, breathing underwater)
- Context: Strange settings or impossible situations
- Form: Things look wrong (distorted faces, wrong colors)
- Awareness: Thoughts or feelings that don't match the situation

Once you know your dream signs, you can trigger lucidity when they appear.''',
    fullDescriptionKo: '''드림 사인은 꿈에 자주 나타나는 반복되는 주제, 인물, 장소, 또는 사건입니다. 개인적인 드림 사인을 파악하면 꿈을 꾸고 있을 때 인식할 수 있습니다.

꿈 일기를 쓰고 패턴을 찾으세요. 일반적인 카테고리:
- 행동: 비정상적인 일 하기 (날기, 물속에서 숨쉬기)
- 맥락: 이상한 환경이나 불가능한 상황
- 형태: 잘못된 모습 (왜곡된 얼굴, 잘못된 색상)
- 인식: 상황과 맞지 않는 생각이나 감정

드림 사인을 알면, 그것들이 나타날 때 자각을 유발할 수 있습니다.''',
    category: TechniqueCategory.awareness,
    totalDurationSeconds: 900,
    recommendedTime: 'While reviewing dream journal',
    recommendedTimeKo: '꿈 일기 검토할 때',
    isInteractive: false,
    steps: [
      TechniqueStep(
        title: 'Review your dreams',
        titleKo: '꿈 검토하기',
        description: 'Read through your dream journal entries from the past week or month.',
        descriptionKo: '지난 주 또는 월의 꿈 일기 항목을 읽어보세요.',
        icon: Icons.menu_book,
      ),
      TechniqueStep(
        title: 'Identify patterns',
        titleKo: '패턴 파악하기',
        description: 'Look for recurring elements: people, places, actions, or feelings.',
        descriptionKo: '반복되는 요소를 찾으세요: 사람, 장소, 행동, 또는 감정.',
        icon: Icons.pattern,
      ),
      TechniqueStep(
        title: 'Categorize signs',
        titleKo: '사인 분류하기',
        description: 'Group your dream signs into categories: Action, Context, Form, or Awareness.',
        descriptionKo: '드림 사인을 카테고리로 분류하세요: 행동, 맥락, 형태, 또는 인식.',
        icon: Icons.category,
      ),
      TechniqueStep(
        title: 'Create triggers',
        titleKo: '트리거 만들기',
        description: 'Tell yourself: "When I see [dream sign], I will realize I\'m dreaming."',
        descriptionKo: '자신에게 말하세요: "[드림 사인]을 보면, 나는 꿈이라는 것을 깨달을 것이다."',
        icon: Icons.lightbulb,
      ),
    ],
    tips: [
      TechniqueTip(
        text: 'Keep a running list of your most common dream signs',
        textKo: '가장 흔한 드림 사인 목록을 계속 업데이트하세요',
        icon: Icons.list,
      ),
      TechniqueTip(
        text: 'Visualize becoming lucid when you encounter these signs',
        textKo: '이 사인들을 만났을 때 자각하는 것을 시각화하세요',
        icon: Icons.psychology,
      ),
      TechniqueTip(
        text: 'Review and update your dream signs monthly',
        textKo: '드림 사인을 매달 검토하고 업데이트하세요',
        icon: Icons.update,
      ),
    ],
    researchNote: 'Personal dream signs are unique to each dreamer. Tracking them significantly increases lucid dream frequency.',
    researchNoteKo: '개인적인 드림 사인은 각 꿈꾸는 사람에게 고유합니다. 추적하면 자각몽 빈도가 크게 증가합니다.',
  );

  /// WBTB (Wake Back To Bed)
  static const wbtbTechnique = Technique(
    id: 'wbtb',
    name: 'WBTB Technique',
    nameKo: 'WBTB 기법',
    shortDescription: 'Wake Back To Bed for enhanced lucidity',
    shortDescriptionKo: '향상된 자각을 위한 중간 기상 기법',
    fullDescription: '''WBTB (Wake Back To Bed) is a powerful technique that takes advantage of your natural sleep cycles. By waking up during the night when REM sleep is most active, you dramatically increase your chances of lucid dreaming.

The technique involves sleeping for 5-6 hours, staying awake for 30-60 minutes while thinking about lucid dreaming, then going back to sleep.

WBTB is often combined with other techniques like MILD or WILD for maximum effectiveness.''',
    fullDescriptionKo: '''WBTB(Wake Back To Bed)는 자연스러운 수면 주기를 활용하는 강력한 기법입니다. REM 수면이 가장 활발할 때 밤에 깨어남으로써 자각몽의 가능성을 극적으로 높입니다.

이 기법은 5-6시간 자고, 자각몽에 대해 생각하면서 30-60분 깨어 있다가 다시 잠드는 것입니다.

WBTB는 최대 효과를 위해 종종 MILD나 WILD 같은 다른 기법과 결합됩니다.''',
    category: TechniqueCategory.preparation,
    totalDurationSeconds: 3600,
    recommendedTime: 'Sleep schedule',
    recommendedTimeKo: '수면 스케줄',
    isInteractive: false,
    steps: [
      TechniqueStep(
        title: 'Set your alarm',
        titleKo: '알람 설정',
        description: 'Set an alarm for 5-6 hours after going to sleep. This targets late REM periods.',
        descriptionKo: '잠든 후 5-6시간에 알람을 설정하세요. 후반 REM 기간을 목표로 합니다.',
        icon: Icons.alarm,
      ),
      TechniqueStep(
        title: 'Wake up completely',
        titleKo: '완전히 깨기',
        description: 'When the alarm goes off, get out of bed. Stay awake for 30-60 minutes.',
        descriptionKo: '알람이 울리면 침대에서 일어나세요. 30-60분 동안 깨어 있으세요.',
        icon: Icons.wb_sunny,
      ),
      TechniqueStep(
        title: 'Focus on lucid dreaming',
        titleKo: '자각몽에 집중',
        description: 'Read about lucid dreaming, review your dream journal, or practice visualization.',
        descriptionKo: '자각몽에 대해 읽거나, 꿈 일기를 검토하거나, 시각화를 연습하세요.',
        icon: Icons.menu_book,
      ),
      TechniqueStep(
        title: 'Go back to sleep',
        titleKo: '다시 잠들기',
        description: 'Return to bed with the intention to lucid dream. Use MILD or WILD if desired.',
        descriptionKo: '자각몽을 꿀 의도를 가지고 침대로 돌아가세요. 원하면 MILD나 WILD를 사용하세요.',
        icon: Icons.nightlight_round,
      ),
    ],
    tips: [
      TechniqueTip(
        text: 'Avoid bright screens during wake period - use dim lights',
        textKo: '깨어있는 동안 밝은 화면을 피하세요 - 어두운 조명을 사용하세요',
        icon: Icons.brightness_low,
      ),
      TechniqueTip(
        text: 'Don\'t eat heavy food during the wake period',
        textKo: '깨어있는 동안 무거운 음식을 먹지 마세요',
        icon: Icons.no_food,
      ),
      TechniqueTip(
        text: '30-60 minutes awake works best - adjust to find your optimal time',
        textKo: '30-60분 깨어있는 것이 가장 좋습니다 - 최적의 시간을 찾아 조정하세요',
        icon: Icons.schedule,
      ),
    ],
    researchNote: 'Studies show WBTB increases lucid dream frequency by 2-3x when combined with MILD.',
    researchNoteKo: '연구에 따르면 WBTB는 MILD와 결합할 때 자각몽 빈도를 2-3배 증가시킵니다.',
  );

  /// Dream Journal
  static const dreamJournal = Technique(
    id: 'dream_journal',
    name: 'Dream Journaling',
    nameKo: '꿈 일기',
    shortDescription: 'Record your dreams to improve recall',
    shortDescriptionKo: '기억력 향상을 위한 꿈 기록',
    fullDescription: '''Dream journaling is the foundation of lucid dreaming practice. By recording your dreams immediately upon waking, you train your brain to remember dreams better and identify recurring patterns.

Write down everything you remember - even fragments or feelings. Over time, your dream recall will dramatically improve, making it easier to achieve lucidity.

Keep your journal by your bed and write before doing anything else when you wake up.''',
    fullDescriptionKo: '''꿈 일기는 자각몽 연습의 기초입니다. 깨어난 직후 꿈을 기록함으로써 뇌가 꿈을 더 잘 기억하고 반복되는 패턴을 파악하도록 훈련합니다.

기억나는 모든 것을 적으세요 - 단편이나 감정도 포함해서. 시간이 지나면 꿈 회상력이 극적으로 향상되어 자각을 달성하기가 더 쉬워집니다.

일기장을 침대 옆에 두고 깨어나면 다른 일을 하기 전에 쓰세요.''',
    category: TechniqueCategory.journaling,
    totalDurationSeconds: 600,
    recommendedTime: 'Immediately upon waking',
    recommendedTimeKo: '깨어난 직후',
    isInteractive: false,
    steps: [
      TechniqueStep(
        title: 'Keep still',
        titleKo: '가만히 있기',
        description: 'When you wake up, don\'t move. Stay in the same position and recall your dreams.',
        descriptionKo: '깨어나면 움직이지 마세요. 같은 자세로 꿈을 회상하세요.',
        icon: Icons.airline_seat_flat,
      ),
      TechniqueStep(
        title: 'Recall everything',
        titleKo: '모든 것 회상하기',
        description: 'Go through the dream from beginning to end. Note people, places, emotions, and events.',
        descriptionKo: '꿈을 처음부터 끝까지 검토하세요. 사람, 장소, 감정, 사건을 기억하세요.',
        icon: Icons.psychology,
      ),
      TechniqueStep(
        title: 'Write immediately',
        titleKo: '즉시 쓰기',
        description: 'Write everything down before getting out of bed. Include all details, no matter how small.',
        descriptionKo: '침대에서 일어나기 전에 모든 것을 쓰세요. 아무리 작은 세부사항도 포함하세요.',
        icon: Icons.edit,
      ),
      TechniqueStep(
        title: 'Add tags',
        titleKo: '태그 추가',
        description: 'Mark any potential dream signs, emotions, or lucid moments.',
        descriptionKo: '잠재적인 드림 사인, 감정, 또는 자각 순간을 표시하세요.',
        icon: Icons.label,
      ),
    ],
    tips: [
      TechniqueTip(
        text: 'Even "I don\'t remember" counts - write it anyway',
        textKo: '"기억나지 않음"도 괜찮습니다 - 어쨌든 쓰세요',
        icon: Icons.edit_note,
      ),
      TechniqueTip(
        text: 'Use present tense: "I am flying" not "I was flying"',
        textKo: '현재 시제를 사용하세요: "나는 날고 있다" "나는 날았다"가 아니라',
        icon: Icons.format_quote,
      ),
      TechniqueTip(
        text: 'Review your journal weekly to spot dream signs',
        textKo: '드림 사인을 발견하기 위해 매주 일기를 검토하세요',
        icon: Icons.calendar_today,
      ),
    ],
    researchNote: 'Essential practice. Dream recall typically doubles within 2-3 weeks of consistent journaling.',
    researchNoteKo: '필수 연습. 꿈 회상력은 일반적으로 2-3주 꾸준한 일기 작성으로 두 배가 됩니다.',
  );

  /// Dream Stabilization
  static const dreamStabilization = Technique(
    id: 'dream_stabilization',
    name: 'Dream Stabilization',
    nameKo: '꿈 안정화',
    shortDescription: 'Keep your lucid dream from fading',
    shortDescriptionKo: '자각몽이 사라지지 않게 유지하기',
    fullDescription: '''Dream stabilization techniques help you maintain lucidity once you've achieved it. Many beginners wake up immediately after becoming lucid due to excitement.

These techniques ground you in the dream and prevent premature awakening. The key is to engage your senses and stay calm when you realize you're dreaming.

Practice these as soon as you become lucid to extend your lucid dreams.''',
    fullDescriptionKo: '''꿈 안정화 기법은 자각을 달성한 후 유지하는 데 도움이 됩니다. 많은 초보자가 흥분으로 인해 자각 직후 깨어납니다.

이 기법들은 꿈에서 당신을 안정시키고 조기 각성을 방지합니다. 핵심은 꿈이라는 것을 깨달았을 때 감각을 활성화하고 침착함을 유지하는 것입니다.

자각몽을 연장하기 위해 자각하자마자 이것들을 연습하세요.''',
    category: TechniqueCategory.stabilization,
    totalDurationSeconds: 60,
    recommendedTime: 'When becoming lucid',
    recommendedTimeKo: '자각하는 순간',
    isInteractive: true,
    steps: [
      TechniqueStep(
        title: 'Stay calm',
        titleKo: '침착하기',
        description: 'Don\'t get too excited! Take a deep breath and remind yourself to stay calm.',
        descriptionKo: '너무 흥분하지 마세요! 심호흡을 하고 침착하라고 스스로에게 말하세요.',
        durationSeconds: 5,
        icon: Icons.self_improvement,
      ),
      TechniqueStep(
        title: 'Rub your hands',
        titleKo: '손 비비기',
        description: 'Rub your hands together vigorously. Feel the friction and warmth.',
        descriptionKo: '손을 힘차게 비비세요. 마찰과 온기를 느끼세요.',
        durationSeconds: 10,
        icon: Icons.pan_tool,
      ),
      TechniqueStep(
        title: 'Spin around',
        titleKo: '빙글 돌기',
        description: 'Spin your dream body around like a top. This can also change dream scenes.',
        descriptionKo: '팽이처럼 꿈 속 몸을 빙글 돌리세요. 이것은 꿈 장면도 바꿀 수 있습니다.',
        durationSeconds: 10,
        icon: Icons.rotate_right,
      ),
      TechniqueStep(
        title: 'Touch everything',
        titleKo: '모든 것 만지기',
        description: 'Touch the ground, walls, or objects. Focus on the textures.',
        descriptionKo: '바닥, 벽, 또는 물체를 만지세요. 질감에 집중하세요.',
        durationSeconds: 15,
        icon: Icons.touch_app,
      ),
      TechniqueStep(
        title: 'Verbal command',
        titleKo: '구두 명령',
        description: 'Shout "Clarity now!" or "Increase lucidity!" to enhance the dream.',
        descriptionKo: '"선명해져라!" 또는 "자각 증가!"라고 외쳐 꿈을 향상시키세요.',
        durationSeconds: 5,
        icon: Icons.record_voice_over,
      ),
    ],
    tips: [
      TechniqueTip(
        text: 'Don\'t look at the sky or far away - it can destabilize the dream',
        textKo: '하늘이나 먼 곳을 보지 마세요 - 꿈을 불안정하게 할 수 있습니다',
        icon: Icons.visibility_off,
      ),
      TechniqueTip(
        text: 'If fading, focus intensely on a nearby object',
        textKo: '사라지면 가까운 물체에 집중하세요',
        icon: Icons.center_focus_strong,
      ),
      TechniqueTip(
        text: 'Practice these techniques regularly even in normal dreams',
        textKo: '일반 꿈에서도 이 기법들을 정기적으로 연습하세요',
        icon: Icons.fitness_center,
      ),
    ],
    researchNote: 'Engaging senses activates brain areas that stabilize the dream state.',
    researchNoteKo: '감각 활성화는 꿈 상태를 안정시키는 뇌 영역을 활성화합니다.',
  );

  /// Dream Control
  static const dreamControl = Technique(
    id: 'dream_control',
    name: 'Dream Control',
    nameKo: '꿈 조종',
    shortDescription: 'Master controlling your lucid dreams',
    shortDescriptionKo: '자각몽 조종 마스터하기',
    fullDescription: '''Dream control is the art of manipulating elements within your lucid dream. Once stable in a lucid dream, you can fly, teleport, create objects, meet dream characters, or explore impossible worlds.

The key to dream control is expectation and belief. The dream responds to your thoughts and intentions. If you expect something to happen with full confidence, it usually will.

Start with simple controls and gradually work up to more complex manipulations.''',
    fullDescriptionKo: '''꿈 조종은 자각몽 내의 요소들을 조작하는 기술입니다. 자각몽에서 안정되면 날거나, 순간이동하거나, 물체를 만들거나, 꿈 속 인물을 만나거나, 불가능한 세계를 탐험할 수 있습니다.

꿈 조종의 핵심은 기대와 믿음입니다. 꿈은 당신의 생각과 의도에 반응합니다. 완전한 확신으로 무언가가 일어날 것이라고 기대하면, 보통 일어납니다.

간단한 조종부터 시작하여 점차 더 복잡한 조작으로 나아가세요.''',
    category: TechniqueCategory.advanced,
    totalDurationSeconds: 0,
    recommendedTime: 'During lucid dreams',
    recommendedTimeKo: '자각몽 중',
    isInteractive: false,
    steps: [
      TechniqueStep(
        title: 'Flying',
        titleKo: '날기',
        description: 'Jump and expect to float. Or simply will yourself upward. Start with hovering.',
        descriptionKo: '뛰어올라 떠다닐 것이라고 기대하세요. 또는 단순히 위로 올라가길 원하세요. 호버링부터 시작하세요.',
        icon: Icons.flight,
      ),
      TechniqueStep(
        title: 'Summoning',
        titleKo: '소환하기',
        description: 'Expect what you want to be behind you or around a corner. Then turn and look.',
        descriptionKo: '원하는 것이 뒤에 있거나 모퉁이에 있을 거라고 기대하세요. 그런 다음 돌아서 보세요.',
        icon: Icons.add_circle,
      ),
      TechniqueStep(
        title: 'Changing scenes',
        titleKo: '장면 바꾸기',
        description: 'Find a door and expect your destination behind it. Or spin while visualizing the new place.',
        descriptionKo: '문을 찾고 뒤에 목적지가 있을 것이라고 기대하세요. 또는 새 장소를 시각화하며 돌아보세요.',
        icon: Icons.door_back_door,
      ),
      TechniqueStep(
        title: 'Meeting characters',
        titleKo: '인물 만나기',
        description: 'Call out to who you want to meet, or expect them to be nearby.',
        descriptionKo: '만나고 싶은 사람을 부르거나, 근처에 있을 것이라고 기대하세요.',
        icon: Icons.people,
      ),
      TechniqueStep(
        title: 'Changing yourself',
        titleKo: '자신 바꾸기',
        description: 'Look at your hands and will them to change. Or find a mirror and transform.',
        descriptionKo: '손을 보고 변하길 원하세요. 또는 거울을 찾아 변신하세요.',
        icon: Icons.transform,
      ),
    ],
    tips: [
      TechniqueTip(
        text: 'Confidence is key - doubt causes failure',
        textKo: '확신이 핵심입니다 - 의심은 실패를 일으킵니다',
        icon: Icons.psychology,
      ),
      TechniqueTip(
        text: 'Use verbal commands: "I can fly!" or "Show me [X]!"',
        textKo: '구두 명령을 사용하세요: "나는 날 수 있다!" 또는 "[X]를 보여줘!"',
        icon: Icons.record_voice_over,
      ),
      TechniqueTip(
        text: 'Work with the dream, not against it - use dream logic',
        textKo: '꿈에 맞서지 말고 함께하세요 - 꿈의 논리를 사용하세요',
        icon: Icons.handshake,
      ),
    ],
    researchNote: 'Advanced practice. Dream control improves with lucid dreaming experience.',
    researchNoteKo: '고급 연습. 꿈 조종은 자각몽 경험과 함께 향상됩니다.',
  );

  /// ID로 기법 찾기
  static Technique? getById(String id) {
    try {
      return allTechniques.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 카테고리로 기법 필터링
  static List<Technique> getByCategory(TechniqueCategory category) {
    return allTechniques.where((t) => t.category == category).toList();
  }

  /// 인터랙티브 기법만 필터링
  static List<Technique> get interactiveTechniques {
    return allTechniques.where((t) => t.isInteractive).toList();
  }
}
