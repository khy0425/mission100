# Character Images Generation Checklist

> Quick action guide for completing the Dream Spirit evolution images

**Status:** 0/7 images complete

---

## ✅ Setup Complete

- [x] Character images folder created: `assets/images/character/`
- [x] Midjourney prompts prepared: [MIDJOURNEY_CHARACTER_PROMPTS.md](./MIDJOURNEY_CHARACTER_PROMPTS.md)
- [x] Asset configuration updated in `pubspec.yaml`
- [x] Character evolution model ready: `lib/models/character_evolution.dart`

---

## 📋 Action Items

### Step 1: Save Your Existing Blue Ghost Character ⭐

**Your existing blue ghost character → Stage 0 (Sleepy Ghost)**

**Action:**
```bash
# Save your existing blue ghost image as:
E:\Projects\mission_apps\lucid_dream_100\assets\images\character\stage0_sleepy_ghost.png

# Required specs:
- Format: PNG (transparent background preferred)
- Size: 512x512px (or similar square ratio)
- Name: stage0_sleepy_ghost.png
```

**Status:** ⏳ Pending

---

### Step 2: Upload to Midjourney and Get URL

1. Open Discord where you have Midjourney access
2. Upload your `stage0_sleepy_ghost.png` image
3. Right-click the uploaded image → "Copy Link"
4. Save this URL - you'll use it for all remaining stages

**Example URL:** `https://cdn.midjourney.com/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/0_0.png`

**Your Stage 0 URL:** `_________________________` (write it here!)

**Status:** ⏳ Pending

---

### Step 3: Generate Remaining 6 Evolution Stages

Use the prompts from [MIDJOURNEY_CHARACTER_PROMPTS.md](./MIDJOURNEY_CHARACTER_PROMPTS.md).

**Replace `[STAGE_0_URL]` with your actual URL from Step 2!**

#### Stage 1: Aware Wisp (Week 2)
```
/imagine the same ghost spirit character now awakening with half-open eyes, becoming more aware and alert, soft light blue glow starting to appear, small sparkles around the body, slightly larger and more defined form, curious expression, same chibi proportions and style, centered on white background, 2D flat illustration, brighter and more vibrant than before --cref [YOUR_STAGE_0_URL] --ar 1:1 --v 6
```
- [ ] Generated
- [ ] Downloaded as `stage1_aware_wisp.png`
- [ ] Copied to `assets/images/character/`

---

#### Stage 2: Lucid Sprite (Week 4)
```
/imagine the same spirit character now fully awake with wide open eyes and excited smile, glowing bright purple aura, gaining small arms and more defined features, floating dream symbols and stars around, energetic pose, same character style but more vibrant and powerful, centered on white background, 2D flat illustration --cref [YOUR_STAGE_0_URL] --ar 1:1 --v 6
```
- [ ] Generated
- [ ] Downloaded as `stage2_lucid_sprite.png`
- [ ] Copied to `assets/images/character/`

---

#### Stage 3: Dream Walker (Week 6)
```
/imagine the same spirit character now with a confident calm expression, standing upright with small legs visible, wearing simple flowing cape, surrounded by teal-green aura and gentle portal effects, balanced and peaceful pose, evolved but same cute style, centered on white background, 2D flat illustration --cref [YOUR_STAGE_0_URL] --ar 1:1 --v 6
```
- [ ] Generated
- [ ] Downloaded as `stage3_dream_walker.png`
- [ ] Copied to `assets/images/character/`

---

#### Stage 4: Astral Traveler (Week 8)
```
/imagine the same spirit character now with adventurous pose and arms spread wide, bright pink-magenta cosmic aura with small stars and galaxies, wearing longer flowing starry cape, more dynamic and powerful, exploring pose with confident smile, same cute character design, centered on white background, 2D flat illustration --cref [YOUR_STAGE_0_URL] --ar 1:1 --v 6
```
- [ ] Generated
- [ ] Downloaded as `stage4_astral_traveler.png`
- [ ] Copied to `assets/images/character/`

---

#### Stage 5: Oneiroi Oracle (Week 10)
```
/imagine the same spirit character in meditative floating pose with serene closed eyes, golden-yellow aura with wisdom symbols and ancient runes floating around, wearing elegant oracle robes with mystical patterns, peaceful and wise expression, more mature but same character, centered on white background, 2D flat illustration --cref [YOUR_STAGE_0_URL] --ar 1:1 --v 6
```
- [ ] Generated
- [ ] Downloaded as `stage5_oneiroi_oracle.png`
- [ ] Copied to `assets/images/character/`

---

#### Stage 6: Master of Dreams (Week 14)
```
/imagine the same spirit character now in ultimate evolved form with majestic pose, wearing crown and grand royal robes with constellation patterns, deep royal purple aura with swirling galaxies and dream dimensions, commanding powerful presence, confident triumphant expression, same character but fully evolved and legendary, centered on white background, 2D flat illustration --cref [YOUR_STAGE_0_URL] --ar 1:1 --v 6
```
- [ ] Generated
- [ ] Downloaded as `stage6_dream_master.png`
- [ ] Copied to `assets/images/character/`

---

## 🎯 Final Verification

Once all 7 images are in place:

```bash
# Check all images are present
ls -la E:\Projects\mission_apps\lucid_dream_100\assets\images\character\

# Should see 7 files:
# stage0_sleepy_ghost.png
# stage1_aware_wisp.png
# stage2_lucid_sprite.png
# stage3_dream_walker.png
# stage4_astral_traveler.png
# stage5_oneiroi_oracle.png
# stage6_dream_master.png
```

- [ ] All 7 image files present
- [ ] File names match exactly (lowercase, underscores)
- [ ] Images are square ratio (512x512 or similar)
- [ ] PNG format with transparent or simple backgrounds

---

## 🚀 Test in App

```bash
cd E:\Projects\mission_apps\lucid_dream_100
flutter pub get
flutter run
```

Character evolution images will display in:
- Profile screen
- Progress tracking screen
- Evolution celebration animations

---

## 📝 Notes

- **Character consistency is KEY**: Always use the same `--cref [YOUR_STAGE_0_URL]` for all 6 stages
- **If a result doesn't match:** Try variations with `--cw 80` or `--cw 100` to increase character weight
- **Quality check:** Each stage should clearly show progression while maintaining the same cute ghost character
- **Estimated time:** 5-10 minutes per image generation = ~1 hour total

---

**Created:** 2025-11-13
**Last Updated:** 2025-11-13
