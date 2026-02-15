/// Returns seasonal care tips based on species genus and current month.
class SeasonalContextService {
  /// Get seasonal tips for a genus at the current time
  static List<String> getTips(String genus) {
    final month = DateTime.now().month;
    final season = _getSeason(month);
    final tips = <String>[];

    // General seasonal tips
    switch (season) {
      case 'winter':
        tips.add('Reduce watering frequency — orchids grow slower in winter.');
        tips.add('Keep away from cold drafts and heating vents.');
        tips.add('Shorter days mean less light — consider supplemental lighting.');
        break;
      case 'spring':
        tips.add('Growth season is starting! Resume regular fertilizing.');
        tips.add('Check for new roots and growth — time to repot if needed.');
        tips.add('Gradually increase watering as growth resumes.');
        break;
      case 'summer':
        tips.add('Watch for overheating — ensure good air circulation.');
        tips.add('Increase misting frequency if humidity is low.');
        tips.add('Sheer curtains can protect from intense afternoon sun.');
        break;
      case 'fall':
        tips.add('Many orchids set bloom spikes now — look for new growth!');
        tips.add('Night temperatures dropping can trigger blooming.');
        tips.add('Start reducing fertilizer as growth slows.');
        break;
    }

    // Genus-specific seasonal tips
    final genusLower = genus.toLowerCase();
    switch (season) {
      case 'winter':
        if (genusLower == 'phalaenopsis') {
          tips.add('Phalaenopsis: Cool nights (60-65°F) help trigger spike development.');
        } else if (genusLower == 'dendrobium') {
          tips.add('Dendrobium: Many species need a dry, cool rest period now. Reduce watering significantly.');
        } else if (genusLower == 'cymbidium') {
          tips.add('Cymbidium: Blooming season! Keep cool (45-55°F at night) for best flowers.');
        } else if (genusLower == 'catasetum') {
          tips.add('Catasetum: Dormant period — stop watering completely until new growth appears.');
        }
        break;
      case 'spring':
        if (genusLower == 'cattleya') {
          tips.add('Cattleya: New growths emerging — great time to repot and divide.');
        } else if (genusLower == 'dendrobium') {
          tips.add('Dendrobium: Resume watering when new growth starts. Watch for keikis.');
        } else if (genusLower == 'vanda') {
          tips.add('Vanda: Increasing light and warmth boost growth. Daily watering may be needed.');
        } else if (genusLower == 'catasetum') {
          tips.add('Catasetum: New growth emerging — start watering and feeding heavily.');
        }
        break;
      case 'summer':
        if (genusLower == 'phalaenopsis') {
          tips.add('Phalaenopsis: Keep out of direct sun. Good growth period for leaves and roots.');
        } else if (genusLower == 'masdevallia') {
          tips.add('Masdevallia: Heat stress danger — keep below 70°F. Increase humidity.');
        } else if (genusLower == 'vanda') {
          tips.add('Vanda: Peak growing season. Water daily and fertilize weekly.');
        }
        break;
      case 'fall':
        if (genusLower == 'phalaenopsis') {
          tips.add('Phalaenopsis: Watch for spike initiation! Cool nights (55-60°F) trigger blooming.');
        } else if (genusLower == 'oncidium') {
          tips.add('Oncidium: Many species bloom now. Reduce fertilizer after spike appears.');
        } else if (genusLower == 'cattleya') {
          tips.add('Cattleya: Fall-blooming types are setting buds. Maintain consistent care.');
        }
        break;
    }

    return tips;
  }

  static String _getSeason(int month) {
    if (month >= 3 && month <= 5) return 'spring';
    if (month >= 6 && month <= 8) return 'summer';
    if (month >= 9 && month <= 11) return 'fall';
    return 'winter';
  }

  static String getSeasonName() {
    return _getSeason(DateTime.now().month).substring(0, 1).toUpperCase() +
        _getSeason(DateTime.now().month).substring(1);
  }
}
