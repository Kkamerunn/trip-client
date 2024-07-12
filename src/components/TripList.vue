<template>
  <div>
    <h1>Listado de Viajes</h1>
    <div>
      <label for="start_gte">Fecha de Inicio Desde:</label>
      <input type="date" v-model="filters.start_gte" @change="fetchTrips" />
      <label for="start_lte">Fecha de Inicio Hasta:</label>
      <input type="date" v-model="filters.start_lte" @change="fetchTrips" />
      <label for="distance_gte">Distancia Mínima:</label>
      <input
        type="number"
        v-model="filters.distance_gte"
        @change="fetchTrips"
      />
    </div>
    <ul>
      <li v-for="trip in trips" :key="trip.id" @click="viewDetail(trip.id)">
        <p>
          Inicio: {{ formatDate(trip.start.time) }} - {{ trip.start.address }}
        </p>
        <p>Fin: {{ formatDate(trip.end.time) }} - {{ trip.end.address }}</p>
        <p>Distancia: {{ trip.distance }} km</p>
        <p>Duración: {{ formatDuration(trip.duration) }}</p>
      </li>
    </ul>
  </div>
</template>

<script>
import axios from "axios";
import { ref } from "vue";
import { useRouter } from "vue-router";

export default {
  name: "TripList",
  setup() {
    const trips = ref([]);
    const filters = ref({
      start_gte: "",
      start_lte: "",
      distance_gte: "",
    });
    const router = useRouter();

    const fetchTrips = async () => {
      const { start_gte, start_lte, distance_gte } = filters.value;
      const response = await axios.get("http://localhost:3000/trip", {
        params: { start_gte, start_lte, distance_gte },
      });
      trips.value = response.data;
    };

    const viewDetail = (id) => {
      router.push(`/trip/${id}`);
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

    fetchTrips();

    return {
      trips,
      filters,
      viewDetail,
      formatDate,
      formatDuration,
      fetchTrips,
    };
  },
};
</script>
