import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('Usage: dart main.dart <location>');
    exit(1);
  }

  final config = jsonDecode(await File('config.json').readAsString());
  final apiKey = config['weather_api_key'];
  if (apiKey == '') {
    print('Please add your OpenWeatherMap API key to config.json');
    exit(1);
  }

  final location = arguments.join(' ');

  final locationRequestUrl = Uri(
      scheme: 'https',
      host: 'api.openweathermap.org',
      path: 'geo/1.0/direct',
      queryParameters: {
        'q': location,
        'appid': apiKey,
      });

  final locationResponse = await http.get(locationRequestUrl);
  final locationInfo = jsonDecode(locationResponse.body)[0];
  final double locationLatitude = locationInfo['lat'];
  final double locationLongitude = locationInfo['lon'];

  final weatherApiUrl = Uri(
      scheme: 'https',
      host: 'api.openweathermap.org',
      path: 'data/2.5/weather',
      queryParameters: {
        'lat': locationLatitude.toString(),
        'lon': locationLongitude.toString(),
        'exclude': 'hourly,minutely,daily,alerts',
        'appid': apiKey,
        'units': 'metric'
      });

  final weatherResponse = await http.get(weatherApiUrl);
  final weatherInfo = jsonDecode(weatherResponse.body);
  final currentWeatherTemperature = weatherInfo['main']['temp'];

  print('The current temperature in $location is $currentWeatherTemperature°C');
}
