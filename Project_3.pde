//Project 3
//API Data 


PImage world;
ArrayList <HashMap<String, Float>> weatherData;
final int MAP_POINTS = 10;
int loadCounter; 

//keys 
final String  COORD_KEY = "coord";
final String LON_KEY = "lon";
final String LAT_KEY = "lat";
final String  WEATHER_KEY = "weather";
final String DESCRIPTION_KEY = "description";
final String MAIN_KEY = "main";
final String TEMP_KEY = "temp";
final String HUMIDITY_KEY = "humidity";
//final String TEMP_MIN_KEY = "temp_min";
//final String TEMP_MAX_KEY = "temp_max";
final String WIND_KEY = "wind";
final String SPEED_KEY = "speed"; 
final String DEG_KEY = "deg";

JSONObject document; 
boolean dataLoaded = false; 

void loadData() {
  while ( loadCounter < MAP_POINTS) {
    HashMap<String, Float> weatherHashMap = new HashMap<String, Float>();
    String urlPart1 = "http://api.openweathermap.org/data/2.5/weather?zip=";
    int urlZip = (int)random(10001, 99999);
    String urlPart2 = ",us&appid=44db6a862fba0b067b1930da0d769e98";
    String urlFinal = urlPart1 + urlZip +urlPart2;
    try {
      document = loadJSONObject(urlFinal);
    } 
    catch( Exception e) {
      continue;
    }
    JSONObject coordValue = document.getJSONObject(COORD_KEY);
    float longitudeValue = coordValue.getFloat(LON_KEY);
    float latitudeValue = coordValue.getFloat(LAT_KEY);

    JSONArray weatherValue = document.getJSONArray(WEATHER_KEY);
    JSONObject weatherDictionary = weatherValue.getJSONObject(0);
    String description = weatherDictionary.getString(DESCRIPTION_KEY);

    JSONObject mainValue = document.getJSONObject(MAIN_KEY);
    float tempValue = mainValue.getFloat(TEMP_KEY);
    float humidityValue = mainValue.getFloat(HUMIDITY_KEY);

    JSONObject windValue = document.getJSONObject(WIND_KEY);
    float speedValue = windValue.getFloat(SPEED_KEY);
    float degreeValue = windValue.getFloat(DEG_KEY);

    weatherHashMap.put(LON_KEY, longitudeValue);
    weatherHashMap.put(LAT_KEY, latitudeValue);
    weatherHashMap.put(TEMP_KEY, tempValue);
    weatherHashMap.put(HUMIDITY_KEY, humidityValue);
    weatherHashMap.put(SPEED_KEY, speedValue);
    weatherHashMap.put(DEG_KEY, degreeValue);
    weatherData.add(weatherHashMap);

    loadCounter++;
    println(urlZip);
  }
}

void setup() {
  size(1170, 546);
  world = loadImage("world.jpg");
  weatherData = new ArrayList <HashMap<String, Float>>();
  loadCounter = 0; 
  thread("loadData");
}

void draw() {
  if (loadCounter > 0) {
    text("Visualization Here", width/2, height/2);
    pushMatrix();
    scale(0.3, 0.3);
    image(world, 0, 0);
    popMatrix();
    text("Press Right Arrow For New Weather Data", 30, height-100);
    text("    Line length represents wind speed", 30, height-80);
    text("    Line angle represents wind degree", 30, height-60);
    text("    Circle color represents temperature", 30, height-40);
    for (int i = 0; i < loadCounter; ++i) {
      dataDisplay(i);
    }
  } else {
    text("Waiting..", width/2, height/2);
  }
}

void dataDisplay(int dataNum) {
  HashMap<String, Float> weatherHashMap = weatherData.get(dataNum); 
  float latitudeValue = weatherHashMap.get(LAT_KEY);
  float yPos = map(latitudeValue, 90, -90, 0, height+135);
  float longitudeValue = weatherHashMap.get(LON_KEY);
  float xPos = map(longitudeValue, -180, 180, 0, width+30);

  float tempValue = weatherHashMap.get(TEMP_KEY);
  float fahrenheitTemp = ((tempValue)*(9.0/5.0)- 459.67);
  float tempColor = map(fahrenheitTemp, 0, 100, 0, 255);
  fill(tempColor, (tempColor/ 2.0), (255 - tempColor)); 


  float windValue = weatherHashMap.get(SPEED_KEY);
  float degreeValue = weatherHashMap.get(DEG_KEY);

  text(fahrenheitTemp, xPos, yPos);
  noStroke(); 
  ellipse(xPos, yPos, 10, 10);
  stroke(0);
  strokeWeight(2);
  pushMatrix();
  translate(xPos, yPos);
  rotate(degreeValue *(PI/180.0));
  line(0, 0, ((windValue*5)), 0);
  popMatrix();
}

void resetData() {
  loadCounter = 0; 
  weatherData.clear();
  thread("loadData");
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      resetData();
    }
  }
}