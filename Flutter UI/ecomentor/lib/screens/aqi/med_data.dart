// lib/screens/med_data.dart

const List<Map<String, dynamic>> medData = [
  {
    "disease": "Asthma",
    "pollutants": [
      {"key": "co", "value": 5000},  // CO in µg/m³
      {"key": "o3", "value": 100},   // Ozone in µg/m³
      {"key": "pm2_5", "value": 35}  // PM2.5 in µg/m³
    ]
  },
  {
    "disease": "COPD",
    "pollutants": [
      {"key": "pm2_5", "value": 25},
      {"key": "pm10", "value": 50},
      {"key": "so2", "value": 10}
    ]
  },
  {
    "disease": "Bronchitis",
    "pollutants": [
      {"key": "o3", "value": 80},
      {"key": "pm2_5", "value": 25}
    ]
  },
  {
    "disease": "Emphysema",
    "pollutants": [
      {"key": "o3", "value": 90},
      {"key": "no2", "value": 40}
    ]
  },
  {
    "disease": "Lung Cancer",
    "pollutants": [
      {"key": "pm2_5", "value": 50},
      {"key": "no2", "value": 40},
      {"key": "o3", "value": 70},
      {"key": "so2", "value": 20}
    ]
  },
  {
    "disease": "Influenza",
    "pollutants": [
      {"key": "pm2_5", "value": 30},
      {"key": "pm10", "value": 60},
      {"key": "co", "value": 4000},
      {"key": "so2", "value": 15}
    ]
  },
  {
    "disease": "Pleural Effusion",
    "pollutants": [
      {"key": "pm2_5", "value": 40},
      {"key": "pm10", "value": 70},
      {"key": "o3", "value": 80}
    ]
  },
  {
    "disease": "Bronchiectasis",
    "pollutants": [
      {"key": "pm2_5", "value": 30},
      {"key": "pm10", "value": 50},
      {"key": "so2", "value": 25},
      {"key": "o3", "value": 60},
      {"key": "no2", "value": 30}
    ]
  }
];
