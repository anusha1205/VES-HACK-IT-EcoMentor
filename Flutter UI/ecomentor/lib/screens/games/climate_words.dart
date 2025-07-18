class ClimateWord {
  final String word;
  final String hint;
  final String explanation;
  final int level;

  ClimateWord({
    required this.word,
    required this.hint,
    required this.explanation,
    required this.level,
  });
}

final List<ClimateWord> climateWords = [
  ClimateWord(
    word: "CLIMATE",
    hint: "Long-term weather patterns in an area",
    explanation: "Climate is the average weather conditions in a region over a long period.",
    level: 1,
  ),
  ClimateWord(
    word: "CARBON",
    hint: "Element linked to fossil fuel emissions",
    explanation: "Carbon dioxide (CO₂) is a greenhouse gas responsible for global warming.",
    level: 1,
  ),
  ClimateWord(
    word: "GREENHOUSE",
    hint: "Effect that warms the Earth’s surface",
    explanation: "The greenhouse effect traps heat in Earth’s atmosphere, essential but harmful in excess.",
    level: 1,
  ),
  ClimateWord(
    word: "EMISSIONS",
    hint: "Pollutants released into the atmosphere",
    explanation: "Emissions from industries and vehicles contribute to global warming.",
    level: 1,
  ),
  ClimateWord(
    word: "DEFORESTATION",
    hint: "Large-scale cutting of trees",
    explanation: "Deforestation reduces carbon absorption, worsening climate change.",
    level: 2,
  ),
  ClimateWord(
    word: "RENEWABLE",
    hint: "Energy source that is naturally replenished",
    explanation: "Solar and wind are renewable energy sources that do not deplete over time.",
    level: 2,
  ),
  ClimateWord(
    word: "SUSTAINABLE",
    hint: "Able to maintain without resource depletion",
    explanation: "Sustainable practices ensure minimal environmental harm for future generations.",
    level: 2,
  ),
  ClimateWord(
    word: "RECYCLING",
    hint: "Process of converting waste into reusable material",
    explanation: "Recycling reduces waste and conserves resources.",
    level: 2,
  ),
  ClimateWord(
    word: "BIODIVERSITY",
    hint: "Variety of life in an ecosystem",
    explanation: "Climate change threatens biodiversity by altering habitats.",
    level: 2,
  ),
  ClimateWord(
    word: "POLLUTION",
    hint: "Contamination of the environment",
    explanation: "Air, water, and soil pollution harm ecosystems and human health.",
    level: 2,
  ),
  ClimateWord(
    word: "ADAPTATION",
    hint: "Adjusting to climate change effects",
    explanation: "Adaptation includes measures like building sea walls to protect against rising seas.",
    level: 3,
  ),
  ClimateWord(
    word: "MITIGATION",
    hint: "Actions to reduce climate change impacts",
    explanation: "Mitigation strategies include switching to clean energy and reducing emissions.",
    level: 3,
  ),
  ClimateWord(
    word: "EROSION",
    hint: "Soil loss due to water or wind",
    explanation: "Climate change increases coastal erosion due to stronger storms.",
    level: 3,
  ),
  ClimateWord(
    word: "TEMPERATURE",
    hint: "Measure of heat in the atmosphere",
    explanation: "Global temperatures are rising due to excessive greenhouse gases.",
    level: 3,
  ),
  ClimateWord(
    word: "DROUGHT",
    hint: "Long period of insufficient rainfall",
    explanation: "Climate change increases drought frequency, affecting agriculture and water supply.",
    level: 3,
  ),
  ClimateWord(
    word: "FOSSIL FUELS",
    hint: "Non-renewable energy sources like coal and oil",
    explanation: "Burning fossil fuels releases CO₂, accelerating climate change.",
    level: 3,
  ),
  ClimateWord(
    word: "OCEAN ACIDIFICATION",
    hint: "Seawater becoming more acidic due to CO₂",
    explanation: "Acidification harms marine life like coral reefs and shellfish.",
    level: 3,
  ),
  ClimateWord(
    word: "PERMAFROST",
    hint: "Frozen soil that stores carbon",
    explanation: "Melting permafrost releases methane, a potent greenhouse gas.",
    level: 3,
  ),
  ClimateWord(
    word: "ICE CAPS",
    hint: "Large frozen areas at the poles",
    explanation: "Ice caps are melting due to rising global temperatures, causing sea levels to rise.",
    level: 3,
  ),
  ClimateWord(
    word: "CARBON FOOTPRINT",
    hint: "Total greenhouse gases emitted by an individual or organization",
    explanation: "Reducing carbon footprint helps slow global warming.",
    level: 3,
  )
];
