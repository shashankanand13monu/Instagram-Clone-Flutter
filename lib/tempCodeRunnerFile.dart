String apikey =
      dotenv.env.entries.firstWhere((e) => e.key == "FIREBASE_API_KEY").value;
  print(apikey);