import { LightningElement, track } from 'lwc';
const API_KEY = 'API_KEY'; // Replace with your OpenWeatherMap API key
import WEATHER_ICON_SVG from "@salesforce/resourceUrl/Agrosphere";

const WEATHER_ICONS = {
    "01d": `${WEATHER_ICON_SVG}/weather-icons/clear-day.svg`,
    "01n": `${WEATHER_ICON_SVG}/weather-icons/clear-night.svg`,
    "02d": `${WEATHER_ICON_SVG}/weather-icons/partly-cloudy-day.svg`,
    "02n": `${WEATHER_ICON_SVG}/weather-icons/partly-cloudy-night.svg`,
    "03d": `${WEATHER_ICON_SVG}/weather-icons/cloudy.svg`,
    "03n": `${WEATHER_ICON_SVG}/weather-icons/cloudy.svg`,
    "04d": `${WEATHER_ICON_SVG}/weather-icons/overcast-day.svg`,
    "04n": `${WEATHER_ICON_SVG}/weather-icons/overcast-night.svg`,
    "09d": `${WEATHER_ICON_SVG}/weather-icons/overcast-day-drizzle.svg`,
    "09n": `${WEATHER_ICON_SVG}/weather-icons/overcast-night-drizzle.svg`,
    "10d": `${WEATHER_ICON_SVG}/weather-icons/overcast-day-rain.svg`,
    "10n": `${WEATHER_ICON_SVG}/weather-icons/overcast-night-rain.svg`,
    "11d": `${WEATHER_ICON_SVG}/weather-icons/thunderstorms-day-extreme.svg`,
    "11n": `${WEATHER_ICON_SVG}/weather-icons/thunderstorms-night-extreme.svg`,
    "13d": `${WEATHER_ICON_SVG}/weather-icons/partly-cloudy-day-snow.svg`,
    "13n": `${WEATHER_ICON_SVG}/weather-icons/partly-cloudy-night-snow.svg`,
    "50d": `${WEATHER_ICON_SVG}/weather-icons/mist.svg`,
    "50n": `${WEATHER_ICON_SVG}/weather-icons/mist.svg`
};

export default class Agrosphere_WeatherOverview extends LightningElement {
    @track temp;
    @track weatherDescription;
    @track dateTime;
    @track dayName;
    currentTime;
    cityName;
    weatherIcon;
    @track cloudPercentage;
    @track uvIndex = 5;
    @track sunset;
    @track sunrise;
    @track windSpeed;
    @track humidity;
    @track visibility;
    @track dewPoint = 18;

    longitude;
    latitude;
    error;

    compass = `${WEATHER_ICON_SVG}/weather-icons/compass.svg`;
    sunriseIcon = `${WEATHER_ICON_SVG}/weather-icons/sunrise.svg`;
    sunsetIcon = `${WEATHER_ICON_SVG}/weather-icons/sunset.svg`;
    cloudy = `${WEATHER_ICON_SVG}/weather-icons/cloudy.svg`;
    rain = `${WEATHER_ICON_SVG}/weather-icons/rain.svg`;
    errorIcon = `${WEATHER_ICON_SVG}/weather-icons/code-red.svg`;



    connectedCallback() {
        this.getLocation()
    }

    getLocation() {
        if ('geolocation' in navigator) {
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    console.log(position)
                    this.latitude = position.coords.latitude;
                    this.longitude = position.coords.longitude;
                    this.fetchWeatherData();
                    this.error = null;
                },
                (error) => {
                    console.log(error)
                    this.latitude = null;
                    this.longitude = null;
                    this.error = error.message;
                }
            );
        } else {
            console.log('Geolocation is not supported by your browser.')
            this.error = 'Geolocation is not supported by your browser.';
        }
    }

    // Method to fetch weather data from OpenWeatherMap API
    fetchWeatherData() {
        // Construct the API URL
        const apiUrl = `https://api.openweathermap.org/data/2.5/weather?lat=${this.latitude}&lon=${this.longitude}&appid=${API_KEY}&units=metric`;

        // Make the API request using the fetch function
        fetch(apiUrl)
            .then((response) => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then((data) => {
                //LOCATION
                this.cityName = data.name + ', ' + data.sys.country
                //WEATHER ICON
                this.weatherIcon = JSON.parse(
                    JSON.stringify(WEATHER_ICONS[data.weather[0].icon])
                );
                //DATE AND TIME
                this.dateTime = new Date(data.dt * 1000);

                this.dayName = this.dateTime.toLocaleString("en-us", {
                    weekday: "short",

                });
                this.currentTime = this.dateTime.toLocaleString("en-US", {
                    hour: "numeric",
                    minute: "numeric",
                    hour12: true
                });
                // TEMPERATURE
                this.temp = Math.round(data.main.temp)
                // WEATHER DESC
                this.weatherDescription = this.capitalizeFirstLetters(data.weather[0].description);
                // SUN RISE
                let sunriseDT = new Date(data.sys.sunrise * 1000);
                this.sunrise = sunriseDT.toLocaleString("en-US", {
                    hour: "numeric",
                    minute: "numeric",
                    hour12: true
                });
                // SUN SET
                let sunsetDT = new Date(data.sys.sunset * 1000);
                this.sunset = sunsetDT.toLocaleString("en-US", {
                    hour: "numeric",
                    minute: "numeric",
                    hour12: true
                });
                // WIND STATUS & DIRECTION
                this.windSpeed= data.wind.speed.toFixed(1)+' m/s ' + this.getCardinalDirection(data.wind.deg);
                //HUMIDITY
                this.humidity = data.main.humidity;
                // Cloud percentage
                this.cloudPercentage = data.clouds.all
                //Visibility
                this.visibility = (data.visibility / 1000).toFixed(1);



                console.log(data)
            })
            .catch((error) => {
                console.error('Error fetching weather data:', JSON.stringify(error));
                console.log(error.message)
            });
    }
    capitalizeFirstLetters(str) {
        let words = str.split(' ');
        for (let i = 0; i < words.length; i++) {
            words[i] = words[i].charAt(0).toUpperCase() + words[i].slice(1);
        }
        return words.join(' ');
    }
    getCardinalDirection(angle) {
        var val = Math.floor(angle / 22.5 + 0.5);
        var arr = [
            "N",
            "NNE",
            "NE",
            "ENE",
            "E",
            "ESE",
            "SE",
            "SSE",
            "S",
            "SSW",
            "SW",
            "WSW",
            "W",
            "WNW",
            "NW",
            "NNW"
        ];
        return arr[val % 16];
    }

}