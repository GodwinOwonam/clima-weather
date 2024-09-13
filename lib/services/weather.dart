import 'package:flutter/foundation.dart';

import '../services/location.dart';
import '../services/networking.dart';

const apiKey = '561136bad948495a8ad191047241109';

class WeatherModel {
  Future<dynamic> getCityWeather(String city) async {
    Location location = Location();

    try {
      await location.getCurrentLocation();

      NetworkHelper networkHelper = NetworkHelper();

      var url = Uri.https(
        'api.weatherapi.com',
        '/v1/current.json',
        {'key': apiKey, 'q': city},
      );

      var data = await networkHelper.getData(url);

      return parseWeatherData(data);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }

      return {
        "cityName": 'Error',
        "temperature": 0.0,
        "condition": 0,
      };
    }
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();

    try {
      await location.getCurrentLocation();

      NetworkHelper networkHelper = NetworkHelper();

      var url = Uri.https(
        'api.weatherapi.com',
        '/v1/current.json',
        {'key': apiKey, 'q': '${location.latitude},${location.longitude}'},
      );

      var data = await networkHelper.getData(url);

      return parseWeatherData(data);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }

      return {
        "cityName": 'Error',
        "temperature": 0.0,
        "condition": 0,
      };
    }
  }

  Map<String, dynamic> parseWeatherData(dynamic data) {
    var locationData = data['location'];
    var currentWeatherData = data['current'];
    String cityName = locationData['name'];
    double celsiusTemperature = currentWeatherData['temp_c'];
    var condition = currentWeatherData['condition'];
    int code = condition['code'];
    /*String description = locationData['region'];
      String country = locationData['country'];
      double latitude = locationData['lat'];
      double longitude = locationData['lon'];
      double fahrenheitTemperature = currentWeatherData['temp_f'];
      int isDay = currentWeatherData['is_day'];
      String conditionDescription = condition['text'];
      String icon = condition['icon'];
      var humidity = currentWeatherData['humidity'];*/

    Map<String, dynamic> weatherData = {
      "cityName": cityName,
      "temperature": celsiusTemperature,
      "condition": code,
      /*"cityDescription": description,
      "country": country,
      "latitude": latitude,
      "longitude": longitude,
      "tempInFahrenheit": fahrenheitTemperature,
      "isDayTime": isDay == 1,
      "description": conditionDescription,
      "icon": icon,
      "humidity": humidity*/
    };

    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if ((condition >= 1192 && condition < 1201) ||
        (condition >= 1243 && condition <= 1252) ||
        (condition >= 1273 && condition <= 1276)) {
      return '🌧';
    } else if ((condition >= 1204 && condition <= 1240) ||
        (condition >= 1255 && condition <= 1264) ||
        (condition >= 1279 && condition <= 1282)) {
      return '☃️';
    } else if (condition >= 1150 && condition < 1201) {
      return '☔️';
    } else if (condition > 1087 && condition < 1150) {
      return '🤷‍';
    } else if (condition == 1087) {
      return '🌩';
    } else if (condition > 1006 && condition < 1087) {
      return '🤷‍';
    } else if (condition == 1003) {
      return '☁️';
    } else if (condition == 1000) {
      return '☀️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp != 0 && temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else if (temp == 0) {
      return 'Something appears to be wrong.';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
