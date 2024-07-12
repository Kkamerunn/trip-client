<template>
  <div>
    <h1>Detalle del Viaje</h1>
    <div v-if="trip">
      <p>
        Inicio: {{ formatDate(trip.start.time) }} - {{ trip.start.address }}
      </p>
      <p>Fin: {{ formatDate(trip.end.time) }} - {{ trip.end.address }}</p>
      <p>Distancia: {{ trip.distance }} km</p>
      <p>Duración: {{ formatDuration(trip.duration) }}</p>
      <div id="map" style="height: 400px"></div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { ref, onMounted } from "vue";

export default {
  name: "TripDetail",
  props: {
    id: {
      type: String,
      required: true,
    },
  },
  setup(props) {
    const trip = ref(null);

    const fetchTrip = async () => {
      const response = await axios.get(
        `http://localhost:3000/trips/${props.id}`
      );
      trip.value = response.data;
      loadMap();
    };

    const loadMap = () => {
      const map = new google.maps.Map(document.getElementById("map"), {
        zoom: 10,
        center: { lat: trip.value.start.lat, lng: trip.value.start.lon },
      });

      const startMarker = new google.maps.Marker({
        position: { lat: trip.value.start.lat, lng: trip.value.start.lon },
        map,
        title: "Inicio del Viaje",
      });

      const endMarker = new google.maps.Marker({
        position: { lat: trip.value.end.lat, lng: trip.value.end.lon },
        map,
        title: "Fin del Viaje",
      });

      const boundingBoxCoords = trip.value.boundingBox.map((point) => ({
        lat: point.lat,
        lng: point.lon,
      }));
      const boundingBox = new google.maps.Polygon({
        paths: boundingBoxCoords,
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35,
      });
      boundingBox.setMap(map);
    };

    const formatDate = (date) => {
      return new Date(date).toLocaleString();
    };

    const formatDuration = (duration) => {
      const seconds = Math.floor((duration / 1000) % 60);
      const minutes = Math.floor((duration / (1000 * 60)) % 60);
      const hours = Math.floor((duration / (1000 * 60 * 60)) % 24);
      return `${hours}h ${minutes}m ${seconds}s`;
    };

    onMounted(fetchTrip);

    return { trip, formatDate, formatDuration };
  },
};
</script>

//
<script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY"></script>
