//Project 3
//API Data 
 

PImage world;
final String URL = "http://api.openweathermap.org/data/2.5/weather?zip=75205,us&appid=44db6a862fba0b067b1930da0d769e98";

//keys 
final String  COORD_KEY = "coord";
final String LON_KEY = "lon";
final String LAT_KEY = "lat";
final String  WEATHER_KEY = "weather";
final String DESCRIPTION_KEY = "description";
final String MAIN_KEY = "main";
final String TEMP_KEY = "temp";
final String HUMIDITY_KEY = "humidity";
final String TEMP_MIN_KEY = "temp_min";
final String TEMP_MAX_KEY = "temp_max";
final String WIND_KEY = "wind";
final String SPEED_KEY = "speed"; 
final String DEG_KEY = "deg";

JSONObject document; 
boolean dataLoaded = false; 
HashMap<String, Float> weatherHashMap; 

void loadData(){
 document = loadJSONObject(URL);
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
 weatherHashMap.put(TEMP_KEY, longitudeValue);
 weatherHashMap.put(HUMIDITY_KEY, longitudeValue);
 weatherHashMap.put(SPEED_KEY, longitudeValue);
 weatherHashMap.put(DEG_KEY, longitudeValue);
 
 world = loadImage("world.jpg");
 dataLoaded = true; 
}

void setup(){
  size(1170, 546);
  weatherHashMap = new HashMap<String, Float>();
  thread("loadData"); 
}

void draw(){
   if (dataLoaded){
    text("Visualization Here", width/2, height/2);
    pushMatrix();
    scale(0.3, 0.3);
    image(world, 0, 0);
    println(world.width, world.height);
    popMatrix();
    dataDisplay();
  }else{
    text("Waiting..", width/2, height/2);
  }
}

void dataDisplay(){
 float latitudeValue = weatherHashMap.get(LAT_KEY);
  float yPos = map(latitudeValue, 90, -90, 0, height+135);
  float longitudeValue = weatherHashMap.get(LON_KEY);
  float xPos = map(longitudeValue, -180, 180, 0, width+30);
  ellipse(xPos, yPos, 10, 10);
  println("lat", latitudeValue);
  println("lon" , longitudeValue);
  
  
}
  //text("Done", width/2, height/2);
//}
  