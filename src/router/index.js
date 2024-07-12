import { createRouter, createWebHistory } from "vue-router";

import TripDetail from "@/components/TripDetail.vue";
import TripList from "@/components/TripList.vue";

const routes = [
  { path: "/", component: TripList },
  { path: "/trip/:id", component: TripDetail, props: true },
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
});

export default router;
