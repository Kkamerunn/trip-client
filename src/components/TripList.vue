<template>
  <div>
    <h1>Viajes</h1>
    <div>
      <label for="start_gte">Desde</label>
      <input type="date" v-model="filters.start_gte" @change="fetchTrips" />
      <label for="start_lte">Hasta</label>
      <input type="date" v-model="filters.start_lte" @change="fetchTrips" />
      <label for="distance_gte">Distancia y tiempo</label>
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
        <p>Termino: {{ formatDate(trip.end.time) }} - {{ trip.end.address }}</p>
        <p>
          Distancia y tiempo: {{ trip.distance }} km <br />{{
            formatDuration(trip.duration)
          }}
        </p>
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
      const url =
        "https://virtserver.swaggerhub.com/CONTABILIDAD/JooycarTest/1.0.0/api/trips/v1"; //"http://localhost:3000/trip"
      const response = await axios.get(url, {
        params: { start_gte, start_lte, distance_gte },
      });
      trips.value = response.data;
      console.log(response.data);
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

    onMounted(() => {
      fetchTrips();
    });

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
